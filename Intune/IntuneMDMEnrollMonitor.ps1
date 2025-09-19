Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Define the event log and event IDs for MDM auto-enrollment events
$logName = "Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin"
$eventIDs = @(4, 6, 8, 11, 52, 59, 71, 72, 75, 76, 90, 91)  # Event IDs for MDM Auto-Enroll Success and another relevant event

# Function to monitor the event log for specific event IDs for 30 minutes
function Monitor-MDMEnrollment {
    Write-Host "Monitoring MDM Auto-Enroll Events for 30 minutes..."

    $startTime = Get-Date
    $endTime = $startTime.AddMinutes(30)

    try {
        # Start monitoring the event log for 30 minutes
        while ((Get-Date) -lt $endTime) {
            $events = Get-WinEvent -LogName $logName -MaxEvents 5 | Where-Object { $eventIDs -contains $_.Id }

            if ($events) {
                foreach ($event in $events) {
                    Write-Host "MDM Auto-Enroll Event Detected:"
                    Write-Host "Event ID: $($event.Id)"
                    Write-Host "Time Created: $($event.TimeCreated)"
                    Write-Host "Message: $($event.Message)"
                    Write-Host "-------------------------------------"
                }
            }

            # Wait for 30 seconds before checking again
            Start-Sleep -Seconds 30
        }

        Write-Host "Monitoring completed. 30 minutes have passed."
    }
    catch {
        Write-Host "An error occurred while monitoring MDM Auto-Enroll events."
        Write-Host "Reason: $($_.Exception.Message)"
        Write-Host "Please check the event log configuration or script permissions."
    }
}

# Start monitoring
Monitor-MDMEnrollment
