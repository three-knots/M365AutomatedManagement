. $PSScriptRoot\StripCharacters.ps1

function CredentialVariableLookUp {
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        $InputObject
    )
    $tenantid = StripCharacters $context.Tenant.Id "-"
    $appid = StripCharacters $context.Account.Id "-"
    return Get-Variable -name $tenantid$appid -ValueOnly
}
