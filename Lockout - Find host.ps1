#Requires -Version 2.0
Function Get-LockedOutLocation
{
    [CmdletBinding()]

    Param(
      [Parameter(Mandatory=$True)]
      [String]$Identity      
    )

    Begin
    { 
        $DCCounter = 0 
        $LockedOutStats = @()   
                
        Try
        {
            Import-Module ActiveDirectory -ErrorAction Stop
        }
        Catch
        {
           Write-Warning $_
           Break
        }
    }#end begin
    Process
    {
        # Get DomainController
        $DomainController = Get-ADDomainController -Identity "PHI-DC2"
        # Iterate through DC2
        Foreach ($DC in @($DomainController)) {
        Write-Progress -Activity "Contacting DCs for lockout info" -Status "Querying $($DC.Hostname)" -PercentComplete (($DCCounter / 1) * 100)
        Try {
        $UserInfo = Get-ADUser -Identity $Identity -Server $DC.Hostname -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut -ErrorAction Stop
        }
        Catch {
        Write-Warning $_
        Continue
        }
    # Rest of the code remains the same
}
        {
            $DCCounter++
            Write-Progress -Activity "Contacting DCs for lockout info" -Status "Querying $($DC.Hostname)" -PercentComplete (($DCCounter/$DomainController.Count) * 100)
            Try
            {
                $UserInfo = Get-ADUser -Identity $Identity  -Server $DC.Hostname -Properties AccountLockoutTime,LastBadPasswordAttempt,BadPwdCount,LockedOut -ErrorAction Stop
            }
            Catch
            {
                Write-Warning $_
                Continue
            }
            If($UserInfo.LastBadPasswordAttempt)
            {    
                $LockedOutStats += New-Object -TypeName PSObject -Property @{
                        Name                   = $UserInfo.SamAccountName
                        SID                    = $UserInfo.SID.Value
                        LockedOut              = $UserInfo.LockedOut
                        BadPwdCount            = $UserInfo.BadPwdCount
                        BadPasswordTime        = $UserInfo.BadPasswordTime            
                        DomainController       = $DC.Hostname
                        AccountLockoutTime     = $UserInfo.AccountLockoutTime
                        LastBadPasswordAttempt = ($UserInfo.LastBadPasswordAttempt).ToLocalTime()
                    }          
            }#end if
        }#end foreach DCs
        $LockedOutStats | Format-Table -Property Name,LockedOut,DomainController,BadPwdCount,AccountLockoutTime,LastBadPasswordAttempt -AutoSize

        #Get User Info
        Try
        {  
           Write-Verbose "Querying event log on PHI-DC2"
           $LockedOutEvents = Get-WinEvent -ComputerName PHI-DC2 -FilterHashtable @{LogName='Security';Id=4740} -ErrorAction Stop | Sort-Object -Property TimeCreated -Descending
        }
        Catch 
        {          
           Write-Warning $_
           Continue
        }#end catch     
                                 
        Foreach($Event in $LockedOutEvents)
        {            
           If($Event | Where {$_.Properties[2].value -match $UserInfo.SID.Value})
           { 
              
              $Event | Select-Object -Property @(
                @{Label = 'User';               Expression = {$_.Properties[0].Value}}
                @{Label = 'DomainController';   Expression = {$_.MachineName}}
                @{Label = 'EventId';            Expression = {$_.Id}}
                @{Label = 'LockedOutTimeStamp'; Expression = {$_.TimeCreated}}
                @{Label = 'Message';            Expression = {$_.Message -split "`r" | Select -First 1}}
                @{Label = 'LockedOutLocation';  Expression = {$_.Properties[1].Value}}
              )
                                                
            }#end ifevent
            
       }#end foreach lockedout event
       
    }#end process
   
}#end function

###START ###
Clear-Host

## GET USERNAME ##
Do {$username = Read-Host 'Please enter the Username of the Locked Out Account'

  ## VALIDATE USERNAME ##
    $validate = Get-Aduser -LDAPFilter "(SamAccountName=$username)"
    if ($validate -eq $null) {
      Write-Host 'Invalid Username'
      }
    } #end of 'Do'
until ($validate -ne $null)

## GET LOCKED OUT INFORMATION ##
Get-LockedOutLocation -Identity $username

### FINISH ###
