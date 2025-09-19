# Disable IPv6 for all network adapters in Windows 11

# Get all network adapters that have IPv6 enabled
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq "Up" }

foreach ($adapter in $adapters) {
    # Disable IPv6 on each adapter
    Write-Output "Disabling IPv6 for adapter: $($adapter.Name)"
    Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6 -Confirm:$false
}

Write-Output "IPv6 has been disabled for all active network adapters."