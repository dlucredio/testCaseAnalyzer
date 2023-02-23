import os
import sys
import csv
import fnmatch

csv.field_size_limit(sys.maxsize)

CSV_HEADER = ["Project", "isBugFix", "CommitHash", "CommitMessage", "Level", "TestCase", "path", "line_of_code"]

def main():
    args = sys.argv
    pathPos = args.index("--path")
    path = args[pathPos + 1]
    
    destPos = args.index("--dest")
    dest = args[destPos + 1]

    csv_rows = []
    csv_rows.append(CSV_HEADER)

    for root, dirnames, filenames in os.walk(path):
        for filename in fnmatch.filter(filenames, '*.csv'):
            with open(os.path.join(root, filename), 'r') as csv_file:
                csv_reader = csv.DictReader(csv_file, delimiter=',')
                for row in csv_reader:
                    csv_data = []
                    if row.get("level") is None:
                        continue
                    if row["level"] == "COMMIT" and row["is_test_file"]:
                        csv_data.append(filename) # Project Name
                        csv_data.append(row["is_bug_fix"]) # Is bug fix
                        csv_data.append(row["commit"]) # Commit hash
                        csv_data.append(row["commitMessage"].replace('\n', ' ').replace('\r', ''))
                        csv_data.append("COMMIT")
                        csv_data.append("")
                        csv_data.append(row["path"])
                        csv_data.append(row["line_of_code"])
                        csv_rows.append(csv_data)
                    elif row["level"] == "METHOD" and row ["test_case"] != "null":
                        csv_data.append(filename) # Project Name
                        csv_data.append(row["is_bug_fix"]) # Is bug fix
                        csv_data.append(row["commit"]) # Commit hash
                        csv_data.append(row["commitMessage"].replace('\n', ' ').replace('\r', ''))
                        csv_data.append("METHOD")
                        csv_data.append(row["test_case"])
                        csv_data.append(row["path"])
                        csv_data.append(row["line_of_code"])
                        csv_rows.append(csv_data)

        with open(dest, "w") as csv_file:
            writer = csv.writer(csv_file, delimiter=',')
            writer.writerows(csv_rows)

if __name__ == "__main__":
    main()
