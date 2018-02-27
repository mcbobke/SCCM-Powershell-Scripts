Any files in this folder that have the ".psm1" extension are Powershell Modules that can be imported when the Powershell window is opened.
When you are asked to run a command, the entire command is contained between two curly brackets {} - don't type the outer curly brackets. Any quotations are part of the command.

To see the list of available cmdlets in a module, run {Get-Command -Module MODULE_NAME}. To see how a cmdlet works, run {Help CMDLET_NAME -full}.

To import a module on a one-time basis:
Open a Powershell console at the folder that the module file is located. Run {Import-Module .\MODULE_FILE_NAME}.

To import a module easily from any directory (for a single user):
Drop the module file into C:\Users\username\Documents\WindowsPowershell\Modules (if the folder doesn't exist, create it).
Preferably, into a folder and not into the root Modules directory itself.

To import a module easily from any directory (for all machine users):
Drop the module file into %ProgramFiles%\WindowsPowershell\Modules (module available to all users of the system).
Preferably, into a folder and not into the root Modules directory itself.

To import a module automatically whenever a Powershell console is opened (for all machine users, after following immediately above step):
1. Open Powershell console as admin.
2. Check to see if a user Powershell profile exists: run {Test-Path $profile.AllUsersAllHosts}. If false, run {New-Item -Path $profile.AllUsersAllHosts -Type File –Force}.
3. Ensure that running {Test-Path $profile.AllUsersAllHosts} prints True to the console.
4. Any time you want to add a new module to this auto-import list, run {Add-Content -Path $profile.AllUsersAllHosts -Value "Import-Module MODULE_NAME"} as an admin.
5. Any time you want to remove a module from being auto-imported, run the following:

    {Select-String -path $profile.AllUsersAllHosts -pattern "Import-Module MODULE_NAME" -NotMatch | Out-File $profile.AllUsersAllHosts}