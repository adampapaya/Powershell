$registryPath = "SOFTWARE\Microsoft\IntuneManagementExtension\"

# Full registry path
$fullPath = "HKLM:\$registryPath"

# Return success/failure code as the result of the script
if (Test-Path -Path $fullPath) {
    exit 0  # File Exists
} else {
    exit 1  # File Does Not Exist
}


$triggers = @()

$triggers += New-ScheduledTaskTrigger -At (get-date) -Once -RepetitionInterval (New-TimeSpan -Minutes 1)

$User = "SYSTEM"

$Action = New-ScheduledTaskAction -Execute "%windir%\system32\deviceenroller.exe" -Argument "/c /AutoEnrollMDM"

$Null = Register-ScheduledTask -TaskName "TriggerEnrollment" -Trigger $triggers -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "TriggerEnrollment"

$RegistryKeys = "HKLM:\SOFTWARE\Microsoft\Enrollments", "HKLM:\SOFTWARE\Microsoft\Enrollments\Status","HKLM:\SOFTWARE\Microsoft\EnterpriseResourceManager\Tracked", "HKLM:\SOFTWARE\Microsoft\PolicyManager\AdmxInstalled", "HKLM:\SOFTWARE\Microsoft\PolicyManager\Providers","HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Accounts", "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Logger", "HKLM:\SOFTWARE\Microsoft\Provisioning\OMADM\Sessions"

$EnrollmentID = Get-ScheduledTask -taskname 'PushLaunch' -ErrorAction SilentlyContinue | Where-Object {$_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt*"} | Select-Object -ExpandProperty TaskPath -Unique | Where-Object {$_ -like "*-*-*"} | Split-Path -Leaf

  foreach ($Key in $RegistryKeys) {
    if (Test-Path -Path $Key) {
     get-ChildItem -Path $Key | Where-Object {$_.Name -match $EnrollmentID} | Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
 }
}
$IntuneCert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {
  $_.Issuer -match "Intune MDM" 
 } | Remove-Item
if ($EnrollmentID -ne $null) { 
 foreach ($enrollment in $enrollmentid){
   Get-ScheduledTask | Where-Object {$_.Taskpath -match $Enrollment} | Unregister-ScheduledTask -Confirm:$false
   $scheduleObject = New-Object -ComObject schedule.service
   $scheduleObject.connect()
   $rootFolder = $scheduleObject.GetFolder("\Microsoft\Windows\EnterpriseMgmt")
   $rootFolder.DeleteFolder($Enrollment,$null)
} 
} 

$EnrollmentIDMDM = Get-ScheduledTask | Where-Object {$_.TaskPath -like "*Microsoft*Windows*EnterpriseMgmt*"} | Select-Object -ExpandProperty TaskPath -Unique | Where-Object {$_ -like "*-*-*"} | Split-Path -Leaf
  foreach ($Key in $RegistryKeys) {
    if (Test-Path -Path $Key) {
     get-ChildItem -Path $Key | Where-Object {$_.Name -match $EnrollmentIDMDM} | Remove-Item -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
 }
}
if ($EnrollmentIDMDM -ne $null) { 
 foreach ($enrollment in $enrollmentidMDM){
   Get-ScheduledTask | Where-Object {$_.Taskpath -match $Enrollment} | Unregister-ScheduledTask -Confirm:$false
   $scheduleObject = New-Object -ComObject schedule.service
   $scheduleObject.connect()
   $rootFolder = $scheduleObject.GetFolder("\Microsoft\Windows\EnterpriseMgmt")
   $rootFolder.DeleteFolder($Enrollment,$null)
} 
$IntuneCert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object {
  $_.Issuer -match "Microsoft Device Management Device CA" 
 } | Remove-Item
} 
Start-Sleep -Seconds 5
$EnrollmentProcess = Start-Process -FilePath "C:\Windows\System32\DeviceEnroller.exe" -ArgumentList "/C /AutoenrollMDM" -NoNewWindow -Wait -PassThru

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM"
New-Item -Path $registryPath
 
$Name = "AutoEnrollMDM"
$Name2 = "UseAADCredentialType"
$value = "1"
 
New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $registryPath -Name $name2 -Value $value -PropertyType DWORD -Force | Out-Null
gpupdate /force
 
$key = 'SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\*'
$keyinfo = Get-Item "HKLM:\$key"
$url = $keyinfo.name
$url = $url.Split("\")[-1]
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$url"
 
New-ItemProperty -LiteralPath $path -Name 'MdmEnrollmentUrl' -Value 'https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath $path  -Name 'MdmTermsOfUseUrl' -Value 'https://portal.manage.microsoft.com/TermsofUse.aspx' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath $path -Name 'MdmComplianceUrl' -Value 'https://portal.manage.microsoft.com/?portalAction=Compliance' -PropertyType String -Force -ea SilentlyContinue;
 
C:\Windows\system32\deviceenroller.exe /c /AutoEnrollMDM