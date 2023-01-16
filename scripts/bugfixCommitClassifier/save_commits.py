# This scripts loads commits from smartshark 2.2 and saves them as commits.jsonl file
# Only _id, revision_hash and message are extracted
# Uses packages from requirements.txt
# Tested on Python 3.11.1

from pymongo import MongoClient
import pandas as pd
import psutil

client = MongoClient("mongodb://localhost:27017/")

smartshark = client['smartshark_2_2']
commit_collection = smartshark['commit']

query = {}
projection = {'revision_hash': 1, 'message': 1}

commits = commit_collection.find(query, projection, batch_size=500)

i=0

commits_list = []

for c in commits:
    commits_list.append({
        '_id': str(c['_id']),
        'revision_hash':c['revision_hash'],
        'message':c['message']
    })
    if i % 100 == 0:
        print(f'Processing commit number {i} - RAM Used (GB): {psutil.virtual_memory()[3]/1000000}')
    i += 1

print(f'Done! {i} commits processed')

dfCommits = pd.DataFrame(commits_list, columns=['_id','revision_hash','message'])
dfCommits.to_parquet('commits.parquet.gzip',compression='gzip')

print('Saved data to file "commits.parquet.gzip"')