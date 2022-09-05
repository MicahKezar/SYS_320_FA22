import syslogCheck
import syslogSU
import importlib
importlib.reload(syslogCheck)

# SSH authentication failures
def su_open(filename, searchTerms):

    # Call syslogCheck and return results
    is_found = syslogCheck._syslog(filename,searchTerms)

    # found list
    found = []

    # Loop through results.
    for eachFound in is_found:

        #print(eachFound)
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split values to the found list
        found.append(sp_results[5])
    
    # Remove duplicates by using set
    # and convert list to dictionary

    returnedValues = set(found)

    # Print results
    for eachValue in returnedValues:

        print(eachValue)
