#  Install_Windows_Updates.ps1

# Installs Windows Updates, tested on a Windows 2012 R2 install base.
# Expects the PSWindowsUpdate Module to be available to work properly.
# PSWindowsUpdate can be downloaded from: https://www.powershellgallery.com/packages/PSWindowsUpdate/1.5.2.2

param($global:RestartRequired="FALSE",
      $global:MoreUpdates=0,
      $global:MaxCycles=99)

# Imports PSWindowsUpdate Module into the current session.
Import-Module PSWindowsUpdate
	  
# This function tells the script what to do when it has succesffuly completed.  
# In this case it's Invoking the Config_Winrm.ps1 script to complete the Packer build Process
function WrapUp {
    Invoke-Expression "a:\Config_Winrm -AutoStart"
     exit
}

# This function checks the state of the scripts processes, it will either:
# Continue installing updates
# Restart the computer and run itselfs again.
# End Successfully
function Check-ContinueRestartOrEnd() {
    $RegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $RegistryEntry = "InstallWindowsUpdates"
	$script:RestartRequired = Get-WURebootStatus -Silent
    switch ($script:RestartRequired) {
        FALSE {
            $prop = (Get-ItemProperty $RegistryKey).$RegistryEntry
            if ($prop) {
				# Removes the registry entry to rerun itself.
                Write-Host "Restart Registry Entry Exists - Removing It"
                Remove-ItemProperty -Path $RegistryKey -Name $RegistryEntry -ErrorAction SilentlyContinue
            }
			$ScriptName1 = split-path $MyInvocation.PSCommandPath
            Write-Host "No Restart Required"
			$CurrentUpdates = Get-WUInstall -ListOnly
            if (($CurrentUpdates.count -ne 0) -and ($script:Cycles -le $global:MaxCycles)) {
                Install-WindowsUpdates
            } elseif ($script:Cycles -gt $global:MaxCycles) {
                Write-Host "Exceeded Cycle Count - Stopping"
                WrapUp
            } else {
                Write-Host "Done Installing Windows Updates"
				WrapUp
            }
        }
        TRUE {
            $prop = (Get-ItemProperty $RegistryKey).$RegistryEntry
            if (-not $prop) {
                Write-Host "Restart Registry Entry Does Not Exist - Creating It"
				# This enters the registry entry that will cause the script to rerun itself after a reboot.
                Set-ItemProperty -Path $RegistryKey -Name $RegistryEntry -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File $($script:ScriptName)"
            } else {
                Write-Host "Restart Registry Entry Exists Already"
            }
			
            Write-Host "Restart Required - Restarting..."
            Restart-Computer
        }
        default {
            Write-Host "Unsure If A Restart Is Required..."
            exit
        }
    }
}

function Install-WindowsUpdates() {
    $script:Cycles++
    $script:i = 0;
	# The command that acually installs the Windows Updates, does not automatically reboots
	# The function Check-ContinueRestartOrEnd will handle this.
    $RegistryKey = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
    $RegistryEntry = "InstallWindowsUpdates"
	$script:RestartRequired = Get-WURebootStatus -Silent	
	Set-ItemProperty -Path $RegistryKey -Name $RegistryEntry -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File $($script:ScriptName)"
	Get-WUInstall -AcceptAll -IgnoreReboot
    Check-ContinueRestartOrEnd
}

$script:ScriptName = $MyInvocation.MyCommand.Path
# Sets the Cycles to 0, it is cycles it will end the script to prevent and infinite loop.
$script:Cycles = 0

# The main function of the script.
Check-ContinueRestartOrEnd