This is an Eclipse plugin that runs different static and dynamic analysis for different metrics.

After cloning all the projects, open the plugin project in eclipse, and configure it as follows:

1) Some projects require [lombok](https://projectlombok.org/) to run. The easier way to do this is to download lombok.jar and configure it as a VM argument:

"Run Configurations" (for running the plugin) -> VM arguments

-javaagent:/home/daniel/Programs/lombok.jar

2) To configure the input/output folders and other parameters, you must do so in the code. The plugin is configurable through variables in class ```br.ufscar.dc.dlucredio.fseanalyzer.handlers.Constants```. See the comments in this class for instructions.

3) Run the plugin project and wait for new instance of Eclipse to open

4) On the workspace of the new instance, import all cloned projects and make sure they compile correctly. Runtime and Maven/Gradle dependency errors can be ignored.

5) A new menu will be available. Just run it to start the plugin.