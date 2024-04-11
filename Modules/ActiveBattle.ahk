#Requires AutoHotkey v2.0

fActiveBattle() {
    static toggle := true
    if (toggle = false) {
        ToolTip()
    } else {
        Log("X " X ", Y " Y ", W " W ", H " H)
        ToolTip("Active wheel clicking", 100, 80)
        fWWClickWheel(true) ; Run as timer doesn't execute straight away
        fWWClickSkills()
        fWWClickMimics()
    }
    SetTimer(fWWClickWheel, 72 * (toggle))
    SetTimer(fWWClickSkills, 50000 * (toggle))
    SetTimer(fWWClickMimics, 72 * (toggle))
    SetTimer(HasGemBuffExpired, 1000 * (toggle))
    SetTimer(HasJewelBuffExpired, 1000 * (toggle))
    SetTimer(HasWizardAppeared, 1000 * (toggle))

    toggle := !toggle
}

fWWClickWheel(spamTen := false) {
    global X, Y, W, H
    ;2392 1272 (1440)
    If (!WinExist(WW2WindowTitle)) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    if (!WinActive(WW2WindowTitle)) {
        WinActivate() ; Use the window found by WinExist.
        WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle) ; Update window size
    }
    if (!IsRoundActive()) {
        return
    }
    if (WinActive(WW2WindowTitle)) {
        ToolTip("Wheel check", 100, 100, 2)
        If (spamTen = false) {
            HasWheelSlowed()
            return
        }
        Loop 15 {
            fSlowClick(1204, 630)
            Sleep(34)
        }
    }
}

HasWheelSlowed() {
    OutX := 0
    OutY := 0
    try {
        X1 := WinRelPosLargeW(2300)
        Y1 := WinRelPosLargeH(1150)
        X2 := WinRelPosLargeW(2480)
        Y2 := WinRelPosLargeH(1220)

        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0xFFFFFF", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(1000)
            }
        }

        ; Halloween filter
        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0x9F9FE5", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(1000)
            }
        }

        ; Winter filter
        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0xE5E5FF", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(34)
                fCustomClick(OutX, OutY)
                Sleep(1000)
            }
        }
    } catch as exc {
        MsgBox("Could not conduct the search due to the following error:`n"
            exc.Message)
        return
    }
}

fWWClickSkills() {
    global X, Y, W, H
    if (!WinExist(WW2WindowTitle)) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    if (!WinActive(WW2WindowTitle)) {
        WinActivate() ; Use the window found by WinExist.
        WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle) ; Update window size
    }
    if (!IsRoundActive()) {
        return
    }
    if (WinActive(WW2WindowTitle)) {
        ToolTip("Skill check", 100, 120, 3)
        fSlowClick(1125, 460, 51) ; (skill 1, left)
        fSlowClick(1125, 460, 51) ; (skill 1, left)
        Sleep(51)
        fSlowClick(1180, 460, 51) ; (skill 2, center)
        fSlowClick(1180, 460, 51) ; (skill 2, center)
        Sleep(51)
        fSlowClick(1250, 460, 51) ; (skill 3, right)
        fSlowClick(1250, 460, 51) ; (skill 3, right)
    }
}

fWWClickMimics() {
    global X, Y, W, H
    ; tongue colour e86a73
    ; 520 320 (1440)
    ; 2070 840 br corner

    if (!WinExist(WW2WindowTitle)) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    if (!WinActive(WW2WindowTitle)) {
        return
    }
    WinActivate() ; Use the window found by WinExist.
    WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle) ; Update window size
    if (!IsRoundActive()) {
        return
    }
    ToolTip("Mimic check", 100, 140, 4)
    OutX := 0
    OutY := 0
    try {
        X1 := WinRelPosLargeW(520)
        Y1 := WinRelPosLargeH(320)
        X2 := WinRelPosLargeW(2070)
        Y2 := WinRelPosLargeH(840)

        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0xE86A73", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(200)
                return
            }
        }
        ; Halloween version
        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0x88569A", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(200)
                return
            }
        }
        ; Winter version
        if (WinActive(WW2WindowTitle)) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0xE1B6CB", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(200)
                return
            }
        }
    } catch as exc {
        MsgBox("Could not conduct the search due to the following error:`n"
            exc.Message)
        return
    }
}

global GemBuffPingCount := 0
HasGemBuffExpired() {
    global GemBuffPingCount
    if (!IsGemBuffActive() && IsRoundActive()) {
        if (GemBuffPingCount < 5) {
            SoundBeep()
        }
        ToolTip("Gem Buff Expired", W / 2, WinRelPosLargeH(50), 8)
        GemBuffPingCount++
    }
    if (IsGemBuffActive()) {
        GemBuffPingCount := 0
        ToolTip(, , , 8)
    }
}

global JewelBuffPingCount := 0
HasJewelBuffExpired() {
    global JewelBuffPingCount
    if (!IsJewelBuffActive() && IsRoundActive()) {
        if (JewelBuffPingCount < 5) {
            SoundBeep()
        }
        ToolTip("Jewel Buff Expired", W / 1.5, WinRelPosLargeH(50), 7)
        JewelBuffPingCount++
    }
    if (IsJewelBuffActive()) {
        JewelBuffPingCount := 0
        ToolTip(, , , 7)
    }
}

HasWizardAppeared() {
    if (IsRoundActive() && IsWizardSpotChanged()) {
        fSlowClickRelL(2066, 1305)
    }
}

HasGameReachedDragonsPike() {
    if (IsRoundActive() && IsLevelDragonPike()) {
        fSlowClickRelL(2400, 155)
        Sleep(51)
        fSlowClickRelL(2400, 155)
        Sleep(51)
        fSlowClickRelL(2400, 155)
        Sleep(51)
        fSlowClickRelL(2400, 155)
        Sleep(51)
        MouseClickDrag("L", WinRelPosLargeW(1400), 1340, WinRelPosLargeW(1400), 250)
        Sleep(51)
        fSlowClickRelL(2220, 600)
    }
}

fWWBuyGemBoost() {

}

fWWUseJewelBoost() {

}