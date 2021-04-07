# =============================================================================
#
# PowerShell Profile
#

# =============================================================================
#
# Set emacs-like key bindings
#
Set-PSReadLineOption -EditMode Emacs

# =============================================================================
#
# Set colors
#

Set-PSReadlineOption -Colors @{
    "Operator"="White"
    "Parameter"="White"
    "InlinePrediction"="White"
}

# =============================================================================
#
# Set Aliases
#

# use lsd as ls
if (Get-Command lsd 2>$null) {
    Set-Alias ls lsd
}

# git status
function gstatus() {
    git status -s -b $args
}

# use nvim as vim
Set-Alias vim nvim

# =============================================================================
#
# Set Key Bindings
#

# go to upper dir by Ctrl-y
Set-PSReadLineKeyHandler -Key Ctrl+y `
                         -BriefDescription "UpDir" `
                         -LongDescription "Go to upper directory" `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cd ../')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}


# =============================================================================
#
# Utility functions for zoxide.
#

# set fzf default opts by env var
$env:FZF_DEFAULT_OPTS = "--layout=reverse"

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd {
    $(Get-Location).Path
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd($dir) {
    Set-Location $dir -ea Stop
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook {
    zoxide add $(__zoxide_pwd)
}

# Initialize hook.
if (($PSVersionTable.PSVersion.Major -ge 6) -and (Get-Command zoxide 2>$null)) {
    $ExecutionContext.InvokeCommand.LocationChangedAction = {
        $null = __zoxide_hook
    }
} else {
    Write-Error "`
zoxide: PWD hooks are not supported below PowerShell 6.
        Use '--hook prompt' when initializing zoxide."
}

# =============================================================================
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired.
#

# Jump to a directory using only keywords.
function __zoxide_z {
    if ($args.Length -eq 0) {
        __zoxide_cd ~
    }
    elseif ($args.Length -eq 1 -and $args[0] -eq '-') {
        __zoxide_cd -
    }
    elseif ($args.Length -eq 1 -and ( Test-Path $args[0] -PathType Container) ) {
        __zoxide_cd $args[0]
    }
    else {
        $__zoxide_result = zoxide query -- @args
        if ($LASTEXITCODE -eq 0) {
            __zoxide_cd $__zoxide_result
        }
    }
}

# Jump to a directory using interactive search.
function __zoxide_zi {
    $__zoxide_result = zoxide query -i -- @args
    if ($LASTEXITCODE -eq 0) {
        __zoxide_cd $__zoxide_result
    }
}

# Add a new entry to the database.
function __zoxide_za {
    zoxide add @args
}

# Query an entry from the database using only keywords.
function __zoxide_zq {
    zoxide query @args
}

# Query an entry from the database using interactive selection.
function __zoxide_zqi {
    zoxide query -i @args
}

# Remove an entry from the database using the exact path.
function __zoxide_zr {
    zoxide remove @args
}

# Remove an entry from the database using interactive selection.
function __zoxide_zri {
    zoxide remove -i @args
}

# =============================================================================
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#

Set-Alias z __zoxide_zi
Set-Alias j __zoxide_zi

Set-PSReadLineKeyHandler -Key Ctrl+j `
                         -BriefDescription 'JumpDirectory' `
                         -LongDescription 'Jump to the selected directory by zoxide' `
                         -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('__zoxide_zi')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# =============================================================================
#
# Set starship prompt (need to be at end)
#

if (Get-Command starship 2>$null) {
    Invoke-Expression (&starship init powershell)
}

# vim: set et shiftwidth=4:
