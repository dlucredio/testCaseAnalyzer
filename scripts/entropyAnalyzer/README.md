The following paper defined the concept of entropy:

Daryl Posnett, Abram Hindle, and Premkumar Devanbu. 2011. A simpler model of software readability. In Proceedings of the 8th Working Conference on Mining Software Repositories (MSR '11). Association for Computing Machinery, New York, NY, USA, 73–82. DOI:https://doi.org/10.1145/1985441.1985454

This script calculates entropy for each method in a Java project.

To run the script, first you need the output from [the last merge script](../mergeStaticAnalysisCommitsClonesAndCoverage.py). But it can't be a very large file, as it might run out of memory. 

You may try first, with the following command:

```$java -jar .\target\testcaseparser-1.0-SNAPSHOT-jar-with-dependencies.jar C:\Users\dlucr\GitProjectsFSE2\ C:\Users\dlucr\GitProjects\testCaseAnalyzer\files\staticAnalysisCommitsClonesCoverage.csv C:\Users\dlucr\GitProjects\testCaseAnalyzer\files\entropy.csv -Xmx4g -XX:+UseConcMarkSweepGC -XX:-UseGCOverheadLimit```

If you run into out of memory error, you can try the following:

If needed, first separate this file into multiple .csv, using ```separate.py```. 5000 entries per file is enough.

```sh
python separate.py staticAnalysisCommitsClonesCoverage.csv ./in/ 5000
```

The, run the maven project, specifying the folder with the projects, the input .csv file and an output .csv file. For example:

```$ java -jar ./target/testcaseparser-1.0-SNAPSHOT-jar-with-dependencies.jar /home/daniel/GitProjectsFSE2 /home/daniel/GitProjects/testCaseAnalyzer/workspaceJan2021/testcaseparser/in/output_1.csv /home/daniel/GitProjects/testCaseAnalyzer/workspaceJan2021/testcaseparser/out/entropy_1.csv -Xmx4g -XX:+UseConcMarkSweepGC -XX:-UseGCOverheadLimit```

After you run the script in all files, merge them all using ```append.py```.

```sh
python append.py ./out/ entropy.csv
```