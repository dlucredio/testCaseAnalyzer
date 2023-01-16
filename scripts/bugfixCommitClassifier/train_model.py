# This file is a compilation of the experimentation notebooks.
# Look at 'find_best_model_with_automl.ipynb' and 'experiment_different_models.ipynb' to understand the logic.
# Tested with Python 3.11.1

import pandas as pd # For data processing

import nltk # For text processing
nltk.download('stopwords') # Stop words
nltk.download('punkt') # Tokenizer
english_stop_words = set(nltk.corpus.stopwords.words('english')) # Saving the stopwords in a list

from tqdm import tqdm # To monitor progress in large tasks
tqdm.pandas() # Configure tqdm to work with pandas

from sklearn.feature_extraction.text import CountVectorizer # To make sklearn work with text features
from sklearn.model_selection import train_test_split # To split train/test data
from sklearn.utils import resample # To balance the dataset

from sklearn.metrics import classification_report # To determine the quality of our models
from sklearn.metrics import confusion_matrix  # To determine the quality of our models

# Best models seems to be LinearSVC with CountVectorizer
from sklearn.svm import LinearSVC

# To save model
import joblib

random_state_value=42

# Read file and drop unnecessary columns
df_commits_annotated = pd.read_parquet('commits_annotated.parquet.gzip')
df_commits_annotated.drop(columns=['_id','revision_hash'], inplace=True)

# Balance data
df_majority = df_commits_annotated[df_commits_annotated.isBugfix==False]
df_minority = df_commits_annotated[df_commits_annotated.isBugfix==True]
df_commits = df_commits_annotated['isBugfix'].value_counts()
count_minority = df_commits[1] # Number of elements in minority class
df_majority_downsampled = resample(df_majority,
                                    replace=False,
                                    n_samples=count_minority,
                                    random_state=random_state_value)
df_commits_annotated = pd.concat([df_majority_downsampled, df_minority])

# Preprocess text
def lower_case_and_remove_stopwords(text):
    return ' '.join([word for word in nltk.tokenize.word_tokenize(text) if word not in (english_stop_words)])
df_commits_annotated['input_feature'] = df_commits_annotated['message']\
    .str.lower().progress_apply(lower_case_and_remove_stopwords)
df_commits_annotated['target'] = df_commits_annotated['isBugfix']\
    .progress_apply(lambda x: 1 if x else 0)
y = df_commits_annotated['target'] # target

# Vectorize text input and split data into train/test
vect = CountVectorizer()
X = vect.fit_transform(df_commits_annotated['input_feature'])
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=42)

# Train model
clf = LinearSVC()
clf.fit(X_train, y_train)

# Print report
y_pred = clf.predict(X_test)
print(classification_report(y_test, y_pred))

# Save model to file
joblib.dump({ 'clf': clf, 'vect': vect },'bugfix_classifier_linearsvc_countvectorizer.joblib')