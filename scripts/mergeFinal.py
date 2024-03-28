import os
import argparse
import glob
import csv

def findLines2(projectName, filePath, testName, data2):
# projectName = 0
# filePath = 2 (ex: /jbehave-needle/src/test/java/org/jbehave/core/configuration/needle/NeedleAnnotationBuilderBehaviour.java)
# testName = 4
    retLine = []
    for line in data2:
        if line[0] == projectName and line[4] == testName and line[2] == filePath:
            retLine.append(line)
    return retLine

def findLines3(projectName, filePath, testName, data3):
# projectName = 0
# filePath = 3 (ex: test/com/amazon/ion/util/EquivalenceTest.java)
# testName = 2
    retLine = []
    className = filePath.split("/")[-1]
    for line in data3:
        lineClassName = line[3].split("/")[-1]
        if line[0] == projectName and line[2] == testName and className == lineClassName:
            retLine.append(line)
    return retLine

parser = argparse.ArgumentParser(
    description='Merges staticAnalysisCommitsClonesCoverage.csv and locComplexityEntropy.csv')

parser.add_argument('csv_file_2',
                    type=str,
                    help='the first file - staticAnalysisCommitsClonesCoverage')

parser.add_argument('csv_file_3',
                    type=str,
                    help='the second file - locComplexityEntropy')

parser.add_argument('csv_file_merged',
                    type=str,
                    help='the merged file')


header_file_2 = [ 
    'mainProjectName',
    'projectName',
    'filePath',
    'typeName',
    'methodName',
    'methodShortSignature',
    'methodVerboseSignature',
    'methodAnnotations',
    'numberOfFirstLevelStatements',
    'numberOfStatements',
    'numberOfMethodInvocations',
    'distinctMethodInvocations',
    'numberOfDistinctMethodInvocations',
    'distinctMethodInvocationsInSameClass',
    'numberOfDistinctMethodInvocationsInSameClass',
    'distinctTestCaseMethodInvocationsInSameClass',
    'numberOfDistinctTestCaseMethodInvocationsInSameClass',
    'numberOfMethodInvocationsWithExceptions',
    'numberOfExceptionsThrown',
    'numberOfExceptionsThrownAndCaughtExact',
    'numberOfExceptionsThrownAndCaughtPartial',
    'exceptionsThrownInMethodInvocations',
    'listOfExpectedExceptions',
    'numberOfDistinctExpectedExceptions',
    'numberOfAssertions',
    'numberOfAssertionsWithRecursion',
    'distinctMethodsInSameClassThatCallThisOne',
    'numberOfdistinctMethodsInSameClassThatCallThisOne',
    'distinctTestCasesInSameClassThatCallThisOne',
    'numberOfdistinctTestCasesInSameClassThatCallThisOne',
    'hasCommitData',
    'mainProjectName2',
    'methodName2',
    'filePath2',
    'noBugFixes',
    'noCommitFixes',
    'noClones',
    'hasCoverageData',
    'projectName3',
    'typeName3',
    'methodName3',
    'LINE_covered'
]


header_file_3 = [ 
    'projectName',
    'kind',
    'testCase',
    'filePath',
    'CountLineCode',
    'Cyclomatic',
    'CyclomaticModified',
    'CyclomaticStrict',
    'projectName2',
    'filePath2',
    'testCase2',
    'halsteadLength',
    'halsteadVocabulary',
    'halsteadVolume',
    'entropy'
]

header_merged = [ 
    'mainProjectName', #0
    'projectName', #1
    'filePath', #2
    'typeName', #3
    'methodName', #4
    'methodShortSignature', #5
    'methodVerboseSignature', #6
    'methodAnnotations', #7
    'numberOfFirstLevelStatements',  #8
    'numberOfStatements', #9
    'numberOfMethodInvocations', #10
    'distinctMethodInvocations', #11
    'numberOfDistinctMethodInvocations', #12
    'distinctMethodInvocationsInSameClass', #13
    'numberOfDistinctMethodInvocationsInSameClass', #14
    'distinctTestCaseMethodInvocationsInSameClass', #15
    'numberOfDistinctTestCaseMethodInvocationsInSameClass', #16
    'numberOfMethodInvocationsWithExceptions', #17
    'numberOfExceptionsThrown', #18
    'numberOfExceptionsThrownAndCaughtExact',  #19
    'numberOfExceptionsThrownAndCaughtPartial', #20
    'exceptionsThrownInMethodInvocations', #21
    'listOfExpectedExceptions', #22
    'numberOfDistinctExpectedExceptions', #23
    'numberOfAssertions', #24
    'numberOfAssertionsWithRecursion', #25
    'distinctMethodsInSameClassThatCallThisOne', #26
    'numberOfdistinctMethodsInSameClassThatCallThisOne', #27
    'distinctTestCasesInSameClassThatCallThisOne', #28
    'numberOfdistinctTestCasesInSameClassThatCallThisOne', #29
    'hasCommitData', #30
    'mainProjectName2', #31
    'methodName2', #32
    'filePath2', #33
    'noBugFixes', #34
    'noCommitFixes', #35
    'noClones', #36
    'hasCoverageData', #37
    'projectName3', #38
    'typeName3', #39
    'methodName3', #40
    'LINE_covered', #41
    'hasLocComplexityEntropy',  #42
    'CountLineCode', #43
    'Cyclomatic', #44
    'CyclomaticModified', #45
    'CyclomaticStrict', #46
    'halsteadLength', #47
    'halsteadVocabulary', #48
    'halsteadVolume', #49
    'entropy' #50
]

args = parser.parse_args()

f2 = open(args.csv_file_2, "r")
f3 = open(args.csv_file_3, "r")
fMerged = open(args.csv_file_merged, "w")

reader2 = csv.reader(f2, delimiter=",")
reader3 = csv.reader(f3, delimiter=",")

data2 = []
data3 = []
dataMerged = []

print("Reading file 2: "+f2.name)
rownum = 0
for row in reader2:
    if rownum > 0:
        data2.append(row)
    rownum += 1

f2.close()
print("Read %i rows" % rownum)

print("Reading file 3: "+f3.name)
rownum = 0
for row in reader3:
    if rownum > 0:
        data3.append(row)
    rownum += 1

f3.close()
print("Read %i rows" % rownum)

rownum = 0
for line2 in data2:

    mergedLine = []
    projectName = line2[0]
    filePath = line2[2]
    testName = line2[4]
    print("Processing row %i - project %s, file %s, test %s" %(rownum, projectName, filePath, testName))
    rownum += 1

    mergedLine.extend(line2[0:42])

    foundLines = findLines3(projectName, filePath, testName, data3)
    if len(foundLines) == 1:
        mergedLine.append('yes')
        mergedLine.extend(foundLines[0][4:8])
        mergedLine.extend(foundLines[0][11:15])
    elif len(foundLines) > 1:
        mergedLine.extend(['duplicated','','','','','','','',''])
    else:
        mergedLine.extend(['no','','','','','','','',''])


    # line[30] == hasCommitData
    # line[37] == hasCoverageData
    # line[42] == hasLocComplexityEntropy
    if mergedLine[30] == 'yes' or mergedLine[30] == 'notfound':
        dataMerged.append(mergedLine)

fMerged.write(','.join(header_merged)+'\n')
for lineMerged in dataMerged:
    fMerged.write(','.join(lineMerged)+'\n')
fMerged.close()