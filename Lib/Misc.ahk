#Requires AutoHotkey v2.0

IsLBRScriptActive() {
    If (WinExist("\LeafBlowerV3.ahk ahk_class AutoHotkey")) {
        Return true
    }
    Return false
}
