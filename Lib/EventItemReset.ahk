#Requires AutoHotkey v2.0

fEventItemReset() {
    socketcount := 0
    itemcount := 0
    starttime := A_Now
    isArmourSlot := true
    storeSlot := 4
    RequirePerfect := false
    RequireGood := true
    RequireSocket := true
    Log("Started")
    loop {
        if (!WinActive(WW2WindowTitle)) {
            Log("Window not found, closing event item reset.")
            return
        }
        isSocketed := false
        isPerfect := false
        isGood := false
        Sleep(300)

        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 34) ; Close inv
            Sleep(150)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 101) ; Close inv
            Sleep(150)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1020, 55, 101) ; Close inv
            Sleep(650)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1238, 31, 51) ; Options
            Sleep(550)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(946, 381, 51) ; Load Save
            Sleep(2500)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(624, 525, 51) ; Play
            Sleep(2000)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(915, 231, 51) ; Igloo
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            switch storeSlot {
                case 1:
                    fSlowClick(535, 250, 51) ; Buy row 1 l
                case 2:
                    fSlowClick(960, 250, 51) ; Buy row 1 r
                case 3:
                    fSlowClick(551, 343, 51) ; Buy row 2 l
                case 4:
                    fSlowClick(960, 343, 51) ; Buy row 2 r
                case 5:
                    fSlowClick(551, 431, 51) ; Buy row 3 l
                case 6:
                    fSlowClick(960, 431, 51) ; Buy row 3 r
                default:
                    fSlowClick(535, 250, 51) ; Buy row 1 l
            }
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1014, 57, 51) ; Close shop
            Sleep(400)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(1052, 624, 51) ; Open inv
            Sleep(400)
        }
        itemcount++
        ItemFarmTooltop(itemcount, socketcount, starttime,
            RequireGood, RequirePerfect, RequireSocket)
        if (WinActive(WW2WindowTitle)) {
            if (!isArmourSlot) {
                ; Weapon slot
                colourSocket := PixelGetColor(WinRelPosW(244), WinRelPosH(279))
                if (colourSocket = "0xFCAE35") {
                    Log("Found Socket")
                    socketcount++
                    isSocketed := true
                }
                if (WinActive(WW2WindowTitle)) {
                    ItemFarmTooltop(itemcount, socketcount, starttime,
                        RequireGood, RequirePerfect, RequireSocket)
                    fSlowClick(350, 275, 51) ; Open weapon item
                }
            }
            if (isArmourSlot) {
                ; Armour slot
                colourSocket := PixelGetColor(WinRelPosW(525), WinRelPosH(270))
                if (colourSocket = "0xFCAE35") {
                    Log("Found Socket")
                    socketcount++
                    isSocketed := true
                }
                if (WinActive(WW2WindowTitle)) {
                    ItemFarmTooltop(itemcount, socketcount, starttime,
                        RequireGood, RequirePerfect, RequireSocket)
                    fSlowClick(630, 275, 51) ; Open armour item
                }
            }
            if (WinActive(WW2WindowTitle)) {
                Sleep(72)
                MouseMove(WinRelPosW(1050), WinRelPosH(624))
                Sleep(1000)
            }
            try {
                found := ImageSearch(&OutX, &OutY,
                    WinRelPosW(190), WinRelPosH(120),
                    WinRelPosW(916), WinRelPosH(491), A_ScriptDir "\Images\QualityPerfect.png")
                if (found) {
                    isPerfect := true
                }
                found := ImageSearch(&OutX, &OutY,
                    WinRelPosW(190), WinRelPosH(120),
                    WinRelPosW(916), WinRelPosH(491), A_ScriptDir "\Images\Quality9.png")
                If (found) {
                    isGood := true
                }

            } catch as exc {
                Log("Error searc failed - " exc.Message)
                MsgBox("Could not conduct the search due to the following error:`n"
                    exc.Message)
            }
            If (RequireGood && isGood) {
                if (RequireSocket && isSocketed) {
                    Log("Found 90% socketed")
                    return
                }
                if (!RequireSocket) {
                    Log("Found 90%")
                    return
                }
            }

            If ((RequireGood || RequirePerfect) && isPerfect) {
                if (RequireSocket && isSocketed) {
                    Log("Found 100% socketed")
                    return
                }
                if (!RequireSocket) {
                    Log("Found 100%")
                    return
                }
            }
            if (!RequireGood && !RequirePerfect && RequireSocket && isSocketed) {
                Log("Found any socketed")
                return
            }
            if (!RequireGood && !RequirePerfect && !RequireSocket) {
                Log("Found any? Set a requirement.")
            }
            if (WinActive(WW2WindowTitle)) {
                Sleep(50)
                fSlowClick(1015, 56, 72) ; Close item
                Sleep(500)
            }
        }
    }
}


ItemFarmTooltop(itemcount, socketcount, starttime, RequireGood, RequirePerfect,
    RequireSocket) {
        timediff := DateDiff(A_Now, starttime, "Seconds")
        if (itemcount > 0 && socketcount > 0) {
            ratio := socketcount / itemcount * 100
            ratio := Format("{1:.2f}", ratio)
        } else {
            ratio := 0
        }
        ToolTip("Found " itemcount
            " Items`n" socketcount " of which sockets`n"
            ratio "% of socketed`nSeconds Taken " timediff 
            "`nRequire 90%: " BinToStr(RequireGood)
            "`nRequire 100%: " BinToStr(RequirePerfect)
            "`nRequire socketed: " BinToStr(RequireSocket),
            WinRelPosW(20), H / 2 - WinRelPosH(30), 7)
}