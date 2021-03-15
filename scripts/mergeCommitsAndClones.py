import os
import re
import sys
import csv
import fnmatch

CSV_HEADER = ["Project", "TestCase", "NoBugFixes", "NoCommitFixes", "NoClones"]

args = sys.argv
beagle_path = args[args.index("--beagle") + 1]
nicad_path = args[args.index("--nicad") + 1]

projects = {}

with open(os.path.join(beagle_path, "result.csv"), 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=',')
    for row in csv_reader:
        if row["isBugFix"] == 0:
            continue
        project = re.findall("(.*)\.csv", row["project_name"])[0]
        if projects.get(project) is None:
            projects[project] = {}
        testCase = row["test_case"]
        if projects.get(project).get(testCase) is None:
            projects.get(project)[testCase] = {}
            projects.get(project).get(testCase)["clones"] = 0
            projects.get(project).get(testCase)["bugFixes"] = []
        projects.get(project).get(testCase).get("bugFixes").append(row["sha_id"])

for root, dirnames, filenames in os.walk(nicad_path):
    for filename in fnmatch.filter(filenames, "*.csv"):
        with open(os.path.join(root, filename), 'r') as csv_file:
            csv_reader = csv.DictReader(csv_file, delimiter=',')
            for row in csv_reader:
                project = re.findall("(.*)_result\.csv", filename)[0]
                testCase = row["TestCase"]
                if projects.get(project) is None:
                    projects[project] = {}
                if projects.get(project).get(testCase) is None:
                    projects.get(project)[testCase] = {}
                    projects.get(project).get(testCase)["bugFixes"] = []
                projects.get(project).get(testCase)["clones"] = row["Clones"]
with open("final_result.csv", 'w') as csv_out:
    writer = csv.DictWriter(csv_out, fieldnames=CSV_HEADER)
    writer.writeheader()
    for project in projects:
        for testCase in projects.get(project):
            writer.writerow({
                'Project': project,
                'TestCase': testCase,
                'NoBugFixes': len(projects.get(project).get(testCase).get("bugFixes")),
                'NoCommitFixes' : len(set(projects.get(project).get(testCase).get("bugFixes"))),
                'NoClones': projects.get(project).get(testCase).get("clones")
                })
