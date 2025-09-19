#Disable IPv6

Disable-NetAdapterBinding "*" -ComponentID 'ms_tcpip6'
Get-NetAdapterBinding | Where-Object ComponentID -EQ 'ms_tcpip6'
cmd /c 'pause'