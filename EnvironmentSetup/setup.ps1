# Script variables
$currentUser = $Env:USERNAME

# Copy files
$ModuleParams = @{
    Path = "$PSScriptRoot\MattBobkeCmdlets.psm1";
    Destination = "$Env:ProgramFiles\WindowsPowershell\Modules\MattBobkeCmdlets";
    Force = $True;
}
Copy-Item @ModuleParams

$ProfileParams = @{
    Path = "$PSScriptRoot\profile.ps1";
    Destination = "$Variable:HOME\Documents\WindowsPowershell";
    Force = $True;
}
Copy-Item @ProfileParams

# Execute profile - will show errors if certain profiles don't exist
& $profile.CurrentUserAllHosts