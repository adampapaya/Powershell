$NewComputerName = read-host 'Computer Name'
$DomainName = "niagarawater.com"
$Credentials = get-credential

Rename-Computer $NewComputerName -force
Add-Computer -Domain $DomainName -NewName $NewComputerName -Credential $Credentials -Restart -Force