import pandas as pd

dfCommitsAnnotated = pd.read_json('commits_annotated.jsonl', lines=True)


print(f'Number of rows: {dfCommitsAnnotated.shape[0]}')
print(f'Number of duplicated: {dfCommitsAnnotated.revision_hash.duplicated().sum()}')

