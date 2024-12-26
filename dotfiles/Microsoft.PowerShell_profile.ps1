Import-Module kmt.winget.autocomplete
Set-Alias code code-insiders
function exitHost {
    exit
}
Set-Alias :q exitHost

function cdc {
    Set-Location C:/users/aaron
}

function cdk {
    Set-Location K:/
}

Set-PSReadLineKeyHandler -Chord "Tab" -Function MenuComplete
Set-PSReadLineOption -BellStyle None -PredictionViewStyle ListView -PredictionSource HistoryAndPlugin
function changeToDocuments { Set-Location -Path "S:\OneDrive - Aaron Junker Technologies\Dokumente\" }
Set-Alias cdd changeToDocuments

function changeToUser { Set-Location -Path "C:\users\aaron" }
Set-Alias cdu changeToUser
Set-Alias code code-insiders

function openMidnightCommander { & "mc.exe" K:\ C:\users\aaron\ }
Set-Alias mc openMidnightCommander

function exitFunction { exit }
Set-Alias ":q" exitFunction
Clear-Host