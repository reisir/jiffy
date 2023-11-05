# Skin information
$SkinName = "Jiffy"
$ROOTCONFIG = $SkinName
$editVariablesFile = "#@#variables.inc"

# Script settings

# Output file
$out = "@Resources\ContextMenu.inc"

# Are you using a language file? 
# If true, context menu titles will use __language variables 
$useLanguage = $False

# Common context menu items

$spacer = @{
    Title  = '-'
    Action = ''
}

$current = @{
    Title  = '#CURRENTCONFIG#'
    Action = '["#CURRENTPATH#"]'
}

$editVariables = @{ 
    Title  = if ($useLanguage) { '#__EditVariables#' } else { 'Edit variables' }
    Action = "[`"#CONFIGEDITOR#`" `"$editVariablesFile`"]"
}

$refreshGroup = @{
    Title  = if ($useLanguage) { '#__RefreshGroup#' } else { "Refresh $SkinName" }
    Action = "[!RefreshGroup $ROOTCONFIG]"
}

$skinmenu = @{    
    Title  = if ($useLanguage) { '#__SkinMenu#' } else { 'Open skin menu' }
    Action = '[!SkinMenu]'
}

$centerHorizontal = @{
    Title  = if ($useLanguage) { '#__CenterHorizontal#' } else { 'Center horizontally' }
    Action = '[!SetWindowPosition "50%" "[#CURRENTCONFIGY]" "50%" "0%"]'
}

$centerVertical = @{
    Title  = if ($useLanguage) { '#__CenterVertical#' } else { 'Center vertically' }
    Action = '[!SetWindowPosition "([#CURRENTCONFIGX] + ([#CURRENTCONFIGWIDTH] / 2))" "50%" "50%" "50%"]'
}

function ToggleVariable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position, ValueFromPipeline)]
        [string]
        $VariableName
    )

    return @{
        Title  = if ($useLanguage) { "#__Toggle$VariableName#" } else { "Toggle $VariableName" } 
        Action = "[!SetVariable `"$VariableName`" `"([#$VariableName] = 1 ? 0 : 1)`"][!WriteKeyValue Variables `"$VariableName`" [#$VariableName] `"$editVariablesFile`"][!Refresh]"
    }
}

$speedUp = @{
    Title = "Animate faster"
    Action = '[!WriteKeyValue Variables Update "([#Update] <= 16 ? 16 : ([#Update] - 8))"][!Refresh]'
}
$speedDown = @{
    Title = "Animate slower"
    Action = '[!WriteKeyValue Variables Update "([#Update] + 8)"][!Refresh]'
}

$menu = @(
    $current, $spacer,
    $centerHorizontal, $centerVertical, $spacer,
    $speedUp, $speedDown, $spacer,
    $skinmenu
)

function Write-Menu {
    $output = "[Rainmeter]`nRightMouseUpAction=[!SkinCustomMenu]`nGroup=$SkinName`n"
    $count = ""

    $menu | % {
        $output += @"
ContextTitle$($count)=$($_.Title)
ContextAction$($count)=$($_.Action)

"@
        $count = 1 + $count
        if ($count -eq 1) { $count++ }
    }

    $output  | Out-File -FilePath $out 
}

Write-Menu
