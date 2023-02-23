# This file is a demonstration of how to use the trained models
# Tested with Python 3.11.1
# Requirements

# To perform data manipulation
# pandas==1.5.2

# To prepare data (with NLTK)
# nltk==3.8.1

# Machine learning algorithms
# %pip install scikit-learn==1.2.0


import nltk # For text processing
nltk.download('stopwords') # Stop words
nltk.download('punkt') # Tokenizer
english_stop_words = set(nltk.corpus.stopwords.words('english')) # Saving the stopwords in a list

import joblib # To load the model
import pandas as pd # For data processing

model = joblib.load('bugfix_classifier_linearsvc_countvectorizer.joblib')
clf = model['clf']
vect = model['vect']

csv_data = pd.read_csv('prepared.csv')  # load csv file

print('Loaded '+str(len(csv_data))+' commits from prepared.csv')

# csv_data_with_messages = csv_data.dropna(subset=['CommitMessage'])
# print('Only '+str(len(csv_data_with_messages))+' have commit messages')
csv_data_with_messages = csv_data


num_true = 0
num_false = 0
num_invalid = 0

for i,commit in csv_data_with_messages.iterrows():
    text = commit['CommitMessage']
    if isinstance(text,float):
        num_invalid+=1
        continue
    else:
        processed_text = ' '.join([word for word in nltk.tokenize.word_tokenize(text) if word not in (english_stop_words)])
        vectorized_text = vect.transform([processed_text])
        prediction = ''
        pred = clf.predict(vectorized_text)
        if pred == [1]:
            prediction = 'True'
            num_true += 1
        else:
            prediction = 'False'
            num_false += 1

        commit['isBugFix'] = prediction

print('Finished')
print('Total   '+str(num_true+num_false+num_invalid))
print('Invalid '+str(num_invalid))
print('True    '+str(num_true))
print('False   '+str(num_false))

csv_data_with_messages.to_csv('commits.csv')

print('Saved predictions to commits.csv')