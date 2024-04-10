#Requires AutoHotkey v2.0

fEventItemReset() {
    Count := 4 ; Amount
    Num := 1 ; Don't edit
    starttime := A_Now
    Log("Started")
    while (Count > 0) {
        Log("Getting item " Num)
        GetGoodItem(Num, starttime)
        Sleep(300)
        StoreGoodItem()
        Sleep(300)
        Count--
        Num++
    }
}

GetGoodItem(Num, starttime) {
    socketcount := 0
    itemcount := 0
    isArmourSlot := true ; Which slot to check for the new item
    storeSlot := 1 ; Which slot to purchase from, tl, tr, l, r, l2, r2, bl, br
    RequirePerfect := false ; Unless you really need perfects save time with it off
    RequireGood := true ; 90% or higher
    RequireSocket := true ; Always valuable
    CloseButton := cInventoryCloseButton()
    loop {
        if (!WinActive(WW2WindowTitle)) {
            Log("Window not found, closing event item reset.")
            return
        }
        isSocketed := false
        isPerfect := false
        isGood := false
        Sleep(300)

        while (WinActive(WW2WindowTitle) && CloseButton.GetColour() = "0xF50000") {
            CloseButton.ClickOffset()
            Sleep(50)
        }
        while (cOptionsOpenButton().GetColour() != "0xBDCBDE"){
            Sleep(50)
        }
        while (WinActive(WW2WindowTitle) && cOptionsOpenButton().GetColour() = "0xBDCBDE") {
            cOptionsOpenButton().ClickOffset(, , 54)
            Sleep(50)
        }
        while (cOptionsLoadSaveButton().GetColour() != "0x9FEDAC"){
            ; wait for save load button
            Sleep(50)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(946, 381, 51) ; Load Save
        }
        while (!IsPlayButtonSeen()) {
            Sleep(100)
        }
        if (WinActive(WW2WindowTitle)) {
            fSlowClick(624, 525, 51) ; Play
        }
        while (!IsVillageLoaded()) {
            Sleep(50)
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
        While (WinActive(WW2WindowTitle) && cIglooCloseButton().GetColour() != "0xF50000") {
            Log(cIglooCloseButton().GetColour())
            Sleep(50)
        }
        while (WinActive(WW2WindowTitle) && cIglooCloseButton().GetColour() = "0xF50000") {
            cIglooCloseButton().ClickOffset()
            Sleep(250)
        }
        While (WinActive(WW2WindowTitle) && cInventoryOpenButton().GetColour() != "0xEFCF84") {
            Sleep(50)
        }
        While (WinActive(WW2WindowTitle) && cInventoryOpenButton().GetColour() = "0xEFCF84") {
            cInventoryOpenButton().ClickOffset() ; Open inv
            Sleep(400)
        }
        itemcount++
        ItemFarmTooltop(itemcount, socketcount, starttime,
            RequireGood, RequirePerfect, RequireSocket, Num)
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
                        RequireGood, RequirePerfect, RequireSocket, Num)
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
                        RequireGood, RequirePerfect, RequireSocket, Num)
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
                found := ImageSearch(&OutX, &OutY,
                    WinRelPosW(190), WinRelPosH(120),
                    WinRelPosW(916), WinRelPosH(491), A_ScriptDir "\Images\Quality09.png")
                If (found) {
                    isGood := false
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

StoreGoodItem() {
    While (WinActive(WW2WindowTitle) && cInventoryStorageButton().GetColour() = "0x007EF5") {
        cInventoryStorageButton().ClickOffset(, , 54)
        Sleep(150)
    }

    while (WinActive(WW2WindowTitle) && cInventoryCloseButton().GetColour() = "0xF50000") {
        cInventoryCloseButton().ClickOffset(, , 54)
        Sleep(150)
    }
    while (cOptionsOpenButton().GetColour() != "0xBDCBDE"){
        Sleep(50)
    }
    while (WinActive(WW2WindowTitle) && cOptionsOpenButton().GetColour() = "0xBDCBDE") {
        cOptionsOpenButton().ClickOffset(, , 54)
        Sleep(150)
    }
    while (cOptionsCopySaveButton().GetColour() != "0x9FEDAC"){
        ; wait for save load button
        Sleep(50)
    }
    if (WinActive(WW2WindowTitle)) {
        cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
        Sleep(150)
        cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
        Sleep(150)
        cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
        Sleep(150)
    }
    while (WinActive(WW2WindowTitle) && cOptionsCloseButton().GetColour() = "0xF50000") {
        Log("Closing window")
        cOptionsCloseButton().ClickOffset()
        Sleep(50)
    }
}

ItemFarmTooltop(itemcount, socketcount, starttime, RequireGood, RequirePerfect,
    RequireSocket, Num) {
        timediff := DateDiff(A_Now, starttime, "Seconds")
        if (itemcount > 0 && socketcount > 0) {
            ratio := socketcount / itemcount * 100
            ratio := Format("{1:.2f}", ratio)
        } else {
            ratio := 0
        }
        ToolTip("Stored " Num - 1 " correct items.`nFound " itemcount
            " Items`n" socketcount " of which sockets`n"
            ratio "% of socketed`nSeconds Taken " timediff
            "`nRequire 90%: " BinToStr(RequireGood)
            "`nRequire 100%: " BinToStr(RequirePerfect)
            "`nRequire socketed: " BinToStr(RequireSocket),
            WinRelPosW(20), H / 2 - WinRelPosH(30), 7)
}

IsPlayButtonSeen() {
    playbutton := cPlayButtonTest()
    if (playbutton.GetColour() = "0xBC00F5") {
        return true
    }
    return false
}

IsVillageLoaded() {
    uiPanel := cVillageLoadedTest()
    if (uiPanel.GetColour() = "0x3B8D9E") {
        return true
    }
    return false
}