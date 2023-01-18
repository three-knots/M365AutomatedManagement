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
            Position = 1
            )]
        [string[]] $tenantID
    )

    foreach ($ID in $tenantID) {
        write-host "connecting to tenant ID: $ID"
        Connect-AzAccount -Tenant $ID -ErrorAction Break
    }
    Save-AzContext -Path ./Contexts/config.json
    Get-AzContext -ListAvailable
    
}



