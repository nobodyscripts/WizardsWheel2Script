#Requires AutoHotkey v2.0

#Include cHotkeysInitScript.ahk

#Include cTravel.ahk

#Include ..\Navigate\Header.ahk

Global DisableZoneChecks := false
Global NavigateTime := 150

IsAreaSampleColour(targetColour := "0xFFFFFF") {
    If (Points.Misc.ZoneSample.GetColour() = targetColour) {
        Return true
    }
    Return false
}

GetAreaSampleColour() {
    Return Points.Misc.ZoneSample.GetColour()
}
