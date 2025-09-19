REM TCP/IP Reset

netsh winsock reset	
netsh int ip reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns
ipconfig /registerdns