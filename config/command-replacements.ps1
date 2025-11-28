. $PSScriptRoot\..\lib.ps1

if (Test-Command eza) {
    Remove-Alias ls
    function ls { eza -a $args }
    function ll { eza -a -l $args }
}

if (Test-Command bat) {
    Set-Alias cat bat
}
