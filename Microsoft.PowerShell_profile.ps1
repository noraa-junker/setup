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


Set-PSReadLineKeyHandler -Chord "Tab" -Function AcceptSuggestion
Set-PSReadLineOption -BellStyle None -PredictionViewStyle ListView -PredictionSource HistoryAndPlugin
Clear-Host