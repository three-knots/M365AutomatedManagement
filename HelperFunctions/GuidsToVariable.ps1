. $PSScriptRoot\StripCharacters.ps1
function GuidsToVariable{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        $InputObject1,
        [Parameter(Position=1, Mandatory=$true)]
        $InputObject2,
        [Parameter(Position=2, Mandatory=$False)]
        $Value
        )

    $a = StripCharacters $InputObject1 '-'
    $b = StripCharacters $InputObject2 '-'


    if($Value){New-Variable -name $a$b -Scope Global -Value $Value -Force}
    else{New-Variable -name $a$b -Scope Global -Force}
}