package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.jdt.core.IAnnotation;
import org.eclipse.jdt.core.ICompilationUnit;
import org.eclipse.jdt.core.IMethod;
import org.eclipse.jdt.core.IType;
import org.eclipse.jdt.core.JavaModelException;
import org.eclipse.jdt.core.Signature;
import org.eclipse.jdt.core.dom.AST;
import org.eclipse.jdt.core.dom.ASTNode;
import org.eclipse.jdt.core.dom.ASTParser;
import org.eclipse.jdt.core.dom.ASTVisitor;
import org.eclipse.jdt.core.dom.CatchClause;
import org.eclipse.jdt.core.dom.IMethodBinding;
import org.eclipse.jdt.core.dom.ITypeBinding;
import org.eclipse.jdt.core.dom.MethodDeclaration;
import org.eclipse.jdt.core.dom.MethodInvocation;
import org.eclipse.jdt.core.dom.SimpleType;
import org.eclipse.jdt.core.dom.TryStatement;
import org.eclipse.jdt.core.dom.Type;
import org.eclipse.jdt.core.dom.UnionType;

public class JavaModelHelpers {
	private static int numberOfRecursiveCalls;
	private static HashMap<String, Integer> numberOfAssertionsCache;
	
	public static void initializeHelperVariables() {
		numberOfAssertionsCache = new HashMap<>();
		numberOfRecursiveCalls = 0;
		
	}
	
	public static String getMainProjectName(IProject project) throws CoreException {
		File projectLocation = new File(project.getLocation().toString());
		while (!projectLocation.getParentFile().equals(Constants.ROOT_FOLDER)) {
			projectLocation = projectLocation.getParentFile();
		}
		return projectLocation.getName();
	}
	
	
	public static boolean checkIfMethodIsATestCase(IMethod method, List<String> testAnnotations) {
		List<String> methodAnnotations;
		try {
			methodAnnotations = getMethodAnnotations(method);
			return Helpers.compareStringsContains(methodAnnotations, testAnnotations);
		} catch (JavaModelException e) {
			Constants.LOGGER.severe("ERROR 17:Error checking if method "+method.getElementName()+" is a test case");
			e.printStackTrace();
		}
		return false;
	}
	
	public static boolean checkIfSameMethod(IMethod method1, IMethod method2) {
		boolean sameMethodSignature = false;
		try {
			sameMethodSignature = getMethodSignature(method1).equals(getMethodSignature(method2));
		} catch (JavaModelException e) {
			Constants.LOGGER.severe("ERROR 21:Error comparing methods " + method1.getElementName() + " and "
					+ method2.getElementName());
			e.printStackTrace();
		}
		boolean sameDeclaringType = method1.getDeclaringType().getFullyQualifiedName()
				.equals(method2.getDeclaringType().getFullyQualifiedName());
		return sameMethodSignature && sameDeclaringType;
	}
	public static boolean checkIfMethodsAreFromSameClass(IMethod method1, IMethod method2) {
		boolean sameMethodSignature = false;
		try {
			sameMethodSignature = getMethodSignature(method1).equals(getMethodSignature(method2));
		} catch (JavaModelException e) {
			Constants.LOGGER.severe("ERROR 16:Error comparing methods " + method1.getElementName() + " and "
					+ method2.getElementName());
			e.printStackTrace();
		}
		boolean sameDeclaringType = method1.getDeclaringType().getFullyQualifiedName()
				.equals(method2.getDeclaringType().getFullyQualifiedName());
		return sameDeclaringType && !sameMethodSignature;
	}

	
	public static int countNumberOfAssertions(IMethod methodToCount) throws JavaModelException {
		String methodCacheKey = getMethodCacheKey(methodToCount);
		Integer i = numberOfAssertionsCache.get(methodCacheKey);
		if (i != null) {
			return i;
		}

		if (numberOfRecursiveCalls > Constants.MAX_RECURSIVE_CALLS) {
			return 0;
		}

		ICompilationUnit cu = methodToCount.getDeclaringType().getCompilationUnit();

		if (cu == null) {
			return 0;
		}

		SimpleCounter ret = new SimpleCounter();
		numberOfRecursiveCalls++;

		ASTParser parser = ASTParser.newParser(AST.JLS11);
		parser.setKind(ASTParser.K_COMPILATION_UNIT);
		parser.setSource(cu);
		parser.setResolveBindings(true);
		ASTNode node = parser.createAST(null);
		node.accept(new ASTVisitor() {

			IMethod currentMethod;

			@Override
			public boolean visit(MethodDeclaration node) {
				currentMethod = null;

				IMethodBinding iMethodBinding = node.resolveBinding();
				if (iMethodBinding == null) {
					Constants.LOGGER.severe("ERROR 5:IMethodBinding for node " + node.getName() + " is null");
				} else {
					IMethod declaredMethod = (IMethod) iMethodBinding.getJavaElement();
					if (declaredMethod == null) {
						Constants.LOGGER.severe(
								"ERROR 15:Java Element for method binding " + iMethodBinding.getName() + " is null");

					} else {
						if (methodToCount.equals(declaredMethod)) {
							currentMethod = declaredMethod;
							return super.visit(node);
						}
					}
				}
				return false;
			}

			@Override
			public boolean visit(MethodInvocation node) {
				if (currentMethod != null) {
					IMethodBinding iMethodBinding = node.resolveMethodBinding();
					if (iMethodBinding == null) {
						Constants.LOGGER.severe("ERROR 6:IMethodBinding for node " + node.getName() + " is null");
					} else {
						IMethod invokedMethod = (IMethod) iMethodBinding.getJavaElement();
						if (invokedMethod == null) {
							Constants.LOGGER.severe("ERROR 7:Invoked method " + iMethodBinding.getName() + " is null");
						} else {
							IType declaringType = invokedMethod.getDeclaringType();
							if (declaringType == null) {
								Constants.LOGGER.severe(
										"ERROR 8:Declaring type for " + invokedMethod.getElementName() + " is null");
							} else {
								if (Helpers.compareStringEquals(declaringType.getFullyQualifiedName(),
										Constants.JUNIT_ASSERTIONS)) {
									ret.increment(1);
								} else {
									try {
										ret.increment(countNumberOfAssertions(invokedMethod));
									} catch (JavaModelException e) {
										e.printStackTrace();
										Constants.LOGGER.severe("ERROR 9:" + e.getMessage());
										Constants.LOGGER.log(Level.SEVERE, e, () -> e.getMessage());
									}
								}
							}
						}
					}
				}
				return super.visit(node);
			}

			@Override
			public void endVisit(MethodDeclaration node) {
				currentMethod = null;
			}

		});

		numberOfRecursiveCalls--;
		numberOfAssertionsCache.put(methodCacheKey, ret.getValue());
		return ret.getValue();
	}

	public static String getMethodCacheKey(IMethod iMethod) throws JavaModelException {
		return iMethod.getDeclaringType().getFullyQualifiedName() + "#" + getMethodSignature(iMethod);
	}

	public static CatchClauseMatch checkForCatchClause(MethodInvocation node, ITypeBinding exception) {
		ASTNode parent = node.getParent();
		while (parent != null) {

			if (parent.getNodeType() == ASTNode.TRY_STATEMENT) {
				TryStatement ts = (TryStatement) parent;
				List<CatchClause> catchClauses = (List<CatchClause>) ts.catchClauses();
				for (CatchClause cc : catchClauses) {
					CatchClauseMatch ccm = checkForCatchClause(cc.getException().getType(), exception);
					if (ccm == CatchClauseMatch.EXACT || ccm == CatchClauseMatch.PARTIAL) {
						return ccm;
					}
				}

			}

			parent = parent.getParent();
		}
		return CatchClauseMatch.NONE;
	}

	public static CatchClauseMatch checkForCatchClause(Type type, ITypeBinding exceptionThrown) {
		int catchType = type.getNodeType();
		if (catchType == ASTNode.SIMPLE_TYPE) {
			SimpleType st = (SimpleType) type;
			ITypeBinding itb = type.resolveBinding();
			if (itb == null) {
				Constants.LOGGER.severe("ERROR 10:ITypeBinding for node " + st.getName() + " is null");
			} else {
				if (itb.equals(exceptionThrown)) {
					return CatchClauseMatch.EXACT;
				} else if (isSuperType(itb, exceptionThrown)) {
					return CatchClauseMatch.PARTIAL;
				}
			}

		} else if (catchType == ASTNode.UNION_TYPE) {
			UnionType ut = (UnionType) type;
			for (Object t : ut.types()) {
				CatchClauseMatch ccm = checkForCatchClause((Type) t, exceptionThrown);
				if (ccm == CatchClauseMatch.EXACT || ccm == CatchClauseMatch.PARTIAL) {
					return ccm;
				}
			}
		}
		return CatchClauseMatch.NONE;
	}

	public static boolean isSuperType(ITypeBinding t1, ITypeBinding t2) {
		ITypeBinding superClass = t2.getSuperclass();
		while (superClass != null) {
			if (t1.equals(superClass)) {
				return true;
			}

			superClass = superClass.getSuperclass();
		}
		return false;
	}

	public static List<String> getTypeAnnotations(IType type) throws JavaModelException {
		List<String> ret = new ArrayList<>();

		for (IAnnotation a : type.getAnnotations()) {
			ret.add(getFullyQualifiedName(a, type));
		}

		return ret;
	}

	public static List<String> getMethodAnnotations(IMethod method) throws JavaModelException {
		List<String> ret = new ArrayList<>();
		IType type = method.getDeclaringType();

		for (IAnnotation am : method.getAnnotations()) {
			ret.add(getFullyQualifiedName(am, type));
		}

		return ret;
	}

	public static String getMethodSignature(IMethod method) throws JavaModelException {
		return Signature
				.toString(method.getSignature(), method.getElementName(), method.getParameterNames(), false, true)
				.replace(',', ';');
	}
	
	public static String getFullyQualifiedName(String elementName, IType type) throws JavaModelException {
		String[][] fullyQualifiedName = type.resolveType(elementName);
		if (fullyQualifiedName == null) {
			Constants.LOGGER.severe("ERROR 11:Type resolving for fully qualified name for element "
					+ elementName + " is null");
			return "";
		} else {
			String ret = "";

			for (int i = 0; i < fullyQualifiedName.length; i++) {
				String[] s1 = fullyQualifiedName[i];
				for (int j = 0; j < s1.length; j++) {
					String s2 = s1[j];
					ret += s2;
					if (j < s1.length - 1) {
						ret += ".";
					}
				}
				if (i < fullyQualifiedName.length - 1) {
					ret += ",";
				}
			}

			return ret;
		}
	}

	public static String getFullyQualifiedName(IAnnotation annotation, IType type) throws JavaModelException {
		return getFullyQualifiedName(annotation.getElementName(), type);
	}
}
