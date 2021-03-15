package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.jdt.core.IAnnotation;
import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IMethod;
import org.eclipse.jdt.core.IPackageFragment;
import org.eclipse.jdt.core.IPackageFragmentRoot;
import org.eclipse.jdt.core.IType;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.JavaModelException;
import org.eclipse.jdt.core.Signature;
import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.ASTVisitor;
import org.eclipse.jdt.core.dom.Block;
import org.eclipse.jdt.core.dom.CatchClause;
import org.eclipse.jdt.core.dom.IMethodBinding;
import org.eclipse.jdt.core.dom.ITypeBinding;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.MethodInvocation;
import org.eclipse.jdt.core.dom.SimpleType;
import org.eclipse.jdt.core.dom.Statement;
import org.eclipse.jdt.core.dom.TryStatement;
import org.eclipse.jdt.core.dom.Type;
import org.eclipse.jdt.core.dom.UnionType;
import org.eclipse.jdt.internal.compiler.parser.diagnose.LexStream;

public class TestCaseAnalyzer extends Job {


	int totalNumberOfCU;
	int currentCU;
	IProgressMonitor monitor;

	{
		Constants.LOGGER.setLevel(Level.ALL);
		try {
			Constants.LOGGER.addHandler(new FileHandler(Constants.OUTPUT_FOLDER.getAbsolutePath() + File.separator + "log.txt"));
		} catch (SecurityException | IOException e) {
			e.printStackTrace();
		}
	}

	public TestCaseAnalyzer() {
		super("Test Case Analyzer");
		setUser(true);
	}

	@Override
	protected IStatus run(IProgressMonitor monitor) {

		JavaModelHelpers.initializeHelperVariables();
		this.monitor = monitor;
		try {
			totalNumberOfCU = countCompilationUnits();

			monitor.beginTask("Finding custom test annotations", totalNumberOfCU);
			currentCU = 0;

			List<String> testAnnotations = findAllCustomTestAnnotations();
			for (String s : Constants.JUNIT_TEST_CASE_ANNOTATIONS) {
				testAnnotations.add(s);
			}

			if (monitor.isCanceled()) {
				return Status.CANCEL_STATUS;
			}

			monitor.done();

			monitor.beginTask("Searching for test cases", totalNumberOfCU);
			currentCU = 0;

			findAllTestCases(testAnnotations);

			if (monitor.isCanceled()) {
				return Status.CANCEL_STATUS;
			}
			monitor.done();

		} catch (Exception e) {
			e.printStackTrace();
			Constants.LOGGER.severe("ERROR 1:" + e.getMessage());
			Constants.LOGGER.log(Level.SEVERE, e, () -> e.getMessage());
		}
		return Status.OK_STATUS;
	}

	private int countCompilationUnits() throws CoreException {
		int ret = 0;
		// Get the root of the workspace
		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IWorkspaceRoot root = workspace.getRoot();
		// Get all projects in the workspace
		IProject[] projects = root.getProjects();
		// Loop over all projects
		for (IProject project : projects) {
			if (project.isOpen() && project.isNatureEnabled("org.eclipse.jdt.core.javanature")) {
				if ((Constants.DEBUG_MODE && project.getName().startsWith(Constants.TEST_PROJECT_PREFIX))
						|| (!Constants.DEBUG_MODE)) {
					IJavaProject javaProject = JavaCore.create(project);
					IPackageFragment[] packages = javaProject.getPackageFragments();
					for (IPackageFragment mypackage : packages) {
						if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE) {
							ret += mypackage.getCompilationUnits().length;
						}
					}
				}
			}
		}
		return ret;
	}

	private List<String> findAllCustomTestAnnotations() throws CoreException {
		List<String> ret = new ArrayList<>();

		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IWorkspaceRoot root = workspace.getRoot();
		IProject[] projects = root.getProjects();
		for (IProject project : projects) {
			if (project.isOpen() && project.isNatureEnabled("org.eclipse.jdt.core.javanature")) {
				if ((Constants.DEBUG_MODE && project.getName().startsWith(Constants.TEST_PROJECT_PREFIX))
						|| (!Constants.DEBUG_MODE)) {
					IJavaProject javaProject = JavaCore.create(project);
					IPackageFragment[] packages = javaProject.getPackageFragments();
					for (IPackageFragment mypackage : packages) {
						if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE) {
							for (ICompilationUnit unit : mypackage.getCompilationUnits()) {
								if (monitor.isCanceled())
									return null;
								monitor.subTask(
										"Searching CU " + unit.getPath().toString() + " (" + (++currentCU) + ")");
								for (IType type : unit.getAllTypes()) {
									if (type.isAnnotation()) {
										List<String> annotations = JavaModelHelpers.getTypeAnnotations(type);
										for (String annotation : annotations) {
											if (Helpers.compareStringEquals(annotation, Constants.JUNIT_TEST_CASE_ANNOTATIONS)) {
												ret.add(type.getFullyQualifiedName());
											}
										}
									}
								}
								monitor.worked(1);
							}
						}
					}
				}
			}
		}
		return ret;
	}

	private void findAllTestCases(List<String> testAnnotations)
			throws JavaModelException, CoreException, FileNotFoundException {
		IWorkspace workspace = ResourcesPlugin.getWorkspace();
		IWorkspaceRoot root = workspace.getRoot();
		IProject[] projects = root.getProjects();
		for (IProject project : projects) {
			if (project.isOpen() && project.isNatureEnabled("org.eclipse.jdt.core.javanature")) {
				if ((Constants.DEBUG_MODE && project.getName().startsWith(Constants.TEST_PROJECT_PREFIX))
						|| (!Constants.DEBUG_MODE)) {
					IJavaProject javaProject = JavaCore.create(project);
					Constants.LOGGER.info("Visiting project " + javaProject.getElementName());
					visitProject(project, javaProject, testAnnotations);
					Constants.LOGGER.info("Finished visiting project " + javaProject.getElementName());
				}
			}
		}
	}

	private void visitProject(IProject iProject, IJavaProject javaProject, List<String> testAnnotations)
			throws FileNotFoundException, JavaModelException {
		File outputFile = new File(Constants.OUTPUT_FOLDER, javaProject.getElementName() + ".csv");
		if (outputFile.exists()) {
			Constants.LOGGER.info("Project " + javaProject.getElementName() + " already analyzed. Skipping...");
			return;
		}
		try (PrintWriter out = new PrintWriter(outputFile)) {
			out.println(CSVEntry.getFieldNames());

			IPackageFragment[] packages = javaProject.getPackageFragments();
			for (IPackageFragment mypackage : packages) {
				if (mypackage.getKind() == IPackageFragmentRoot.K_SOURCE) {
					for (ICompilationUnit unit : mypackage.getCompilationUnits()) {
						if (monitor.isCanceled())
							return;
						monitor.subTask("Searching CU " + (++currentCU) + ": " + javaProject.getElementName() + "/"
								+ unit.getElementName());
						Constants.LOGGER.info("Searching CU " + (++currentCU) + ": " + javaProject.getElementName() + "/"
								+ unit.getElementName());
						List<IMethod> testCases = new ArrayList<>();
						for (IType type : unit.getAllTypes()) {
							Constants.LOGGER.info("Searching type " + type.getElementName());
							for (IMethod m : type.getMethods()) {
								Constants.LOGGER.info("Searching method " + m.getElementName());
								if(JavaModelHelpers.checkIfMethodIsATestCase(m, testAnnotations)) {
									testCases.add(m);
									Constants.LOGGER.info(m.getElementName() + " is a test case");
								} else {
									Constants.LOGGER.info(m.getElementName() + " is not a test case");
								}
							}
						}
						
						ASTParser parser = ASTParser.newParser(AST.JLS11);
						parser.setKind(ASTParser.K_COMPILATION_UNIT);
						parser.setSource(unit);
						parser.setResolveBindings(true);
						
						ASTNode node = parser.createAST(null);
						
						// This visitor creates a call->called list
						CallCalledVisitor ccv = new CallCalledVisitor();
						node.accept(ccv);
						
						CallCalledList callCalledList = ccv.getCallCalledList();

						
						// This visitor collects all the metrics and writes the CSV file
						node.accept(new MethodDeclarationVisitor(testCases, iProject, testAnnotations, callCalledList,
								javaProject, unit, out) );
						
						

						monitor.worked(1);
					}
				}
			}
		}
	}
}
