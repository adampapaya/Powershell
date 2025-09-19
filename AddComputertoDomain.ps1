# Prompt for the domain name
$domain = Read-Host -Prompt "Enter the domain name"

# Join the computer to the domain using current user credentials
Add-Computer -DomainName $domain -Credential (Get-Credential) -Force

Write-Output "Computer successfully added to the domain."

# Set countdown duration in seconds
$countdownSeconds = 10

# Countdown before restart
for ($i = $countdownSeconds; $i -ge 1; $i--) {
    Write-Host "Restarting in $i seconds. Press Ctrl+C to cancel." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Restart the computer after countdown
Restart-Computer -Force
