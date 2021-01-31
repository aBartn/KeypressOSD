
; saves keys to log file in "C:\Users\{USER}\AppData\Roaming\KeypressOSD\"
logdir := A_AppData . "\KeypressOSD"
global log := GetLog(logdir)
global ActiveFileName := ""
global ReplacableKeys := {"Enter": "`n", "Space": " ", "Add": "+", "Sub": "-", "Div": "/", "Mult": "*", "Tab": "`t", "Backspace": "▌", "Up": "↑", "Down": "↓", "Right": "→", "Left": "←"}
; global ReplacableNumberKeys := ["!", "@", "#", "$", "%", "^", "&", "*", "("]
; global ReplacableShiftKeys := {"0": ")", "-": "_", "=": "+", "[": "[", "]": "}", ";": ":", "'": "''", ",": "<", ".": ">", "/": "?", "~": "~", "|": "|"}


GetLog(logdir) {
	FileCreateDir, %logdir%
    FormatTime, time, , yyyy-MM-dd-HH,mm,ss
    newlog = %logdir%\log-%time%.txt
    return %newlog%
}

LogToFile(key) {
	if (IsStickyKey(key)) {
		return
	}
	key := CleanupKey(key)
	
	if (IsWindowChanged()) {
		FormatTime, time, , yyyy-MM-dd HH:mm:ss
		FileAppend, `n%ActiveFileName%: [%time%]`n, *%log%
	}
	if (A_TimeSincePriorHotkey > 30 * 1000) { ; show time if no keys pressed for longer than 30 seconds
		FormatTime, time, , yyyy-MM-dd HH:mm:ss
		FileAppend, `n[%time%]`n, *%log%
	} else if (StrLen(key) > 1) { ; add single chars one same line abc123 \n {ctrl + A}
		FileAppend, `n, *%log%
		key = {%key%}
	}
	FileAppend, %key%, *%log%
}

IsWindowChanged() {
	newName := GetWindowTitle()
	if (ActiveFileName == newName or newName == "KeypressOSD") {
		return False
	}
	ActiveFileName := newName

	return True
}

IsStickyKey(key) {
	if (key == PreviousKey) { ; prevent double keys for holding down key
		return True
	}
	PreviousKey := key
}

CleanupKey(key) {
	if (key == "CapsLock") {
		CapslockIsOn := GetKeyState("Capslock", "T")
	}
	if (GetKeyState("Shift")) {
		UpperCaseKey := % SubStr(A_ThisHotkey, 3)
		
		if (ReplacableNumberKeys[UpperCaseKey]) {
			return ReplacableNumberKeys[UpperCaseKey]
		}
		if (ReplacableShiftKeys[UpperCaseKey]) {
			return ReplacableShiftKeys[UpperCaseKey]
		}
		if (CapslockIsOn)
			StringLower CorrectCaseKey, UpperCaseKey
		else
			StringUpper CorrectCaseKey, UpperCaseKey
		
		return %CorrectCaseKey%
	}
	if (SubStr(key, 1, 6) == "Numpad") {
		key := % SubStr(key, 7)
	}
	
	if (ReplacableKeys[key]) {
		return ReplacableKeys[key]
	}

	
	return key
}

GetWindowTitle() {
	WinGetTitle, title, A
	return title
}
