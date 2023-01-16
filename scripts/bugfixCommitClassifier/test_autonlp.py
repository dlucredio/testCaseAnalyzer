import pandas as pd
from sklearn.model_selection import train_test_split
from autoviml.Auto_NLP import Auto_NLP

data=pd.read_csv('train.csv')

train,test = train_test_split(data, test_size=0.2)

input_feature, target = "SentimentText", "Sentiment"

train["Sentiment"] = pd.to_numeric(train["Sentiment"])
test["Sentiment"] = pd.to_numeric(test["Sentiment"])

train_x, test_x, final, predicted=Auto_NLP(input_feature,train,test,target,score_type="balanced_accuracy",modeltype="classification",verbose=0,build_model=True)
