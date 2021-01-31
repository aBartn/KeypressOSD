; KeypressOSD v2.61 (2021-01-31)

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1

global appVersion := "v2.61"
global AutoGuiW, BkColor, Bottom_OffsetX, Bottom_OffsetY, Bottom_Screen, Bottom_Win, DisplaySec, FixedX, FixedY
     , FontColor, FontName, FontSize, FontStyle, GuiHeight, GuiPosition, GuiWidth, SettingsGuiIsOpen
     , ShowModifierKeyCount, ShowMouseButton, ShowSingleKey, ShowSingleModifierKey, ShowStickyModKeyCount
     , ShowPressedKey, LogPressedKey, Top_OffsetX, Top_OffsetY, Top_Screen, Top_Win, TransN
     , oLast, PreviousKey := {}, hGui_OSD, hGUI_s
global KeyString := []
global CapslockIsOn := GetKeyState("Capslock", "T")

; saves keys to log file in "C:\Users\{USER}\AppData\Roaming\KeypressOSD\"
logdir := A_AppData . "\KeypressOSD"
global log := GetLog(logdir)

#include src/settings.ahk
#include src/show_hotkeys.ahk
#include src/get_key_string.ahk
#include src/log_to_file.ahk

ReadSettings()
CreateTrayMenu()
CreateGUI()
CreateHotkey()
return

#if !SettingsGuiIsOpen
	OnKeyPressed:
		try {
			key := GetKeyStr()
			if (ShowPressedKey) {
				ShowHotkey(key)
			}
			if (LogPressedKey) {
				LogToFile(key)
			}
			SetTimer, HideGUI, % -1 * DisplaySec * 1000
		}
	return

	OnKeyUp:
	return

	_OnKeyUp:
		tickcount_start := A_TickCount
	return

; ===================================================================================
CreateGUI() {
	global

	Gui, +AlwaysOnTop -Caption +Owner +LastFound +E0x20 +HWNDhGui_OSD
	Gui, Margin, 0, 0
	Gui, Color, %BkColor%
	Gui, Font, c%FontColor% %FontStyle% s%FontSize%, %FontName%
	Gui, Add, Text, vHotkeyText Center y20

	WinSet, Transparent, %TransN%
}

CreateHotkey() {
	Loop, 95
	{
		k := Chr(A_Index + 31)
		k := (k = " ") ? "Space" : k

		Hotkey, % "~*" k, OnKeyPressed
		Hotkey, % "~*" k " Up", _OnKeyUp
	}

	Loop, 24 ; F1-F24
	{
		Hotkey, % "~*F" A_Index, OnKeyPressed
		Hotkey, % "~*F" A_Index " Up", _OnKeyUp
	}

	Loop, 10 ; Numpad0 - Numpad9
	{
		Hotkey, % "~*Numpad" A_Index - 1, OnKeyPressed
		Hotkey, % "~*Numpad" A_Index - 1 " Up", _OnKeyUp
	}

	Otherkeys := "WheelDown|WheelUp|WheelLeft|WheelRight|XButton1|XButton2|Browser_Forward|Browser_Back|Browser_Refresh|Browser_Stop|Browser_Search|Browser_Favorites|Browser_Home|Volume_Mute|Volume_Down|Volume_Up|Media_Next|Media_Prev|Media_Stop|Media_Play_Pause|Launch_Mail|Launch_Media|Launch_App1|Launch_App2|Help|Sleep|PrintScreen|CtrlBreak|Break|AppsKey|NumpadDot|NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|NumpadEnter|Tab|Enter|Esc|BackSpace"
	           . "|Del|Insert|Home|End|PgUp|PgDn|Up|Down|Left|Right|ScrollLock|CapsLock|NumLock|Pause|sc145|sc146|sc046|sc123"
	Loop, parse, Otherkeys, |
	{
		Hotkey, % "~*" A_LoopField, OnKeyPressed
		Hotkey, % "~*" A_LoopField " Up", _OnKeyUp
	}

	If ShowMouseButton {
		Loop, Parse, % "LButton|MButton|RButton", |
			Hotkey, % "~*" A_LoopField, OnKeyPressed
	}

	for i, mod in ["Ctrl", "Shift", "Alt"] {
		Hotkey, % "~*" mod, OnKeyPressed
		Hotkey, % "~*" mod " Up", OnKeyUp
	}
	for i, mod in ["LWin", "RWin"]
		Hotkey, % "~*" mod, OnKeyPressed
}
