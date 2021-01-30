
GetKeyStr() {
	static modifiers := ["Ctrl", "Shift", "Alt", "LWin", "RWin"]
	static repeatCount := 1

	for i, mod in modifiers {
		if GetKeyState(mod)
			prefix .= mod " + "
	}

	if (!prefix && !ShowSingleKey)
		throw

	key := SubStr(A_ThisHotkey, 3)

	if (key ~= "i)^(Ctrl|Shift|Alt|LWin|RWin)$") {
		if !ShowSingleModifierKey {
			throw
		}
		key := ""
		prefix := RTrim(prefix, "+ ")

		if ShowModifierKeyCount {
			if !InStr(prefix, "+") && IsDoubleClickEx() {
				if (A_ThisHotKey != A_PriorHotKey) || ShowStickyModKeyCount {
					if (++repeatCount > 1) {
						prefix .= " ( * " repeatCount " )"
					}
				} else {
					repeatCount := 0
				}
			} else {
				repeatCount := 1
			}
		}
	} else {
		if ( StrLen(key) = 1 ) {
			key := GetKeyChar(key, "A")
		} else if ( SubStr(key, 1, 2) = "sc" ) {
			key := SpecialSC(key)
		} else if (key = "LButton") && IsDoubleClick() {
			key := "Double-Click"
		}
		_key := (key = "Double-Click") ? "LButton" : key

		static pre_prefix, pre_key, keyCount := 1
		global tickcount_start
		if (prefix && pre_prefix) && (A_TickCount-tickcount_start < 300) {
			if (prefix != pre_prefix) {
				result := pre_prefix pre_key ", " prefix key
			} else {
				keyCount := (key=pre_key) ? (keyCount+1) : 1
				key := (keyCount>2) ? (key " (" keyCount ")") : (pre_key ", " key)
			}
		} else {
			keyCount := 1
		}

		pre_prefix := prefix
		pre_key := _key

		repeatCount := 1
	}
	return result ? result : prefix . key
}

SpecialSC(sc) {
	static k := {sc046: "ScrollLock", sc145: "NumLock", sc146: "Pause", sc123: "Genius LuxeMate Scroll"}
	return k[sc]
}

; by Lexikos -- https://autohotkey.com/board/topic/110808-getkeyname-for-other-languages/#entry682236
GetKeyChar(Key, WinTitle:=0) {
	thread := WinTitle=0 ? 0
		: DllCall("GetWindowThreadProcessId", "ptr", WinExist(WinTitle), "ptr", 0)
	hkl := DllCall("GetKeyboardLayout", "uint", thread, "ptr")
	vk := GetKeyVK(Key), sc := GetKeySC(Key)
	VarSetCapacity(state, 256, 0)
	VarSetCapacity(char, 4, 0)
	n := DllCall("ToUnicodeEx", "uint", vk, "uint", sc
		, "ptr", &state, "ptr", &char, "int", 2, "uint", 0, "ptr", hkl)
	return StrGet(&char, n, "utf-16")
}

IsDoubleClick(MSec = 300) {
	Return (A_ThisHotKey = A_PriorHotKey) && (A_TimeSincePriorHotkey < MSec)
}

IsDoubleClickEx(MSec = 300) {
	preHotkey := RegExReplace(A_PriorHotkey, "i) Up$")
	Return (A_ThisHotKey = preHotkey) && (A_TimeSincePriorHotkey < MSec)
}
