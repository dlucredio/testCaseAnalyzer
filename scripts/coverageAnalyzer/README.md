We analyze code coverage for each individual test case, by running each one with Apache Maven.

Before running these scripts, all projects must be configured to use [JaCoCo Maven Plugin](https://www.eclemma.org/jacoco/trunk/doc/maven.html). This has to be done manually!

Then, use the [testCaseAnalyzerPlugin](../testCaseAnalyzerPlugin) with ```COVERAGE_MODE = true```. This will generate multiple .sh files, one for each test case found. Each .sh file will run mvn test, which will generate a coverage report. The script then copies the generated report to the output folder, properly renaming it.

Use ```runMultipleSh.sh``` to execute all .sh files. This will take a very long time, depending on how many projects are being analyzed. This will produce many .csv files, organized by project in folders.

Then, use ```combineIndividualMethodCoverageIntoSingleCsv.py``` to combine all .csv files into a single one.


