. $PSScriptRoot\..\HelperFunctions\CredentialVariableLookup.ps1

function PullConfigs {
     [CmdletBinding()]
     Param(
         [Parameter(Position=0, Mandatory=$false)]
         $InputObject
     )

     $context = Get-AzContext -ListAvailable | Out-GridView -PassThru -Title "Select the EA used to connect, NOT your user acount"
     Set-AzContext -Context $context
     
     $fileTimeStamp = get-date -Format yyyy-MM-dd_HH-mm-ss
     $exportFileName = $fileTimeStamp+".ps1" 
     $backupsPath = "$PSScriptRoot\..\Outputs\Backups\"
     $orgName = $context.tenant.id
     $exportPath = $backupsPath+$orgName
     $credential = CredentialVariableLookUp $context

     If(!(test-path -PathType container $exportPath)){
     New-Item -ItemType Directory -Path $exportPath
     }
     Export-M365DSCConfiguration -Path $exportPath -FileName $exportFileName -ApplicationId $context.Account.Id -TenantId $context.Tenant.Id -ApplicationSecret $credential -ErrorAction Stop -Workloads INTUNE
 }
     
# https://export.microsoft365dsc.com/

