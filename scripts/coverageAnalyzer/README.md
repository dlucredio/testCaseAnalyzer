Run [testCaseAnalyzerPlugin](./testCaseAnalyzerPlugin) with ```COVERAGE_MODE = true``` and ```PARSE_TEST_CASE_MODE = false``` (these variables are in file `Constants.java`, change them before running the new Eclipse instance with the plugin)

- Input: projects folder
- Output: one `.sh` file for each project, in the folder configured inside the plugin (also located in file `Constants.java`).

IMPORTANT: the output folder must be empty, otherwise no script will be generated.

Each .sh file will run `mvn test`, which will generate a coverage report using [JaCoCo](https://www.eclemma.org/jacoco/). The script then copies the generated report to the output folder, properly renaming it.

But before running these `.sh` files, you must be able to compile and run tests in all projects. You will need to:

1. Maven will try to download all dependencies for the projects. But some are old, and a small hack is necessary.

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

2. Now try to compile each project. Enter the parent folder (e.g: `/projects/ambrose`) and run `mvn clean test`
* In some cases, you might need to adjust the source and target version (a message will be shown to indicate that this is necessary)
* In some cases, there are broken dependencies. This is too hard to fix and we will not do it, since each case might be for a different reason. But feel free to analyze and attempt to fix as many projects as possible.

3. If at least one subproject runs correctly, you are good to go. Let's configure JaCoCo.
* Open `pom.xml`
* Search for `surefire` or `failsafe`. If there is not an entry, add the following piece of XML in `build/plugins` tag (warning, NOT `build/pluginManagement/plugins`):

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
</plugin>
```

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
        <execution>
            <id>report</id>
            <phase>test</phase>
            <goals>
                <goal>report</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

4. Run `mvn test`
5. Check if at least some sub project had success, and if a `target/site/jacoco` directory was generated for it. If not, you may delete this project folder, as no coverage data was collected.
6. Once all projects are configured, navigate to the same folder with the `.sh` files and run ```runMultipleSh.sh``` to execute all `.sh` files. This will take a very long time, depending on how many projects are being analyzed. This will produce many `.csv` files, organized by project in a new folder called `coverageReports` generated where you executed the script.

7. Now run ```combineIndividualMethodCoverageIntoSingleCsv.py``` to combine all .csv files into a single one.

```python combineIndividualMethodCoverageIntoSingleCsv.py ./coverageReports coverage.csv```
