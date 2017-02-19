# Add_modules.ps1

# Addes modules into the Powershell's default location.

# Adds unziping functionality to the current session.
Add-Type -assembly "system.io.compression.filesystem"

#PSWindowsUpdate
# Where the file is stored.
$BackUpPath = "A:\PSWindowsUpdate.zip"

# Where it is being put.
$destination = "C:\Program Files\WindowsPowerShell\Modules"

# Unzips the file to the final location
[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)