param(
    [String]$AllDevicesCollectionID
)

# Import necessary modules
Import-Module ActiveDirectory
Import-Module ConfigurationManager

# Get all Active Directory computer names
Write-Host "Getting all Active Directory computer names..."
Set-Location AD:
$AllADComputerObjects = Get-ADComputer -Filter * -ResultSetSize 15000 -Properties Name
$AllADComputers = $AllADComputerObjects | Select-Object -ExpandProperty Name
# Set -SearchBase to search in specific OUs
# Set -Filter to search for specific property values

# Get all SCCM device names
Write-Host "Getting all SCCM computer names..."
Set-Location CMS:
$AllCMComputers = Get-CMDevice -CollectionId $AllDevicesCollectionID | Select-Object -ExpandProperty Name

# Create .NET collection in preparation for filtering
$AllMissingComputers = @()
$AllMissingComputers = {$AllMissingComputers}.Invoke()

foreach ($name in $AllCMComputers)
{
    if ($name -notin $AllADComputers)
    {
        $AllMissingComputers.Add($name)
    }
}

$AllMissingComputers