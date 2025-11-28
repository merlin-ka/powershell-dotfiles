function Test-Command($commandName) {
    return $null -ne (Get-Command $commandName -ErrorAction Ignore)
}

if (Test-Command eza) {
    Remove-Alias ls
    function ls { eza -a $args }
    function ll { eza -a -l $args }
}

if (Test-Command bat) {
    Set-Alias cat bat
}
