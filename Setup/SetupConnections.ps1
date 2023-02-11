
function SetupConnections {
    [CmdletBinding()]
    param (
        [Parameter(
            HelpMessage = 'Set this value to $true if you want to create/recreate your EA'
            )]
        [Alias("CreateApp","Create")]
        [switch[]] $CreateApplication,
        
        [Parameter(
            HelpMessage = 'Set this value to $true if you want to update the access that your EA has'
            )]
        [Alias("UpdateApp", "UpdateAccess","Update")]
        [switch[]] $UpdateApplicationAccess
    )

    Connect-AzAccount
    $applicationDisplayName = "M365DSC_"+$env:COMPUTERNAME 
    $userSelectedAzureContexts = Get-AzContext -ListAvailable | Out-GridView -PassThru -Title "Select the Azure Tenants to configure" -ErrorAction Stop
    Foreach ($context in $userSelectedAzureContexts){
        Select-AzContext -InputObject $context 
        if($CreateApplication -eq $true){
            Get-AzADServicePrincipal -DisplayName $applicationDisplayName | Remove-AzADServicePrincipal
            Get-AzADApplication -DisplayName $applicationDisplayName | Remove-AzADApplication 
            $Script:applicationObject = New-AzADServicePrincipal -Displayname $applicationDisplayName
            $Script:applicationSecret = $applicationObject.PasswordCredentials.SecretText
            UpdateApplication
        }
        if($UpdateApplicationAccess -eq $true){ 
            UpdateApplication
        }
        else {
            $Script:applicationObject = Get-AzADApplication -DisplayName $applicationDisplayName
            $applicationObject | Remove-AzADAppCredential
            $Script:applicationSecret = $applicationObject | New-AzADAppCredential | ConvertFrom-Json | Select-Object 'secretText' -ExpandProperty 'secretText'
        }
        
        $applicationID = $applicationObject.AppId
        Get-AzADAppCredential -ApplicationId $applicationID
        $secret = ConvertTo-SecureString -String $applicationSecret -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $applicationID, $secret

        RetryCommand -ScriptBlock{Connect-AzAccount -Tenant $context.tenant.id -ServicePrincipal -Credential $Credential -ErrorAction Stop}
        Save-AzContext -Path .\Contexts\config.json -Force
    }


}

function UpdateApplication{
    $perms = Get-M365DSCCompiledPermissionList -ResourceNameList (Get-M365DSCAllResources) 
    ## needs to be array of hashtables. $perms.UpdatePermissions contains all explicit read access levels i.e. we only need to do UpdatePermissions if we want to read/write, not both.
    $permsArray=@()
    foreach ($i in $perms.Update.Permission.name){
        $param = @{
            Api='Graph'
            PermissionName=$i
        }
        $permsArray += $param
    }
    Update-M365DSCAzureAdApplication -ApplicationName $applicationDisplayName -Permissions $permsArray -AdminConsent -Type Secret
}


function RetryCommand {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        [scriptblock]$ScriptBlock,

        [Parameter(Position=1, Mandatory=$false)]
        [int]$Maximum = 5,

        [Parameter(Position=2, Mandatory=$false)]
        [int]$Delay = 10
    )

    Begin {
        $cnt = 0
    }

    Process {
        do {
            $cnt++
            try {
                $ScriptBlock.Invoke()
                return
            } catch {
                Write-Error $_.Exception.InnerException.Message -ErrorAction Continue
                Start-Sleep $Delay
            }
        } while ($cnt -lt $Maximum)

        throw 'Execution failed.'
    }
}


##
# Lazy Debug
##
<#
$applicationDisplayName = "M365DSC_"+$env:COMPUTERNAME 
$context = Get-AzContext -ListAvailable | Out-GridView -PassThru -Title "Select the Azure Tenants to configure" -ErrorAction Stop

Get-AzADServicePrincipal -DisplayName $applicationDisplayName | Remove-AzADServicePrincipal
Get-AzADApplication -DisplayName $applicationDisplayName | Remove-AzADApplication 
Clear-AzContext -PassThru -Force

SetupConnections -CreateApplication $true
SetupConnections
#>

