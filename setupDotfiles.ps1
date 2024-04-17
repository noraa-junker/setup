Write-Host "Setting up dotfiles..."

Write-Host "Copying .vimrc to $env:USERPROFILE"
Copy-Item -Path .vimrc -Destination "$($env:USERPROFILE)\.vimrc" -Force