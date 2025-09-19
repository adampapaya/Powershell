# Define paths and filenames
$teamsBootstrapper = "C:\teamsbootstrapper.exe"
$msixFile = "C:\MSTeams-x64.msix"

# Copy files to C:\ directory
Copy-Item -Path $teamsBootstrapper -Destination "C:\" -Force
Copy-Item -Path $msixFile -Destination "C:\" -Force

# Start Command Prompt as Administrator
Start-Process cmd -ArgumentList "/c cd C:\ && .\teamsbootstrapper.exe -p -o `"C:\MSTeams-x64.msix`"" -Verb RunAs
