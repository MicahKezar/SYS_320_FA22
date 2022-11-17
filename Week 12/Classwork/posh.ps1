cls
# Login to a remote SSH Server
# New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-Credential sys320)

<#
while ($True) {

    # Add a prompt to run commands
    $the_cmd = read-host -Prompt "Please enter a command"
    # Run command on a remote SSH Server
    (Invoke-SSHCommand -index 0 $the_cmd).Output

}
#>

Set-SCPFile -Computername '192.168.4.22' -Credential (Get-Credential sys320) `
-RemotePath '/home/sys320' -LocalFile '.\tedx.jpeg'