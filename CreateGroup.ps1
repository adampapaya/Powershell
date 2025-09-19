Install-Module -Name Microsoft.Graph -RequiredVersion 2.15.0
Connect-MgGraph -scopes "user.readwrite.all, group.readwrite.all"
## New-MgGroup -DisplayName "Contoso_Sales" -Description "Contoso Sales team users" -MailEnabled:$false -Mailnickname "Contoso_Sales" -SecurityEnabled
Get-MgGroup