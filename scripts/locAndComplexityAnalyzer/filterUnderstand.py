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

rownum = 0

# Input file format: (needed fields are marked with *)
# 0: Kind *
# 1: Name *
# 2: File *
# 3: AvgCyclomatic
# 4: AvgCyclomaticModified
# 5: AvgCyclomaticStrict
# 6: AvgCyclomaticStrictModified
# 7: AvgEssential
# 8: AvgLine
# 9: AvgLineBlank
# 10: AvgLineCode
# 11: AvgLineComment
# 12: CountClassBase
# 13: CountClassCoupled
# 14: CountClassCoupledModified
# 15: CountClassDerived
# 16: CountDeclClass
# 17: CountDeclClassMethod
# 18: CountDeclClassVariable
# 19: CountDeclExecutableUnit
# 20: CountDeclFile
# 21: CountDeclFunction
# 22: CountDeclInstanceMethod
# 23: CountDeclInstanceVariable
# 24: CountDeclMethod
# 25: CountDeclMethodAll
# 26: CountDeclMethodDefault
# 27: CountDeclMethodPrivate
# 28: CountDeclMethodProtected
# 29: CountDeclMethodPublic
# 30: CountInput
# 31: CountLine
# 32: CountLineBlank
# 33: CountLineCode *
# 34: CountLineCodeDecl
# 35: CountLineCodeExe
# 36: CountLineComment
# 37: CountOutput
# 38: CountPath
# 39: CountPathLog
# 40: CountSemicolon
# 41: CountStmt
# 42: CountStmtDecl
# 43: CountStmtExe
# 44: Cyclomatic *
# 45: CyclomaticModified *
# 46: CyclomaticStrict *
# 47: CyclomaticStrictModified
# 48: Essential
# 49: Knots
# 50: MaxCyclomatic
# 51: MaxCyclomaticModified
# 52: MaxCyclomaticStrict
# 53: MaxCyclomaticStrictModified
# 54: MaxEssential
# 55: MaxEssentialKnots
# 56: MaxInheritanceTree
# 57: MaxNesting
# 58: MinEssentialKnots
# 59: PercentLackOfCohesion
# 60: PercentLackOfCohesionModified
# 61: RatioCommentToCode
# 62: SumCyclomatic
# 63: SumCyclomaticModified
# 64: SumCyclomaticStrict
# 65: SumCyclomaticStrictModified
# 66: SumEssential


# Write output file
fout = open(args.out_csv, "w")
fout.write("Project,Kind,MethodName,FilePath,CountLineCode,Cyclomatic,CyclomaticModified,CyclomaticStrict\n")
for d in dataIn:
    if "method" in d[0].lower():
        try:
            d[1] = d[1].split(".")[-1]
            projectName = d[2].split("/")[0]
            filePath = d[2].split("/",1)[1]
            d[2] = filePath
            fout.write(projectName+','+d[0]+','+d[1]+','+d[2]+','+d[33]+','+d[44]+','+d[45]+','+d[46]+'\n')
        except:
            print('Row number '+str(rownum)+' is not properly formatted')
    rownum += 1

fin.close()
fout.close()