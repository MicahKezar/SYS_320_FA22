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
$input_paths = @('.\Week 12\Classwork\compromised-ips.txt','.\Week 12\Classwork\emerging-botcc.rules')


# Extract the IP addresses. 
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list. 
Select-String -Path $input_paths -Pattern $regex_drop | `
ForEach-Object {$_.Matches} | `
ForEach-Object {$_.Value} | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

$var = (Read-host -Prompt "Please enter Windows or IPTables").ToLower()

# Create Switch
switch ($var) {

    #IPTables
    "iptables" {
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
        { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
            Out-File -FilePath "iptables.out"

            # Function to send iptables.out over SCP, and then return True.
        function scpToDevice {

            Set-SCPItem -ComputerName "192.168.7.116" -Port 22 -Credential (Get-Credential -Message "Please enter your credentials")`
         -Path "./iptables.out" -Destination "C:\Users\micah.kezar\Desktop"
            return $true;
                
        }
        # If the function returned true:
        if (scpToDevice == $true) {
            Write-Output "`n The File has successfully been sent! `n"
        }
        
    }
    #Windows
    "windows" {
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object `
        { $_ -replace "^", "New-NetFirewallRule -DisplayName 'Block Outbound IP' -Direction Outbound -Profile Any -Action Block -RemoteAddress $_"} | `
            Out-File -FilePath "windowsfirewall.out"

            # Function to send windowsfirewall.out via SCP, and return true
            function scpToDevice {

                Set-SCPItem -ComputerName "192.168.7.116" -Port 22 -Credential (Get-Credential -Message "Please enter your credentials")`
         -Path "./windowsfirewall.out" -Destination "C:\Users\micah.kezar\Desktop"
                return $true;
                    
            }

            # if the function returned true:   
            if (scpToDevice == $true) {
                Write-Output "`n The File has successfully been sent! `n"
            }
        
    }
}

<# 

Reflection:

What I liked most about the assignment:

I liked the utilization of switches instead of having to use If/Else statements. I never knew switch statements existed, and I think
they should in some form be in every programming language.

What did I like the least:

I found it a little challenging to get the correct iptable or firewall statement with each IP address to be neatly saved in a file. 

#>