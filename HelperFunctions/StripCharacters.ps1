function StripCharacters{
    [CmdletBinding()]
    Param(
        [Parameter(Position=0, Mandatory=$true)]
        $inputObject,
        [Parameter(Position=1, Mandatory=$true)]
        $Character
        )

    $inputObject -replace "[$Character]",""

}