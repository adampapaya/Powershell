Function Get-LockedOutLocation {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]$identity      
    )

    Begin { 
        $lockedOutStats = @()
        $counter = 0   
                
        Try {
            Import-Module ActiveDirectory -ErrorAction Stop
        } Catch {
            Write-Warning $_
            Break
        }

        # Get all valid domain controllers
        $validDomainControllers = (Get-ADDomainController -Filter *).HostName

        # Convert to array for indexing
        $validDomainControllersArray = @($validDomainControllers)
        $validDomainControllersArray += "Search all DCs"
    }

    Process {
        Write-Host "Available Domain Controllers:"
        for ($i=0; $i -lt $validDomainControllersArray.Count; $i++) {
            Write-Host "$($i+1): $($validDomainControllersArray[$i])"
        }
        
        do {
            $dcChoice = Read-Host "Enter the number of the Domain Controller to search"
            if ($dcChoice -match '^\d+$' -and $dcChoice -le $validDomainControllersArray.Count) {
                $dcSearchPrompt = $validDomainControllersArray[$dcChoice - 1]
                if ($dcSearchPrompt -eq "Search all DCs") {
                    # Get all domain controllers
                    $domainController = Get-ADDomainController -Filter *
                    break
                } else {
                    $domainController = Get-ADDomainController -Identity $dcSearchPrompt -ErrorAction Stop
                    break
                }
            } else {
                Write-Host "Invalid choice. Please select a valid number from the list."
            }
        } while ($true)

        # Retrieve user information
        $userInfo = Get-ADUser -Identity $identity -Properties LastBadPasswordAttempt, LockedOut, SamAccountName, SID, BadPwdCount, BadPasswordTime, AccountLockoutTime, LastLogonDate -Server $domainController.HostName -ErrorAction Stop

        If($userInfo.LastBadPasswordAttempt) {    
            $lockedOutStats = New-Object -TypeName PSObject -Property @{
                    name = $userInfo.SamAccountName
                    sid = $userInfo.SID.Value
                    lockedOut = $userInfo.LockedOut
                    badPwdCount = $userInfo.BadPwdCount
                    badPasswordTime = $userInfo.BadPasswordTime            
                    domainController = $domainController.Hostname
                    accountLockoutTime = $userInfo.AccountLockoutTime
                    lastBadPasswordAttempt = ($userInfo.LastBadPasswordAttempt).ToLocalTime()
                    lastLogonDate = $userInfo.LastLogonDate
            }       
            $counter = 0     
            $lockedOutStats | Format-Table -Property @{Label = "Number"; Expression = {$counter++; $counter}},name,lockedOut,domainController,badPwdCount,accountLockoutTime,lastBadPasswordAttempt,lastLogonDate -AutoSize
            do {
                $userChoice = Read-Host "Enter the number of the user you want to unlock, or type 'exit' to exit"
                if ($userChoice -eq 'exit') { break }
                if ($userChoice -match '^\d+$' -and $userChoice -le ($counter + 1)) {
                    $selectedUser = $lockedOutStats[$userChoice - 1].name
                    Unlock-ADAccount -Identity $selectedUser
                    Write-Host "$selectedUser has been unlocked"
                } else {
                    Write-Host "Invalid selection. Please enter a valid number from the list or type 'exit'"
                }
            } while ($true)
        } else {
            Write-Host "No locked out users found."
        }
    }
}

Clear-Host

do {
    $userName = Read-Host 'Please enter the Username of the Locked Out Account'
    $validate = Get-Aduser -LDAPFilter "(SamAccountName=$userName)"
    if ($null -eq $validate) {
        Write-Host 'Invalid Username'
    }
} until ($null -ne $validate)

Get-LockedOutLocation -Identity $userName
