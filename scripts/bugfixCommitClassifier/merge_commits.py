import pandas as pd

dfLabels = pd.read_json('hunk_labels.json') 
# The following columns exist in dfLabels
# 'lines_manual', 'file', 'issue_id', 'revision_hash', 'hunk_id', 'repository_url', 'project'

dfCommits = pd.read_json('commits.jsonl', lines=True)
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
            row['isBugfix'] = True
            dfCommits.loc[index,'isBugfix'] = True
    print(f'{index} - revision_hash: {revision_hash} - isBugfix: {row["isBugfix"]}')

dfCommits = dfCommits.drop_duplicates(subset=['revision_hash'])

f = open('commits_annotated.jsonl','w')
print(dfCommits.to_json(orient='records', lines=True), file=f, flush=False)
f.close()