import os
import argparse
import glob
import sys
import csv

parser = argparse.ArgumentParser(
    description='Filters CSV file from Understand')

parser.add_argument('in_csv',
                    type=str,
                    help='the input CSV file')

parser.add_argument('out_csv',
                    type=str,
                    help='the output CSV file')

args = parser.parse_args()

# Read input file
fin = open(args.in_csv)
reader = csv.reader(fin, delimiter=",")
dataIn = []
rownum = 0
for row in reader:
    if rownum > 0:
        dataIn.append(row)
    rownum += 1
fin.close()

# Write output file
fout = open(args.out_csv, "w")
fout.write("Project,Kind,MethodName,FilePath,CountLineCode,Cyclomatic,CyclomaticModified,CyclomaticStrict\n")
for d in dataIn:
    if "method" in d[0].lower():
        d[1] = d[1].split(".")[-1]
        projectName = d[2].split("/")[0]
        filePath = d[2].split("/",1)[1]
        d[2] = filePath
        d.insert(0,projectName)
        fout.write(','.join(d)+'\n')
    rownum += 1

fin.close()
fout.close()