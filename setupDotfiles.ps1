Write-Host "Setting up dotfiles..."

Write-Host "Copying .vimrc to $env:USERPROFILE"
Copy-Item -Path .vimrc -Destination "$($env:USERPROFILE)\.vimrc" -Force

Write-Host "Copying .gitconfig to $env:USERPROFILE"
Copy-Item -Path .gitconfig -Destination "$($env:USERPROFILE)\.gitconfig" -Force

Write-Host "Copying Terminal Config to $env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Copy-Item -Path .\terminal-settings.json -Destination "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force