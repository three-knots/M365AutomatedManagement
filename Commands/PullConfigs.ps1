. $PSScriptRoot\..\HelperFunctions\CredentialVariableLookup.ps1

function PullConfig {
     [CmdletBinding()]
     Param(
         [Parameter(Position=0, Mandatory=$false)]
         $InputObject
     )

     $context = Get-AzContext -ListAvailable | Out-GridView -PassThru -Title "Select the EA used to connect, NOT your user acount"
     Set-AzContext -Context $context
     
     $fileTimeStamp = get-date -Format yyyy-MM-dd_HH-mm-ss
     $exportFileName = $fileTimeStamp+".ps1" 
     $exportPath = "$PSScriptRoot\..\Outputs\Backups\"
     $credential = CredentialVariableLookUp $context

     Export-M365DSCConfiguration -Path $exportPath -FileName $exportFileName -ApplicationId $context.Account.Id -TenantId $context.Tenant.Id -ApplicationSecret $credential -Components @("IntuneAntivirusPolicyWindows10SettingCatalog","IntuneAppConfigurationPolicy","IntuneApplicationControlPolicyWindows10","IntuneAppProtectionPolicyAndroid","IntuneAppProtectionPolicyiOS","IntuneASRRulesPolicyWindows10","IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager","IntuneDeviceAndAppManagementAssignmentFilter","IntuneDeviceCategory","IntuneDeviceCompliancePolicyAndroid","IntuneDeviceCompliancePolicyAndroidDeviceOwner","IntuneDeviceCompliancePolicyAndroidWorkProfile","IntuneDeviceCompliancePolicyiOs","IntuneDeviceCompliancePolicyMacOS","IntuneDeviceCompliancePolicyWindows10","IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator","IntuneDeviceConfigurationPolicyAndroidDeviceOwner","IntuneDeviceConfigurationPolicyAndroidOpenSourceProject","IntuneDeviceConfigurationPolicyAndroidWorkProfile","IntuneDeviceConfigurationPolicyiOS","IntuneDeviceConfigurationPolicyMacOS","IntuneDeviceConfigurationPolicyWindows10","IntuneDeviceEnrollmentLimitRestriction","IntuneDeviceEnrollmentPlatformRestriction","IntuneExploitProtectionPolicyWindows10SettingCatalog","IntuneRoleAssignment","IntuneRoleDefinition","IntuneSettingCatalogASRRulesPolicyWindows10","IntuneWiFiConfigurationPolicyAndroidDeviceAdministrator","IntuneWifiConfigurationPolicyAndroidEntrepriseDeviceOwner","IntuneWifiConfigurationPolicyAndroidEntrepriseWorkProfile","IntuneWifiConfigurationPolicyAndroidForWork","IntuneWifiConfigurationPolicyAndroidOpenSourceProject","IntuneWifiConfigurationPolicyIOS","IntuneWifiConfigurationPolicyMacOS","IntuneWifiConfigurationPolicyWindows10") -ErrorAction Stop 
     
 }
     
# https://export.microsoft365dsc.com/

