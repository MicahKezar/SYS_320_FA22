# Generate a random number 1000-9000
$randInt = Get-Random -Minimum 1000 -Maximum 9876

# Copy powershell.exe to Home directory
Copy-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe" `
-Destination "C:\Users\micah\EnNoB-$randInt.exe"

# Check that the copied file exists.
$newFile = "C:\Users\micah\EnNoB-$randInt.exe"

if (Test-Path -Path $newFile) {

    Write-Host "The new file was created!"

}else{

    Write-Host "The new file was not created :("
}

# Create readme and append message to it

New-Item -Path "C:\Users\micah\Desktop\README.read"
Set-Content -Path "C:\Users\micah\Desktop\README.read" 'If you want your files restored, please contact me at micah.kezar@mymail.champlain.edu. I look forward to doing business with you.'

$readmeFile = "C:\Users\micah\Desktop\README.read"

if (Test-Path -Path $readmeFile) {

    Write-Host "The new README file was created!"

}else{

    Write-Host "The new README file was not created :("

}