package br.ufscar.dc.dlucredio.fseanalyzer.handlers;

public class CSVEntry {
	public static String getFieldNames() {
		return "mainProjectName," + "projectName," + "filePath," + "typeName," + "methodName," + "methodShortSignature,"
				+ "methodVerboseSignature," + "methodAnnotations," + "numberOfFirstLevelStatements,"
				+ "numberOfStatements," + "numberOfMethodInvocations," + "distinctMethodInvocations,"
				+ "numberOfDistinctMethodInvocations," + "distinctMethodInvocationsInSameClass,"
				+ "numberOfDistinctMethodInvocationsInSameClass," + "distinctTestCaseMethodInvocationsInSameClass,"
				+ "numberOfDistinctTestCaseMethodInvocationsInSameClass," + "numberOfMethodInvocationsWithExceptions,"
				+ "numberOfExceptionsThrown," + "numberOfExceptionsThrownAndCaughtExact,"
				+ "numberOfExceptionsThrownAndCaughtPartial," + "exceptionsThrownInMethodInvocations,"
				+ "listOfExpectedExceptions," + "numberOfDistinctExpectedExceptions,"
				+ "numberOfAssertions," + "numberOfAssertionsWithRecursion,"
				+ "distinctMethodsInSameClassThatCallThisOne," + "numberOfdistinctMethodsInSameClassThatCallThisOne,"
				+ "distinctTestCasesInSameClassThatCallThisOne," + "numberOfdistinctTestCasesInSameClassThatCallThisOne";
	}

	private String[] fields;

	public CSVEntry(String mainProjectName, String projectName, String filePath, String typeName, String methodName,
			String methodShortSignature, String methodVerboseSignature, String methodAnnotations,
			String numberOfFirstLevelStatements, String numberOfStatements, String numberOfMethodInvocations,
			String distinctMethodInvocations, String numberOfDistinctMethodInvocations,
			String distinctMethodInvocationsInSameClass, String numberOfDistinctMethodInvocationsInSameClass,
			String distinctTestCaseMethodInvocationsInSameClass,
			String numberOfDistinctTestCaseMethodInvocationsInSameClass, String numberOfMethodInvocationsWithExceptions,
			String numberOfExceptionsThrown, String numberOfExceptionsThrownAndCaughtExact,
			String numberOfExceptionsThrownAndCaughtPartial, String exceptionsThrownInMethodInvocations,
			String listOfExpectedExceptions, String numberOfDistinctExpectedExceptions,
			String numberOfAssertions, String numberOfAssertionsWithRecursion,
			String distinctMethodsInSameClassThatCallThisOne, String numberOfdistinctMethodsInSameClassThatCallThisOne,
			String distinctTestCasesInSameClassThatCallThisOne,
			String numberOfdistinctTestCasesInSameClassThatCallThisOne) {
		fields = new String[] { mainProjectName, // Main project name
				projectName, // Project name
				filePath, // File name
				typeName, // Name of the declaring type
				methodName, // Method (test case) name
				methodShortSignature, // Method (test case) short signature as internally represented in the JVM
				methodVerboseSignature, // Method (test case) signature as represented in the source code
				methodAnnotations, // Method (test case) annotations
				numberOfFirstLevelStatements, // Number of statements in the method's body (only first level statements.
												// Nested statements are not counted)
				numberOfStatements, // Total number of statements. The entire body AST is traversed and all
									// statements are counted
				numberOfMethodInvocations, // Number of statements that are method invocations (complete AST)
				distinctMethodInvocations, // List of distinct method invocations (complete AST)
				numberOfDistinctMethodInvocations, // Number of distinct method invocations (complete AST)
				distinctMethodInvocationsInSameClass, // List of distinct method invocations (complete AST) that are in
														// the same class
				numberOfDistinctMethodInvocationsInSameClass, // Number of distinct method invocations (complete AST)
																// that are in the same class
				distinctTestCaseMethodInvocationsInSameClass, // List of distinct method invocations (complete AST) that
																// are in the same class and are test cases
				numberOfDistinctTestCaseMethodInvocationsInSameClass, // Number of distinct method invocations (complete
																		// AST) that are in the same class and are test
																		// cases
				numberOfMethodInvocationsWithExceptions, // Number of statements that are method invocations with
															// exceptions being thrown (complete AST)
				numberOfExceptionsThrown, // Number of exceptions thrown in method invocations
				numberOfExceptionsThrownAndCaughtExact, // Number of exceptions thrown in method invocations and
														// specifically
				// caught
				numberOfExceptionsThrownAndCaughtPartial, // Number of exceptions thrown in method invocations and
															// specifically
				// caught but not an exact match (a supertype catching a subtype)
				exceptionsThrownInMethodInvocations, // List of exceptions thrown in all method invocations (complete
														// AST)
				listOfExpectedExceptions, // List of exceptions expected in JUnit4 annotations
				numberOfDistinctExpectedExceptions, // Number of exceptions expected in JUnit4 annotations
				numberOfAssertions, // Number of JUnit assertions, without going inside method invocations
				numberOfAssertionsWithRecursion, // Number of JUnit assertions, going inside method invocations
				distinctMethodsInSameClassThatCallThisOne, // List of methods from the same class that call this one
				numberOfdistinctMethodsInSameClassThatCallThisOne, // Number of methods from the same class that call
																	// this one
				distinctTestCasesInSameClassThatCallThisOne, // List of test cases from the same class that call this
																// one
				numberOfdistinctTestCasesInSameClassThatCallThisOne // Number of test cases from the same class that
																	// call this one
		};
	}

	@Override
	public String toString() {
		return Helpers.arrayToString(fields, ",");
	}

}
