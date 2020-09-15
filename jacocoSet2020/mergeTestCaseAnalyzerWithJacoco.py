import os
import argparse
import glob
import csv

def main():
    parser = argparse.ArgumentParser(
        description='Merges CSV files into one, using JaCoCo metrics, for the FSE project')

    parser.add_argument('csv_file_merged',
                        type=str,
                        help='the first file - Merged')

    parser.add_argument('csv_file_jacoco',
                        type=str,
                        help='the second file - JaCoCo')

    parser.add_argument('csv_file_merged_2',
                        type=str,
                        help='the merged file with JaCoCo metrics')

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
                    'filePath2', # The path to the file containing the test case in Andrew's file (the first slash is not present here)
                    'noBugFixes', # The number of changes to that test case which considered a bug fix
                    'noCommitFixes', # The number of commits changes that test case and classified as a bug fix
                    'noClones', # The number of code clones detected by Nicad5 Tool                
                    'hasCoverageData', # Whether this test case has coverage data gathered by JaCoCo
                    'projectName3', # Project name as extracted from JaCoCo
                    'typeName3', # The fully qualified name of the type that declares the test case, extracted from JaCoCo
                    'methodName3', # The method name, as extracted from JaCoCo
                    'LINE_covered', # Number of LOC covered by this test case (from JaCoCo)
                    ]

    args = parser.parse_args()

    fMerged = open(args.csv_file_merged, "r")
    fJaCoCo = open(args.csv_file_jacoco, "r")
    fMerged2 = open(args.csv_file_merged_2, "w")

    readerMerged = csv.reader(fMerged, delimiter=",")
    readerJaCoCo = csv.reader(fJaCoCo, delimiter=",")

    dataMerged = []
    dataJaCoCo = []

    print("Reading Merged file "+fMerged.name)
    rownum = 0
    for row in readerMerged:
        if rownum > 0:
            dataMerged.append(row)
        rownum += 1

    fMerged.close()
    print("Read %i rows" % rownum)


    print("Reading JaCoCo file "+fJaCoCo.name)
    rownum = 0
    for row in readerJaCoCo:
        if rownum > 0:
            dataJaCoCo.append(row)
        rownum += 1

    fJaCoCo.close()
    print("Read %i rows" % rownum)

    fMerged2.write(','.join(header)+'\n')

    rownum = 0
    for lineMerged in dataMerged:
        projectName = lineMerged[1]
        typeName = lineMerged[3]
        testName = lineMerged[4]
        print("Processing row %i - project %s, type %s, test %s" %(rownum, projectName, typeName, testName))
        rownum += 1

        if lineMerged[28] == 'yes':
            adjustMergedLine(lineMerged)
            cla = countLinesJaCoCoFile(projectName, typeName, testName, dataJaCoCo)
            if cla == 0:
                lineMerged.append('notfound')
            elif cla > 1:
                lineMerged.append("duplicated_%i" % cla)
            else:
                lineJaCoCo = findLineJaCoCoFile(projectName, typeName, testName, dataJaCoCo)
                lineMerged.append('yes')
                lineMerged.extend(lineJaCoCo)
                lineJaCoCo.append('ok')
                fMerged2.write(','.join(lineMerged)+'\n')

    fMerged2.close()


def adjustMergedLine(lineMerged):
    while(len(lineMerged) < 35):
        lineMerged.append('')
    while(len(lineMerged) > 35):
        lineMerged.pop()

def countLinesJaCoCoFile(projectName, typeName, testName, dataJaCoCo):
# JaCoCo's file:
# projectName = 0
# typeName = 1
# testName = 2
    ret = 0
    for line in dataJaCoCo:
        if line[0] == projectName and line[1] == typeName and line[2] == testName:
            ret += 1
    return ret

def findLineJaCoCoFile(projectName, typeName, testName, dataJaCoCo):
# JaCoCo's file:
# projectName = 0
# typeName = 1
# testName = 2
    ret = 0
    for line in dataJaCoCo:
        if line[0] == projectName and line[1] == typeName and line[2] == testName:
            return line
    return None

if __name__ == "__main__":
    main()