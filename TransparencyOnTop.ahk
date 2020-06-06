
if ( not FileExist(A_ScriptDir "\\key.ini")){
	FileAppend,,key.ini
	IniWrite,"^[",key.ini,keys,OnTopKey
	IniWrite,"^9",key.ini,keys,DecreaseTransparency
	IniWrite,"^0",key.ini,keys,IncreaseTransparency	
}

IniRead, ontopkey, key.ini, keys, OnTopKey, "^["
IniRead, dectrans, key.ini, keys, DecreaseTransparency, "^9"
IniRead, inctrans, key.ini, keys, IncreaseTransparency, "^0"

Menu, Tray, Add
Menu, Tray, Add, On Top Key %ontopkey%, OTMenuHandler
Menu, Tray, Add, Increase Transparency Key %inctrans% , ITMenuHandler
Menu, Tray, Add, Decrease Transparency Key %dectrans%, DTMenuHandler

Hotkey, %ontopkey%, OnTop
Hotkey, %dectrans%, Decrease_Transparency
Hotkey, %inctrans%, Increase_Transparency

return 

OTMenuHandler:
InputBox, k, "Input Hotkey", "Hotkey for toggling Stay-On-Top:"
if ErrorLevel
	return
k = %k% ; trim text
Hotkey, %k%, OnTop
IniWrite, %k%, key.ini, keys, OnTopKey
Menu, Tray, Rename, On Top Key %ontopkey%, On Top Key %k%
ontopkey = %k%
return

ITMenuHandler:
InputBox, k, "Input Hotkey", "Hotkey for increasing transparency:"
if ErrorLevel
	return
k = %k% ; trim text
Hotkey, %k%, Increase_Transparency
IniWrite, %k%, key.ini, keys, IncreaseTransparency
Menu, Tray, Rename, Increase Transparency Key %inctrans%, Increase Transparency Key %k%
inctrans = %k%
return

DTMenuHandler:
InputBox, k, "Input Hotkey", "Hotkey for decreasing transparency:"
if ErrorLevel
	return
k = %k% ; trim text
Hotkey, %k%, Decrease_Transparency
IniWrite, %k%, key.ini, keys, DecreaseTransparency
Menu, Tray, Rename, Decrease Transparency Key %dectrans%, Increase Transparency Key %k%
dectrans = %k%
return


OnTop:
SetTimer, ToolOff, Off
ToolTip
MouseGetPos, CursorX, CursorY, Window, Control
WinGetTitle, WinTitle, ahk_id %Window%
WinGet, ExStyle, ExStyle, ahk_id %Window%
if (ExStyle & 0x8) { ; 0x8 is WS_EX_TOPMOST.
	WinSet, AlwaysOnTop, OFF, ahk_id %Window%
	ToolTip, "Deactivating always on top", %CursorX%, %CursorY%
	SetTimer, ToolOff, 1500	 
}else{
	WinSet, AlwaysOnTop, ON, ahk_id %Window%
	ToolTip, "Activating always on top", %CursorX%, %CursorY%
	SetTimer, ToolOff, 1500	
}

return

Increase_Transparency:
SetTimer, ToolOff, Off
ToolTip
MouseGetPos, CursorX, CursorY, Window, Control
WinGetTitle, WinTitle, ahk_id %Window%

WinGet, Transparency, Transparent, ahk_id %Window%  ; get transparency of window

if (Transparency = "" or Transparency = 255){ ; if window has no transparency
	Transparency = 225
}
else if (Transparency <= 50){
	Transparency = 25
}else{
	Transparency -= 25
}
WinSet, Transparent, %Transparency%, ahk_id %Window%

ToolTip, Setting Transparency to %Transparency%, %CursorX%, %CursorY%
SetTimer, ToolOff, 1500
return

Decrease_Transparency:
SetTimer, ToolOff, Off
ToolTip
MouseGetPos, CursorX, CursorY, Window, Control
WinGetTitle, WinTitle, ahk_id %Window%

WinGet, Transparency, Transparent, ahk_id %Window%  ; get transparency of window

if (Transparency = "" ){ ; if window has no transparency
	ToolTip, Window already fully opaque, %CursorX%, %CursorY%
	SetTimer, ToolOff, 1500	
}
else if (Transparency >= 225){
	WinSet, Transparent, Off, ahk_id %Window%
	ToolTip, Window set to fully opaque, %CursorX%, %CursorY%
	SetTimer, ToolOff, 1500 	
}else{	
	Transparency += 25
	WinSet, Transparent, %Transparency%, ahk_id %Window%
	ToolTip, Setting Transparency to %Transparency%, %CursorX%, %CursorY%
	SetTimer, ToolOff, 1500
}
return

ToolOff:
ToolTip
SetTimer, ToolOff, Off
return

