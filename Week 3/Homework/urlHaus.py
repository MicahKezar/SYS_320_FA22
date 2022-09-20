# Fixed: Imported re as it wasn't imported in the original code
# Function: these lines below will import re and csv

import re
import csv

# Fixed: searchTerm needs to be changed to to searchTerms
# Fixed: changed ur1HausOpen to urlHausOpen. The only difference being the 'l' and the '1'.
# Function: This will create a function called urlHausOpen with the parameters filename and searchTerms

def urlHausOpen(filename, searchTerms):

    # Fixed: indented this and following lines
    # Fixed: changed from 'while open' to 'with open'. It's not meant to be a loop.
    # Fixed: removed the quotes around filename.
    # Function: This opens the file from 'filename' and then saves everything to the variable 'f'.

    with open(filename) as f:

        # Fixed: removed an equal sign from '=='.
        # Fixed: changed 'csv.review(filename)' to 'csv.reader(f.readlines())'
        # Function: This creates a csv reader object

        contents = csv.reader(f.readlines())

    # Function: Creates a new for loop with the intention of skipping the first 9 lines.

    for skipped_line in range(9):

        # Function: skips to the next item

        next(contents)

    # Fixed: Swapped the for loops on lines 37 and 41. They were nested improperly. 
    # Function: goes over each line in contents

    for eachLine in contents:

        # Funcion: goes over each keyword in searchTerms

        for keyword in searchTerms:

            # Fixed: replaced `r+keyword+` with `r'' + keyword + r ''`
            # Function: Finds all instances of keyword within eachLine, and assigns those instances to x.

            x = re.findall(r''+ keyword + '', eachLine[2])

            # Function: The for loop will print info about the instancces found.
            for _ in x:

                # Don't edit this line. It is here to show how it is possible
                # to remove the "tt" so programs don't convert the malicious
                # domains to links that an be accidentally clicked on.

                the_url = eachLine[2].replace("http", "hxxp")
                the_src = eachLine[4]

                # Fixed: changed the '+' in +60 to a '*'
                # Fixed: replaced the comma after the three """ with a period so .format could be called properly.

                print("""
URL: {}
Info: {}
{}""".format(the_url, the_src, "*"*60))