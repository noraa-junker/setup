Write-Host "Setting up dotfiles..."

Write-Host "Copying .vimrc to $env:USERPROFILE"
Copy-Item -Path .vimrc -Destination "$($env:USERPROFILE)\.vimrc" -Force

Write-Host "Copying .gitconfig to $env:USERPROFILE"
Copy-Item -Path .gitconfig -Destination "$($env:USERPROFILE)\.gitconfig" -Force