$tempFolder = $env:TEMP
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Invoke-WebRequest "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip" -OutFile "$tempfolder\CascadiaCode.zip"
Expand-Archive -Path "$tempfolder\CascadiaCode.zip" -DestinationPath "$tempfolder\CascadiaCode"
$location = Get-Location
Set-Location "$tempfolder\CascadiaCode"
foreach ($file in Get-ChildItem *.ttf) {
    $fileName = $file.Name
    if (-not (Test-Path -Path "C:\Windows\fonts\$fileName")) {
        echo $fileName
        Get-Item $file | ForEach-Object { $fonts.CopyHere($_.FullName) }
    }
}
Set-Location $location