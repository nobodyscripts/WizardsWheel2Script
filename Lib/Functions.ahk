#Requires AutoHotkey v2.0

#Include Logging.ahk
#Include cPoints.ahk
#Include cRects.ahk
#Include cToolTip.ahk
; ------------------- Functions -------------------

; Custom clicking function, uses given coords no relative correction
fCustomClick(clickX, clickY, delay := 34) {
    If (!Window.IsActive()) {
        Out.I("No window found while trying to click at " clickX " * " clickY)
        Return false
    }
    MouseClick("left", clickX, clickY, , , "D")
    Sleep(delay)
    MouseClick("left", clickX, clickY, , , "U")
    Out.V("Clicking at " cPoint(clickX, clickY, false).toStringDisplay())
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
    Try {
        ; if no width, and y has length
        If (x1 = x2 && y1 < y2) {
            ; Starting point
            i := y1
            While (i <= y2) {
                colour := PixelGetColor(x1, i)
                If (foundArr.Length = 0 || lastColour != colour) {
                    foundArr.Push({
                        x: x1,
                        y: i,
                        colour: colour
                    })
                    lastColour := colour
                }
                i++
            }
            Return foundArr
        }
        ; if no height, and x has length
        If (y1 = y2 && x1 < x2) {
            ; Starting point
            i := x1
            While (i <= x2) {
                colour := PixelGetColor(i, y1)
                If (foundArr.Length = 0 || foundArr[foundArr.Length].colour !=
                    colour) {
                    foundArr.Push({
                        x: i,
                        y: y1,
                        colour: colour
                    })
                }
                i++
            }
            Return foundArr
        }
    } Catch As exc {
        Out.I("Error 9: LineGetColourInstances check failed - " exc.Message)
        MsgBox("Could not conduct the search due to the following error:`n" exc
            .Message)
    }
    Return false
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
    While splitCur < splitCount {
        yTop := y1 + (splitCur * splitSize)
        yBot := y1 + ((splitCur + 1) * splitSize)
        result := cRect(x, yTop, x, yBot).PixelSearch(colour)
        If (result) {
            ; Out.D("Found in segment " splitCur " at " result[1] " by " result[2])
            found++
            foundArr.Push(result[2])
        }
        splitCur++
    }
    If (found) {
        Return foundArr
    }
    Return false
}

cReload(*) {
    Reload()
}

ReloadIfNoGame() {
    If (!Window.Exist() || !Window.IsActive()) {
        cReload() ; Kill if no game
        Return
    }
}

InitScriptHotKey() {
    ReloadIfNoGame()
}

BinaryToStr(var) {
    If (var) {
        Return "true"
    }
    Return "false"
}

ArrToCommaDelimStr(var) {
    output := ""
    If (Type(var) = "String") {
        If (var = "") {
            Return false
        }
        Return var
    }
    If (var.Length > 1) {
        For text in var {
            If (output != "") {
                output := output ", " text
            } Else {
                output := text
            }
        }
        Return output
    } Else {
        Return false
    }
}

CommaDelimStrToArr(var) {
    Return StrSplit(var, " ", ",.")
}

IsLBRScriptActive() {
    If (WinExist("\LeafBlowerV3.ahk ahk_class AutoHotkey")) {
        Return true
    }
    Return false
}

IsRoundActive() {
    colour := cPoint(,)
    If (colour = "0x3B8D9E" || ; normal
        colour = "0x7E1084" || ; normal purple
        colour = "0x84ADCF") { ; Winter
        Return true
    }
    If (false) {
        Out.I("Round active false: " colour)
    }
    Return false
}

IsGemBuffActive() {
    ;1074 274 1490 315
    found := cRect(, , ,)
    ;found := PixelSearch(&OutX, &OutY, WinRelPosLargeW(1074), WinRelPosLargeH(274),
    ;WinRelPosLargeW(1490), WinRelPosLargeH(315), "0xFBFF00", 0)
    If (found && found[1] > 0) { ; Found yellow of buff
        Return true
    }
    found := cRect(, , ,)
    ;found := PixelSearch(&OutX, &OutY, WinRelPosLargeW(1074), WinRelPosLargeH(274),
    ;WinRelPosLargeW(1490), WinRelPosLargeH(315), "0xE3E580", 0)
    If (found && found[1] > 0) { ; Found yellow of buff
        Return true
    }
    Return false
}

IsJewelBuffActive() {
    colour := cPoint(,)
    ; colour := PixelGetColor(WinRelPosLargeW(2377), WinRelPosLargeH(491))
    If (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
        Return true
    }
    Out.I("Jewel col " colour)
    Return false
}

IsLevelDragonPike() {
    colour := cPoint(,)
    ; colour := PixelGetColor(WinRelPosLargeW(2280), WinRelPosLargeH(20))
    If (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
        Return true
    }
    Out.I("Area Sample Col " colour)
    Return false
}

Global lastWizardColour := ""

IsWizardSpotChanged() {
    Global lastWizardColour
    colour := cPoint(,)
    ; colour := PixelGetColor(WinRelPosLargeW(2065), WinRelPosLargeH(1300))
    If (colour != "0xFFFFFF" || colour != "0x000000") {
        Return false
    }
    If (lastWizardColour = "") {
        lastWizardColour := colour
        Return false
    }
    If (colour != lastWizardColour) {
        lastWizardColour := colour
        Return true
    }
    Return false
}

BinToStr(var) {
    If (var) {
        Return "true"
    } Else {
        Return "false"
    }
}

IsBool(var) {
    If (IsInteger(var) && (var = 0 || var = 1)) {
        Return true
    }
    Return false
}
