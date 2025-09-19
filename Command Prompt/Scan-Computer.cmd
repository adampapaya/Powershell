@echo on

cmd

sfc /scannow

DISM /online /cleanup-image /checkhealth

DISM /online /cleanup-image /scanhealth

REM Use DISM /online /cleanup-image /restorehealth

REM Use sfc /scannow