param(
   [switch]$installPersonalTools
)

if ((get-location).Drive.Name -ne "c:/") {
   Write-Host "Run this script only from the C:/ drive so that the hardlinks can be created" -ForegroundColor red -BackgroundColor white
   exit
}

$additionalArgs = "-installPersonalTools $" + $installPersonalTools
Write-Host "Args for script: $Args $additionalArgs" -ForegroundColor red -BackgroundColor white

# turning off progress bar to make invoke WebRequest fast
$ProgressPreference = 'SilentlyContinue'

# Turning off all confirmation prompts
$ConfirmPreference = 'None'

# forcing WinGet to be installed
./setupWinget.ps1

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
   Write-Host "Run this script as Admin to install all the tools" -ForegroundColor red -BackgroundColor white
   exit
}

$dscPowerToys = "./configurationFiles/aaronjunker.PowerToys.dsc.yml";
$dscPersonalTools = "./configurationFiles/aaronjunker.personalTools.dsc.yml";
$dscDev = "./configurationFiles/aaronjunker.dev.dsc.yml";
$dscOffice = "./configurationFiles/aaronjunker.office.dsc.yml";
$dscEnvironment = "./configurationFiles/aaronjunker.envVars.dsc.yml";

# Uninstall Terminal and install Preview
Write-Host "Uninstalling Terminal and installing Terminal Preview..." -ForegroundColor red -BackgroundColor white
winget uninstall Microsoft.WindowsTerminal --force
winget install Microsoft.WindowsTerminal.Preview --source winget

winget install Microsoft.PowerShell

Write-Host "Installing nerd fonts..." -ForegroundColor red -BackgroundColor white
./setupFonts.ps1

if ($installPersonalTools) {
   Write-Host "Installing Office..." -ForegroundColor red -BackgroundColor white
   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\' -Name 'DefaultProfile' -Value "OutlookAuto" -PropertyType String -Force

   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\OutlookAuto' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\OutlookAuto' -Name 'Default' -Value "" -PropertyType String -Force

   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover' -Name 'ZeroConfigExchange' -Value "1" -PropertyType DWORD -Force

   gpupdate /force

   winget configuration -f $dscOffice --disable-interactivity --suppress-initial-details --accept-configuration-agreements

   Write-Host "Installing personal tools.." -ForegroundColor red -BackgroundColor white
   winget configuration -f $dscPersonalTools --disable-interactivity --suppress-initial-details --accept-configuration-agreements
}

# Staring dev workload
Write-Host "Setup dev environment..." -ForegroundColor red -BackgroundColor white
winget configuration -f $dscDev 

Write-Host "Setting up and installing Visual Studio..." -ForegroundColor red -BackgroundColor white
git clone https://github.com/microsoft/PowerToys.git --depth 1 -b main --single-branch
winget configuration -f ./powertoys/.configurations/configuration.vsEnterprise.dsc.yaml --disable-interactivity --suppress-initial-details --accept-configuration-agreements
Remove-Item -Path ./powertoys -Recurse -Force

Write-Host "Configuring Visual Studio..." -ForegroundColor red -BackgroundColor white
&"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\common7\ide\devenv.exe" /ResetSettings .\dotfiles\CurrentSettings.vssettings

Write-Host "Configuring PowerShell..." -ForegroundColor red -BackgroundColor white
$modules = @(
   "PSReadLine",
   "CompletionPredictor",
   "Az",
   "Azuread",
   "Azureadpreview",
   "Pnp.powershell",
   "kmt.winget.autocomplete",
   "git-completion"
)

foreach ($module in $modules) {
   Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name $module -acceptlicense -force"
}

Write-Host "Updating help..."
Update-Help -Confirm
tart-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Update-Help -Confirm"

Write-Host "Configuring PowerToys..." -ForegroundColor red -BackgroundColor white
winget configuration -f $dscPowerToys --disable-interactivity --suppress-initial-details --accept-configuration-agreements

Write-Host "Configuring Environment..." -ForegroundColor red -BackgroundColor white
winget configuration -f $dscEnvironment --disable-interactivity --suppress-initial-details --accept-configuration-agreements

Write-Host "Removing unneeded installed system components"
Get-AppxPackage "*.mixed*" | Remove-AppxPackage
Get-AppxPackage "*xboxgamingoverlay*" | Remove-AppxPackage
Get-AppxPackage "*compatibil*" | remove-appxpackage

Write-Host "Configuring GameBar so it won't pop up on a game start"

reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v "GameDVR_Enabled" /d 0

Write-Host "Setting up dotfiles..." -ForegroundColor red -BackgroundColor white
./setupDotfiles.ps1

Write-Host "Done!" -ForegroundColor Green -BackgroundColor white