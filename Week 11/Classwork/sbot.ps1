# Send an email using Powershell

$toSend = @('micah.kezar@mymail.champlain.edu', 'micah.kezar@mymail.champlain.edu', 'micah.kezar@mymail.champlain.edu')


# Message Body

$msg = "Hello world!"

while($true) {

    foreach ($email in $toSend) {


        # Send the Email
        write-host "Send-MailMessage -from 'micah.kezar@mymail.champlain.edu' to '$email' -Subject 'Tisk Tisk' `
        -Body $msg -SmtpServer X.X.X.X"

        # Pause for 1 second
        start-sleep 1
    }
}