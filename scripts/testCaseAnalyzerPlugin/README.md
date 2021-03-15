This is an Eclipse plugin that runs different static and dynamic analysis for different metrics.

Step 2: Install the [Eclipse plugin](./testCaseAnalyzerPlugin) and run it (instructions on the folder)

Step 3: On the workspace of eclipse instance where the plugin is installed, import all projects cloned in Step 1 and make sure they compile correctly. Runtime and Maven/Gradle dependency errors can be ignored.



Some projects require [lombok](https://projectlombok.org/) to run. The easier way to do this is to download lombok.jar and configure it as a VM argument:

"Run Configurations" (for running the plugin) -> VM arguments

-javaagent:/home/daniel/Programs/lombok.jar

The plugin is configurable through variables in class ```br.ufscar.dc.dlucredio.fseanalyzer.handlers.Constants```. See the comments for instructions.