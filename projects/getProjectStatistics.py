import requests
import json 
import csv
import dateutil.parser

access_token = ''

headers = {
    'Authorization': 'token ' + access_token,
    'Accept': 'application/vnd.github.v3+json'
}

fProjectList = open("projectList.csv", "r")
fProjectListWithMetadata = open("projectListWithMetadata.csv","w")
readerProjectList = csv.reader(fProjectList, delimiter=",")
dataProjectList = []
headerFinal = ["Author","Project","URL","API","Stars","Created","Updated"]

rownum = 0
for row in readerProjectList:
    if rownum > 0:
        url = row[3]
        print("Fetching from: "+url)
        res = requests.get(url, headers=headers)

        response = json.loads(res.text)
        stargazers_count = str(response["stargazers_count"])
        created_at = str(dateutil.parser.isoparse(response["created_at"]).year)
        updated_at = str(dateutil.parser.isoparse(response["updated_at"]).year)
        row.extend([stargazers_count, created_at, updated_at])
        dataProjectList.append(row)
    rownum+=1

fProjectList.close()

fProjectListWithMetadata.write(','.join(headerFinal)+'\n')
for row in dataProjectList:
    fProjectListWithMetadata.write(','.join(row)+'\n')
fProjectListWithMetadata.close()
