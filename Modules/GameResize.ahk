#Requires AutoHotkey v2.0

fGameResize() {
    global W, H, X, Y, WW2WindowTitle
    WinMove(, , 1294, 703, WW2WindowTitle)
    WinWait(WW2WindowTitle)

    if WinExist(WW2WindowTitle) {
        WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle)
        if (W != "1278" || H != "664") {
            Log("Resized window to 1294*703 client size should be 1278*664, found: " W "*" H)
        }
    }
}