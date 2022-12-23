##
# Static Variables
##

$EaName = ''

##
# Create EA
##

# Create EA
$entapp = New-AzureADApplication -displayname $EaName

# Get AppID, TenantID
#$EA = Get-AzureADApplication -SearchString 'tempEA'

# Create Secret
## IMPORTANT! Copy this value down to use in IntuneConfigPull.ps1, that script currently uses the same variable name 
$EASecret = New-AzureADApplicationPasswordCredential -objectid $entapp.ObjectId #
    # ToDo: Write secret to vault/where ever

## Get required perms for Ent App.
#$perms = Get-M365DSCCompiledPermissionList -Source 'Graph' -PermissionsType 'Application' -ResourceNameList @("IntuneAntivirusPolicyWindows10SettingCatalog", "IntuneAppConfigurationPolicy", "IntuneApplicationControlPolicyWindows10", "IntuneAppProtectionPolicyAndroid", "IntuneAppProtectionPolicyiOS", "IntuneASRRulesPolicyWindows10", "IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager", "IntuneDeviceAndAppManagementAssignmentFilter", "IntuneDeviceCategory", "IntuneDeviceCompliancePolicyAndroid", "IntuneDeviceCompliancePolicyAndroidDeviceOwner", "IntuneDeviceCompliancePolicyAndroidWorkProfile", "IntuneDeviceCompliancePolicyiOs", "IntuneDeviceCompliancePolicyMacOS", "IntuneDeviceCompliancePolicyWindows10", "IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator", "IntuneDeviceConfigurationPolicyAndroidDeviceOwner", "IntuneDeviceConfigurationPolicyAndroidOpenSourceProject", "IntuneDeviceConfigurationPolicyAndroidWorkProfile", "IntuneDeviceConfigurationPolicyiOS", "IntuneDeviceConfigurationPolicyMacOS", "IntuneDeviceConfigurationPolicyWindows10", "IntuneDeviceEnrollmentLimitRestriction", "IntuneDeviceEnrollmentPlatformRestriction", "IntuneExploitProtectionPolicyWindows10SettingCatalog", "IntuneSettingCatalogASRRulesPolicyWindows10", "IntuneWiFiConfigurationPolicyAndroidDeviceAdministrator", "IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner", "IntuneWifiConfigurationPolicyAndroidEntrepriseWorkProfile", "IntuneWifiConfigurationPolicyAndroidForWork", "IntuneWifiConfigurationPolicyAndroidOpenSourceProject", "IntuneWifiConfigurationPolicyIOS", "IntuneWifiConfigurationPolicyMacOS", "IntuneWifiConfigurationPolicyWindows10")
##use this one for now until we can scope things down correctly
$perms = Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources) 

## build the perms, needs to be array of hashtables. $perms.UpdatePermissions contains all explicit read access levels i.e. we only need to do UpdatePermissions if we want to read/write, not both.
$permsArray=@()
foreach ($i in $perms.Update.Permission.name){
    $param = @{
        Api='Graph'
        PermissionName=$i
    }
    $permsArray += $param
}



## update the perms. Might take a few minutes (or more) for the admin consent to register.
Update-M365DSCAzureAdApplication -ApplicationName $entapp.DisplayName -Permissions $permsArray -AdminConsent -Type Secret 
    # ToDo: Should write a test case to validate app settings applied and consents granted. Wrap in do until then out to intuneconfigpull.ps1
