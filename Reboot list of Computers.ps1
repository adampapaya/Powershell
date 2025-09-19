Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Define the list of computers to reboot
$computers = @("", "", "", "","")  # Replace with your actual computer names

# Define domain credentials
$domainCredential = Get-Credential

# Loop through each computer in the list
foreach ($computer in $computers) {
    # Ping the computer to check if it's online
    if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
        try {
            Write-Host "Rebooting $computer..."

            # Reboot the computer with the specified domain credentials
            Restart-Computer -ComputerName $computer -Credential $domainCredential -Force -Confirm:$false -ErrorAction Stop

            Write-Host "$computer rebooted successfully."
        } catch {
            Write-Host "Failed to reboot $computer. Error: $_"
        }
    } else {
        Write-Host "$computer is not reachable."
    }
}
