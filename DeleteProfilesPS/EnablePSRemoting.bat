@echo off
setlocal enabledelayedexpansion

REM Set the path to the PsExec executable
set "psexec_path=.\PsExec.exe"

REM Check if ComputerNames.txt exists
if not exist ComputerNames.txt (
    echo Error: computers.txt file not found.
    pause
    exit /b 1
)

REM Enable PowerShell remoting on each computer in ComputerNames.txt
for /f "delims=" %%a in (ComputerNames.txt) do (
    echo Enabling PowerShell remoting on %%a...
    %psexec_path% \\%%a powershell.exe -Command "Enable-PSRemoting -Force"
)

echo All computers have been configured for PowerShell remoting.
pause
exit /b 0