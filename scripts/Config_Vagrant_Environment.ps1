## Config_Vagrant_Environment.ps1

## Adds Confiuration settigns for the Vagrant Example.

## Show file extensions in Explorer ##
"$env:windir\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v HideFileExt /t REG_DWORD /d 0 /f"
 

## Enable QuickEdit mode ##
"$env:windir\System32\reg.exe ADD HKCU\Console /v QuickEdit /t REG_DWORD /d 1 /f"


## Show Run command in Start Menu ##
"$env:windir\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v Start_ShowRun /t REG_DWORD /d 1 /f"


## Show Administrative Tools in Start Menu ##
"$env:windir\System32\reg.exe ADD HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ /v StartMenuAdminTools /t REG_DWORD /d 1 /f"


## Zero Hibernation File ##
"$env:windir\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateFileSizePercent /t REG_DWORD /d 0 /f"


## Disable Hibernation Mode ##
"$env:windir\System32\reg.exe ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\ /v HibernateEnabled /t REG_DWORD /d 0 /f"


## Disable password expiration for vagrant user ## 
wmic useraccount where "name='vagrant'" set PasswordExpires=FALSE


## Disable password expiration for vagrant user ##				
"$env:windir\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\Install_Windows_Updates.ps1 -AutoStart"
