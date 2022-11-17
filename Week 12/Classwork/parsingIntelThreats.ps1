# Array of websites containing threat intell
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLs for the rules list 
foreach ($u in $drop_urls) {
    
    # Extract the filename 
    $temp = $u.split("/")

    # The last element in the array plucked off is the filename 
    $file_name = $temp[-1]

    if (Test-Path $file_name) {

        continue

    } else {

        # Download thhe rules list 
        Invoke-WebRequest -Uri $u -OutFile $file_name
    } # close if

} #close foreach

# Array containing the filename 
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')


# Extract the IP addresses. 
# 108.190.109.107
# 108.191.2.72 
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list. 
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object {$_.Matches} | `
ForEach-Object {$_.Value} | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

# Get the IP addresses discovered, Loop through and replaace the beginning  of the line with the IPTables syntax
# After the IP address, add the remaining IPTables syntax and save the results to a file 
# iptables -A INPUT -s 255.255.255.255 -j DROP 
(Get-Content -Path "ips-bad.tmp") | % `
{$_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File -FilePath "iptables.bash"