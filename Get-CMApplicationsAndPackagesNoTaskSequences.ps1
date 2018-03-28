# Import the necessary module and CD to the CMS PSDrive
Import-Module ConfigurationManager
Set-Location CMS:

Write-Output "Imported ConfigurationManager module and CD'ed to CMS."

# Grab all non-deployed/0 dependent TS/0 dependent DT applications, and all packages (can't filter packages like applications)
$FinalApplications = Get-CMApplication `
    | Where-Object {($_.IsDeployed -eq $False) -and ($_.NumberofDependentTS -eq 0) -and ($_.NumberofDependentDTs -eq 0)}
$AllPackages = Get-CMPackage

Write-Output "Grabbed relevant applications and all packages."

# Grab all task sequences, filter to just a list of their references
$TSReferences = Get-CMTaskSequence | Select-Object -ExpandProperty References

Write-Output "Grabbed all task sequences and filtered for their references."

# Grab all deployments, filter to just a list of their package IDs
$DeploymentPackageIDs = Get-CMDeployment | Select-Object -ExpandProperty PackageID

Write-Output "Grabbed all deployments and filtered for their PackageIDs."

# Create PS array for final collection
$FinalPackages = @()

# The next line turns this PS array into a .NET collection
$FinalPackages = {$FinalPackages}.Invoke()

Write-Output "Converted to .NET collection."

# Filter packages to only those that do not have their PackageID in the list of references
foreach ($package in $AllPackages) {
    if (($package.PackageID -notin $TSReferences) -and ($package.PackageID -notin $DeploymentPackageIDs)) {
        $FinalPackages.Add($package)
    } 
}

Write-Output "Filtered packages through references and deployment PackageIDs."

# Final output to CSV
$FinalApplications `
    | Select-Object -Property LocalizedDisplayName, PackageID, DateCreated, DateLastModified, IsDeployable, IsEnabled, IsExpired, IsHidden, IsSuperseded `
    | Sort-Object -Property LocalizedDisplayName `
    | Export-Csv -Path "C:\temp\SCCM_Apps.csv"

$FinalPackages `
    | Select-Object Name, PackageID, SourceDate, LastRefreshTime `
    | Sort-Object -Property Name `
    | Export-Csv -Path "C:\temp\SCCM_Packages.csv"

Write-Output "Output done and stored in C:\temp."