Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -scopes "user.readwrite.all, group.readwrite.all"

$PWProfile = @{
    Password = "Pa55w.rd";
    ForceChangePasswordNextSignIn = $false
}

New-MgUser `
    -DisplayName "Cody Godinez" `
    -GivenName "Cody" -Surname "Godinez" `
    -MailNickname "cgodinez" `
    -UsageLocation "US" `
    -UserPrincipalName "cgodinez@yourtenant.onmicrosoft.com" `
    -PasswordProfile $PWProfile -AccountEnabled `
    -Department "Sales" -JobTitle "Sales Rep"

Get-MgUser