$tempFolder = $env:TEMP
if (Test-Path "$tempFolder\CascadiaCode") {
    Remove-Item "$tempFolder\CascadiaCode" -Force -Recurse -Confirm:$false
}
$localAppDataFolder = $env:localAppData
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Invoke-WebRequest "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip" -OutFile "$tempfolder\CascadiaCode.zip"
Expand-Archive -Path "$tempfolder\CascadiaCode.zip" -DestinationPath "$tempfolder\CascadiaCode"
$location = Get-Location
Set-Location "$tempfolder\CascadiaCode"
foreach ($file in Get-ChildItem *.ttf) {
    $fileName = $file.Name
    if (-not (Test-Path -Path "$localAppDataFolder\Microsoft\Windows\Fonts\$fileName")) {
        Write-Output $fileName
        Get-Item $file | ForEach-Object { $fonts.CopyHere($_.FullName) }
    }
}
Set-Location $location
