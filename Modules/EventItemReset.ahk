#Requires AutoHotkey v2.0

global EventItemTypeArmour := 0,
    EventItemAmount := 1,
    EventItemGood := 0,
    EventItemPerfect := 0,
    EventItemSocketed := 0,
    EventItemStoreSlot := 1

fEventItemReset() {
        Static on10 := False
        Log("F10: Pressed")
        if (!IsInteger(EventItemAmount)) {
            MsgBox("Amount must be an integer. Exiting.")
            Reload()
        }
        If (on10 := !on10) {
            Count := EventItemAmount
            Num := 1 ; Iterator
            starttime := A_Now
            Log("Started")
            if (Count = 1) {
                GetGoodItem(Num, starttime)
            } else {
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
        } Else {
            Reload()
        }
}

GetGoodItem(Num, starttime) {
    socketcount := 0
    itemcount := 0
    isArmourSlot := EventItemTypeArmour ; Which slot to check for the new item
    storeSlot := EventItemStoreSlot ; Which slot to purchase from, tl, tr, l, r, l2, r2, bl, br
    RequireGood := EventItemGood ; 90% or higher
    RequirePerfect := EventItemPerfect ; Unless you really need perfects save time with it off
    RequireSocket := EventItemSocketed ; Always valuable
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

        i := 20
        while (WinActive(WW2WindowTitle) && CloseButton.GetColour() = "0xF50000") {
            CloseButton.ClickOffset()
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 1")
                return
            }
        }

        i := 20
        while (cOptionsOpenButton().GetColour() != "0xBDCBDE") {
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 2")
                Log("Colour 2 " cOptionsOpenButton().GetColour())
                return
            }
        }

        i := 20
        while (WinActive(WW2WindowTitle) && cOptionsOpenButton().GetColour() = "0xBDCBDE") {
            cOptionsOpenButton().ClickOffset(, , 54)
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 3")
                return
            }
        }
        while (cOptionsLoadSaveButton().GetColour() != "0x9FEDAC" &&
            (cOptionsNewCopySaveButton().GetColour() != "0x9FEDAC" &&
                cOptionsNewCloudSaveButton().GetColour() != "0x9FEDAC")) {
                    ; wait for save load button
                    Sleep(50)
                    i--
                    if (i = 0) {
                        Log("Failure at 15")
                        Log(cOptionsLoadSaveButton().GetColour() " "
                            cOptionsNewCopySaveButton().GetColour() " "
                            cOptionsNewCloudSaveButton().GetColour())
                        return
                    }
        }
        if (cOptionsNewCopySaveButton().GetColour() = "0x9FEDAC" &&
            cOptionsNewCloudSaveButton().GetColour() = "0x9FEDAC") {
                ;Is new ui
                cOptionsNewLoadSaveButton().ClickOffset(, , 54) ; Load Save
                Sleep(150)
        } else {
            ;Is old ui
            if (WinActive(WW2WindowTitle)) {
                fSlowClick(946, 381, 51) ; Load Save
            }
        }
        i := 20
        while (!IsPlayButtonSeen()) {
            Sleep(100)
            i--
            if (i = 0) {
                Log("Failure at 5")
                return
            }
        }

        if (WinActive(WW2WindowTitle)) {
            fSlowClick(624, 525, 51) ; Play
        }

        i := 20
        while (!IsVillageLoaded()) {
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 6")
                return
            }
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

        i := 20
        While (WinActive(WW2WindowTitle) && cIglooCloseButton().GetColour() != "0xF50000") {
            Log(cIglooCloseButton().GetColour())
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 7")
                return
            }
        }

        i := 20
        while (WinActive(WW2WindowTitle) && cIglooCloseButton().GetColour() = "0xF50000") {
            cIglooCloseButton().ClickOffset()
            Sleep(250)
            i--
            if (i = 0) {
                Log("Failure at 8")
                return
            }
        }

        i := 20
        While (WinActive(WW2WindowTitle) && cInventoryOpenButton().GetColour() != "0xEFCF84") {
            Sleep(50)
            i--
            if (i = 0) {
                Log("Failure at 9")
                return
            }
        }

        i := 20
        While (WinActive(WW2WindowTitle) && cInventoryOpenButton().GetColour() = "0xEFCF84") {
            cInventoryOpenButton().ClickOffset() ; Open inv
            Sleep(400)
            i--
            if (i = 0) {
                Log("Failure at 10")
                return
            }
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
    i := 20
    While (WinActive(WW2WindowTitle) && cInventoryStorageButton().GetColour() = "0x007EF5") {
        cInventoryStorageButton().ClickOffset(, , 54)
        Sleep(150)
        i--
        if (i = 0) {
            Log("Failure at 11")
            return
        }
    }

    i := 20
    while (WinActive(WW2WindowTitle) && cInventoryCloseButton().GetColour() = "0xF50000") {
        cInventoryCloseButton().ClickOffset(, , 54)
        Sleep(150)
        i--
        if (i = 0) {
            Log("Failure at 12")
            return
        }
    }

    i := 20
    while (WinActive(WW2WindowTitle) && cOptionsCloseButton().GetColour() = "0xF50000") {
        Log("Closing window")
        cOptionsCloseButton().ClickOffset()
        Sleep(50)
        i--
        if (i = 0) {
            Log("Failure at 16")
            return
        }
    }

    i := 20
    while (cOptionsOpenButton().GetColour() != "0xBDCBDE") {
        Sleep(50)
        i--
        if (i = 0) {
            Log("Failure at 13")
            Log("Colour 13 " cOptionsOpenButton().GetColour())
            return
        }
    }
    i := 20
    while (WinActive(WW2WindowTitle) && cOptionsOpenButton().GetColour() = "0xBDCBDE") {
        cOptionsOpenButton().ClickOffset(, , 54)
        Sleep(150)
        i--
        if (i = 0) {
            Log("Failure at 14")
            return
        }
    }
    i := 20
    while (cOptionsCopySaveButton().GetColour() != "0x9FEDAC" ||
        (cOptionsNewCopySaveButton().GetColour() != "0x9FEDAC" &&
            cOptionsNewCloudSaveButton().GetColour() != "0x9FEDAC")) {
                ; wait for save load button
                Sleep(50)
                i--
                if (i = 0) {
                    Log("Failure at 15")
                    return
                }
    }
    if (cOptionsNewCopySaveButton().GetColour() = "0x9FEDAC" &&
        cOptionsNewCloudSaveButton().GetColour() = "0x9FEDAC") {
            ;Is new ui
            cOptionsNewCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
            cOptionsNewCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
            cOptionsNewCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
    } else {
        ;Is old ui
        if (WinActive(WW2WindowTitle)) {
            cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
            cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
            cOptionsCopySaveButton().ClickOffset(, , 54) ; Copy Save
            Sleep(150)
        }
    }
    i := 20
    while (WinActive(WW2WindowTitle) && cOptionsCloseButton().GetColour() = "0xF50000") {
        Log("Closing window")
        cOptionsCloseButton().ClickOffset()
        Sleep(50)
        i--
        if (i = 0) {
            Log("Failure at 16")
            return
        }
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