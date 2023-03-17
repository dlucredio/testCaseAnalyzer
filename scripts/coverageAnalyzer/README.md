1. The first step is to compile all projects. Navigate into each project and run ```mvn compile``` (or a different goal might exist, such as `hibernate-search`, which is compiled with ```mvnw clean install -DskipTests```). Fix any compilation problems you might encounter, as many as possible.

In the process, Maven will try to download all dependencies for the projects. But some are old, and two small hacks may be necessary.

Edit file `<maven home>/conf/settings.xml`, to override the default http blocker. Modify this part here:

```diff
    <mirror>
      <id>maven-default-http-blocker</id>
-      <mirrorOf>external:http:*</mirrorOf>
+      <mirrorOf>external:dummy:*</mirrorOf>
      <name>Pseudo repository to mirror external repositories initially using HTTP.</name>
      <url>http://0.0.0.0/</url>
      <blocked>true</blocked>
    </mirror>
```

Next, tell Maven to ignore some old restrictions regarding checks that did not exist before Java 9:

```export MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED"```

2. For each project, we must be able to run the test and get coverage information. This will be done using [JaCoCo](https://www.eclemma.org/jacoco/).

* Open `pom.xml`
* Search for `surefire` or `failsafe`. If there is not an entry, add the following piece of XML in `build/plugins` tag (warning, NOT `build/pluginManagement/plugins`). If there is an entry, but no `<testFailureIgnore>true</testFailureIgnore>` tag, include it. This tells surefire to continue running even if there are failing tests. There might be some failing tests, but we do not care. We only want to get as much coverage data as possible for each individual test:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <configuration>
        <testFailureIgnore>true</testFailureIgnore>
    </configuration>
</plugin>
```

If there are additional tags in the surefire configuration, it might be necessary to remove them and keep the config as simple as above. But only do it if a problem occurs.

* Search for `jacoco`. If there is not an entry, add the following piece of XML in `build/plugins` tag (warning, NOT `build/pluginManagement/plugins`):

```xml
<plugin>
    <groupId>org.jacoco</groupId>
    <artifactId>jacoco-maven-plugin</artifactId>
    <version>0.8.8</version>
    <executions>
        <execution>
            <goals>
                <goal>prepare-agent</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

If there is already a `jacoco` entry, the project is already configured. But it might be missing the `report` execution goal. Complete it if necessary.

* Run `mvn test jacoco:report`. In some cases it might be worth to try `mvn clean test jacoco:report`. If jacoco is configured in a Maven profile, the command must be `mvn clean test jacoco:report -P coverage` (where `coverage` is the name of the profile)

* Check if at least some sub project had success, and if a `target/site/jacoco` directory was generated for it. If not, you may delete this project folder, as no coverage data was collected. Or you can keep it, no problem, but it may slow down the entire process a bit.

3. Now let's generate the coverage scripts.

* Run [testCaseAnalyzerPlugin](./testCaseAnalyzerPlugin) with ```COVERAGE_MODE = true``` and ```PARSE_TEST_CASE_MODE = false``` (these variables are in file `Constants.java`, change them before running the new Eclipse instance with the plugin)

- Input: projects folder
- Output: one `.sh` file for each project, in the folder configured inside the plugin (also located in file `Constants.java`).

IMPORTANT: the output folder must be empty, otherwise no script will be generated.

Each .sh file will run `mvn test`, which will generate a coverage report using [JaCoCo](https://www.eclemma.org/jacoco/). The script then copies the generated report to the output folder, properly renaming it.

* Navigate to the same folder with the `.sh` files and copy the script [runMultipleSh.sh](./runMultipleSh.sh). This will execute all `.sh` filesm and will take a very long time, depending on how many projects are being analyzed. This will produce many `.csv` files, organized by project in a new folder called `coverageReports` generated where you executed the script.

* Important, you might have to re-run the following command to set the variable before executing all scripts:

```export MAVEN_OPTS="--add-opens java.base/java.lang=ALL-UNNAMED"```

*. Now run [combineIndividualMethodCoverageIntoSingleCsv.py](./combineIndividualMethodCoverageIntoSingleCsv.py) to combine all .csv files into a single one.

```python combineIndividualMethodCoverageIntoSingleCsv.py ./coverageReports coverage.csv```
