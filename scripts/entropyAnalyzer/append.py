import os
import argparse
import glob
import sys

parser = argparse.ArgumentParser(
    description='Appends multiple CSV files into one')

parser.add_argument('csv_folder',
                    type=str,
                    help='the folder where CSV files are located')

parser.add_argument('csv_file',
                    type=str,
                    help='the output CSV file to be produced')

args = parser.parse_args()

if not os.path.isdir(args.csv_folder):
    print("The specified folder does not exist!")
    sys.exit()

fout = open(args.csv_file, "a")

all_filenames = [i for i in glob.glob(args.csv_folder+'/*.{}'.format("csv"))]

sorted_filenames = sorted(all_filenames)

filenum = 0
for filename in sorted_filenames:
    f = open(filename)
    print("Reading file "+filename)
    rownum = 0
    for line in f:
        if (filenum == 0 and rownum == 0) or rownum > 0:
            fout.write(line)
        rownum += 1
    f.close()
    filenum += 1
fout.close()