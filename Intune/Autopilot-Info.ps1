cd\

Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

New-Item -Type Directory -Path "C:\HWID"
Set-Location -Path "C:\HWID"
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Install-Script -Name Get-WindowsAutopilotInfo
Get-WindowsAutopilotInfo.ps1 -OutputFile c:\HWID\deviceid.csv

# For multiple computers over the network do Get-WindowsAutoPilotInfo.ps1 -ComputerName PC1,PC2,PC3 -Outputfile c:\deviceid.csv 

