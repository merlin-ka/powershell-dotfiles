# powershell-dotfiles

My personal PowerShell `$PROFILE`.

## Setup

```ps1
git clone https://github.com/merlin-ka/powershell-dotfiles.git $HOME\.powershell
cd $HOME\.powershell
.\setup.ps1
```

## Features

- Custom colored prompt
  - Display the current time
  - Replaces the user directory (`$HOME`) with `~`
- Replaces some built-in commands and aliases with alternatives
  - `bat` replaces `cat`
  - `eza` replaces `ls`
    - `ls` = `eza -a`
    - `ll` = `eza -a -l`
  - Alternative programs can be installed automatically via `scoop`
