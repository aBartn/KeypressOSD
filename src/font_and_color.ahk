
; https://autohotkey.com/boards/viewtopic.php?p=112730#p112730
;-------------------------------------------------------------------------------
Select_Font(hGui, ByRef Style, ByRef Name, ByRef Color) { ; using comdlg32.dll
;-------------------------------------------------------------------------------
    static SubKey := "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontDPI"


    ;-----------------------------------
    ; LOGFONT structure
    ;-----------------------------------
    VarSetCapacity(LOGFONT, 128, 0)

    If RegExMatch(Style, "s\K\d+", s) {
        RegRead, LogPixels, HKLM, %SubKey%, LogPixels
        NumPut(s * LogPixels // 72, LOGFONT, 0, "Int")
    }

    If RegExMatch(Style, "w\K\d+", w)
        NumPut(w, LOGFONT, 16, "Int")

    If InStr(Style, "italic")
        NumPut(255, LOGFONT, 20, "Int")

    If InStr(Style, "underline")
        NumPut(1, LOGFONT, 21, "Int")

    If InStr(Style, "strikeout")
        NumPut(1, LOGFONT, 22, "Int")

    StrPut(Name, &LOGFONT + 28, StrLen(Name) + 1)


    ;-----------------------------------
    ; CHOOSEFONT structure
    ;-----------------------------------

    ; CHOOSEFONT structure expects text color in BGR format
    BGR := convert_Color(Color)

    If (A_PtrSize = 8) { ; 64 bit
        VarSetCapacity(CHOOSEFONT, 104, 0)
        NumPut(     104, CHOOSEFONT,  0, "UInt") ; StructSize
        NumPut(    hGui, CHOOSEFONT,  8, "UInt") ; hwndOwner
        NumPut(&LOGFONT, CHOOSEFONT, 24, "UInt") ; lpLogFont
        NumPut(   0x141, CHOOSEFONT, 36, "UInt") ; Flags
        NumPut(     BGR, CHOOSEFONT, 40, "UInt") ; bgrColor
    }

    Else { ; 32 bit
        VarSetCapacity(CHOOSEFONT, 60, 0)
        NumPut(      60, CHOOSEFONT,  0, "UInt") ; StructSize
        NumPut(    hGui, CHOOSEFONT,  4, "UInt") ; hwndOwner
        NumPut(&LOGFONT, CHOOSEFONT, 12, "UInt") ; lpLogFont
        NumPut(   0x141, CHOOSEFONT, 20, "UInt") ; Flags
        NumPut(     BGR, CHOOSEFONT, 24, "UInt") ; bgrColor
    }


    ;-----------------------------------
    ; call ChooseFont function
    ;-----------------------------------
    FuncName := "comdlg32\ChooseFont" (A_IsUnicode ? "W" : "A")
    If Not DllCall(FuncName, "UInt", &CHOOSEFONT)
        Return, False


    ;-----------------------------------
    ; results to return
    ;-----------------------------------

    ; style
    Style := "s" NumGet(CHOOSEFONT, A_PtrSize = 8 ? 32 : 16, "Int") // 10
    Style .= " w" NumGet(LOGFONT, 16)
    If NumGet(LOGFONT, 20, "UChar")
        Style .= " italic"
    If NumGet(LOGFONT, 21, "UChar")
        Style .= " underline"
    If NumGet(LOGFONT, 22, "UChar")
        Style .= " strikeout"

    ; name
    Name := StrGet(&LOGFONT + 28)

    ; chosen color
    RGB := convert_Color(NumGet(CHOOSEFONT, A_PtrSize = 8 ? 40 : 24, "UInt"))
    Color := SubStr("0x00000", 1, 10 - StrLen(RGB)) SubStr(RGB, 3)
    Return, True
}



;-------------------------------------------------------------------------------
Select_Color(hGui, ByRef Color) { ; using comdlg32.dll
;-------------------------------------------------------------------------------

    ; CHOOSECOLOR structure expects text color in BGR format
    BGR := convert_Color(Color)

    ; unused, but a valid pointer to the structure
    VarSetCapacity(CUSTOM, 64, 0)


    ;-----------------------------------
    ; CHOOSECOLOR structure
    ;-----------------------------------

    If (A_PtrSize = 8) { ; 64 bit
        VarSetCapacity(CHOOSECOLOR, 72, 0)
        NumPut(     72, CHOOSECOLOR,  0) ; StructSize
        NumPut(   hGui, CHOOSECOLOR,  8) ; hwndOwner
        NumPut(    BGR, CHOOSECOLOR, 24) ; bgrColor
        NumPut(&CUSTOM, CHOOSECOLOR, 32) ; lpCustColors
        NumPut(  0x103, CHOOSECOLOR, 40) ; Flags
    }

    Else { ; 32 bit
        VarSetCapacity(CHOOSECOLOR, 36, 0)
        NumPut(     36, CHOOSECOLOR,  0) ; StructSize
        NumPut(   hGui, CHOOSECOLOR,  4) ; hwndOwner
        NumPut(    BGR, CHOOSECOLOR, 12) ; bgrColor
        NumPut(&CUSTOM, CHOOSECOLOR, 16) ; lpCustColors
        NumPut(  0x103, CHOOSECOLOR, 20) ; Flags
    }


    ;-----------------------------------
    ; call ChooseColorA function
    ;-----------------------------------

    If Not DllCall("comdlg32\ChooseColorA", "UInt", &CHOOSECOLOR)
        Return, False


    ;-----------------------------------
    ; result to return
    ;-----------------------------------

    ; chosen color
    RGB := convert_Color(NumGet(CHOOSECOLOR, A_PtrSize = 8 ? 24 : 12, "UInt"))
    Color := SubStr("0x00000", 1, 10 - StrLen(RGB)) SubStr(RGB, 3)
    Return, True
}



;-------------------------------------------------------------------------------
convert_Color(Color) { ; convert RGB <--> BGR
;-------------------------------------------------------------------------------
    $_FormatInteger := A_FormatInteger
    SetFormat, Integer, Hex
    Result := (Color & 0xFF) << 16 | Color & 0xFF00 | (Color >> 16) & 0xFF
    SetFormat, Integer, % $_FormatInteger
    Return, Result
}
