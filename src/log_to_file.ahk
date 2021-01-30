

GetLog(logdir) {
	FileCreateDir, %logdir%
    FormatTime, time, , yyyy-MM-dd-HH,mm,ss
    newlog = %logdir%\log-%time%.txt
    return %newlog%
}

LogToFile(key) {
	if (key == PreviousKey) { ; prevent double keys for holding down key
		return
	}
	PreviousKey := key
	FileAppend, %key%`n, *%log%
}
