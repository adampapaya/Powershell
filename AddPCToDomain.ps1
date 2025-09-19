# Prompt for the domain and organizational unit (optional)
$DomainName = Read-Host "Enter the domain name (e.g., example.com)"
$OUPath = Read-Host "Enter the organizational unit (OU) path (optional, e.g., OU=Computers,DC=example,DC=com)"
if ([string]::IsNullOrWhiteSpace($OUPath)) { $OUPath = $null }

# Prompt for domain credentials
$DomainCredential = Get-Credential -Message "Enter domain administrator credentials"

# Join the computer to the domain
try {
    Write-Host "Attempting to add computer to domain $DomainName..." -ForegroundColor Yellow
    Add-Computer -DomainName $DomainName -Credential $DomainCredential -OUPath $OUPath -Force -Restart
    
    Write-Host "Successfully added the computer to the domain. The computer will restart shortly." -ForegroundColor Green
} catch {
    Write-Host "Failed to add the computer to the domain. Error details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
}
