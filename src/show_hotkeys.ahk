
ShowHotkey(HotkeyStr) {
	if SettingsGuiIsOpen {
		ActWin_X := ActWin_Y := 0
		ActWin_W := A_ScreenWidth
		ActWin_H := A_ScreenHeight
	} else {
		WinGetPos, ActWin_X, ActWin_Y, ActWin_W, ActWin_H, A
		if !ActWin_W
			throw
	}

	text_w := AutoGuiW ? ActWin_W : GuiWidth
	if (HotkeyStr != oLast.HotkeyStr) {
		GuiControl, 1:, HotkeyText, %HotkeyStr%
		oLast.HotkeyStr := HotkeyStr
		changed := true
	}

	ctrlSize = w%text_w% h%GuiHeight%
	; ToolTip, % obj_print(oLast) "`n`n" ctrlSize "`n" oLast.ctrlSize
	if (ctrlSize != oLast.ctrlSize) {
		GuiControl, 1:Move, HotkeyText, x0 y0 %ctrlSize%
		GuiControl, +0x201, HotkeyText
		oLast.ctrlSize := ctrlSize
		changed := true
	}

	if (GuiPosition = "Fixed Position")
	{
		gui_x := FixedX
		gui_y := FixedY
	}
	else
	{
		if (GuiPosition = "Top" && Top_Screen)
		|| (GuiPosition = "Bottom" && Bottom_Screen)
		{
			ActWin_X := ActWin_Y := 0
			ActWin_W := A_ScreenWidth
			ActWin_H := A_ScreenHeight
		}

		if (GuiPosition = "Top")
		{
			gui_x := ActWin_X + Top_OffsetX
			gui_y := ActWin_Y + Top_OffsetY
		}
		else if (GuiPosition = "Bottom")
		{
			gui_x := ActWin_X + Bottom_OffsetX
			gui_y := (ActWin_Y+ActWin_H) - GuiHeight - Bottom_OffsetY
		}
	}
	

	guiPos = x%gui_x% y%gui_y%
	if (guiPos != oLast.guiPos || changed) {
		Gui, 1:Show, NoActivate %guiPos% %ctrlSize%
		oLast.guiPos := guiPos
		; ToolTip, updated! %a_now%

		; static n := 0
		; n += 1
		; ToolTip, % HotkeyStr " " n "`n" guiPos
	} else {
		; ToolTip, % "why?`n" obj_print(oLast) "`n`n" ctrlSize "`n" oLast.ctrlSize
	}
}
