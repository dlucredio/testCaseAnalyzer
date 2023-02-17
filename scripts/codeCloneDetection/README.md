We used [NICAD](http://www.txl.ca/txl-nicaddownload.html) to detect code clones in test cases.

First you need to install it. Follow the instructions in the `00-README-NiCad6.txt` file in the downloaded. But first, read below:

[testonly.cfg](./testonly.cfg): This is a Nicad config file. This file should be located at the config folder inside of the nicad installation folder. This config excludes all non-test files. Copy this to the folder before installing.

1) First, navigate to the folder containing all cloned projects (parent folder), then execute:

```nicad6 functions java <<project folder>> testonly```

You may use [runNicadAll.sh](./runNicadAll.sh) to see how to run.

After running, NICAD will create many XML files in this folder, as well as some subdirectories containing the analysis results.

2) Run ```gather-nicad.py```: This file parses the Nicad XML output.

Nicad doesn't include function names at XML output. Instead, it generates a file contains code clones function body which is not a valid XML file because of the java generic types (they have "<>" characters). So it is necessary to manually parse the XML file.

Usage: python gather-nicad.py --project <PROJECT_NAME> --path <NICAD_FILES>

You may use [runGatherAll.sh](./runGatherAll.sh) to see how to run.

