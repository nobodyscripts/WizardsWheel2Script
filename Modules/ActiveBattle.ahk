#Requires AutoHotkey v2.0

fActiveBattle() {
    static toggle := true
    if (toggle = false) {
        ToolTip()
    } else {
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
    ;2392 1272 (1440)
    If (!Window.Activate()) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    if (!IsRoundActive()) {
        return
    }
    if (Window.IsActive()) {
        ToolTip("Wheel check", 100, 100, 2)
        If (spamTen = false) {
            HasWheelSlowed()
            return
        }
        Loop 15 {
            cPoint(1204, 630).Click()
            Sleep(34)
        }
    }
}

HasWheelSlowed() {
    OutX := 0
    OutY := 0
    try {
        X1 := "" ; WinRelPosLargeW(2300)
        Y1 := "" ; WinRelPosLargeH(1150)
        X2 := "" ; WinRelPosLargeW(2480)
        Y2 := "" ; WinRelPosLargeH(1220)

        if (Window.IsActive()) {
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
        if (Window.IsActive()) {
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
        if (Window.IsActive()) {
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
    if (!Window.Exist()) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    Window.Activate()
    if (!IsRoundActive()) {
        return
    }
    if (Window.IsActive()) {
        ToolTip("Skill check", 100, 120, 3)
        cPoint(1125, 460, 51).Click() ; (skill 1, left)
        cPoint(1125, 460, 51).Click() ; (skill 1, left)
        Sleep(51)
        cPoint(1180, 460, 51).Click() ; (skill 2, center)
        cPoint(1180, 460, 51).Click() ; (skill 2, center)
        Sleep(51)
        cPoint(1250, 460, 51).Click() ; (skill 3, right)
        cPoint(1250, 460, 51).Click() ; (skill 3, right)
    }
}

fWWClickMimics() {
    ; tongue colour e86a73
    ; 520 320 (1440)
    ; 2070 840 br corner

    if (!Window.Exist()) {
        MsgBox("Wizard's Wheel 2: Window not found")
        Reload()
        return ; Kill the loop if the window closes
    }
    Window.Activate()
    if (!IsRoundActive()) {
        return
    }
    ToolTip("Mimic check", 100, 140, 4)
    OutX := 0
    OutY := 0
    try {
        X1 := "" ; WinRelPosLargeW(520)
        Y1 := "" ; WinRelPosLargeH(320)
        X2 := "" ; WinRelPosLargeW(2070)
        Y2 := "" ; WinRelPosLargeH(840)

        if (Window.IsActive()) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0xE86A73", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(200)
                return
            }
        }
        ; Halloween version
        if (Window.IsActive()) {
            found := PixelSearch(&OutX, &OutY, X1, Y1, X2, Y2, "0x88569A", 0)
            If (found and OutX != 0) {
                fCustomClick(OutX, OutY)
                Sleep(200)
                return
            }
        }
        ; Winter version
        if (Window.IsActive()) {
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
        ; ToolTip("Gem Buff Expired", Window.W / 2, WinRelPosLargeH(50), 8)
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
        ; ToolTip("Jewel Buff Expired", W / 1.5, WinRelPosLargeH(50), 7)
        JewelBuffPingCount++
    }
    if (IsJewelBuffActive()) {
        JewelBuffPingCount := 0
        ToolTip(, , , 7)
    }
}

HasWizardAppeared() {
    if (IsRoundActive() && IsWizardSpotChanged()) {
        cPoint(, ).Click()
        ;fSlowClickRelL(2066, 1305)
    }
}

HasGameReachedDragonsPike() {
    if (IsRoundActive() && IsLevelDragonPike()) {
        cPoint(, ).Click()
        ;fSlowClickRelL(2400, 155)
        Sleep(51)
        cPoint(, ).Click()
        ;fSlowClickRelL(2400, 155)
        Sleep(51)
        cPoint(, ).Click()
        ;fSlowClickRelL(2400, 155)
        Sleep(51)
        cPoint(, ).Click()
        ;fSlowClickRelL(2400, 155)
        Sleep(51)
        ;MouseClickDrag("L", WinRelPosLargeW(1400), 1340, WinRelPosLargeW(1400), 250)
        Sleep(51)
        cPoint(, ).Click()
        ;fSlowClickRelL(2220, 600)
    }
}

fWWBuyGemBoost() {

}

fWWUseJewelBoost() {

}