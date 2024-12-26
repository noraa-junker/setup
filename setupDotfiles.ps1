Write-Host "Copying .vimrc to $env:USERPROFILE"
Copy-Item -Path .\dotfiles\.vimrc -Destination "$($env:USERPROFILE)\.vimrc" -Force

Write-Host "Copying .gitconfig to $env:USERPROFILE"
Copy-Item -Path .\dotfiles\.gitconfig -Destination "$($env:USERPROFILE)\.gitconfig" -Force

Write-Host "Copying Terminal Config to $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState"
Copy-Item -Path .\dotfiles\terminal-settings.json -Destination "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" -Force

$documents = [Environment]::GetFolderPath("MyDocuments")

Write-Host "PowerShell profile setup"
Copy-Item -Path .\dotfiles\Microsoft.PowerShell_profile.ps1 -Destination "$($documents)\PowerShell\Microsoft.PowerShell_profile.ps1" -Force

Write-Host "Setting up winget settings"
Copy-Item -Path .\dotfiles\winget-settings.json -Destination "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Force

Write-Host "Set up config for legacy Windows PowerShell"
Copy-Item -Path .\dotfiles\Microsoft.WindowsPowerShell_profile.ps1 -Destination "$($env:USERPROFILE)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Force