This folder contains the scripts for analyzing commits, trying to find bug fixing commits.

We used [BEAGLE](https://github.com/alipourm/testevol2) to collect all the information from commits during the evolution of the projects.

1) First step is to run BEAGLE

2) Run ```prepare.py```: This script parses BEAGLE output and pick commits that edit a test file and generates all.csv file suitable for the classifier.

3) Run ```Make_pred.py```: This script gets all.csv files as input and generates a result.csv as an output.

```tfidf.pickle``` and ```commit_clf.pkl```: These are used by the classifier.
