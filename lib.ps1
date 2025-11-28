# This file contains helper functions

function Test-Command {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string]$CommandName
    )

    return $null -ne (Get-Command $CommandName -ErrorAction Ignore)
}
