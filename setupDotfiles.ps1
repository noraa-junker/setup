function MakeLink{
    param(
        [string]$link,
        [string]$target
    )
    if (Test-Path $target) {
        Remove-Item $target -Force
    }
    New-Item -Path $target -ItemType HardLink -Value $link
}

Write-Host "Copying .vimrc to $env:USERPROFILE"
MakeLink -target "$($env:USERPROFILE)\.vimrc" -link ".\dotfiles\.vimrc"

Write-Host "Copying .gitconfig to $env:USERPROFILE"
MakeLink -target "$($env:USERPROFILE)\.gitconfig" -link ".\dotfiles\.gitconfig"

Write-Host "Copying Terminal Config to $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState"
MakeLink -target "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json" -link ".\dotfiles\terminal-settings.json"

$documents = [Environment]::GetFolderPath("MyDocuments")

Write-Host "PowerShell profile setup"
MakeLink -target "$($documents)\PowerShell\Microsoft.PowerShell_profile.ps1" -link ".\dotfiles\Microsoft.PowerShell_profile.ps1"

Write-Host "Setting up winget settings"
MakeLink -target "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -link ".\dotfiles\winget-settings.json"

Write-Host "Set up config for legacy Windows PowerShell"
MakeLink -target "$($env:USERPROFILE)\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -link ".\dotfiles\Microsoft.WindowsPowerShell_profile.ps1"