import os, argparse, lib
from tokenize import String

# Lines 5-13 gives us a nice description of our tool, and creates the arguements needed for the command
parser = argparse.ArgumentParser(

    description="Security tool to analyze Registry data collection, Script execution and PowerShell invoking"
)

parser.add_argument("-d", "--directory", required = True, help = "Directory containing CSV Files for analysis")
parser.add_argument("-p", "--program", required = True, help = "Program to scan for")
parser.add_argument("-t", "--terms", required = True, help = "Term to search for")
parser.add_argument("-c", "--configuration", required = True, help = "configuration file to use")

# We are now assigning variables to each of our arguements
args = parser.parse_args()

rootdir = args.directory 
program = args.program 
terms = args.terms
conf_file = args.configuration

# Checking to see if the directory is invalid
if not os.path.isdir(rootdir):
    print("Invalid Directory => {}".format(rootdir))

fList = [] 

for root, subffolders, filenames in os.walk(rootdir):

    for f in filenames: 

        fileList = root + "/" + f 
        fList.append(fileList)
print("-" * 100)

# While loop to check to see if the program they chose was valid. If it isn't any of the 3, you will get an error code and the
# Code will exit. 
while True:
    if program == "Registry":
        print("ATTACK DESCRIPTION")
        print("The Windows Registry contains important configuration information for the operating system, for installed applications as well as individual settings for each user and application.")
        break
    if program == "Script":
        print("ATTACK DESCRIPTION")
        print("a script is a program or sequence of instructions that is interpreted or carried out by another program rather than by the computer processor")
        break
    if program == "PowerShell":
        print("ATTACK DESCRIPTION")
        print("PowerShell is a task automation and configuration management program from Microsoft, consisting of a command-line shell and the associated scripting language.")
        break
    else:
        print("Please select a valid attack. (eg. Registry, Script, Powershell")
        print("-" * 100)
        exit()

print("-" * 100)
print("Formatting: ARGUMENTS | HOSTNAME | PATH | PID | USERNAME")
print("-" * 100)

for eachFile in fList:

    results = []
    found = lib._logs(eachFile,program,terms,conf_file)
    for eachFound in found:
        results.append(eachFound)

    if len(results) == 0:
        continue
    else:
        print("""File:{}""".format(eachFile))
        for eachValue in results:
            print(eachValue)
        print("-" * 100)
