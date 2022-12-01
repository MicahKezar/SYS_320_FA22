# Create commandline parameters to copy a file and place into an evidence directory

param(

    [Parameter(Mandatory = $true)]
    [int]$reportNo,

    [Parameter(Mandatory = $true)]
    [String]$filePath
)

# Create directory with report number
$reportDir = "rpt$reportNo"

#Creating New Directory
mkdir $reportDir

# Copy the file to the new directory
Copy-Item $filePath $reportDir