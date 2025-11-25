function Get-CommandAvailable($commandName) {
    return $null -ne (Get-Command $commandName -ErrorAction Ignore)
}

if (Get-CommandAvailable eza) {
    Remove-Alias ls
    function ls { eza -a $args }
    function ll { eza -a -l $args }
}

if (Get-CommandAvailable bat) {
    Set-Alias cat bat
}
