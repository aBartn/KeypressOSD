#include src/font_and_color.ahk

ReadSettings() {
	IniFile := SubStr(A_ScriptFullPath, 1, -4) ".ini"

	IniRead, TransN               , %IniFile%, Settings, TransN               , 200
	IniRead, ShowSingleKey        , %IniFile%, Settings, ShowSingleKey        , 1
	IniRead, ShowMouseButton      , %IniFile%, Settings, ShowMouseButton      , 1
	IniRead, ShowSingleModifierKey, %IniFile%, Settings, ShowSingleModifierKey, 1
	IniRead, ShowModifierKeyCount , %IniFile%, Settings, ShowModifierKeyCount , 1
	IniRead, ShowStickyModKeyCount, %IniFile%, Settings, ShowStickyModKeyCount, 0
	IniRead, ShowPressedKey       , %IniFile%, Settings, ShowPressedKey       , 0
	IniRead, LogPressedKey        , %IniFile%, Settings, LogPressedKey        , 0
	IniRead, DisplaySec           , %IniFile%, Settings, DisplaySec           , 2
	IniRead, GuiPosition          , %IniFile%, Settings, GuiPosition          , Bottom
	IniRead, FontSize             , %IniFile%, Settings, FontSize             , 50
	IniRead, GuiWidth             , %IniFile%, Settings, GuiWidth             , %A_ScreenWidth%
	IniRead, GuiHeight            , %IniFile%, Settings, GuiHeight            , 115
	IniRead, BkColor              , %IniFile%, Settings, BkColor              , Black
	IniRead, FontColor            , %IniFile%, Settings, FontColor            , White
	IniRead, FontStyle            , %IniFile%, Settings, FontStyle            , w700
	IniRead, FontName             , %IniFile%, Settings, FontName             , Arial
	IniRead, AutoGuiW             , %IniFile%, Settings, AutoGuiW             , 1
	IniRead, Bottom_Win           , %IniFile%, Settings, Bottom_Win           , 1
	IniRead, Bottom_Screen        , %IniFile%, Settings, Bottom_Screen        , 0
	IniRead, Bottom_OffsetX       , %IniFile%, Settings, Bottom_OffsetX       , 0
	IniRead, Bottom_OffsetY       , %IniFile%, Settings, Bottom_OffsetY       , 50
	IniRead, Top_Win              , %IniFile%, Settings, Top_Win              , 1
	IniRead, Top_Screen           , %IniFile%, Settings, Top_Screen           , 0
	IniRead, Top_OffsetX          , %IniFile%, Settings, Top_OffsetX          , 0
	IniRead, Top_OffsetY          , %IniFile%, Settings, Top_OffsetY          , 0
	IniRead, FixedX               , %IniFile%, Settings, FixedX               , 100
	IniRead, FixedY               , %IniFile%, Settings, FixedY               , 200
}

SaveSettings() {
	IniFile := SubStr(A_ScriptFullPath, 1, -4) ".ini"

	IniWrite, %TransN%               , %IniFile%, Settings, TransN
	IniWrite, %ShowSingleKey%        , %IniFile%, Settings, ShowSingleKey
	IniWrite, %ShowMouseButton%      , %IniFile%, Settings, ShowMouseButton
	IniWrite, %ShowSingleModifierKey%, %IniFile%, Settings, ShowSingleModifierKey
	IniWrite, %ShowModifierKeyCount% , %IniFile%, Settings, ShowModifierKeyCount
	IniWrite, %ShowStickyModKeyCount%, %IniFile%, Settings, ShowStickyModKeyCount
	IniWrite, %ShowPressedKey%       , %IniFile%, Settings, ShowPressedKey
	IniWrite, %LogPressedKey%        , %IniFile%, Settings, LogPressedKey
	IniWrite, %DisplaySec%           , %IniFile%, Settings, DisplaySec
	IniWrite, %GuiPosition%          , %IniFile%, Settings, GuiPosition
	IniWrite, %FontSize%             , %IniFile%, Settings, FontSize
	IniWrite, %GuiWidth%             , %IniFile%, Settings, GuiWidth
	IniWrite, %GuiHeight%            , %IniFile%, Settings, GuiHeight
	IniWrite, %BkColor%              , %IniFile%, Settings, BkColor
	IniWrite, %FontColor%            , %IniFile%, Settings, FontColor
	IniWrite, %FontStyle%            , %IniFile%, Settings, FontStyle
	IniWrite, %FontName%             , %IniFile%, Settings, FontName
	IniWrite, %AutoGuiW%             , %IniFile%, Settings, AutoGuiW
	IniWrite, %Bottom_Win%           , %IniFile%, Settings, Bottom_Win
	IniWrite, %Bottom_Screen%        , %IniFile%, Settings, Bottom_Screen
	IniWrite, %Bottom_OffsetX%       , %IniFile%, Settings, Bottom_OffsetX
	IniWrite, %Bottom_OffsetY%       , %IniFile%, Settings, Bottom_OffsetY
	IniWrite, %Top_Win%              , %IniFile%, Settings, Top_Win
	IniWrite, %Top_Screen%           , %IniFile%, Settings, Top_Screen
	IniWrite, %Top_OffsetX%          , %IniFile%, Settings, Top_OffsetX
	IniWrite, %Top_OffsetY%          , %IniFile%, Settings, Top_OffsetY
	IniWrite, %FixedX%               , %IniFile%, Settings, FixedX
	IniWrite, %FixedY%               , %IniFile%, Settings, FixedY
}

CreateTrayMenu() {
	Menu, Tray, NoStandard
	Menu, Tray, Add, Settings, ShowSettingsGUI
	Menu, Tray, Add, Suspend, ToggleSuspend
	Menu, Tray, Add, About, ShowAboutGUI
	Menu, Tray, Add
	Menu, Tray, Add, Exit, _ExitApp
	Menu, Tray, Default, Settings
	Menu, Tray, Tip, KeypressOSD
}

ToggleSuspend() {
	Suspend, Toggle
	Menu, Tray, ToggleCheck, Suspend
	Menu, Tray, Tip, % "KeypressOSD" (A_IsSuspended ? " - Suspended" : "")
}

ShowAboutGUI() {
	Gui, a:Font, s12 bold
	Gui, a:Add, Text, , KeypressOSD %appVersion%
	Gui, a:Add, Link, gOpenUrl, <a>https://github.com/tmplinshi/KeypressOSD</a>
	Gui, a:Show,, About
	Return

	OpenUrl:
		Run, https://github.com/tmplinshi/KeypressOSD
	return
}

_ExitApp() {
	ExitApp
}

sGuiAddTitleText(text) {
	Gui, s:Font, s16
	Gui, s:Add, Text, xm y+20, %text%
	Gui, s:Font, s12
}

ShowSettingsGUI() {
	global

	SettingsGuiIsOpen := true

	Gui, s:Destroy
	Gui, s:+HWNDhGUI_s
	Gui, s:Font, s12

	Gui, s:Add, Text, xm, Transparency:
	Gui, s:Add, Text, x+10 w100 vTransNVal, %TransN%
	Gui, s:Add, Slider, xm+10 vTransN Range0-255 ToolTip gUpdateTransVal, %TransN%


	Gui, s:Add, Text, xm, Display
	Gui, s:Add, Edit, x+10 w80 Center vDisplaySec, %DisplaySec%
	Gui, s:Add, Text, x+10, Seconds

	Gui, s:Add, Checkbox, xm h24 vShowSingleKey Checked%ShowSingleKey%, Show Single Key
	Gui, s:Add, Checkbox, xm h24 vShowMouseButton Checked%ShowMouseButton%, Show Mouse Button
	Gui, s:Add, Checkbox, xm h24 vShowSingleModifierKey Checked%ShowSingleModifierKey%, Show Single Modifier Key
	Gui, s:Add, Checkbox, xm h24 vShowModifierKeyCount Checked%ShowModifierKeyCount%, Show Modifier Key Count
	Gui, s:Add, Checkbox, xm h24 vShowStickyModKeyCount Checked%ShowStickyModKeyCount%, Show Sticky Modifier Key Count
	Gui, s:Add, Checkbox, xm h24 vShowPressedKey Checked%ShowPressedKey%, Show Pressed Key
	Gui, s:Add, Checkbox, xm h24 vLogPressedKey Checked%LogPressedKey%, Log Pressed Key

	sGuiAddTitleText("Window Position")
		Gui, s:Add, Tab3, xm y+10 Buttons vGuiPosition gUpdateGuiPosition, Bottom|Top|Fixed Position
		GuiControl, s:ChooseString, GuiPosition, |%GuiPosition%
		Gui, s:Tab, 1
			Gui, s:Add, Text, Section y+20, Relative To:
			Gui, s:Add, Radio, x+10 vBottom_Win Checked%Bottom_Win%, Active Window
			Gui, s:Add, Radio, x+20 vBottom_Screen Checked%Bottom_Screen%, Screen
			Gui, s:Add, Text, xs y+20, OffsetX
			Gui, s:Add, Edit, x+10 w80 vBottom_OffsetX Number gUpdateOSD, %Bottom_OffsetX%
			Gui, s:Add, UpDown, Range0-%A_ScreenWidth% 0x80 gUpdateOSD, %Bottom_OffsetX%
			Gui, s:Add, Text, x+50, OffsetY
			Gui, s:Add, Edit, x+10 w80 vBottom_OffsetY Number gUpdateOSD, %Bottom_OffsetY%
			Gui, s:Add, UpDown, Range0-%A_ScreenHeight% 0x80 gUpdateOSD, %Bottom_OffsetY%
		Gui, s:Tab, 2
			Gui, s:Add, Text, Section y+20, Relative To:
			Gui, s:Add, Radio, x+10 vTop_Win Checked%Top_Win%, Active Window
			Gui, s:Add, Radio, x+20 vTop_Screen Checked%Top_Screen%, Screen
			Gui, s:Add, Text, xs y+20, OffsetX
			Gui, s:Add, Edit, x+10 w80 vTop_OffsetX Number gUpdateOSD, 
			Gui, s:Add, UpDown, Range0-%A_ScreenWidth% 0x80 gUpdateOSD, %Top_OffsetX%
			Gui, s:Add, Text, x+50, OffsetY
			Gui, s:Add, Edit, x+10 w80 vTop_OffsetY Number gUpdateOSD, 
			Gui, s:Add, UpDown, Range0-%A_ScreenHeight% 0x80 gUpdateOSD, %Top_OffsetY%
		Gui, s:Tab, 3
			Gui, s:Add, Text, y+20, X
			Gui, s:Add, Edit, x+10 w80 vFixedX Number gUpdateOSD, %FixedX%
			Gui, s:Add, UpDown, Range0-%A_ScreenWidth% 0x80 gUpdateOSD, %FixedX%
			Gui, s:Add, Text, x+50, Y
			Gui, s:Add, Edit, x+10 w80 vFixedY Number gUpdateOSD, %FixedY%
			Gui, s:Add, UpDown, Range0-%A_ScreenHeight% 0x80 gUpdateOSD, %FixedY%
			Gui, s:Font, s10
			Gui, s:Add, Text, xs cGray, Input or drag the OSD window.
			Gui, s:Font, s12
		Gui, s:Tab

	sGuiAddTitleText("Window Size")
		Gui, s:Add, Text, xm, % " Width:"

		Gui, s:Add, Edit, x+10 w85 Center Number vGuiWidth gUpdateGuiWidth, %GuiWidth%
		Gui, s:Add, UpDown, Range10-4000 gUpdateGuiWidth 0x80 vGuiWUD, %GuiWidth%
		Gui, s:Add, Checkbox, x+30 vAutoGuiW Checked%AutoGuiW% g_AutoGuiW, Same As Active Window
		Gosub, _AutoGuiW

		Gui, s:Add, Text, xm, Height:
		Gui, s:Add, Edit, x+10 w85 Number Center vGuiHeight gUpdateGuiHeight, %GuiHeight%
		Gui, s:Add, UpDown, Range5-2000 gUpdateGuiHeight 0x80, %GuiHeight%

	Gui, s:Add, Button, xm y+20 gChangeBkColor, Change Background Color

	Gui, s:Add, Button, xm gChangeFont, Change Font
	Gui, s:Add, Button, x+50 gChangeFontColor, Change Font Color

	Gui, s:Add, Text, xm, Font Size:
	Gui, s:Add, Edit, x+10 w100 Number Center vFontSize gUpdateFontSize, %FontSize%
	Gui, s:Add, UpDown, Range1-1000 gUpdateFontSize 0x80, %fontSize%

	if (GuiPosition = "Fixed Position")
		OSD_EnableDrag()
	Gui, s:Show,, Settings - KeypressOSD

	ShowHotkey("KeypressOSD")
	SetTimer, HideGUI, Off
	return

	UpdateOSD:
		Gui, Submit, NoHide
		Gosub, _CheckValues
		ShowHotkey("KeypressOSD")
	return

	_CheckValues:
		Loop, Parse, % "Bottom_OffsetX,Bottom_OffsetY,Top_OffsetX,Top_OffsetY,FixedX,FixedY", `,
		{
			if (%A_LoopField% = "") {
				%A_LoopField% := 0
			}
		}
	return

	_AutoGuiW:
		; GuiControlGet, AutoGuiW, s:
		Gui, Submit, NoHide
		GuiControl, % "s:Enable" !AutoGuiW, GuiWidth
		GuiControl, % "s:Enable" !AutoGuiW, GuiWUD
		ShowHotkey("KeypressOSD")
		GuiControl, 1:+Redraw, HotkeyText
	return

	UpdateGuiPosition:
		oLast := {}
		Gui, Submit, NoHide
		ShowHotkey("KeypressOSD")

		if (GuiPosition = "Fixed Position")
			OSD_EnableDrag()
		else
			OSD_DisableDrag()
	return

	UpdateGuiWidth:
		GuiControlGet, newW,, GuiWidth
		if newW {
			GuiWidth := newW
			ShowHotkey("KeypressOSD")
		}
	return

	UpdateGuiHeight:
		GuiControlGet, newH,, GuiHeight
		if newH {
			GuiHeight := newH
			ShowHotkey("KeypressOSD")
		}
	return

	UpdateTransVal:
		GuiControlGet, TransN
		GuiControl,, TransNVal, % TransN

		Gui, 1:+LastFound
		WinSet, Transparent, %TransN%
	return

	UpdateFontSize:
		GuiControlGet, FontSize
		Gui, 1:Font, s%FontSize%
		GuiControl, 1:Font, HotkeyText
	return

	sGuiClose:
	sGuiEscape:
		FontSize_pre := FontSize

		Gui, s:Submit
		Gosub, _CheckValues

		ShowMouseButton ? MouseHotkey_On() : MouseHotkey_Off()

		if (FontSize_pre != FontSize) {
			Gui, 1:Font, s%FontSize%
			GuiControl, 1:Font, HotkeyText
		}

		if !GuiHeight
			GuiHeight := 115

		SaveSettings()
		Gui, s:Destroy
		Gui, 1:Hide
		OSD_DisableDrag()
		SettingsGuiIsOpen := ""
	return

	ChangeBkColor:
		newColor := BkColor
		if Select_Color(hGUI_s, newColor) {
			Gui, 1:Color, %newColor%
			ShowHotkey("KeypressOSD")
			SetTimer, HideGUI, Off
			BkColor := newColor
		}
	return

	ChangeFontColor:
		newColor := FontColor
		if Select_Color(hGUI_s, newColor) {
			Gui, 1:Font, c%newColor%
			GuiControl, 1:Font, HotkeyText
			ShowHotkey("KeypressOSD")
			SetTimer, HideGUI, Off
			FontColor := newColor
		}
	return

	ChangeFont:
		fStyle := FontStyle " s" FontSize
		fName  := FontName
		fColor := FontColor

		if Select_Font(hGUI_s, fStyle, fName, fColor) {
			FontStyle := fStyle
			FontName := fName
			FontColor := fColor
			if RegExMatch(FontStyle, "\bs\K\d+", FontSize) {
				FontStyle := RegExReplace(FontStyle, "\bs\d+")
				GuiControl,, FontSize, %FontSize%
			}

			Gui, 1:Font
			Gui, 1:Font, %fStyle% c%FontColor%, %fName%
			GuiControl, 1:Font, HotkeyText
			ShowHotkey("KeypressOSD")
			SetTimer, HideGUI, Off
		}
	return
}


WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
	static hCursor := DllCall("LoadCursor", "Uint", 0, "Int", 32646, "Ptr") ; SizeAll = 32646

	if (hwnd = hGui_OSD) {
		PostMessage, 0xA1, 2
		DllCall("SetCursor", "ptr", hCursor)
	}
}

WM_MOVE(wParam, lParam, msg, hwnd) {
	if (hwnd = hGui_OSD) && GetKeyState("LButton", "P")
	{
		GuiControl, s:, FixedX, % lParam << 48 >> 48
		GuiControl, s:, FixedY, % lParam << 32 >> 48
	}
}

OSD_EnableDrag() {
	OnMessage(0x0201, "WM_LBUTTONDOWN")
	OnMessage(0x0003, "WM_MOVE")
	Gui, 1:-E0x20
}

OSD_DisableDrag() {
	OnMessage(0x0201, "")
	OnMessage(0x0003, "")
	Gui, 1:+E0x20
}

MouseHotkey_On() {
	Loop, Parse, % "LButton|MButton|RButton", |
		Hotkey, % "~*" A_LoopField, On, UseErrorLevel
}

MouseHotkey_Off() {
	Loop, Parse, % "LButton|MButton|RButton", |
		Hotkey, % "~*" A_LoopField, Off, UseErrorLevel
}

HideGUI() {
	if !SettingsGuiIsOpen {
		Gui, Hide
	}
	oLast := {}
}
