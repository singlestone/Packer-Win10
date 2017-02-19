## Config_Winrm.ps1

## Configures WinRM to be compatiable to the packer processes.
set-NetConnectionProfile -NetworkCategory private

## winrm quickconfig -q ##
winrm quickconfig -q

## winrm quickconfig -transport:http ##
winrm quickconfig -transport:http



## Win RM MaxTimoutms ##
winrm set winrm/config '@{MaxTimeoutms="18000000"}'

## Win RM MaxMemoryPerShellMB ## 
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="80000"}'

## Win RM AllowUnencrypted ##
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

## Win RM auth Basic ##
winrm set winrm/config/service/auth '@{Basic="true"}'

## Win RM client auth Basic ##
winrm set winrm/config/client/auth '@{Basic="true"}'

## Win RM listener Address/Port ##
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'

## Win RM adv firewall enable ##
netsh advfirewall firewall set rule group="remote administration" new enable=yes 

## Win RM port open ## 
netsh firewall add portopening TCP 5985 "Port 5985" 

## Stop Win RM Service ## 
Stop-Service -Name "winrm" 

## Win RM Autostart ##
Set-Service –Name "winrm"–StartupType “Automatic”

## Start Win RM Service ##
Start-Service -Name "winrm"

Stop-Service -Name tiledatamodelsvc
Stop-Service -Name StateRepository
Get-AppxPackage "bingweather" -AllUsers | Remove-AppxPackage
Get-AppxPackage "zune" -AllUsers | Remove-AppxPackage
Get-AppxPackage "xbox" -AllUsers | Remove-AppxPackage

netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f