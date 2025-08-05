function MakeLink {
    param(
        [string]$link,
        [string]$target
    )
    if (Test-Path $target) {
        Remove-Item $target -Force | Out-Null
    }
    $Drive1 = Get-DriveLetter -path $link
    $Drive2 = Get-DriveLetter -path $target
    if ($Drive1 -eq $Drive2) {
	New-Item -Path $target -ItemType HardLink -Value $link | Out-Null
    } else {
	Copy-Item $link -destination $target
    }
}

function Get-DriveLetter {
    param([string]$path)
    return ($path -split ':')[0].ToUpper()
}

Write-Host "Copying .vimrc to $env:USERPROFILE and to nvim config"
MakeLink -target "$($env:USERPROFILE)\.vimrc" -link ".\dotfiles\.vimrc"
if (-Not (Test-Path "$($env:APPDATA)\..\local\nvim")) {
    New-Item "$($env:APPDATA)\..\local" -Name "nvim" -ItemType "Directory"
}
MakeLink -target "$($env:APPDATA)\..\local\nvim\init.vim" -link ".\dotfiles\.vimrc"

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
MakeLink -target "$($documents)\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -link ".\dotfiles\Microsoft.WindowsPowerShell_profile.ps1"

Write-Host "Setting up automatic network drive mapping"
MakeLink -target "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\MapNetworkDrives.cmd" -link ".\dotfiles\MapNetworkDrives.cmd"
