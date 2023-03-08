import os
import argparse
import glob
import csv

parser = argparse.ArgumentParser(
    description='Analyzes project main names and subproject names')

parser.add_argument('csv_file_static_analysis',
                    type=str,
                    help='the first file - Static analysis')

parser.add_argument('csv_file_commits_and_clones',
                    type=str,
                    help='the second file - Commits and clones')

args = parser.parse_args()

fStaticAnalysis = open(args.csv_file_static_analysis, "r")
fCommitsAndClones = open(args.csv_file_commits_and_clones, "r")

readerStaticAnalysis = csv.reader(fStaticAnalysis, delimiter=",")
readerCommitsAndClones = csv.reader(fCommitsAndClones, delimiter=",")

dataStaticAnalysis = []
dataCommitsAndClones = []

print("Reading static analysis file "+fStaticAnalysis.name)
rownum = 0
for row in readerStaticAnalysis:
    if rownum > 0:
        dataStaticAnalysis.append(row)
    rownum += 1

fStaticAnalysis.close()
print("Read %i rows" % rownum)

print("Reading commits and clones file "+fCommitsAndClones.name)
rownum = 0
for row in readerCommitsAndClones:
    if rownum > 0:
        dataCommitsAndClones.append(row)
    rownum += 1

fCommitsAndClones.close()
print("Read %i rows" % rownum)

for lineStaticAnalysis in dataStaticAnalysis:
    mainProjectName = lineStaticAnalysis[0]
    projectName = lineStaticAnalysis[1]
    filePath = lineStaticAnalysis[2]
    projectNameFromFilePath = filePath.split("/")[1]
    if( projectName != projectNameFromFilePath):
        print("Different in static analysis file:"+projectName+" / "+projectNameFromFilePath)

# for lineCommitsClones in dataCommitsAndClones:
#     projectName = lineCommitsClones[0]
#     filePath = lineCommitsClones[2]
#     projectNameFromFilePath = filePath.split("/")[0]
#     if( projectName != projectNameFromFilePath):
#         print("Different in commits and clones file:"+projectName+" / "+projectNameFromFilePath)
