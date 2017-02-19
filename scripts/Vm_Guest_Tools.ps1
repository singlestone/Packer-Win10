## Vm_Guest_Tools.ps1

## There needs to be Oracle CA (Certificate Authority) certificates installed in order
## to prevent user intervention popups which will undermine a silent installation.

write-host "$env:PACKER_BUILDER_TYPE"

#$env:PACKER_BUILDER_TYPE = "vmware-iso"

function virtualbox_guest_install{
	## Installs the oracle certificate to allow for a silent install of the guest additions.
	certutil -addstore -f "TrustedPublisher" A:\oracle-cert.cer

	## Runs the silent install of VirtualBox installs guest additions.
	Start-Process -FilePath "E:\VBoxWindowsAdditions.exe" -ArgumentList "/S" -wait

	exit
}

function vmware_guest_install{
	## Copies the windows.iso file to a working directory.
	Move-Item -path C:\Users\vagrant\windows.iso -destination C:\Windows\Temp
	
	## Unpacks the ISO file to give access to the install binary.
	Start-Process -FilePath "C:\Windows\Temp\software\7-Zip\7z.exe" -ArgumentList "x C:\Windows\Temp\windows.iso -oC:\Windows\Temp\VMWare" -wait

	## Runs the silent install of VMware installs guest additions.
	Start-Process -FilePath "C:\Windows\Temp\VMWare\setup64.exe" -ArgumentList '/S /v "/qn REBOOT=R"' -wait

	exit
}

if($env:PACKER_BUILDER_TYPE -eq "virtualbox-iso") {virtualbox_guest_install}

if($env:PACKER_BUILDER_TYPE -eq "vmware-iso") {vmware_guest_install}


