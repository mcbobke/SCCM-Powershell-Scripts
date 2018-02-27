# Import the necessary module and CD to the CMS PSDrive
Import-Module ConfigurationManager
cd CMS:

Write-Output "Imported ConfigurationManager module and CD'ed to CMS."

# Grab all non-deployed/0 dependent TS/0 dependent DT applications, and all packages (can't filter packages like applications)
$AllRelevantApplications = Get-CMApplication | where {($_.IsDeployed -eq $False) `
                                                        -and ($_.NumberofDependentTS -eq 0) `
                                                        -and ($_.NumberofDependentDTs -eq 0)}
$AllPackages = Get-CMPackage

Write-Output "Grabbed relevant applications and all packages."

# Grab all task sequences, filter to just a list of their references
$TSReferences = Get-CMTaskSequence | select -ExpandProperty References

Write-Output "Grabbed all task sequences and filtered for their references."

# Grab all deployments, filter to just a list of their package IDs
$DeploymentPackageIDs = Get-CMDeployment | select -ExpandProperty PackageID

Write-Output "Grabbed all deployments and filtered for their PackageIDs."

# Create PS array for final collection
$FinalPackages = @()

# The next line turns this PS array into a .NET collection
$FinalPackages = {$FinalPackages}.Invoke()

Write-Output "Converted to .NET collection."

<# NO LONGER NECESSARY DUE TO FILTERING DONE ABOVE
# Filter applications to only those that do not have their PackageID or CI_UniqueID in the list of references
foreach ($app in $AllRelevantApplications)
{
    if (($app.PackageID -notin $TSReferences) -or ($app.CI_UniqueID -notin $TSReferences))
    {
        $FinalApps.Add($app)
    } 
}
#>

# Filter packages to only those that do not have their PackageID in the list of references
foreach ($package in $AllPackages)
{
    if (($package.PackageID -notin $TSReferences) -and ($package.PackageID -notin $DeploymentPackageIDs))
    {
        $FinalPackages.Add($package)
    } 
}

Write-Output "Filtered packages through references and deployment PackageIDs."

# Final output to CSV
$AllRelevantApplications | select LocalizedDisplayName,PackageID,DateCreated,DateLastModified,IsDeployable,IsEnabled,IsExpired,IsHidden,IsSuperseded | sort -Property LocalizedDisplayName | Export-Csv -Path C:\temp\SCCM_Apps.csv
$FinalPackages | select Name,PackageID,SourceDate,LastRefreshTime | sort -Property Name | Export-Csv -Path C:\temp\SCCM_Packages.csv

Write-Output "Output done."