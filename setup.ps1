function confirm($prompt) {
    while ($true) {
        $Host.UI.Write($prompt + " $($PSStyle.Dim)[y/n]$($PSStyle.Reset) ")
        $choice = $Host.UI.ReadLine()
        
        switch ($choice) {
            "y" { return $true }
            "n" { return $false }
        }
        
        Write-Host "Invalid input." -ForegroundColor Red
    }
}

function isCommandAvailable($commandName) {
    return $null -ne (Get-Command $commandName -ErrorAction Ignore)
}

function installScoop {
    # From https://github.com/ScoopInstaller/Scoop#installation
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

function checkScoopInstalled {
    if (!(isCommandAvailable scoop)) {
        Write-Host "scoop package manager not found." -ForegroundColor Yellow
        Write-Host "scoop is used to install optional programs like 'bat' as an alternative for 'cat'." -ForegroundColor Yellow
        
        if (confirm "Install scoop?") {
            Write-Host "Installing scoop"
        }
        else {
            return $false
        }
    }

    return $true
}

function installScoopPackages {
    if (!(checkScoopInstalled)) {
        return
    }
    
    $programs = "eza", "bat", "less"
    $missingPrograms = [System.Collections.Generic.List[string]]::new()

    foreach ($p in $programs) {
        if (!(isCommandAvailable $p)) {
            $missingPrograms.Add($p)
        }
    }

    if ($missingPrograms.Count -ne 0) {
        Write-Host "The following optional programs are not installed:" ($missingPrograms -join ", ") -ForegroundColor Yellow
        $install = confirm "Install with scoop?"

        if ($install) {
            scoop install $missingPrograms
        }
    }
}

function addToProfile {
    $sourceLine = '. $HOME\.powershell\profile.ps1'

    if (Test-Path $PROFILE) {
        if (Select-String -Path $PROFILE -Pattern $sourceLine -SimpleMatch -Quiet) {
            Write-Host '$PROFILE already configured.'
            return
        }

        # Add a newline separator if $PROFILE exists already
        Add-Content -Path $PROFILE -Value "`n"
    }

    Add-Content -Path $PROFILE -Value $sourceLine
    Write-Host "Added to $PROFILE"
}

function checkPowerShellVersion {
    $ver = $PSVersionTable.PSVersion.Major * 100 + $PSVersionTable.PSVersion.Minor
    if ($ver -lt 702) {
        $verStr = $PSVersionTable.PSVersion.ToString()
        Write-Host "Error: Minimum supported PowerShell version is 7.2 (current version: $verStr)" -ForegroundColor Red
        Write-Host "Run 'winget install --id Microsoft.PowerShell' to install the latest version."
        exit 1
    }
}

checkPowerShellVersion
installScoopPackages
addToProfile
Write-Host "Setup successful. Restart your terminal or run '. `$PROFILE' to use new config." -ForegroundColor Green
