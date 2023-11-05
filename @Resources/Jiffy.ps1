$ROOTCONFIGPATH = $RmApi.VariableStr('ROOTCONFIGPATH')
$RESOURCES = $RmApi.VariableStr('@')
$TOTAL = $RmApi.Variable('Total')

$ROOTCONFIG = $RmApi.VariableStr('ROOTCONFIG')

# Programs
$dump = "$($RESOURCES)anim_dump.exe"
$ffmpeg = "$($RESOURCES)ffmpeg.exe"

# Temp frames folder
$frames = "$($RESOURCES)frames"

function Extract {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Mandatory)]
        [string]
        $Path
    )

    # Move to root config
    Set-Location $ROOTCONFIGPATH

    # Extract frames
    if ($Path -like "*.webp") {
        & $dump -folder "$frames" "$Path" 
    }
    else {
        ffmpeg -i "$Path" "$frames\%04d.png"
    }

    # Rename frames to uniform 4 digit number
    Get-ChildItem -Path "$frames\*" -File -Include *.png | ForEach-Object {
        "$($_.Name)" -match '\d+'
        $_ | Move-Item -Destination "$($frames)\$($Matches[0]).png" -Force
    }

    # Get grid width
    $count = (Get-ChildItem -Path "$frames\*" -Include *.png | Measure-Object).Count

    # Concat frames into one bitmap
    ffmpeg -y -i "$frames\%04d.png" -y -filter_complex "tile=$($count)x1" frames.png

    # Remove frames
    Get-ChildItem "$frames\*" -Include *.png | Remove-Item

    # Generate skin
    Skin -Path $Path -Count $count

}

function Skin {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline, Position = 0, Mandatory)]
        [string]
        $Path,
        [Parameter(Mandatory)]
        [int]
        $Count
    )

    $file = Get-ChildItem -Path $Path
    $filename = $file.Name -replace "\.webp|\.gif", ""
    $folder = "$($TOTAL + 1) $($filename)"

    # Create skin folder
    New-Item -ItemType Directory -Name $folder
    $RmApi.Bang("[!WriteKeyValue Variables Total $($TOTAL + 1) `"$($RESOURCES)Common.inc`"]")

    # Move stitched frames into the skin folder
    Move-Item -Path "frames.png" -Destination "$($folder)\frames.png"

    # Generate the skin
    $skin = @"
[Rainmeter]
Update=#Update#
OnRefreshAction=
@IncludeCommon=#@#Common.inc

[Variables]
Update=32
Frames=$($Count)

[Measures]
@IncludeMeasures=#@#Measures.inc

[Bitmap]
@IncludeBitmap=#@#Bitmap.inc

"@

    $skin | Out-File -FilePath "$($folder)\$($filename).ini"

    $RmApi.Bang("[!WriteKeyValue Rainmeter OnRefreshAction `"`"`"[!ActivateConfig `"$($ROOTCONFIG)\$($folder)`"][!WriteKeyValue Rainmeter OnRefreshAction `"`"]`"`"`"]")
    $RmApi.Bang("[!RefreshApp]")

}

function Update {
    return ":3"
}
