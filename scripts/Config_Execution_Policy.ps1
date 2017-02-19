## Config_Execution_Policy.ps1

## Sets the execution police for Powershell to "RemoteSigned"

## Set Execution Policy 64 Bit ##
powershell -Command 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force'

## Set Execution Policy 32 Bit ##
"$env:windir\SysWOW64\cmd.exe /c powershell -Command 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force'"