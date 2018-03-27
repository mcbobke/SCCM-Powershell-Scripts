Param(
    [Switch]$InstallSSH
)

# Copy files
$ModuleParams = @{
    Path = "$PSScriptRoot\MattBobkeCmdlets.psm1";
    Destination = "$Env:ProgramFiles\WindowsPowershell\Modules\MattBobkeCmdlets";
    Force = $True;
}
if (!(Test-Path $ModuleParams.Destination)) {
    New-Item -Path "$Env:ProgramFiles\WindowsPowershell\Modules" -ItemType Directory -Name MattBobkeCmdlets
}
Copy-Item @ModuleParams

$ProfileParams = @{
    Path = "$PSScriptRoot\profile.ps1";
    Destination = $profile.AllUsersAllHosts;
    Force = $True;
}
Copy-Item @ProfileParams

if ($InstallSSH)
{
    & "$PSScriptRoot\Install-WinOpenSSH.ps1"
}

# Execute profile - will show errors if certain profiles don't exist
& $profile.AllUsersAllHosts