param(
   [Parameter(Mandatory = $true)]
   [bool]$installPersonalTools
)

$additionalArgs = "-installPersonalTools $" + $installPersonalTools
Write-Output "Args for script: $Args $additionalArgs"

# forcing WinGet to be installed
$isWinGetRecent = (winget -v).Trim('v').TrimEnd("-preview").split('.')

# turning off progress bar to make invoke WebRequest fast
$ProgressPreference = 'SilentlyContinue'

if (!(($isWinGetRecent[0] -gt 1) -or ($isWinGetRecent[0] -ge 1 -and $isWinGetRecent[1] -ge 6))) { # WinGet is greater than v1 or v1.6 or higher
   $paths = "Microsoft.VCLibs.x64.14.00.Desktop.appx", "Microsoft.UI.Xaml.2.8.x64.appx", "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
   $uris = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx", "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx", "https://aka.ms/getwinget"
   Write-Host "Downloading WinGet and its dependencies..."

   for ($i = 0; $i -lt $uris.Length; $i++) {
      $filePath = $paths[$i]
      $fileUri = $uris[$i]
      Write-Host "Downloading: ($filePat) from $fileUri"
      Invoke-WebRequest -Uri $fileUri -OutFile $filePath
   }

   Write-Host "Installing WinGet and its dependencies..."
   
   foreach ($filePath in $paths) {
      Write-Host "Installing: ($filePath)"
      Add-AppxPackage $filePath
   }

   Write-Host "Verifying Version number of WinGet"
   winget -v

   Write-Host "Cleaning up"
   foreach ($filePath in $paths) {
      if (Test-Path $filePath) {
         Write-Host "Deleting: ($filePath)"
         Remove-Item $filePath -verbose
      } 
      else {
         Write-Error "Path doesn't exits: ($filePath)"
      }
   }
}
else {
   write-Host "WinGet in decent state, moving to executing DSC"
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (!$isAdmin) {
   Write-Host "Run this script as Admin to install all the tools"
   exit
}

$dscPowerToys = "./configurationFiles/aaronjunker.PowerToys.dsc.yml";
$dscPersonalTools = "./configurationFiles/aaronjunker.personalTools.dsc.yml";
$dscDev = "./configurationFiles/crutkas.dev.dsc.yml";
$dscOffice = "./configurationFiles/crutkas.office.dsc.yml";

// Uninstall Terminal and install Preview
Write-Host "Uninstalling Terminal and installing Terminal Preview"
winget uninstall Microsoft.WindowsTerminal --force
winget install Microsoft.WindowsTerminal.Preview --source winget

Write-Host "Setting up dotfiles..."
./setupDotfiles.ps1

Write-Host "Install nerd fonts"
./installFont.ps1

if ($installPersonalTools) {
   Write-Host "Installing Office"
   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\' -Name 'DefaultProfile' -Value "OutlookAuto" -PropertyType String -Force

   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\OutlookAuto' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\OutlookAuto' -Name 'Default' -Value "" -PropertyType String -Force

   New-Item -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover' -Force
   New-ItemProperty -Path 'HKCU:\Software\Microsoft\Office\16.0\Outlook\AutoDiscover' -Name 'ZeroConfigExchange' -Value "1" -PropertyType DWORD -Force

   gpupdate /force

   winget configuration -f $dscOffice 

   Write-Host "Installing personal tools"
   winget configuration -f $dscPersonalTools
}

# Staring dev workload
Write-Host ""
winget configuration -f $dscDev 

Write-Host "Start: PowerToys dsc install"
git clone https://github.com/microsoft/PowerToys.git --depth 1 -b main --single-branch
winget configuration -f ./powertoys/.configurations/configuration.vsEnterprise.dsc.yaml
Remove-Item -Path ./powertoys -Recurse -Force

Write-Host "Configure Visual Studio"
&"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\common7\ide\devenv.exe" /ResetSettings .\CurrentSettings.vssettings

Write-Host "Configure PowerShell"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name PSReadLine -acceptlicense -force"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name CompletionPredictor -acceptlicense -force"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name Az -acceptlicense -force"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name Azuread -acceptlicense -force"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name Azureadpreview -acceptlicense -force"
Start-Process PWSH -wait -Verb RunAs -ArgumentList "-Command", "Install-Module -Name Pnp.powershell -acceptlicense -force"
Update-Help

Write-Host "Configure PowerToys"
winget configuration -f $dscPowerToys

# clean up, Clean up, everyone wants to clean up
Write-Host "Done: Dev flows install"
# ending dev workload