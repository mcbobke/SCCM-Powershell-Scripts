# Variable to make editing options simpler
$Shell = $Host.UI.RawUI

Set-Location C:
Import-Module MattBobkeCmdlets

$Shell.WindowTitle = "Godmode Activated!"

$WindowSize = $Shell.WindowSize
$WindowSize.Width = 150
$WindowSize.Height = 50
$Shell.WindowSize = $WindowSize

$BufferSize = $Shell.BufferSize
$BufferSize.Width = 150
$BufferSize.Height = 3000
$Shell.BufferSize = $BufferSize

function Test-Administrator {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    $IsAdmin = $principal.IsInRole($admin)
    return $IsAdmin
}

function prompt {
    # If running as administrator, set the following options
    if (Test-Administrator){
        Write-Host "(ADMINISTRATOR) " -NoNewline -ForegroundColor Red
    }

    Write-Host "$Env:USERNAME" -NoNewline -ForegroundColor Green
    Write-Host "@" -NoNewline -ForegroundColor DarkGray
    Write-Host "$Env:COMPUTERNAME" -NoNewline -ForegroundColor Magenta
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host "$(Get-Location)".Replace($Env:USERPROFILE, "~") -ForegroundColor Blue
    return ">" # The prompt function must return a string, or it will write the default prompt
}