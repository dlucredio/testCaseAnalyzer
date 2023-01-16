# This scripts loads commits from 'commits.parquet.gzip', annotations from 'hunk_labels.json'
# and saves the merge result in 'commits_annotated.parquet.gzip'
# Merge is based on consensus: if 3 or more users annotated a commit as a bugfix, a value 'True'
# is saved. 'False' otherwise.
# Uses packages from requirements.txt
# Tested on Python 3.11.1

import pandas as pd
import psutil

dfLabels = pd.read_json('hunk_labels.json') 
# The following columns exist in dfLabels
# 'lines_manual', 'file', 'issue_id', 'revision_hash', 'hunk_id', 'repository_url', 'project'

dfCommits = pd.read_parquet('commits.parquet.gzip')
# The following columns exist in dfCommits
# '_id', 'revision_hash', 'message'

dfCommits = dfCommits.reset_index()
dfCommits['isBugfix'] = False

for index, row in dfCommits.iterrows():
    revision_hash = row['revision_hash']
    message = row['message']
    labels = dfLabels.loc[dfLabels['revision_hash'] == revision_hash]
    if not labels.empty:
        lines_manual = labels.lines_manual
        label_dict_bugfix = {}
        for annotation in lines_manual:
            for user, user_labels in annotation.items():
                for label_type, label_lines in user_labels.items():
                    if label_type=='bug':
                        label_type='bugfix'
                    if label_type=='bugfix':
                        if not user in label_dict_bugfix:
                            label_dict_bugfix[user] = 1
                        else:
                            label_dict_bugfix[user] += 1
        # According to the original paper, if at least three
        # different users marked this commit as a bigfix,
        # it is a bugfix (consensual)
        if len(label_dict_bugfix) >= 3:
            dfCommits.loc[index,'isBugfix'] = True
    if index % 100 == 0:
        print(f'Processing commit number {index} - RAM Used (GB): {psutil.virtual_memory()[3]/1000000}')

dfCommits = dfCommits.drop_duplicates(subset=['revision_hash'])

dfCommits.to_parquet('commits_annotated.parquet.gzip',compression='gzip')

print('Saved data to file "commits_annotated.parquet.gzip"')