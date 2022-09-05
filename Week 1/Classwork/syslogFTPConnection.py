import syslogCheck
import importlib
importlib.reload(syslogCheck)

# SSH authentication failures
def ftp_connect(filename, searchTerms):

    # Call syslogCheck and return results
    is_found = syslogCheck._syslog(filename,searchTerms)

    # found list.
    found = []

    # Loop through results
    for eachFound in is_found:

        #print(eachFound)
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split values to the found list
        found.append(sp_results[3])
    
    # Remove duplicates by using set
    # and convert list to dictionary

    hosts = set(found)

    # Print results
    for eachHost in hosts:

        print(eachHost)
