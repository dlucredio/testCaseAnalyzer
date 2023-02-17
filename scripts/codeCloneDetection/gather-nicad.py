import sys
import csv
import re
import os
result = {}

args = sys.argv
project_name = args[args.index("--project")+1]
project_path = args[args.index("--path")+1]

with open(os.path.join(project_path, "{0}_functions-blind-clones/{0}_functions-blind-clones-0.30-classes-withsource.xml".format(project_name))) as nicad_file:
    data = nicad_file.readlines()
    for index, line in enumerate(data):
        if "<source" in line:
            function = data[index+1]
            function_name = re.findall("([a-zA-Z0-9_]+) ?\(", function)
            if len(function_name) == 0:
                continue
            function_name = function_name[0]

            if result.get(function_name) is None:
                result[function_name] = 1
            else:
                result[function_name] += 1

with open("{}_result.csv".format(project_name), 'w') as csv_out:
    fieldnames = ['TestCase', 'Clones']
    writer = csv.DictWriter(csv_out, fieldnames=fieldnames)
    writer.writeheader()
    for key in result:
        writer.writerow({
            'TestCase': key,
            'Clones' : result[key]
            })
    
