package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Level;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jdt.core.IAnnotation;
import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IMemberValuePair;
import org.eclipse.jdt.core.IMethod;
import org.eclipse.jdt.core.IType;
import org.eclipse.jdt.core.JavaModelException;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTVisitor;
import org.eclipse.jdt.core.dom.Block;
import org.eclipse.jdt.core.dom.IMethodBinding;
import org.eclipse.jdt.core.dom.ITypeBinding;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.MethodInvocation;
import org.eclipse.jdt.core.dom.Statement;

public class MethodDeclarationVisitor extends ASTVisitor {

	IMethod currentMethod;
	Set<String> exceptionsThrownInMethodInvocations;
	int numberOfFirstLevelStatements;
	int numberOfStatements;
	int numberOfMethodInvocations;
	TreeSet<String> distinctMethodInvocations;
	TreeSet<String> distinctMethodInvocationsInSameClass;
	TreeSet<String> distinctTestCaseMethodInvocationsInSameClass;
	int numberOfMethodInvocationsWithExceptions;
	int numberOfExceptionsThrown;
	int numberOfExceptionsThrownAndCaughtExact;
	int numberOfExceptionsThrownAndCaughtPartial;
	TreeSet<String> listOfExpectedExceptions;

	int numberOfAssertions;
	int numberOfAssertionsWithRecursion;
	TreeSet<String> otherMethodsInSameClassThatDependOnThis;
	TreeSet<String> otherTestCasesInSameClassThatDependOnThis;
	
	List<IMethod> testCases;
	IProject iProject;
	List<String> testAnnotations;
	CallCalledList callCalledList;
	IJavaProject javaProject;
	ICompilationUnit unit;
	PrintWriter out;

	public MethodDeclarationVisitor(List<IMethod> testCases, IProject iProject, List<String> testAnnotations,
			CallCalledList callCalledList, IJavaProject javaProject, ICompilationUnit unit, PrintWriter out) {
		this.testCases = testCases;
		this.iProject = iProject;
		this.testAnnotations = testAnnotations;
		this.callCalledList = callCalledList;
		this.javaProject = javaProject;
		this.unit = unit;
		this.out = out;
	}

	@Override
	public boolean visit(MethodDeclaration node) {
		if (currentMethod != null)
			return false;
		numberOfFirstLevelStatements = 0;
		numberOfStatements = 0;
		numberOfMethodInvocations = 0;
		distinctMethodInvocations = new TreeSet<>();
		distinctMethodInvocationsInSameClass = new TreeSet<>();
		distinctTestCaseMethodInvocationsInSameClass = new TreeSet<>();
		numberOfMethodInvocationsWithExceptions = 0;
		numberOfExceptionsThrown = 0;
		numberOfExceptionsThrownAndCaughtExact = 0;
		numberOfExceptionsThrownAndCaughtPartial = 0;
		listOfExpectedExceptions = new TreeSet<>();
		numberOfAssertions = 0;
		numberOfAssertionsWithRecursion = 0;
		exceptionsThrownInMethodInvocations = new TreeSet<>();
		otherMethodsInSameClassThatDependOnThis = new TreeSet<>();
		otherTestCasesInSameClassThatDependOnThis = new TreeSet<>();

		IMethodBinding iMethodBinding = node.resolveBinding();
		if (iMethodBinding == null) {
			Constants.LOGGER.severe("ERROR 2:IMethodBinding for node " + node.getName() + " is null");
		} else {
			IMethod method = (IMethod) iMethodBinding.getJavaElement();
			if (method == null) {
				Constants.LOGGER.severe("ERROR 13:Java element for method " + iMethodBinding.getName() + " is null");
			} else {
				if (testCases.contains(method)) {

					if (Constants.COVERAGE_MODE) {
						executeAndGetCoverage(method);
					}
					if (Constants.PARSE_TEST_CASE_MODE) {
						try {
							Constants.LOGGER.info("Parsing test case " + JavaModelHelpers.getMethodSignature(method)); // testUidSearchText
						} catch (JavaModelException e) {
							Constants.LOGGER.severe("ERROR 14: " + e.getMessage());
						}

						currentMethod = method;
						Constants.LOGGER
								.info("Counting number of first level statements for " + method.getElementName());
						if (node.getBody() != null && node.getBody().statements() != null) {
							numberOfFirstLevelStatements = node.getBody().statements().size();
							Constants.LOGGER.info("Number of first level statements for " + method.getElementName()
									+ " is " + numberOfFirstLevelStatements);
						}

						Constants.LOGGER.info("Checking exceptions expected for " + method.getElementName());
						try {
							IAnnotation[] junitAnnotations = method.getAnnotations();
							for (IAnnotation junitAnnotation : junitAnnotations) {
								String annotationFullyQualifiedName = JavaModelHelpers.getFullyQualifiedName(junitAnnotation, method.getDeclaringType());
								if(annotationFullyQualifiedName.equals(Constants.JUNIT4_TEST_ANNOTATION)) {
									IMemberValuePair[] pair = junitAnnotation.getMemberValuePairs();
									for (IMemberValuePair imvp : pair) {
										if(imvp.getMemberName().equals(Constants.JUNIT4_EXPECTS_ANNOTATION)) {
											String expectedException = JavaModelHelpers.getFullyQualifiedName((String)imvp.getValue(), method.getDeclaringType());
											listOfExpectedExceptions.add(expectedException);
										}
									}
									
								}
							}
						} catch (JavaModelException e) {
							Constants.LOGGER.severe(
									"ERROR 28: Error getting annotations for method " + method.getElementName());
							e.printStackTrace();
						}

						List<IMethod> methodsThatCallThisOne = callCalledList.getAllMethodsCalling(currentMethod);
						for (IMethod callingMethod : methodsThatCallThisOne) {
							if (JavaModelHelpers.checkIfMethodsAreFromSameClass(currentMethod, callingMethod)) {
								try {
									otherMethodsInSameClassThatDependOnThis
											.add(JavaModelHelpers.getMethodSignature(callingMethod));
								} catch (JavaModelException e) {
									Constants.LOGGER.severe("ERROR 22: Error getting signature for method "
											+ callingMethod.getElementName());
									e.printStackTrace();
								}
								if (JavaModelHelpers.checkIfMethodIsATestCase(callingMethod, testAnnotations)) {
									try {
										otherTestCasesInSameClassThatDependOnThis
												.add(JavaModelHelpers.getMethodSignature(callingMethod));
									} catch (JavaModelException e) {
										Constants.LOGGER.severe("ERROR 27: Error getting signature for method "
												+ callingMethod.getElementName());
										e.printStackTrace();
									}
								}
							}
						}
					}

					return super.visit(node);
				}
			}
		}
		return false;
	}

	private void executeAndGetCoverage(IMethod method) {
		IType methodType = method.getDeclaringType();
		String className = methodType.getFullyQualifiedName();
		String projectFolder = javaProject.getProject().getLocation().toString();

		try (PrintWriter pw = new PrintWriter(new FileWriter(
				new File(Constants.OUTPUT_FOLDER, javaProject.getElementName() + "coverageScript.sh"), true))) {
			pw.append("cd " + projectFolder + "\n");
			pw.append("rm -rf " + projectFolder + "/target/site/\n");
			pw.append("rm -f " + projectFolder + "/target/jacoco.exec\n");
			pw.append("mvn test jacoco:report -Dtest=" + className + "#" + method.getElementName() + " -DfailIfNoTests=false -P coverage \n");
			pw.append(
					"mkdir -p " + Constants.OUTPUT_FOLDER + "/coverageReports/" + javaProject.getElementName() + "\n");
			pw.append("cp " + projectFolder + "/target/site/jacoco/jacoco.csv " + Constants.OUTPUT_FOLDER
					+ "/coverageReports/" + javaProject.getElementName() + "/" + javaProject.getElementName() + "###"
					+ className + "###" + method.getElementName() + ".csv\n");
			pw.append("\n");
		} catch (IOException e) {
			e.printStackTrace();
		}
//		System.out.println("Running "+method.getElementName());
//		Constants.LOGGER.info("Running method " + method.getElementName());
//		IType methodType = method.getDeclaringType();
//		
//		JUnitCore junit = new JUnitCore();
//		System.out.println("Running "+method.getDeclaringType().getElementName()+"."+method.getElementName());
//		junit.run(Request.method(classFile.getClass(), method.getElementName()));
//		System.out.println("Runned "+classFile.getClass().getName()+"."+method.getElementName());

//		final IRuntime runtime = new LoggerRuntime();
//		final Instrumenter instr = new Instrumenter(runtime);
//		try {
//			final byte[] instrumented = instr.instrument(classFile.getBytes(),
//					method.getDeclaringType().getElementName());
//
//			final RuntimeData data = new RuntimeData();
//			runtime.startup(data);

//		} catch (JavaModelException | IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

	}

	@Override
	public void preVisit(ASTNode node) {
		if (currentMethod != null) {
			if (node instanceof Statement && !(node instanceof Block)) {

				numberOfStatements++;
			}
		}
	}

	@Override
	public boolean visit(MethodInvocation node) {
		Constants.LOGGER.info("Starting visiting method invocation " + node.getName());
		if (currentMethod != null) {
			Constants.LOGGER.info("Succeeded visiting method invocation " + node.getName());

			numberOfMethodInvocations++;
			IMethodBinding imb = node.resolveMethodBinding();
			if (imb == null) {
				Constants.LOGGER.severe("ERROR 3:IMethodBinding for node " + node.getName() + " is null");
			} else {
				IMethod invokedMethod = (IMethod) imb.getJavaElement();
				if (invokedMethod == null) {
					Constants.LOGGER.severe("Error 12:Java element for method " + imb.getName() + " is null");
				} else {
					Constants.LOGGER.info("Visiting method invocation " + invokedMethod.getElementName());
					if (imb.getExceptionTypes().length > 0) {
						numberOfMethodInvocationsWithExceptions++;
						for (ITypeBinding exc : imb.getExceptionTypes()) {
							exceptionsThrownInMethodInvocations.add(exc.getQualifiedName());
							numberOfExceptionsThrown++;
							Constants.LOGGER.info("Checking for catch clause for " + invokedMethod.getElementName());
							CatchClauseMatch ccm = JavaModelHelpers.checkForCatchClause(node, exc);
							Constants.LOGGER.info("Checked for catch clause for " + invokedMethod.getElementName());
							if (ccm == CatchClauseMatch.EXACT) {
								numberOfExceptionsThrownAndCaughtExact++;
							} else if (ccm == CatchClauseMatch.PARTIAL) {
								numberOfExceptionsThrownAndCaughtPartial++;
							}

						}
					}

					Constants.LOGGER.info("Testing for assertion " + invokedMethod.getElementName());

					try {
						distinctMethodInvocations.add(JavaModelHelpers.getMethodSignature(invokedMethod));
					} catch (JavaModelException e1) {
						e1.printStackTrace();
						Constants.LOGGER
								.severe("ERROR 24: Error getting method signature: " + invokedMethod.getElementName());
					}
					if (Helpers.compareStringEquals(imb.getDeclaringClass().getQualifiedName(),
							Constants.JUNIT_ASSERTIONS)) {
						numberOfAssertions++;
						numberOfAssertionsWithRecursion++;
					} else {
						Constants.LOGGER.info("Counting number of assertions in " + invokedMethod.getElementName());

						try {
							numberOfAssertionsWithRecursion += JavaModelHelpers.countNumberOfAssertions(invokedMethod);
						} catch (JavaModelException e) {
							e.printStackTrace();
							Constants.LOGGER.severe("ERROR 4:" + e.getMessage());
							Constants.LOGGER.log(Level.SEVERE, e, () -> e.getMessage());
						}
						Constants.LOGGER.info("Counted number of assertions in " + invokedMethod.getElementName());

						Constants.LOGGER.info("Checking if " + invokedMethod.getElementName()
								+ " belongs to the same class as test case " + currentMethod.getElementName());
						boolean isAnotherMethodInSameClass = JavaModelHelpers
								.checkIfMethodsAreFromSameClass(invokedMethod, currentMethod);
						if (isAnotherMethodInSameClass) {
							try {
								distinctMethodInvocationsInSameClass
										.add(JavaModelHelpers.getMethodSignature(invokedMethod));
							} catch (JavaModelException e) {
								Constants.LOGGER.severe(
										"ERROR 25: Error getting method signature: " + invokedMethod.getElementName());
								e.printStackTrace();
							}
							Constants.LOGGER.info("Checking if " + invokedMethod.getElementName() + " is a test case");
							boolean otherMethodIsATestCase = JavaModelHelpers.checkIfMethodIsATestCase(invokedMethod,
									testAnnotations);
							if (otherMethodIsATestCase) {
								try {
									distinctTestCaseMethodInvocationsInSameClass
											.add(JavaModelHelpers.getMethodSignature(invokedMethod));
								} catch (JavaModelException e) {
									Constants.LOGGER.severe("ERROR 26: Error getting method signature: "
											+ invokedMethod.getElementName());
									e.printStackTrace();
								}
							}
						}
						Constants.LOGGER.info(
								"Checked as '" + isAnotherMethodInSameClass + "' that " + invokedMethod.getElementName()
										+ " belongs to the same class as test case " + currentMethod.getElementName());
					}
					return super.visit(node);
				}
			}
		} else {
			Constants.LOGGER.info("Current method = null while visiting method invocation " + node.getName());

		}
		return false;
	}

	@Override
	public void endVisit(MethodDeclaration node) {
		if (currentMethod != null) {
			Constants.LOGGER.info("End visit " + node.getName());
			CSVEntry csvEntry;
			try {

				csvEntry = new CSVEntry(JavaModelHelpers.getMainProjectName(iProject), javaProject.getElementName(),
						unit.getPath().toString(), currentMethod.getDeclaringType().getFullyQualifiedName(),
						currentMethod.getElementName(), currentMethod.getSignature(),
						JavaModelHelpers.getMethodSignature(currentMethod),
						Helpers.iterableToString(JavaModelHelpers.getMethodAnnotations(currentMethod),
								Constants.SECONDARY_SEPARATOR),
						Integer.toString(numberOfFirstLevelStatements), Integer.toString(numberOfStatements),
						Integer.toString(numberOfMethodInvocations),
						Helpers.streamToString(distinctMethodInvocations.stream(), Constants.SECONDARY_SEPARATOR),
						Integer.toString(distinctMethodInvocations.size()),
						Helpers.streamToString(distinctMethodInvocationsInSameClass.stream(),
								Constants.SECONDARY_SEPARATOR),
						Integer.toString(distinctMethodInvocationsInSameClass.size()),
						Helpers.streamToString(distinctTestCaseMethodInvocationsInSameClass.stream(),
								Constants.SECONDARY_SEPARATOR),
						Integer.toString(distinctTestCaseMethodInvocationsInSameClass.size()),
						Integer.toString(numberOfMethodInvocationsWithExceptions),
						Integer.toString(numberOfExceptionsThrown),
						Integer.toString(numberOfExceptionsThrownAndCaughtExact),
						Integer.toString(numberOfExceptionsThrownAndCaughtPartial),
						Helpers.iterableToString(exceptionsThrownInMethodInvocations, Constants.SECONDARY_SEPARATOR),
						Helpers.iterableToString(listOfExpectedExceptions, Constants.SECONDARY_SEPARATOR),
						Integer.toString(listOfExpectedExceptions.size()),
						Integer.toString(numberOfAssertions), Integer.toString(numberOfAssertionsWithRecursion),
						Helpers.streamToString(otherMethodsInSameClassThatDependOnThis.stream(),
								Constants.SECONDARY_SEPARATOR),
						Integer.toString(otherMethodsInSameClassThatDependOnThis.size()),
						Helpers.streamToString(otherTestCasesInSameClassThatDependOnThis.stream(),
								Constants.SECONDARY_SEPARATOR),
						Integer.toString(otherTestCasesInSameClassThatDependOnThis.size()));

				out.println(csvEntry.toString());
			} catch (JavaModelException e) {
				e.printStackTrace();
			} catch (CoreException e) {
				e.printStackTrace();
			}
			currentMethod = null;
		}
	}
}
