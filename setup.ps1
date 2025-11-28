. $PSScriptRoot\..\lib.ps1

function Read-Confirmation($prompt) {
    while ($true) {
        Write-Host "$prompt $($PSStyle.Dim)[y/n]$($PSStyle.Reset) " -NoNewline
        $choice = Read-Host
        
        switch ($choice) {
            "y" { return $true }
            "n" { return $false }
        }
        
        Write-Host "Invalid input." -ForegroundColor Red
    }
}

function Install-Scoop {
    # From https://github.com/ScoopInstaller/Scoop#installation
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

function Test-ScoopInstalled {
    if (!(Test-Command scoop)) {
        Write-Host "scoop package manager not found." -ForegroundColor Yellow
        Write-Host "scoop is used to install optional programs like 'bat' as an alternative for 'cat'." -ForegroundColor Yellow
        
        if (Read-Confirmation "Install scoop?") {
            Install-Scoop
        }
        else {
            return $false
        }
    }

    return $true
}

function Install-ScoopPackages {
    if (!(Test-ScoopInstalled)) {
        return
    }
    
    $programs = "eza", "bat", "less", "fzf", "fd"
    $missingPrograms = [System.Collections.Generic.List[string]]::new()

    foreach ($p in $programs) {
        if (!(isCommandAvailable $p)) {
            $missingPrograms.Add($p)
        }
    }

    if ($missingPrograms.Count -ne 0) {
        Write-Host "The following optional programs are not installed:" ($missingPrograms -join ", ") -ForegroundColor Yellow
        $install = Read-Confirmation "Install with scoop?"

        if ($install) {
            scoop install $missingPrograms
        }
    }
}

function Register-ConfigInProfile {
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

function Test-PowerShellVersion {
    $ver = $PSVersionTable.PSVersion.Major * 100 + $PSVersionTable.PSVersion.Minor
    if ($ver -lt 702) {
        $verStr = $PSVersionTable.PSVersion.ToString()
        Write-Host "Error: Minimum supported PowerShell version is 7.2 (current version: $verStr)" -ForegroundColor Red
        Write-Host "Run 'winget install --id Microsoft.PowerShell' to install the latest version."
        exit 1
    }
}

Test-PowerShellVersion
Install-ScoopPackages
Register-ConfigInProfile
Write-Host "Setup successful. Restart your terminal or run '. `$PROFILE' to use new config." -ForegroundColor Green
