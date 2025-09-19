DelProf v 2.01 by Diego Plaza

Use instructions:

1. Copy this whole folder to your desktop or anywhere you'd like to run this script.
2. Open ComputerNames.txt and input the name of the computer on the network for which you'd like to delete all the users.
3. Right Click on DelProf2.ps1 script and run with powershell.
4. Wait a little bit, it should start working after a couple minutes if there's a lot of users
5. ???
6. Profit

It may show some errors but it will be deleting profiles.  This will delete profile folders and registry.  It will not delete the user's profile of whoever is logged into it.  

Please don't use it for assigned computers as this WILL delete the user's profile.  It is only able to ignore the basic things like the local admin accounts, the niagara account, and the PDQInventory account.

Once the script finished scripting, if there are any more profiles left on the computer, run the script again and see if it deletes the profiles.  Otherwise, double click the EnablePSRemoting.bat file and then run the DelProf2.ps1 script again.