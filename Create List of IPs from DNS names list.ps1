# Function to retrieve IP address of a computer
function Get-IPAddress {
    param (
        [string]$ComputerName
    )
    try {
        $IPAddress = [System.Net.Dns]::GetHostAddresses($ComputerName) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString -ErrorAction Stop
        return $IPAddress
    } catch {
        Write-Host "Failed to retrieve IP address for $ComputerName : $_" -ForegroundColor Red
    }
}

# Main script

# Path to the text file containing computer names
$ComputerListFile = "C:\Users\aampaya\OneDrive - Niagara Bottling, LLC\Desktop\ComputersNeedingUpdate9-19.txt"
# Path to the output text file
$OutputFile = "C:\Users\aampaya\OneDrive - Niagara Bottling, LLC\Desktop\output9-19.txt"

# Check if the input file exists
if (Test-Path $ComputerListFile) {
    # Read computer names from the file
    $ComputerNames = Get-Content $ComputerListFile

    # Initialize an array to store IP addresses
    $IPAddresses = @()

    # Iterate through each computer name and retrieve its IP address
    foreach ($ComputerName in $ComputerNames) {
        $IPAddress = Get-IPAddress -ComputerName $ComputerName
        if ($IPAddress) {
            Write-Host "IP address of $ComputerName : $IPAddress" -ForegroundColor Green
            # Add the IP address to the array
            $IPAddresses += "$IPAddress"
        }
    }

    # Write IP addresses to the output file
    $IPAddresses | Out-File -FilePath $OutputFile -Encoding utf8

    Write-Host "IP addresses saved to $OutputFile" -ForegroundColor Green
} else {
    Write-Host "File not found: $ComputerListFile" -ForegroundColor Red
}
