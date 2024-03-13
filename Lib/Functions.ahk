#Requires AutoHotkey v2.0

; ------------------- Functions -------------------

; Convert positions from 1278*664 client resolution to current resolution
WinRelPosW(PosW) {
    global W
    return PosW / 1278 * W
}

WinRelPosH(PosH) {
    global H
    return PosH / 664 * H
}

; Convert positions from 2560*1396 client resolution to current resolution to
; allow higher accuracy
WinRelPosLargeW(PosW2) {
    global W
    return PosW2 / 2560 * W
}

WinRelPosLargeH(PosH2) {
    global H
    return PosH2 / 1369 * H
}


; Default clicking function, uses relative locations
fSlowClick(x, y, delay := 34) {
    if (WinActive(WW2WindowTitle)) {
        MouseClick("left", WinRelPosW(x), WinRelPosH(y), , , "D")
        Sleep(delay) ; Must be higher than 16.67 which is a single frame of 60fps,
        ; set to slightly higher than 2 frames for safety
        ; If clicking isn't reliable increase this sleep value
        MouseClick("left", WinRelPosW(x), WinRelPosH(y), , , "U")
    }
}

; Custom clicking function, swap the above to this if you want static coords
; that are more easily changed
fCustomClick(x, y, delay := 34) {
    if (WinActive(WW2WindowTitle)) {
        MouseClick("left", x, y, , , "D")
        Sleep(delay)
        /* Must be higher than 16.67 which is a single frame of 60fps,
        set to slightly higher than 2 frames for safety
        If clicking isn't reliable increase this sleep value */
        MouseClick("left", x, y, , , "U")
    }
}

fSlowClickRelL(clickX, clickY, delay := 34) {
    if (!WinActive(WW2WindowTitle)) {
        Log("No window found while trying to Lclick at " clickX " * " clickY
            "`n Rel: " WinRelPosLargeW(clickX) " * " WinRelPosLargeH(clickY))
        return false
    }
    MouseClick("left", WinRelPosLargeW(clickX),
        WinRelPosLargeH(clickY), , , "D")
    Sleep(delay)
    MouseClick("left", WinRelPosLargeW(clickX),
        WinRelPosLargeH(clickY), , , "U")
}

ResetModifierKeys() {
    ; Cleanup incase still held, ahk cannot tell if the key has been sent as up
    ; getkeystate reports the key, not what lbr has been given

    ControlSend("{Control up}", , WW2WindowTitle)
    ControlSend("{Alt up}", , WW2WindowTitle)
    ControlSend("{Shift up}", , WW2WindowTitle)
}

PixelSearchWrapper(x1, y1, x2, y2, colour) {
    try {
        found := PixelSearch(&OutX, &OutY,
            x1, y1,
            x2, y2, colour, 0)
        If (!found || OutX = 0) {
            return false
        }
    } catch as exc {
        Log("Error 8: PixelSearchWrapper check failed - " exc.Message)
        MsgBox("Could not conduct the search due to the following error:`n"
            exc.Message)
    }
    return [OutX, OutY]
}

/**
 * Search area for first instance of colour found from top left
 * @param x1 Top left Coordinate (relative 1440)
 * @param y1 Top left Coordinate (relative 1440)
 * @param x2 Bottom Right Coordinate (relative 1440)
 * @param y2 Bottom Right Coordinate (relative 1440)
 * @returns {array|number} returns array of [ x, y ] or false
 */
PixelSearchWrapperRel(x1, y1, x2, y2, colour) {
    /*try {
        found := PixelSearch(&OutX, &OutY,
            WinRelPosLargeW(x1), WinRelPosLargeH(y1),
            WinRelPosLargeW(x2), WinRelPosLargeH(y2), colour, 0)
        If (!found || OutX = 0) {
            return false
        }
    } catch as exc {
        Log("Error: PixelSearchWrapperRel check failed - " exc.Message)
        MsgBox("Could not conduct the search due to the following error:`n"
            exc.Message)
    }*/
    return PixelSearchWrapper(WinRelPosLargeW(x1), WinRelPosLargeH(y1),
        WinRelPosLargeW(x2), WinRelPosLargeH(y2), colour)
}

/**
 * For a given 1px wide strip horizontally or vertically, get all blocks
 * of colour from the first point reached.
 * @param x1 Top left Coordinate (non relative)
 * @param y1 Top left Coordinate (non relative)
 * @param x2 Bottom Right Coordinate (non relative)
 * @param y2 Bottom Right Coordinate (non relative)
 * @returns {array|number} returns array of { x, y, colour } or false
 */
LineGetColourInstances(x1, y1, x2, y2) {
    ; Returns array of points and colours {x, y, colour}
    ; Detects when the colour changes to remove redundant entries
    foundArr := []
    lastColour := ""
    try {
        ; if no width, and y has length
        if (x1 = x2 && y1 < y2) {
            ; Starting point
            i := y1
            while (i <= y2) {
                colour := PixelGetColor(x1, i)
                if (foundArr.Length = 0 || lastColour != colour) {
                    foundArr.Push({ x: x1, y: i, colour: colour })
                    lastColour := colour
                }
                i++
            }
            return foundArr
        }
        ; if no height, and x has length
        if (y1 = y2 && x1 < x2) {
            ; Starting point
            i := x1
            while (i <= x2) {
                colour := PixelGetColor(i, y1)
                if (foundArr.Length = 0 || foundArr[foundArr.Length].colour != colour) {
                    foundArr.Push({ x: i, y: y1, colour: colour })
                }
                i++
            }
            return foundArr
        }
    } catch as exc {
        Log("Error 9: LineGetColourInstances check failed - " exc.Message)
        MsgBox("Could not conduct the search due to the following error:`n"
            exc.Message)
    }
    return false
}

/**
 * 
 * @param x 
 * @param y1 
 * @param y2 
 * @param colour 
 * @param {number} splitCount 
 * @returns {array|number} false if nothing, array of Y heights if found
 */
LineGetColourInstancesOffsetV(x, y1, y2, colour, splitCount := 20) {
    splitSize := (y2 - y1) / splitCount
    splitCur := 0
    foundArr := []
    found := 0
    ; Because checking every pixel takes 7 seconds, lets split up the line
    ; use pixelsearch and try to find a balance where we don't get overlap
    while splitCur < splitCount {
        yTop := y1 + (splitCur * splitSize)
        yBot := y1 + ((splitCur + 1) * splitSize)
        result := PixelSearchWrapperRel(x, yTop, x, yBot, colour)
        if (result) {
            found++
            foundArr.Push(result[2])
        }
        splitCur++
    }
    if (found) {
        return foundArr
    }
    return false
}

LineGetColourInstancesOffsetH(x1, y1, x2, y2, offset, colour) {
    PixelSearchWrapper(x1, y1, x2, y2, colour)
}

/**
 * Logger, user disable possible, debugout regardless of setting to vscode.
 * Far more usable than outputting to tooltips or debugging using normal means
 * due to focus changing and hotkeys overwriting
 * @param logmessage 
 * @param {string} logfile Defaults to A_ScriptDir "\WizardsWheel2.log" but is 
 * overwritable
 */
Log(logmessage, logfile := A_ScriptDir "\WizardsWheel2.log") {
    static isWritingToLog := false
    message := FormatTime(, 'MM/dd/yyyy hh:mm:ss:' A_MSec) ' - ' logmessage '`r`n'
    OutputDebug(message)
/*     if (!EnableLogging) {
        return
    } */
    k := 0
    try {
        if (!isWritingToLog) {
            isWritingToLog := true
            Sleep(1)
            FileAppend(message, logfile)
            isWritingToLog := false

        }
    } catch as exc {
        OutputDebug("LogError: Error writing to log - " exc.Message "`r`n")
        ; MsgBox("Error writing to log:`n" exc.Message)
        Sleep(1)
        FileAppend(message, logfile)
        Sleep(1)
        FileAppend(FormatTime(, 'MM/dd/yyyy hh:mm:ss:' A_MSec) ' - '
            "LogError: Error writing to log - " exc.Message '`r`n', logfile)
    }
}

cReload() {
    if (false) {
        ExitApp()
    }
    Reload()
}

IsLBRScriptActive() {
    if (WinExist("\LeafBlowerV3.ahk ahk_class AutoHotkey")) {
        return true
    }
    return false
}

IsRoundActive() {
    colour := PixelGetColor(WinRelPosLargeW(2552), WinRelPosLargeH(364))
    if (colour = "0x3B8D9E" || ; normal
        colour = "0x7E1084" || ; normal purple
        colour = "0x84ADCF") { ; Winter
            return true
    }
    if (false) {
        Log("Round active false: " colour)
    }
    return false
}

IsGemBuffActive() {
    ;1074 274 1490 315
    found := PixelSearch(&OutX, &OutY, WinRelPosLargeW(1074), WinRelPosLargeH(274),
        WinRelPosLargeW(1490), WinRelPosLargeH(315), "0xFBFF00", 0)
    if (found && OutX > 0) { ; Found yellow of buff
        return true
    }
    found := PixelSearch(&OutX, &OutY, WinRelPosLargeW(1074), WinRelPosLargeH(274),
        WinRelPosLargeW(1490), WinRelPosLargeH(315), "0xE3E580", 0)
    if (found && OutX > 0) { ; Found yellow of buff
        return true
    }
    return false
}

IsJewelBuffActive() {
    colour := PixelGetColor(WinRelPosLargeW(2377), WinRelPosLargeH(491))
    if (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
        return true
    }
    Log("Jewel col " colour)
    return false
}

IsLevelDragonPike() {
    colour := PixelGetColor(WinRelPosLargeW(2280), WinRelPosLargeH(20))
    if (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
        return true
    }
    Log("Area Sample Col " colour)
    return false
}

global lastWizardColour := ""

IsWizardSpotChanged() {
    global lastWizardColour
    colour := PixelGetColor(WinRelPosLargeW(2065), WinRelPosLargeH(1300))
    if (colour != "0xFFFFFF" || colour != "0x000000") {
        return false
    }
    if (lastWizardColour = "") {
        lastWizardColour := colour
        return false
    }
    if (colour != lastWizardColour) {
        lastWizardColour := colour
        return true
    }
    return false
}

BinToStr(var) {
    if (var) {
        return "true"
    } else {
        return "false"
    }
}