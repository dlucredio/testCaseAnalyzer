import os
import re
import sys
import csv
import fnmatch

maxInt = sys.maxsize

while True:
    # decrease the maxInt value by factor 10 
    # as long as the OverflowError occurs.

    try:
        csv.field_size_limit(maxInt) # Let's set max field size to max value possible
        break
    except OverflowError:
        maxInt = int(maxInt/10)

CSV_HEADER = ["Project", "TestCase", "FilePath", "NoBugFixes", "NoCommitFixes", "NoClones"]

args = sys.argv
beagle_path = args[args.index("--beagle") + 1]
nicad_path = args[args.index("--nicad") + 1]

projects = {}
tCases = {}

print('Loading file '+beagle_path+'/commits.csv')

with open(os.path.join(beagle_path, "commits.csv"), 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=',')
    for row in csv_reader:
        if row["isBugFix"] == 0:
            continue
        project = re.findall("(.*)\.csv", row["Project"])[0]
        try:
            preTag = re.search(r'Output_TestEvol_[0-9]+_', project).group()
            project = project.replace(preTag, '')
        except AttributeError:
            pass # no preTag in this row
        if projects.get(project) is None:
            projects[project] = {}
        testCase = row['path'] + ': ' + row["TestCase"]
        if projects.get(project).get(testCase) is None:
            projects.get(project)[testCase] = {}
            cName = row["line_of_code"]
            projects.get(project).get(testCase)["clones"] = 0
            projects.get(project).get(testCase)["bugFixes"] = []
            projects.get(project).get(testCase)["ClassName"] = cName.split(':')[0]
        projects.get(project).get(testCase).get("bugFixes").append(row["CommitHash"])


for root, dirnames, filenames in os.walk(nicad_path):
    for filename in fnmatch.filter(filenames, "*_result.csv"):
        with open(os.path.join(root, filename), 'r') as csv_file:
            print('Loading file '+csv_file.name)
            csv_reader = csv.DictReader(csv_file, delimiter=',')
            for row in csv_reader:
                project = re.findall("(.*)_result\.csv", filename)[0]
                testCase = row["TestCase"]
                if projects.get(project) is None:
                    projects[project] = {}
                if projects.get(project).get(testCase) is None:
                    projects.get(project)[testCase] = {}
                    projects.get(project).get(testCase)["bugFixes"] = []
                    projects.get(project).get(testCase)["ClassName"] = ""
                projects.get(project).get(testCase)["clones"] = row["Clones"]
with open("commitsClones.csv", 'w') as csv_out:
    writer = csv.DictWriter(csv_out, fieldnames=CSV_HEADER)
    writer.writeheader()
    for project in projects:
        for testCase in projects.get(project):
            if testCase.split(': ')[-1].strip() == '':
                continue
            writer.writerow({
                'Project': project,
                'TestCase': testCase.split(': ')[-1],
                'FilePath': testCase.split(': ')[0],
                'NoBugFixes': len(projects.get(project).get(testCase).get("bugFixes")),
                'NoCommitFixes' : len(set(projects.get(project).get(testCase).get("bugFixes"))),
                'NoClones': projects.get(project).get(testCase).get("clones")
                })
                
print('Saved file commitsClones.csv')
#'ClassName': projects.get(project).get(testCase).get("ClassName"),
