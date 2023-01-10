# This scripts loads commits from smartshark 2.2 and saves them as commits.jsonl file
# Only _id, revision_hash and message are extracted

from pymongo import MongoClient
import json

client = MongoClient("mongodb://localhost:27017/")

smartshark = client['smartshark_2_2']
commit_collection = smartshark['commit']

query = {}
projection = {'revision_hash': 1, 'message': 1}

commits = commit_collection.find(query, projection, batch_size=1000)

i=0
with open("commits.jsonl",'w') as f:
    for c in commits:
        f.write(json.dumps({'_id': str(c['_id']),'revision_hash':c['revision_hash'], 'message':c['message']}) + "\n")
        print(f'Processing commit number {i}')
        i += 1

print(f'Done! {i} commits processed')
