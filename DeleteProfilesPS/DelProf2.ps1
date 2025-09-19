$AccountsToKeep = @('Administrator', 'Admin', 'Public', 'Default', 'niagara', 'niagarawater.com\PDQInventory')

# Determine the script's directory using the automatic variable $PSScriptRoot
$scriptPath = $PSScriptRoot

# Create the full file path using Join-Path
$filePath = Join-Path $scriptPath "ComputerNames.txt"

# Read the content of the text file and store computer names in an array
$computers = Get-Content -Path $filePath

# Count the total number of computers
$totalComputers = $computers.Count
$currentComputer = 1

# Loop through each computer and delete profiles
foreach ($computer in $computers) {
    # Get the list of user profiles on the remote computer
    $profiles = Invoke-Command -ComputerName $computer -ScriptBlock {
        Get-CimInstance -ClassName Win32_UserProfile | Where-Object { (!$_.Special) -and ($_.LocalPath.split('\')[-1] -notin $using:AccountsToKeep) }
    }

    # Count the number of profiles to delete
    $totalProfiles = $profiles.Count
    $currentProfile = 1

    foreach ($profile in $profiles) {
        # Delete the profile
        Invoke-Command -ComputerName $computer -ScriptBlock {
            param($profile)
            Remove-CimInstance -InputObject $profile
        } -ArgumentList $profile

        # Display progress
        $progressMessage = "Deleting profile $currentProfile of $totalProfiles on $computer"
        Write-Progress -Activity "Deleting User Profiles" -Status $progressMessage -PercentComplete (($currentComputer - 1) / $totalComputers * 100)
        $currentProfile++
    }

    # Update progress for the next computer
    $currentComputer++
}

# Completed progress
Write-Progress -Activity "Deleting User Profiles" -Status "Profile deletion completed" -Completed
