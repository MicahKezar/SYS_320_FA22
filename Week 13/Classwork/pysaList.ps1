# List the files in a directory and 
# List of all files and print full path
#Get-Childitem -Recurse -Include *.docx,*.pdf,*.txt -Path .\Documents | Get-Member

#Get-Childitem -Recurse -Include *.docx,*.pdf,*.txt -Path .\Documents | export-csv `
#-Path files.csv

# Import the CSV
$fileList = Import-Csv -Path .\files.csv #-header FullName


# Loop for results
foreach ($f in $fileList) {

    Get-ChildItem -Path $f.FullName

}