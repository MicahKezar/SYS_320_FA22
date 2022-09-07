import logCheck
import importlib
importlib.reload(logCheck)

# SSH authentication failures
def apache_events(filename, service, term):

    # Call syslogCheck and return results
    is_found = logCheck._logs(filename, service, term)

    # found list
    found = []

    # Loop through results.
    for eachFound in is_found:

        #print(eachFound)
        # Split the results
        sp_results = eachFound.split(" ")

        # Append the split values to the found list
        found.append(sp_results[3] + " " + sp_results[0] + " " + sp_results[1])
    
    # Remove duplicates by using set
    # and convert list to dictionary

    hosts = set(found)

    # Print results
    for eachValue in hosts:

        print(eachValue)