function BuildAZContexts {
<#
.SYNOPSIS
    Use this cmdlet to build out your Azure contexts to simplify administration of multiple tenants
 
 
.NOTES
    Name: BuildAZContexts
    Author: Taifur@Three-knots.com
    Version: 1.0
    DateCreated: 2022-Dec
 
 
.EXAMPLE
    BuildAZContexts -TenantIDs 123123-wsdf123-sdf, 123fsd-fsd1234-fsdf
    BuildAZContexts 123123-wsdf123-sdf, 123fsd-fsd1234-fsdf
 
.LINK
    https://github.com/three-knots/M365AutomatedManagement/
#>    
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter one or more tenant IDs separated by commas"
            )]
        [string[]] $tenantIDs,

        [Parameter(
            Mandatory = $true
            )]
        [ValidateSet("EA","Credential")]
        [string[]] $AuthType
    )

    foreach ($ID in $tenantIDs) {
        write-host "connecting to tenant ID: $ID"
        if ($AuthType -eq "EA"){
            read-host -Prompt "Enter the EA name for tenant ID $ID"
            read-host -Prompt "Enter the EA password" -maskinput
            $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecuredPassword
            Connect-AzAccount -Tenant $ID -ServicePrincipal -Credential $Credential  -ErrorAction Stop
        }
        Connect-AzAccount -Tenant $ID -ErrorAction Stop
    }
    Save-AzContext -Path ./Contexts/config.json
    Get-AzContext -ListAvailable
    
}

    

