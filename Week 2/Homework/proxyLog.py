import logCheck
import importlib
import re
importlib.reload(logCheck)

# SSH authentication failures
def proxy_events(filename, service, term):

    # Call syslogCheck and return results
    is_found = logCheck._logs(filename, service, term)

    # found list
    found = []

    # Loop through results.
    for eachFound in is_found:

        #print(eachFound)
        # Split the results
        sp_results = eachFound.split(" ")

        for item in sp_results:
            if bool(re.search(r"[qq]{2}", item)):
                sp_results.remove(item)


        # Append the split values to the found list
        if(term == "qqOpen"):
            found.append(sp_results[0] + " " + sp_results[2] + " " + sp_results[3])
        if(term == "qqClose"):
            found.append(sp_results[4] + " " + sp_results[5])
    
    # Remove duplicates by using set
    # and convert list to dictionary

    hosts = set(found)

    # Print results
    for eachValue in hosts:

        print(eachValue)
