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

# Three positives (1) and three negatives (0)
input = [
    "check nullity to fail earlier, to help isolate IVY-355",
    "Trying to minimize the number of simultaneous open connections by following the guidelines mentioned in http://java.sun.com/j2se/1.5.0/docs/guide/net/http-keepalive.html (IVY-1105)",
    "Fixed an event resetting issue in ODE. \n When several discrete events occur during the same ODE integration step, \n they are handled chronologically or reverse chronologically depending on \n the integration direction. If one of the event truncates the step (for \n example because its eventOccurred method returns RESET or \n RESET_DERIVATIVES for example), the stepAccepted method of the pending \n events later in the step were not called. This implied that in the next \n step, these events were still referring to data from previous step, they \n had lost synchronization with the integrator. \n JIRA: MATH-695",
    "Just some hacks to allow multiline plugins.  Not functional yet.",
    "removing schemas.",
    "Move Serializable from interface to implementations"
]

processed_input = []

for text in input:
    processed_input.append(' '.join([word for word in nltk.tokenize.word_tokenize(text) if word not in (english_stop_words)]))

vectorized_input = vect.transform(processed_input)

pred = clf.predict(vectorized_input)

print(pred) # Should print [1 1 1 0 0 0]
