function prompt {
    $dir = (Get-Location).Path
    if ($dir.StartsWith($HOME)) {
        $dir = "~" + $dir.Substring($HOME.Length)
    }
    
    $time = (Get-Date).ToLongTimeString()

    $dirStr = $PSStyle.Foreground.BrightCyan + $dir + $PSStyle.Reset
    $timeStr = $PSStyle.Dim + "(" + $time + ")" + $PSStyle.Reset
    $promptStr = $PSStyle.BrightGreen + ">" + $PSStyle.Reset
    $promptStr = "$($PSStyle.Foreground.BrightGreen)$($PSStyle.Bold)❯$($PSStyle.Reset)"

    # Add a newline separator if it's not the first line in the terminal
    $newline = $Host.UI.RawUI.CursorPosition.Y -eq 0 ? "" : "`n"
    
    return "$newline$dirStr $timeStr`n$promptStr "
}
