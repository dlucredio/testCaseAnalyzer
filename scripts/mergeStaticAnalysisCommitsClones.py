import os
import argparse
import glob
import csv

def findLineStaticAnalysis(mainProjectName, projectName, filePath, testName, dataStaticAnalysis):
# Static analysis file:
# mainProjectName = 0
# projectName = 1
# filePath = 2 (ex: /optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
# testName = 4
    className = filePath.split("/")[-1]
    retLine = []
    for line in dataStaticAnalysis:
        lineClassName = line[2].split("/")[-1]
        if line[0] == mainProjectName and line[1] == projectName and lineClassName == className and line[4] == testName:
            retLine.append(line)
    return retLine

def findLinesCommitsClonesProjectNameOnly(projectName, filePath, testName, dataCommitsClones):
# CommitsClones's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
    className = filePath.split("/")[-1]
    retLine = []
    for line in dataCommitsClones:
        lineClassName = line[2].split("/")[-1]
        if line[0] == projectName and lineClassName == className and line[1] == testName:
            retLine.append(line)
    return retLine

def findLinesCommitsClonesMainProjectNameOnly(mainProjectName, filePath, testName, dataCommitsClones):
# CommitsClones's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
    className = filePath.split("/")[-1]
    retLine = []
    for line in dataCommitsClones:
        lineClassName = line[2].split("/")[-1]
        if line[0] == mainProjectName and lineClassName == className and line[1] == testName:
            retLine.append(line)
    return retLine

def findLinesCommitsClonesProjectNameOnlyWithoutClass(projectName, testName, dataCommitsClones):
# CommitsClones's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
    retLine = []
    for line in dataCommitsClones:
        if line[0] == projectName and line[1] == testName:
            retLine.append(line)
    return retLine

def findLinesCommitsClonesMainProjectNameOnlyWithoutClass(mainProjectName, testName, dataCommitsClones):
# CommitsClones's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
    retLine = []
    for line in dataCommitsClones:
        if line[0] == mainProjectName and line[1] == testName:
            retLine.append(line)
    return retLine

def findLinesCommitsClonesMainProjectAndProjectNames(mainProjectName, projectName, filePath, testName, dataCommitsClones):
# CommitsClones's file:
# projectName = 0
# testName = 1
# filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
    className = filePath.split("/")[-1]
    retLine = []
    for line in dataCommitsClones:
        lineClassName = line[2].split("/")[-1]
        if (line[0] == mainProjectName or line[0] == projectName) and lineClassName == className and line[1] == testName:
            retLine.append(line)
    return retLine

# def findLineCommitsClones(mainProjectName, projectName, filePath, testName, dataCommitsClones):
# # CommitsClones's file:
# # projectName = 0
# # testName = 1
# # filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
#     className = filePath.split("/")[-1]
#     ret = 0
#     for line in dataCommitsClones:
#         lineClassName = line[2].split("/")[-1]
#         if (line[0] == mainProjectName or line[0] == projectName) and lineClassName == className and line[1] == testName:
#             return line
#     return None

# def findLineCommitsClonesWithoutClass(mainProjectName, projectName, testName, dataCommitsClones):
# # CommitsClones's file:
# # projectName = 0
# # testName = 1
# # filePath = 2 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
#     ret = 0
#     for line in dataCommitsClones:
#         if (line[0] == mainProjectName or line[0] == projectName) and line[1] == testName:
#             return line
#     return None


parser = argparse.ArgumentParser(
    description='Merges static analysis, commits and clones into one')

parser.add_argument('csv_file_static_analysis',
                    type=str,
                    help='the first file - Static Analysis')

parser.add_argument('csv_file_commits_clones',
                    type=str,
                    help='the second file - Commits and clones')

parser.add_argument('csv_file_merged',
                    type=str,
                    help='the merged file')

parser.add_argument('csv_file_duplicated_static_analysis',
                    type=str,
                    help='the file containing methods that have the same names in Static Analysis\'s file')

parser.add_argument('csv_file_duplicated_commits_clones',
                    type=str,
                    help='the file containing methods that have the same names in Commits and clones\'s file')

parser.add_argument('csv_file_unused_commits_clones',
                    type=str,
                    help='the file containing lines from Commits and Clones\'s file that were never used')

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
				'numberOfExceptionsThrownAndCaughtPartial', # Number of exceptions thrown in method invocations and specifically caught but not an exact match (there is a "throw X" and a "catch Y" where Y may be X or a supertype of X)
				'exceptionsThrownInMethodInvocations', # List of exceptions thrown in all method invocations (complete AST)
				'listOfExpectedExceptions', # List of exceptions expected in JUnit4 annotations
				'numberOfDistinctExpectedExceptions', # Number of exceptions expected in JUnit4 annotations
                'numberOfAssertions', # Number of JUnit assertions, without going inside method invocations
				'numberOfAssertionsWithRecursion', # Number of JUnit assertions, recursively going inside method invocations up to 5 recursion levels
                'distinctMethodsInSameClassThatCallThisOne', # List of distinct methods in the same class that call this one
                'numberOfdistinctMethodsInSameClassThatCallThisOne', # Number of distinct methods in the same class that call this one
                'distinctTestCasesInSameClassThatCallThisOne', # List of distinct test cases in the same class that call this one
                'numberOfdistinctTestCasesInSameClassThatCallThisOne', # Number of distinct test cases in the same class that call this one
                'hasCommitData', # Whether this test case has commit data gathered by NICAD
                'mainProjectName2',  # Main project name (GitHub project) - repeated from mainProjectName for matching
                'methodName2', # Aggregated list of test cases for each project which has code clone or edited at some time - repeated from methodName for matching
                'filePath2', # The path to the file containing the test case in CommitsClones's file (the first slash is not present here)
                'noBugFixes', # The number of changes to that test case which considered a bug fix
                'noCommitFixes', # The number of commits changes that test case and classified as a bug fix
                'noClones' # The number of code clones detected by Nicad5 Tool                
                ]

args = parser.parse_args()

fStaticAnalysis = open(args.csv_file_static_analysis, "r")
fCommitsClones = open(args.csv_file_commits_clones, "r")
fMerged = open(args.csv_file_merged, "w")
fDuplicatedStaticAnalysis = open(args.csv_file_duplicated_static_analysis, "w")
fDuplicatedCommitsClones = open(args.csv_file_duplicated_commits_clones, "w")
fUnusedCommitsClones = open(args.csv_file_unused_commits_clones, "w")

readerStaticAnalysis = csv.reader(fStaticAnalysis, delimiter=",")
readerCommitsClones = csv.reader(fCommitsClones, delimiter=",")

dataStaticAnalysis = []
dataCommitsClones = []
duplicateStaticAnalysis = []
duplicateCommitsClones = []

print("Reading static analysis file "+fStaticAnalysis.name)
rownum = 0
for row in readerStaticAnalysis:
    if rownum > 0:
        dataStaticAnalysis.append(row)
    rownum += 1

fStaticAnalysis.close()
print("Read %i rows" % rownum)


print("Reading commits clones file "+fCommitsClones.name)
rownum = 0
for row in readerCommitsClones:
    if rownum > 0:
        dataCommitsClones.append(row)
    rownum += 1

fCommitsClones.close()
print("Read %i rows" % rownum)

fMerged.write(','.join(header)+'\n')

rownum = 0
for lineStaticAnalysis in dataStaticAnalysis:
    mainProjectName = lineStaticAnalysis[0]
    projectName = lineStaticAnalysis[1]
    filePath = lineStaticAnalysis[2]
    testName = lineStaticAnalysis[4]
    print("Processing row %i - project %s/%s, file %s, test %s" %(rownum, mainProjectName, projectName, filePath, testName))
    rownum += 1

    if len(findLineStaticAnalysis(mainProjectName, projectName, filePath, testName, dataStaticAnalysis)) > 1:
        duplicateStaticAnalysis.append(lineStaticAnalysis)
    else:
        foundLines = findLinesCommitsClonesProjectNameOnly(projectName, filePath, testName, dataCommitsClones)
        if len(foundLines) == 0:
            foundLines = findLinesCommitsClonesMainProjectNameOnly(mainProjectName, filePath, testName, dataCommitsClones)
        if len(foundLines) == 0:
            foundLines = findLinesCommitsClonesMainProjectAndProjectNames(mainProjectName, projectName, filePath, testName, dataCommitsClones)
        if len(foundLines) == 0:
            foundLines = findLinesCommitsClonesProjectNameOnlyWithoutClass(projectName, testName, dataCommitsClones)
        if len(foundLines) == 0:
            foundLines = findLinesCommitsClonesMainProjectNameOnlyWithoutClass(mainProjectName, testName, dataCommitsClones)
        if len(foundLines) == 0:
            lineStaticAnalysis.append('notfound')
            lineStaticAnalysis.append(mainProjectName)
            lineStaticAnalysis.append('')
            lineStaticAnalysis.append('')
            lineStaticAnalysis.append('0')
            lineStaticAnalysis.append('0')
            lineStaticAnalysis.append('0')
        elif len(foundLines) > 1:
            duplicateCommitsClones.append(lineStaticAnalysis)
            lineStaticAnalysis.append("duplicated_%i" % len(foundLines))
        else:
            lineStaticAnalysis.append('yes')
            lineStaticAnalysis.extend(foundLines[0])
            foundLines[0].append('ok')
        fMerged.write(','.join(lineStaticAnalysis)+'\n')

fMerged.close()

rownum = 0
for line in dataCommitsClones:
    if line[-1] != "ok":
        fUnusedCommitsClones.write(','.join(line)+'\n')
fUnusedCommitsClones.close()

for dtcd in duplicateStaticAnalysis:
    fDuplicatedStaticAnalysis.write(','.join(dtcd)+'\n')
fDuplicatedStaticAnalysis.close()

for dtca in duplicateCommitsClones:
    fDuplicatedCommitsClones.write(','.join(dtca)+'\n')
fDuplicatedCommitsClones.close()