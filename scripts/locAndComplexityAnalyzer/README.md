We used SciTool's [Understand](https://www.scitools.com/) to collect LOC and Complexity metrics for the projects.

1) Just run the tool in all projects, and save the output as `outputUnderstand.csv`. Chose the following options:

- Show File Entity Names As: Relative
- Show Declared in File: Relative (check this option, as it is not checked by default)

2) The output from Understand includes all methods, classes, files, etc. Use ```filterUnderstand.py``` to filter the output, leaving only methods.

```sh
python filterUnderstand.py outputUnderstand.csv locComplexity.csv
```