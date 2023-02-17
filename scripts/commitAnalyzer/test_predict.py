# This file is a demonstration of how to use the trained models
# Tested with Python 3.11.1

import nltk # For text processing
nltk.download('stopwords') # Stop words
nltk.download('punkt') # Tokenizer
english_stop_words = set(nltk.corpus.stopwords.words('english')) # Saving the stopwords in a list

import joblib # To load the model

# The two best models were the following, with practically the same metrics:

# bugfix_classifier_linearsvc_countvectorizer.joblib
# Requires scikit-learn (tested with version 1.2.0 and Python 3.11.1)
#                precision    recall  f1-score   support
#            0       0.98      0.96      0.97       455
#            1       0.96      0.98      0.97       417
#     accuracy                           0.97       872
#    macro avg       0.97      0.97      0.97       872
# weighted avg       0.97      0.97      0.97       872

# bugfix_classifier_automl_countvectorizer.joblib
# Requires auto-sklearn (tested with version 0.15.0 and Python 3.10.9)
# precision    recall  f1-score   support
#            0       0.98      0.96      0.97       978
#            1       0.96      0.98      0.97       940
#     accuracy                           0.97      1918
#    macro avg       0.97      0.97      0.97      1918
# weighted avg       0.97      0.97      0.97      1918

# Choose one and use it as follows. I will choose the LinearSVC model, which is much smaller

model = joblib.load('bugfix_classifier_linearsvc_countvectorizer.joblib')
clf = model['clf']
vect = model['vect']

input = [
    "Merge branch 'master' of github.com:matozoid/javaparser ",#False
    "Update readme.md  Adding reference to Javadoc documentation.",#False
    "basic support of PowerTrack ", #False
    "Adding in a HadoopVersion class instead of having the enum inside Constants ", #False
    "Fix NPE thrown in parallelScan() of TreeDiffer.  Previously, parallelScan() failed when passed two null iterable values. This CL fixes this by performing the proper null pointer check before attempting to dereference in order to access the parameter's iterator() method. ------------- Created by MOE: http://code.google.com/p/moe-java MOE_MIGRATED_REVID=74252905 ",# True
    "Fix #40 implementing an option for considering comments between annotations and start of the method as associated to the method ", #True
    "Fix #52: verify if an object is an instance of a Node before casting to a Node in Node.equals ",#True
]

processed_input = []

for text in input:
    processed_input.append(' '.join([word for word in nltk.tokenize.word_tokenize(text) if word not in (english_stop_words)]))

vectorized_input = vect.transform(processed_input)

pred = clf.predict(vectorized_input)

print(pred) # Should print [0 0 0 1 1 1 1]