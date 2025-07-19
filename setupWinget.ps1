$isWinGetRecent = (winget -v).Trim('v').TrimEnd("-preview").split('.')

if (!(([int]$isWinGetRecent[0] -gt 1) -or ([int]$isWinGetRecent[0] -ge 1 -and [int]$isWinGetRecent[1] -ge 6))) { # WinGet is greater than v1 or v1.6 or higher
   $paths = "Microsoft.VCLibs.x64.14.00.Desktop.appx", "Microsoft.UI.Xaml.2.8.x64.appx", "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
   $uris = "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx", "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx", "https://aka.ms/getwinget"
   Write-Host "Downloading WinGet and its dependencies..." -ForegroundColor red -BackgroundColor white

   for ($i = 0; $i -lt $uris.Length; $i++) {
      $filePath = $paths[$i]
      $fileUri = $uris[$i]
      Write-Host "Downloading: ($filePat) from $fileUri" -ForegroundColor red -BackgroundColor white
      Invoke-WebRequest -Uri $fileUri -OutFile $filePath
   }

   Write-Host "Installing WinGet and its dependencies..."
   
   foreach ($filePath in $paths) {
      Write-Host "Installing: ($filePath)" -ForegroundColor red -BackgroundColor white
      Add-AppxPackage $filePath
   }

   Write-Host "Verifying Version number of WinGet"
   winget -v

   Write-Host "Cleaning up"
   foreach ($filePath in $paths) {
      if (Test-Path $filePath) {
         Write-Host "Deleting: ($filePath)" -ForegroundColor red -BackgroundColor white
         Remove-Item $filePath -verbose
      } 
      else {
         Write-Error "Path doesn't exits: ($filePath)"
      }
   }
}
else {
   write-Host "WinGet in decent state, moving to executing DSC" -ForegroundColor red -BackgroundColor white
}
