Enable-PSRemoting -Force 

$ComputerName = "PC-NAME", "PC2-Name" # Replace with the actual remote computer name
$UserName = "DOMAIN\UserName" # Replace with the user's domain and username (e.g., "CONTOSO\JohnDoe") or "LocalUserName" for a local user.

Invoke-Command -ComputerName $ComputerName -ScriptBlock {
    Param($UserToAdd)
    Add-LocalGroupMember -Group "Administrators" -Member $UserToAdd
} -ArgumentList $UserName