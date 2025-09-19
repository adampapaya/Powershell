$DomainName = Read-Host "Domain name:"

$ComputerName = Read-Host "Computer name:"

$UserName = Read-Host "User name:"

$AdminGroup = [ADSI]"WinNT://$ComputerName/Administrators,group"

$User = [ADSI]"WinNT://$DomainName/$UserName,user"

$AdminGroup.Add($User.Path)