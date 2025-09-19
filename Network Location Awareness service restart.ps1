# PowerShell script to modify Registry Keys and restart service Network Location Awareness Service
# Resolves no network icon when you are connected
# Created by Vinny Vasile - 6.16.2023
$ServiceName = "NlaSvc"

try {
    Restart-Service -Name $ServiceName -Force -ErrorAction Stop
    Write-Output "Successfully restarted the $ServiceName service."
} catch {
    Write-Output "Failed to restart the $ServiceName service: $_"
}

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet"

$RegistryData = @{
    "ActiveDnsProbeContent"    = "8.8.8.8"
    "ActiveDnsProbeContentV6"  = "2001:4860:4860::8844"
    "ActiveDnsProbeHost"       = "dns.google"
    "ActiveDnsProbeHostV6"     = "dns.google"
    "ActiveWebProbeHostV6"     = "www.msftconnecttest.com"
    "EnableActiveProbing"      = "1"
}

if (!(Test-Path $RegistryPath)) {
    Write-Output "Registry path $RegistryPath does not exist. Please check the registry path."
} else {
    foreach ($Entry in $RegistryData.GetEnumerator()) {
        if (!(Get-ItemProperty -Path $RegistryPath -Name $Entry.Key -ErrorAction SilentlyContinue)) {
            Set-ItemProperty -Path $RegistryPath -Name $Entry.Key -Value $Entry.Value
            Write-Output "Registry value $($Entry.Key) has been set to $($Entry.Value)."
        } else {
            Write-Output "Registry value $($Entry.Key) already exists. Skipping..."
        }
    }
}