## Install_PowerShellv5.ps1

# Installs Powershell v5, expects Packer to have uploaded the MSU file to C:\Windows\Temp\software\

Start-Process -FilePath C:\Windows\Temp\software\Win8.1AndW2K12R2-KB3134758-x64.msu -ArgumentList '/quiet /norestart' -wait