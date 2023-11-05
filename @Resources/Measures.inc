[PSRM]
Measure=Plugin
Plugin=PowershellRM
ScriptFile=#@#Jiffy.ps1
UpdateDivider=-1

[DragNDrop]
Measure=Plugin
Plugin=Drag&Drop
Action=Path
OnDropAction=[!CommandMeasure PSRM "Extract -Path '$File$'"]
