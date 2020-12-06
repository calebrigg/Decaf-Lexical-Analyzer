
Your documentation
------------------

The tool decaflex is used to create a stream of tokens based on the input stream.
The way we implemented said stream is to use piped output using cat into the decaflex program.
To automate that, I provide a bash script that goes through all files in the folder dev in testcases and a script that goes through all 
files in the test folder in testcases. Then there is another script that compares files from testcases/dev and references/dev and outputs the difference.
All the testcases match and error reporting is done correctly as well.

