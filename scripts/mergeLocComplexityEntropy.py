import os
import argparse
import glob
import csv

def findLinesLocComplexity(projectName, filePath, testName, dataLocComplexity):
# LOC/Complexity file:
# projectName = 0
# testName = 2
# filePath = 3 (ex: javaparser/javaparser-symbol-solver-testing/target/test-classes/issue1491/A.java)
    retLine = []
    for line in dataLocComplexity:
        if line[0] == projectName and line[2] == testName and line[3] == filePath:
            retLine.append(line)
    return retLine

def findLinesEntropy(projectName, filePath, testName, dataEntropy):
# Entropy file:
# projectName = 0
# filePath = 1 (ex: /optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
# testName = 2
    retLine = []
    for line in dataEntropy:
        if line[0] == projectName and line[2] == testName and (line[1] == filePath or line[1][1:] == filePath):
            retLine.append(line)
    return retLine

parser = argparse.ArgumentParser(
    description='Merges LOC/Complexity with entropy')

parser.add_argument('csv_file_loc_complexity',
                    type=str,
                    help='the first file - LOC/Complexity')

parser.add_argument('csv_file_entropy',
                    type=str,
                    help='the second file - Entropy')

parser.add_argument('csv_file_merged',
                    type=str,
                    help='the merged file')

headerLocComplexity = [
    'Project',
    'Kind',
    'MethodName',
    'FilePath',
    'CountLineCode',
    'Cyclomatic',
    'CyclomaticModified',
    'CyclomaticStrict'
]

headerEntropy = [
    'project',
    'filePath',
    'methodName',
    'halsteadLength',
    'halsteadVocabulary',
    'halsteadVolume',
    'entropy'
]

headerMerged = [
    'projectName', # Eclipse project name (subproject/module in GitHub)
    'kind', # Kind of entity (from Understand)
    'testCase', # The name of the test case (method name)
    'filePath', # The path to the file containing the test case
    'CountLineCode', # Lines of source code
    'Cyclomatic', # Cyclomatic complexity
    'CyclomaticModified', # Cyclomatic modified
    'CyclomaticStrict', # Cyclomatic strict                
    'projectName2', # Same as projectName
    'filePath2', # Same as filePath
    'testCase2', # Same as testCase
    'halsteadLength', # Halstead Length (total token count)
    'halsteadVocabulary', # Halstead Vocabulary
    'halsteadVolume', # Halstead Volume
    'entropy' # Entropy
]

args = parser.parse_args()

fLocComplexity = open(args.csv_file_loc_complexity, "r")
fEntropy = open(args.csv_file_entropy, "r")
fMerged = open(args.csv_file_merged, "w")

readerLocComplexity = csv.reader(fLocComplexity, delimiter=",")
readerEntropy = csv.reader(fEntropy, delimiter=",")

dataLocComplexity = []
dataEntropy = []

print("Reading LOC/Complexity file "+fLocComplexity.name)
rownum = 0
for row in readerLocComplexity:
    if rownum > 0:
        dataLocComplexity.append(row)
    rownum += 1

fLocComplexity.close()
print("Read %i rows" % rownum)


print("Reading Entropy file "+fEntropy.name)
rownum = 0
for row in readerEntropy:
    if rownum > 0:
        dataEntropy.append(row)
    rownum += 1

fEntropy.close()
print("Read %i rows" % rownum)

print("Starting processing")

fMerged.write(','.join(headerMerged)+'\n')

rownum = 0
for lineLocComplexity in dataLocComplexity:
    projectName = lineLocComplexity[0]
    testName = lineLocComplexity[2]
    filePath = lineLocComplexity[3]
    print("Processing row %i - project %s, file %s, test %s" %(rownum, projectName, filePath, testName))
    rownum += 1

    # if len(findLinesLocComplexity(projectName, filePath, testName, dataLocComplexity)) == 1:
    foundLines = findLinesEntropy(projectName, filePath, testName, dataEntropy)
    if len(foundLines) == 1:
        print('found!')
        lineLocComplexity.extend(foundLines[0])
        fMerged.write(','.join(lineLocComplexity)+'\n')

fMerged.close()