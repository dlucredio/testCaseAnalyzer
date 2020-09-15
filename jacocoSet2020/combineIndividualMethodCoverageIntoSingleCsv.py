import os
import argparse
import csv

def main():
    parser = argparse.ArgumentParser(
        description='Merges multiple JaCoCo CSV files, one for each test case, into a single')

    parser.add_argument('jacoco_input_folder',
                        type=str,
                        help='input folder with individual CSV files')

    parser.add_argument('csv_output_file',
                        type=str,
                        help='the output jacoco file')

    header = [ 'projectName', 'typeName', 'methodName', 'locCovered' ]

    args = parser.parse_args()

    with open(args.csv_output_file, "w") as fOutput:
        fOutput.write(','.join(header)+'\n')


        files = os.listdir(args.jacoco_input_folder)

        for f in files:
            data = f[:-4].split("###")
            projectName = data[0]
            className = data[1]
            testCaseName = data[2]

            with open(args.jacoco_input_folder+"/"+f, "r+") as fin:
                headerline = fin.readline()
                total = 0
                for row in csv.reader(fin):
                    total += int(row[8]) # jacoco Column for LOC covered
            fOutput.write(projectName+','+className+','+testCaseName+','+str(total)+'\n')
        
            

if __name__ == "__main__":
    main()