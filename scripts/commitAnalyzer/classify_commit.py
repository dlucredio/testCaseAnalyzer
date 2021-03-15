#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: youngchen
@author: mmeidani
"""
import os
import sys
from sklearn.externals import joblib 
import csv
from nltk.corpus import stopwords 
from nltk.tokenize import word_tokenize 
from nltk.stem.snowball import SnowballStemmer
from nltk.stem import WordNetLemmatizer
import string
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
import pickle
import json

csv.field_size_limit(sys.maxsize)
  
wordnet_lemmatizer = WordNetLemmatizer()
stemmer = SnowballStemmer("english", ignore_stopwords=True)
stop_words = set(stopwords.words('english')) 

def remove_stop_words(commit_msg, if_stemming, if_lemmatize):
    '''
    remove stop words and do stemming
    '''
    word_tokens = word_tokenize(commit_msg) 
    filtered_sentence = ""
    
    for w in word_tokens: 
        if if_stemming:
            w = stemmer.stem(w)
        if if_lemmatize:
            w = wordnet_lemmatizer.lemmatize(w, pos="v")
        if w not in stop_words: 
            if w not in string.punctuation: 
                filtered_sentence += (w+ " ")
    return filtered_sentence

#load model
# Load the model from the file 
classifier = joblib.load('commit_clf.pkl')  
tfidf_vect = joblib.load("tfidf.pickle")

text = []
commit_dic = {}

with open("all.csv", 'r') as csv_file:
    csv_reader = csv.DictReader(csv_file, delimiter=',')
    i = 0
    for row in csv_reader:
        if row["Level"] == "COMMIT":
            commit_message = row["CommitMessage"]
            commit_message = remove_stop_words(commit_message, if_stemming = False, if_lemmatize = True)
            text.append(commit_message)
            commit_dic[row["CommitHash"]] = i
            i += 1

    commit_tfidf = tfidf_vect.transform(text)    
    label = classifier.predict(commit_tfidf)

    
    csv_file.seek(0)
    next(csv_reader, None) #Skip header
    with open("result.csv", 'w') as csv_out:
        fieldnames = ['project_name', 'test_case', 'isBugFix', 'sha_id']
        writer = csv.DictWriter(csv_out, fieldnames=fieldnames)
        writer.writeheader()
        for i,row in enumerate(csv_reader):
            if row['Level'] == "COMMIT":
                continue
            if commit_dic.get(row["CommitHash"]) is None:
                continue
            writer.writerow({
                'project_name': row['Project'],
                'isBugFix': int(label[commit_dic.get(row["CommitHash"])]),
                'sha_id': row['CommitHash'],
                'test_case' : row['TestCase'],
                })

