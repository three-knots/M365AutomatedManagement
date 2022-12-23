##
# Static Variables
##

# These values are created in CreateEA.ps1, if you're running that first you can comment these variables out
$EASecret = ''
$EaName = ''
$tenantID = ''

# Used when naming the directories and files
$org = 'TargetTenant'

# Makes sure you're in the correct directory when writing files. This is an absolute path while testing, we'll modify to use the var for project root
$projectRoot = 'C:\git\M365AutomatedManagement'

##
# Variables
##

# Used to uniquely name the backups with a timestamp
$today = get-date -Format yyyy-MM-dd_HH-mm-ss

# Get AppID, TenantID
$EA = Get-AzureADApplication -SearchString $EaName

$appID = $EA.AppID
#$EASecret = $EASecret.value #If you're running CreateEa.ps1 first, you can uncomment this line instead of setting the static var above
$exportFileName = $org+'_'+$today+".ps1" 
$exportPath = '.\Outputs\Backups\'+$org

###
# Create backup of the tenant
###

# Ensure you're in the correct directory
Set-Location $projectRoot

# Export the settings using the enterprise app
Export-M365DSCConfiguration -ApplicationId $appID -TenantId $tenantID -ApplicationSecret $EASecret -Path $exportPath -FileName $exportFileName -Components @("IntuneDeviceCompliancePolicyWindows10") 
    # full list of intune components: -Components @("IntuneAntivirusPolicyWindows10SettingCatalog", "IntuneAppConfigurationPolicy", "IntuneApplicationControlPolicyWindows10", "IntuneAppProtectionPolicyAndroid", "IntuneAppProtectionPolicyiOS", "IntuneASRRulesPolicyWindows10", "IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager", "IntuneDeviceAndAppManagementAssignmentFilter", "IntuneDeviceCategory", "IntuneDeviceCompliancePolicyAndroid", "IntuneDeviceCompliancePolicyAndroidDeviceOwner", "IntuneDeviceCompliancePolicyAndroidWorkProfile", "IntuneDeviceCompliancePolicyiOs", "IntuneDeviceCompliancePolicyMacOS", "IntuneDeviceCompliancePolicyWindows10", "IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator", "IntuneDeviceConfigurationPolicyAndroidDeviceOwner", "IntuneDeviceConfigurationPolicyAndroidOpenSourceProject", "IntuneDeviceConfigurationPolicyAndroidWorkProfile", "IntuneDeviceConfigurationPolicyiOS", "IntuneDeviceConfigurationPolicyMacOS", "IntuneDeviceConfigurationPolicyWindows10", "IntuneDeviceEnrollmentLimitRestriction", "IntuneDeviceEnrollmentPlatformRestriction", "IntuneExploitProtectionPolicyWindows10SettingCatalog", "IntuneSettingCatalogASRRulesPolicyWindows10", "IntuneWiFiConfigurationPolicyAndroidDeviceAdministrator", "IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner", "IntuneWifiConfigurationPolicyAndroidEntrepriseWorkProfile", "IntuneWifiConfigurationPolicyAndroidForWork", "IntuneWifiConfigurationPolicyAndroidOpenSourceProject", "IntuneWifiConfigurationPolicyIOS", "IntuneWifiConfigurationPolicyMacOS", "IntuneWifiConfigurationPolicyWindows10")
#-Workloads @("Intune")
