#Script for windows updates

Set-ExecutionPolicy remotesigned -Scope Process -Force;
Install-Module PSWindowsUpdate -Force;
Import-Module PSWindowsUpdate;
Get-WindowsUpdate -AcceptAll -Install

#Script for windows updates

Set-ExecutionPolicy remotesigned -Scope Process -Force;
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

[Net.ServicePointManager]::SecurityProtocol

Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force

Install-Module PSWindowsUpdate -Force

Import-Module PSWindowsUpdate -Force

Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose    