This folder contains the scripts for analyzing commits, trying to find bug fixing commits.

We used [BEAGLE](https://github.com/alipourm/testevol2) to collect all the information from commits during the evolution of the projects.

1) First step is to run BEAGLE:
Run the following script (you must have Java in your path). Replace `~/testcase/projects/` with the folder where you cloned all the projects. A directory called `beagleOutput` will be created. This will take a while to run (several hours), because BEAGLE will inspect all commits from all repositories.

```sh
./runBeagle.sh ~/testcase/projects/
```

2) Run ```prepare.py```: This script parses BEAGLE output and pick commits that edit a test file and generates `prepared.csv` file suitable for the classifier.

```sh
python prepare.py --path beagleOutput --dest prepared.csv
```

3) Run ```predict.py```: This script gets `prepared.csv` files as input and generates a `commits.csv` as an output.

```sh
python predict.py
```

```bugfix_classifier_linearsvc_countvectorizer.joblib```: This is the classifier used to detect which commits are bug fixes.
