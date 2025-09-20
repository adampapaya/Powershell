# Define the server and printer name
$serverName = "name"
$printerName = "name"

# Get the print queue for the specified printer on the server
$printQueue = Get-Printer -ComputerName $serverName | Where-Object { $_.Name -eq $printerName }

# Check if the printer exists
if ($printQueue -eq $null) {
    Write-Host "Printer '$printerName' on server '$serverName' not found."
    exit
}

# Get all print jobs in the queue
$printJobs = Get-WmiObject -Query "SELECT * FROM Win32_PrintJob WHERE Name LIKE '%$printerName%' AND Document <> ''" -ComputerName $serverName

# Cancel each print job
foreach ($job in $printJobs) {
    Stop-PrintJob -InputObject $job
    Write-Host "Cancelled print job $($job.Document) (Job ID: $($job.JobId))"
}

Write-Host "Print jobs cancelled for printer '$printerName' on server '$serverName'."
