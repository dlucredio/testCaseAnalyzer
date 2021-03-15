We used [NICAD](https://github.com/bumper-app/nicad) to detect code clones in test cases. The following files are included:

testonly.cfg: This is a Nicad config file. This file should be located at the config folder inside of the nicad installation path. This config excludes all non-test files.

usage: nicad5 functions java <PATH> testonly

gather-nicad.py: This file parses the Nicad XML output.

Nicad doesn't include function names at XML output. Instead, it generates a file contains code clones function body which is not a valid XML file because of the java generic types (they have "<>" characters). So I manually parse the XML file.

Usage: python gather-nicad.py --project <PROJECT_NAME> --path <NICAD_FILES>

