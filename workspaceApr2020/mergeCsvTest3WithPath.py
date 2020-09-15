import os
import argparse
import glob
import csv

# Daniel's file:
# projectName = 0
# filePath = 2 (ex: /optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
# testName = 4

# Andrew's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)


def findLine(projectName, filePath, testName, iProjectName, iFilePath, iTestName, a):
    for line in a:
        if line[iProjectName] == projectName and line[iFilePath] == filePath and line[iTestName] == testName:
            return line
    return None

def countLines(projectName, filePath, testName, iProjectName, iFilePath, iTestName, a):
    ret = 0
    for line in a:
        if line[iProjectName] == projectName and line[iFilePath] == filePath and line[iTestName] == testName:
            ret += 1
    return ret

parser = argparse.ArgumentParser(
    description='Merges multiple CSV files into one, for the FSE project')

parser.add_argument('csv_file_daniel',
                    type=str,
                    help='the first file - Daniel')

parser.add_argument('csv_file_andrew',
                    type=str,
                    help='the second file - Andrew')

parser.add_argument('csv_file_merged',
                    type=str,
                    help='the merged file')

parser.add_argument('csv_file_duplicated',
                    type=str,
                    help='the file containing methods that have the same names')

parser.add_argument('csv_file_unused_andrew',
                    type=str,
                    help='the file containing lines from Andrew\'s file that were never used')

header = [ 'mainProjectName', # Main project name (GitHub project)
				'projectName', # Eclipse project name (subproject/module in GitHub)
				'filePath', # The path to the file containing the test case
				'typeName', # The fully qualified name of the type that declares the test case
				'methodName', # The name of the test case (method name)
				'methodShortSignature', # Method (test case) short signature as internally represented in the JVM
				'methodVerboseSignature', # Method (test case) signature as represented in the source code
				'methodAnnotations', # Method (test case) annotations
				'numberOfFirstLevelStatements', # Number of statements in the method's body (only first level statements. Nested statements are not counted)
				'numberOfStatements', # Total number of statements. The entire body AST is traversed and all statements are counted
				'numberOfMethodInvocations', # Number of statements that are method invocations (complete AST)
				'distinctMethodInvocations', # List of distinct method invocations (complete AST)
				'numberOfDistinctMethodInvocations', # Number of distinct method invocations (complete AST)
                'distinctMethodInvocationsInSameClass', # List of distinct method invocations in the same class
                'numberOfDistinctMethodInvocationsInSameClass', # Number of distinct method invocations in the same class
                'distinctTestCaseMethodInvocationsInSameClass', # List of distinct test case method invocations in same class
                'numberOfDistinctTestCaseMethodInvocationsInSameClass', # Number of distinct test case method invocations in the same class
				'numberOfMethodInvocationsWithExceptions', # Number of statements that are method invocations with exceptions being thrown (complete AST)
				'numberOfExceptionsThrown', # Number of exceptions thrown in method invocations
				'numberOfExceptionsThrownAndCaughtExact', # Number of exceptions thrown in method invocations and specifically caught (there is a "throw X" and a corresponding "catch X")
				'numberOfExceptionsThrownAndCaughtPartial', # // Number of exceptions thrown in method invocations and specifically caught but not an exact match (there is a "throw X" and a "catch Y" where Y may be X or a supertype of X)
				'exceptionsThrownInMethodInvocations', # List of exceptions thrown in all method invocations (complete AST)
				'numberOfAssertions', # Number of JUnit assertions, without going inside method invocations
				'numberOfAssertionsWithRecursion', # Number of JUnit assertions, recursively going inside method invocations up to 5 recursion levels
                'distinctMethodsInSameClassThatCallThisOne', # List of distinct methods in the same class that call this one
                'numberOfdistinctMethodsInSameClassThatCallThisOne', # Number of distinct methods in the same class that call this one
                'distinctTestCasesInSameClassThatCallThisOne', # List of distinct test cases in the same class that call this one
                'numberOfdistinctTestCasesInSameClassThatCallThisOne', # Number of distinct test cases in the same class that call this one
                'hasCommitData', # Whether this test case has commit data gathered by NICAD
                'mainProjectName2',  # Main project name (GitHub project) - repeated from mainProjectName for matching
                'methodName2', # Aggregated list of test cases for each project which has code clone or edited at some time - repeated from methodName for matching
                'noBugFixes', # The number of changes to that test case which considered a bug fix
                'noCommitFixes', # The number of commits changes that test case and classified as a bug fix
                'noClones' # The number of code clones detected by Nicad5 Tool                
                ]

args = parser.parse_args()

fDaniel = open(args.csv_file_daniel, "r")
fAndrew = open(args.csv_file_andrew, "r")
fMerged = open(args.csv_file_merged, "w")
fDuplicated = open(args.csv_file_duplicated, "w")
fUnusedAndrew = open(args.csv_file_unused_andrew, "w")

readerDaniel = csv.reader(fDaniel, delimiter=",")
readerAndrew = csv.reader(fAndrew, delimiter=",")

dataDaniel = []
dataAndrew = []
duplicateTestCases = []

print("Reading Daniel's file "+fDaniel.name)
rownum = 0
for row in readerDaniel:
    if rownum > 0:
        dataDaniel.append(row)
    rownum += 1

fDaniel.close()
print("Read %i rows" % rownum)


print("Reading Andrew's file "+fAndrew.name)
rownum = 0
for row in readerAndrew:
    if rownum > 0:
        dataAndrew.append(row)
    rownum += 1

fAndrew.close()
print("Read %i rows" % rownum)

fMerged.write(','.join(header)+'\n')

rownum = 0
for lineDaniel in dataDaniel:
    projectName = lineDaniel[0]
    filePath = lineDaniel[2]
    testName = lineDaniel[4]
    print("Processing row %i - project %s, file %s, test %s" %(rownum, projectName, filePath, testName))
    rownum += 1

    if countLines(projectName, filePath, testName, 0, 2, 4, dataDaniel) > 1:
        duplicateTestCases.append(lineDaniel)
    else:
        lineAndrew = findLine(projectName, filePath[1:], testName, 0, 2, 1, dataAndrew)
        if lineAndrew != None:
            lineDaniel.append('yes')
            lineDaniel.extend(lineAndrew)
            lineAndrew.append('ok')
        else:
            lineDaniel.append('no')
        fMerged.write(','.join(lineDaniel)+'\n')

fMerged.close()

rownum = 0
for line in dataAndrew:
    if line[-1] != "ok":
        fUnusedAndrew.write(','.join(line)+'\n')
fUnusedAndrew.close()

for dtc in duplicateTestCases:
    fDuplicated.write(','.join(dtc)+'\n')
fDuplicated.close()
