These scripts are used to collect different data and inputs from projects. The following guide is a brief description of all steps used to reproduce everything. Please feel free to submit a pull request to fix something or provide more info.

In the following instructions, the input/output file names are only suggestions. But if you follow all suggestions it is easier to understand how all files are merged together. If the default file name is not the same described here, rename it to make the steps easier to follow.

### Preparation

Manually clone and compile all projects from the [projects list](../projects) into a folder.

### Step 1: Code commits

Run [commitAnalyzer](./commitAnalyzer)
- Input: projects folder
- Output name: ```commits.csv```

### Step 2: Code clones

Run [codeCloneDetection](./codeCloneDetection)
- Input: projects folder
- Output name: ```clones.csv```

### Step 3: Merge commits and clones

Run ```mergeCommitsAndClones.py```
- This merges the output from commits and clones analyzers.
- Inputs: ```commits.csv``` and ```clones.csv```
- Output name: ```commitsClones.csv```

### Step 4: Run static analysis

Run [testCaseAnalyzerPlugin](./testCaseAnalyzerPlugin) with ```PARSE_TEST_CASE_MODE = true```
- Input: projects folder
- Output name: ```staticAnalysis.csv```

### Step 5: Merge static analysis and clones/commits

Before running this step, there might be necessary to manually adjust some project names:

Run ```analyzeProjectNames.py``` and manually adjust the names based on the output
- Input ```staticAnalysis.csv``` and ```commitsClones.csv```
- Output name: ```commitsClonesCorrectNames.csv```

Run ```mergeStaticAnalysisCommitsClones.py```
- Input ```staticAnalysis.csv``` and ```commitsClonesCorrectNames.csv```
- Output: ```staticAnalsysisCommitsClones.csv```

### Step 6: Run coverage analysis

Run [testCaseAnalyzerPlugin](./testCaseAnalyzerPlugin) with ```COVERAGE_MODE = true```
- Input: projects folder
- Output name: ```coverage.csv```

### Step 7: Merge coverage with static analysis, commits and clones

Run ```mergeStaticAnalysisCommitsClonesCoverage.py```
- Input: ```staticAnalysisCommitsClones.csv``` and ```coverage.csv```
- Output name: ```staticAnalysisCommitsClonesCoverage.csv```

### Step 8: Basic LOC and Complexity analysis

Run [locAndComplexityAnalyzer](./locAndComplexityAnalyzer)
- Input: projects folder
- Output name: ```locComplexity.csv```

### Step 9: Entropy analysis

Run [entropyAnalyzer](./entropyAnalyzer)
- Input: projects folder and ```commitsClonesCorrectNames.csv```
- Output name: ```entropyCommitsClones.csv```

### Step 10: Merge LOC and complexity with entropy, commits and clones

Run ```mergeLocComplexityEntropyCommitsClones.py```
- Input: ```locComplexity.csv``` and ```entropyCommitsClones.csv```
- Output name: ```locComplexityEntropyCommitsClones.csv```

### Importing into R Studio

The R scripts will need the following files:

- ```staticAnalysisCommitsClones.csv``` (output from Step 5)
- ```staticAnalysisCommitsClonesCoverage.csv``` (output from Step 7)
- ```locComplexityEntropyCommitsClones.csv``` (output from Step 10)



