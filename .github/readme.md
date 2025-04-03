# Aaron Junkers Setup Scripts

> [!WARNING]
> This is not meant to work for everyone or to meet anyone's needs. Rather this repo can be used as a starting point and as an inspiration for your own needs.

Based on [Clint Rutkas setup scripts](https://github.com/crutkas/setup)

## Todo 
- [ ] Move office registry keys to DSC
- [ ] Allow office insider installs
- [ ] Add remove certain preinstalled apps to DSC
- [ ] Find out argument for Enter-DevShell
- [ ] Sync vscode settings
- [ ] Move uninstall terminal and install terminal preview to DSC

 
## What to do if no winget is installed (ex. Sandbox)
```
Install-Script -Name winget-install -RequiredVersion 2.1.0
.\setupWinget.ps1
```