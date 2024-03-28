These scripts are used to collect different data and inputs from projects. The following guide is a brief description of all steps used to reproduce everything. Please feel free to submit a pull request to fix something or provide more info.

In the following instructions, the input/output file names are only suggestions. But if you follow all suggestions it is easier to understand how all files are merged together. If the default file name produced by a script is not the same described here, rename it to make the steps easier to follow.

### Preparation

Manually clone and compile all projects from the [projects list](../projects) into a folder. You can use [this script](./cloneAll.sh) to speed thing up.

### Step 1: Train or reuse commit classifier

See [bugfixCommitClassifier](./bugfixCommitClassifier/) for details

### Step 2: Code commits

Run [commitAnalyzer](./commitAnalyzer)
- Input: projects folder
- Output name: ```commits.csv```

### Step 3: Code clones

Run [codeCloneDetection](./codeCloneDetection)
- Input: projects folder
- Output name: many `*_result.csv` files (one for each project)

### Step 4: Merge commits and clones

Run ```mergeCommitsAndClones.py```
- This merges the output from commits and clones analyzers.
- Inputs: ```commits.csv``` and ```*_results.csv```
- Output name: ```commitsClones.csv```
- Command:

```python mergeCommitsAndClones.py --beagle <<folder with commits.csv>> --nicad <<folder with *_results.csv>>```

### Step 5: Run static analysis

Run [testCaseAnalyzerPlugin](./testCaseAnalyzerPlugin) with ```PARSE_TEST_CASE_MODE = true```
- Input: projects folder
- Output name: ```staticAnalysis.csv```

### Step 6: Merge static analysis and clones/commits

Before running this step, there might be necessary to manually adjust some project names:

Run ```analyzeProjectNames.py``` and manually adjust the names in ```commitsClones.csv``` based on the output.

- Input ```staticAnalysis.csv``` and ```commitsClones.csv```
- Output name: ```commitsClonesCorrectNames.csv```

For example, the following output could be shown:

```
python analyzeProjectNames.py ../files/staticAnalysis.csv ../files/commitsClones.csv 
Reading static analysis file ../files/staticAnalysis.csv
Read 19733 rows
Reading commits and clones file ../files/commitsClones.csv
Read 60772 rows
Different in static analysis file:hbc-twitter / hbc-twitter4j
```

This means that project with name `hbc-twitter` must be renamed to `hbc-twitter4j` so that the next scripts won't fail. Do these changes manually and save the result as `commitsClonesCorrectNames.csv`. If there are no differences, just rename `commitsClones.csv` to `commitsClonesCorrectNames.csv`.

Next, run [mergeStaticAnalysisCommitsClones.py](./mergeStaticAnalysisCommitsClones.py) to merge the outputs of the two analys made so far. This script also cleans the output, removing duplicate entries and unused entries in one file.

Run ```mergeStaticAnalysisCommitsClones.py```
- Input ```staticAnalysis.csv``` and ```commitsClonesCorrectNames.csv```
- Output: ```staticAnalsysisCommitsClones.csv```, ```uplicatedStaticAnalysis.csv```, ```duplicatedCommitsClones.csv```,  ```unusedCommitsClones.csv```

Example of how to run:

```python mergeStaticAnalysisCommitsClones.py ../files/staticAnalysis.csv ../files/commitsClonesCorrectNames.csv ../files/staticAnalysisCommitsClones.csv ../files/duplicatedStaticAnalysis.csv ../files/duplicatedCommitsClones.csv ../files/unusedCommitsClones.csv```

### Step 7: Run coverage analysis

Run [coverageAnalyzer](./coverageAnalyzer)
- Input: projects folder
- Output: ```coverage.csv```

### Step 8: Merge coverage with static analysis, commits and clones

Run [mergeStaticAnalysisCommitsClonesAndCoverage.py](./mergeStaticAnalysisCommitsClonesAndCoverage.py)
- Input: ```staticAnalysisCommitsClones.csv``` and ```coverage.csv```
- Output name: ```staticAnalysisCommitsClonesCoverage.csv```

Command:
```sh
python mergeStaticAnalysisCommitsClonesAndCoverage.py ../files/staticAnalysisCommitsClones.csv ../files/coverage.csv ../files/staticAnalysisCommitsClonesCoverage.csv
```

### Step 9: Basic LOC and Complexity analysis

Run [locAndComplexityAnalyzer](./locAndComplexityAnalyzer)
- Input: projects folder
- Output name: ```locComplexity.csv```

### Step 10: Entropy analysis

Run [entropyAnalyzer](./entropyAnalyzer)
- Input: projects folder and ```staticAnalysisCommitsClonesCoverage.csv```
- Output name: ```entropy.csv```

### Step 11: Merge loc/complexity file with entropy file

Run ```mergeLocComplexityEntropy.py```
- Input: ```locComplexity.csv``` and ```entropy.csv```
- Output name: ```locComplexityEntropy.csv```

Run as follows:

```sh
python .\mergeLocComplexityEntropy.py ..\files\locComplexity.csv ..\files\entropy.csv ..\files\locComplexityEntropy.csv
```

### Step 12: Merge all files into a single csv

Run ```mergeFinal.py```
- Input: ```staticAnalysisCommitsClonesCoverage.csv``` and ```locComplexityEntropy.csv```
- Output name: ```mergedFinal.csv```

```sh
python mergeFinal.py staticAnalysisCommitsClonesCoverage.csv locComplexityEntropy.csv mergedFinal.csv
```

### Importing into R Studio

The R scripts will need only the ```mergedFinal.csv``` file (output from Step 11)

The main script is [fullAnalysis.r](./statisticAnalysis/fullAnalysis.r). It calls other scripts, one for each hypothesis tested.

The output of this analysis are the files named ```analysisResultHX.csv```, in folder [files](../files). Each file has, on the first line, the results for all projects, and in the next lines, one result per project.


