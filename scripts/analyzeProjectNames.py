import os
import argparse
import glob
import csv

parser = argparse.ArgumentParser(
    description='Analyzes project main names and subproject names')

parser.add_argument('csv_file_daniel',
                    type=str,
                    help='the first file - Daniel')

parser.add_argument('csv_file_andrew',
                    type=str,
                    help='the second file - Andrew')

args = parser.parse_args()

fDaniel = open(args.csv_file_daniel, "r")
fAndrew = open(args.csv_file_andrew, "r")

readerDaniel = csv.reader(fDaniel, delimiter=",")
readerAndrew = csv.reader(fAndrew, delimiter=",")

dataDaniel = []
dataAndrew = []

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

for lineDaniel in dataDaniel:
    mainProjectName = lineDaniel[0]
    projectName = lineDaniel[1]
    filePath = lineDaniel[2]
    projectNameFromFilePath = filePath.split("/")[1]
    if( projectName != projectNameFromFilePath):
        print("Different Daniel:"+projectName+" / "+projectNameFromFilePath)

# for lineAndrew in dataAndrew:
#     projectName = lineAndrew[0]
#     filePath = lineAndrew[2]
#     projectNameFromFilePath = filePath.split("/")[0]
#     if( projectName != projectNameFromFilePath):
#         print("Different Andrew:"+projectName+" / "+projectNameFromFilePath)
