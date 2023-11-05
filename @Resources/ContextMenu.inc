[Rainmeter]
RightMouseUpAction=[!SkinCustomMenu]
Group=Jiffy
ContextTitle=#CURRENTCONFIG#
ContextAction=["#CURRENTPATH#"]
ContextTitle2=-
ContextAction2=
ContextTitle3=Center horizontally
ContextAction3=[!SetWindowPosition "50%" "[#CURRENTCONFIGY]" "50%" "0%"]
ContextTitle4=Center vertically
ContextAction4=[!SetWindowPosition "([#CURRENTCONFIGX] + ([#CURRENTCONFIGWIDTH] / 2))" "50%" "50%" "50%"]
ContextTitle5=-
ContextAction5=
ContextTitle6=Animate faster
ContextAction6=[!WriteKeyValue Variables Update "([#Update] <= 16 ? 16 : ([#Update] - 8))"][!Refresh]
ContextTitle7=Animate slower
ContextAction7=[!WriteKeyValue Variables Update "([#Update] + 8)"][!Refresh]
ContextTitle8=-
ContextAction8=
ContextTitle9=Open skin menu
ContextAction9=[!SkinMenu]

