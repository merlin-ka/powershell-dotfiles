. $PSScriptRoot\..\lib.ps1

# Find directory ("change directory find")
if (Test-Command fzf) {
    function cdf { Set-Location $(fzf --walker dir) }
}
