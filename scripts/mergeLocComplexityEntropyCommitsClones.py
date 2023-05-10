import os
import argparse
import glob
import csv

def findLinesUnderstand(projectName, filePath, testName, dataUnderstand):
# Understand's file:
# projectName = 0
# testName = 2
# filePath = 3 (ex: javaparser/javaparser-symbol-solver-testing/target/test-classes/issue1491/A.java)
    retLine = []
    for line in dataUnderstand:
        if line[0] == projectName and line[2] == testName and line[3] == filePath:
            retLine.append(line)
    return retLine

def findLinesCommitsClones(projectName, filePath, testName, dataCommitsClonesEntropy):
# CommitsClones's and Entropy file:
# projectName = 0
# filePath = 1 (ex: optaplanner-core/src/test/java/org/optaplanner/core/api/score/stream/uni/UniConstraintStreamTest.java)
# testName = 2
    retLine = []
    for line in dataCommitsClonesEntropy:
        if line[0] == projectName and line[2] == testName and line[1] == filePath:
            retLine.append(line)
    return retLine

parser = argparse.ArgumentParser(
    description='Merges Understand and Commit/Clone + Entropy CSV files into one')

parser.add_argument('csv_file_understand',
                    type=str,
                    help='the first file - Understand')

parser.add_argument('csv_file_commitsclones',
                    type=str,
                    help='the second file - Commit/Clones + Entropy')

parser.add_argument('csv_file_merged',
                    type=str,
                    help='the merged file')

parser.add_argument('csv_file_duplicated_understand',
                    type=str,
                    help='the file containing methods that have the same names in Understand\'s file')

parser.add_argument('csv_file_duplicated_commitsclones',
                    type=str,
                    help='the file containing methods that have the same names in Commit/Clones/Entropy\'s file')

parser.add_argument('csv_file_unused_commitsclones',
                    type=str,
                    help='the file containing lines from Commit/Clones/Entropy\'s file that were never used')

header = [ 		'projectName', # Eclipse project name (subproject/module in GitHub)
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
                'noBugFixes', # The number of changes to that test case which considered a bug fix
                'noCommitFixes', # The number of commits changes that test case and classified as a bug fix
                'noClones', # The number of code clones detected by Nicad5 Tool
                'halsteadLength', # Halstead Length (total token count)
                'halsteadVocabulary', # Halstead Vocabulary
                'halsteadVolume', # Halstead Volume
                'entropy' # Entropy
]

args = parser.parse_args()

fUnderstand = open(args.csv_file_understand, "r")
fCommitsClones = open(args.csv_file_commitsclones, "r")
fMerged = open(args.csv_file_merged, "w")
fDuplicatedUnderstand = open(args.csv_file_duplicated_understand, "w")
fDuplicatedCommitsClones = open(args.csv_file_duplicated_commitsclones, "w")
fUnusedCommitsClones = open(args.csv_file_unused_commitsclones, "w")

readerUnderstand = csv.reader(fUnderstand, delimiter=",")
readerCommitsClones = csv.reader(fCommitsClones, delimiter=",")

dataUnderstand = []
dataCommitsClones = []
duplicateTestCasesUnderstand = []
duplicateTestCasesCommitsClones = []

print("Reading Understand's file "+fUnderstand.name)
rownum = 0
for row in readerUnderstand:
    if rownum > 0:
        dataUnderstand.append(row)
    rownum += 1

fUnderstand.close()
print("Read %i rows" % rownum)


print("Reading CommitsClones's file "+fCommitsClones.name)
rownum = 0
for row in readerCommitsClones:
    if rownum > 0:
        dataCommitsClones.append(row)
    rownum += 1

fCommitsClones.close()
print("Read %i rows" % rownum)

fMerged.write(','.join(header)+'\n')

rownum = 0
for lineUnderstand in dataUnderstand:
    projectName = lineUnderstand[0]
    testName = lineUnderstand[2]
    filePath = lineUnderstand[3]
    print("Processing row %i - project %s, file %s, test %s" %(rownum, projectName, filePath, testName))
    rownum += 1

    if len(findLinesUnderstand(projectName, filePath, testName, dataUnderstand)) > 1:
        duplicateTestCasesUnderstand.append(lineUnderstand)
    else:
        foundLines = findLinesCommitsClones(projectName, filePath, testName, dataCommitsClones)
        if len(foundLines) == 1:
            lineUnderstand.extend(foundLines[0])
            foundLines[0].append('ok')
            fMerged.write(','.join(lineUnderstand)+'\n')

fMerged.close()

rownum = 0
for line in dataCommitsClones:
    if line[-1] != "ok":
        fUnusedCommitsClones.write(','.join(line)+'\n')
fUnusedCommitsClones.close()

for dtcu in duplicateTestCasesUnderstand:
    fDuplicatedUnderstand.write(','.join(dtcu)+'\n')
fDuplicatedUnderstand.close()

for dtca in duplicateTestCasesCommitsClones:
    fDuplicatedCommitsClones.write(','.join(dtca)+'\n')
fDuplicatedCommitsClones.close()