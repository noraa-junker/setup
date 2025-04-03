Import-Module kmt.winget.autocomplete

Set-Alias code code-insiders
Set-Alias ":q" exitFunction

Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete
Set-PSReadLineOption -BellStyle None -PredictionViewStyle ListView -PredictionSource HistoryAndPlugin

function cdc {
    Set-Location "$($env:USERPROFILE)"
}

function cdk {
    Set-Location K:/
}

function cdr {
    $downloadsPath = (New-Object -ComObject Shell.Application).Namespace('shell:Downloads').Self.Path
    Set-Location $downloadsPath
}

function cdd {
    $documentsPath = (New-Object -ComObject Shell.Application).Namespace('shell:Personal').Self.Path
    Set-Location -Path $documentsPath
}

function openMidnightCommander { & "mc.exe" K:\ C:\users\aaron\ }
Set-Alias mc openMidnightCommander

function exitFunction { exit }
Clear-Host