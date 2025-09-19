Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Define the computer to reboot
$computer = Read-Host "Which PC?"

# Define domain credentials
$domaincredential = Get-Credential

# Create a credential object
$credential = New-Object System.Management.Automation.PSCredential($domaincredential)

# Ping the computer to check if it's online
if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
    try {
        Write-Host "Rebooting $computer..."

        # Reboot the computer with the specified domain credentials
        Restart-Computer -ComputerName $computer -Credential $credential -Force -Confirm:$false -ErrorAction Stop

        Write-Host "$computer rebooted successfully."
    } catch {
        Write-Host "Failed to reboot $computer"
    }
} else {
    Write-Host "$computer is not reachable."
}
