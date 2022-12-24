##
# Static Variables
##

$sourceOrg = ''
$targetOrg = ''
$targetEaName = 'IntuneM365DSCtarget'
$targetTenantID = ''
$targetEASecret = ''

##
# Variables
##
$targetEA = Get-AzureADApplication -SearchString $targetEaName
$targetAppID = $targetEA.AppID
$targetEASecret = New-AzureADApplicationPasswordCredential -ObjectId $targetEA.ObjectId
#$targetEASecret = Get-AzureADApplicationKeyCredential -ObjectId $targetEA.ObjectId



$projectRoot = 'C:\git\M365AutomatedManagement'

$sourceBackupPath = $projectRoot+'\Outputs\Backups\'+$sourceOrg+'/*'
$applyConfigPath = $projectRoot+'\Outputs\ApplyConfigs\'+$sourceOrg+'_to_'+$targetOrg

###
# Create the MOF file using the source backup to apply to the target
###

# Copy the backup files over to applyConfig
mkdir $applyConfigPath
Copy-Item -Path $sourceBackupPath -Destination $applyConfigPath -Recurse


# Generate the MOF
$MofFile = Get-ChildItem -Path $applyConfigPath | Where-Object {$_.Name -cne "ConfigurationData.psd1"}

Set-Location $applyConfigPath
Powershell.exe -file .\$MofFile -ApplicationId $targetAppID -TenantId $targetTenantID -ApplicationSecret $targetEASecret

##
# Apply changes to target
##
$MofDirectory = Get-ChildItem -Directory | Select-Object Name -ExpandProperty Name

Enable-PSRemoting -Force
Start-DSCConfiguration -Path .\$MofDirectory -Wait -Verbose -Force # give it the path where the mof file exists

# dsc is now registered on your host, updates every 15 min by default. To disable
Stop-DSCConfiguration -Force
Remove-DSCConfigurationDocument -Stage Current