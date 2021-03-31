#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Mar  6 11:46:45 2020

@author: youngchen
"""

#from sklearn.externals
import joblib 
import os
import csv
import pandas as pd

from nltk.corpus import stopwords 
from nltk.tokenize import word_tokenize 
from nltk.stem.snowball import SnowballStemmer
from nltk.stem import PorterStemmer
from nltk.stem import LancasterStemmer
from nltk.stem import WordNetLemmatizer
import re, string
import numpy as np

def remove_stop_words(commit_msg, if_stemming, if_lemmatize):
    '''
    remove stop words in commit_msg and do stemming
    @commit_msg: string, commit message that need to be cleaned
    @if_stemming: bool, if true, function will use stemming to clean message
    @if_lemmatize: bool, if true function will use lemmatization to clean message
    '''
    # Remove stop words and stemming in commit message

    stop_words = set(stopwords.words('english')) 
    
    stemmer = SnowballStemmer("english", ignore_stopwords=True)
    stemmer_port = PorterStemmer()
    stemmer_lanca = LancasterStemmer()
    wordnet_lemmatizer = WordNetLemmatizer()
    
    word_tokens = word_tokenize(commit_msg) 
    filtered_sentence = ""
    
    for w in word_tokens: 
        w = w.lower()
        #replace special character
        w = w.replace("=-,,()\n","")
        w.strip('\/')
        w = re.sub("[@\'``\\n\-\+\/*]()","",w)
        if if_stemming:
            w = stemmer.stem(w)
        if if_lemmatize:
            w = wordnet_lemmatizer.lemmatize(w, pos="v")
        if w not in stop_words: 
            if w not in string.punctuation: 
                filtered_sentence += (w+ " ") 
    filtered_sentence = filtered_sentence.strip()
    return filtered_sentence

def remove_all_stop_words(csv_data):
    #iterate all rows in csv_data
    n=0

    for index, msg in csv_data.iterrows(): # iterrows return index and row elements
        # If commit message is located as column 1, named of 'commit_message' in csv_data
        # commit_message, SHA, Bugfix
        # fix storm bugs, 27ae23, B
        
        n += 1
#        print(msg['CommitMessage'])
        if isinstance(msg['CommitMessage'],float):
            continue
        else:
            
            msg['CommitMessage'] = remove_stop_words(msg['CommitMessage'], if_stemming = False, if_lemmatize = True) #remove stop words           
#            msg['CommitMessage'] = msg['CommitMessage'].apply(lambda x: len(x.split(' '))).sum()
#            print(msg['CommitMessage'])
#        if n > 30:
#            break
    return csv_data

def read_csv_file(example_path):
    #use pandas to read csv file and return pandas.Dataframe: csv_data
    csv_data = pd.read_csv(example_path)  # load csv file
    
    #drop useless column
#    csv_data = csv_data.drop(columns=[]) # optional

    csv_data = remove_all_stop_words(csv_data)
    return csv_data

def make_prediction(csv_data, classifier):
    '''
    Use the classifier to make predictions of commit message
    '''
    
#    commit_msg = csv_data.CommitMessage
#    print(commit[:30])
    for i,commit in csv_data.iterrows():
        if isinstance(commit['CommitMessage'],float):
            #print([commit['CommitMessage']])
            continue
        else:
            #print([commit['CommitMessage']])
            #print(len([commit['CommitMessage']]))
            #print(np.array([commit['CommitMessage']]).shape)
            prediction = classifier.predict([commit['CommitMessage']])
            #prediction = classifier.predict(np.array([commit['CommitMessage']]))
            if prediction == [0]:
                prediction = 'True'
            else:
                prediction = 'False'
                
            commit['isBugFix'] = prediction
    return csv_data


if __name__ == '__main__':
    #load classifier
    clf = joblib.load('commit_clf_updated.pkl')
    print(type(clf))
#    path = ['csv_files/csv_file_direct', 'csv_files/csv_file_inter']

    path = 'all2.csv'
    
    #load csv file
    csv_data = read_csv_file(path)
    
    print(csv_data.info())
#    if len(csv_data) != 0: #filter out empty csv file
    #make prediction
    csv_data = make_prediction(csv_data,clf)

    #write panda datafram to csv file
    csv_path_pred = 'result3.csv'#'/Users/youngchen/Downloads/classifierUpdated/all1.csv'
    csv_data.to_csv(csv_path_pred) 
                