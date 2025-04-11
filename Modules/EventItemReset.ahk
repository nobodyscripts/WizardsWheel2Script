#Requires AutoHotkey v2.0

Global EventItemTypeArmour := 0,
    EventItemAmount := 1,
    EventItemGood := 0,
    EventItemPerfect := 0,
    EventItemSocketed := 0,
    EventItemStoreSlot := 1,
    EventItemID := 1

; ID 1 winter
; ID 2 Easter
; ID 3 St patricks
; ID 4 Halloween
; ID 5 Valentines

fEventItemReset() {
    Static on10 := False
    Out.I("F10: Pressed")
    Window.Activate()
    If (!IsInteger(EventItemAmount)) {
        MsgBox("Amount must be an integer. Exiting.")
        Reload()
    }
    If (on10 := !on10) {
        Count := EventItemAmount
        Num := 1 ; Iterator
        starttime := A_Now
        Out.I("Started")
        /** @type {cRect} */
        var := cRect(190, 120, 816, 491)
        If (var.ImageSearch(A_ScriptDir "\Images\QualityPerfect.png")) {
            Out.D("perfect")
        }
        If (var.ImageSearch(A_ScriptDir "\Images\Quality9.png")) {
            Out.D("9")
        }
        If (var.ImageSearch(A_ScriptDir "\Images\Quality09.png")) {
            Out.D("09")
        }
        /* 
        EventItems().GetStartSave()
        If (Count = 1) {
            If (!EventItems().GetGoodItem(Num, starttime)) {
                Reload()
            }
        } Else {
            While (Count > 0) {
                Out.I("Getting item " Num)
                If (!EventItems().GetGoodItem(Num, starttime)) {
                    Break
                }
                Sleep(300)
                EventItems().StoreGoodItem()
                Sleep(300)
                Count--
                Num++
            }
            Reload()
        } */
    } Else {
        Reload()
    }
}

/**
 * VillagePoints Collection of cPoints for the village screens
 * @module VillagePoints
 * @property {cPoint} pUITest Desc
 * @property {cPoint} pInventoryStorage Desc
 * @property {cPoint} pIglooClose Desc
 * @property {cPoint} pInventoryOpen Desc
 * @property {cPoint} pOptionsOpen Desc
 * @property {cPoint} pOptionsCopySave Desc
 * @property {cPoint} pOptionsCloudSave Desc
 * @property {cPoint} pOptionsLoadSave Desc
 * @property {cPoint} pOptionsClose Desc
 * @method Name Desc
 */
Class VillagePoints {
    /** @type {cPoint} Desc */
    pUITest := cPoint(1090, 3)
    /** @type {cPoint} Desc */
    pInventoryStorage := cPoint(616, 540)
    /** @type {cPoint} Desc */
    pIglooClose := cPoint(1012, 58)
    /** @type {cPoint} Desc */
    pInventoryOpen := cPoint(1047, 626)
    /** @type {cPoint} Desc */
    pOptionsOpen := cPoint(1214, 40)
    /** @type {cPoint} Desc */
    pOptionsCopySave := cPoint(796, 231)
    /** @type {cPoint} Desc */
    pOptionsCloudSave := cPoint(796, 328)
    /** @type {cPoint} Desc */
    pOptionsLoadSave := cPoint(917, 231)
    /** @type {cPoint} Desc */
    pOptionsClose := cPoint(1040, 55)
    /** @type {cPoint} Close inventory button */
    pClose := cPoint(1031, 61)
    /** @type {cPoint} Desc */
    pPlay := cPoint(740, 530)

    ;@region VillagePoints()
    /**
     * constructor
     */
    VillagePoints() {

    }
    ;@endregion
}

/**
 * EventItems Description
 * @module EventItems
 * @property {Type} property Desc
 * @method CloseInventory Desc
 */
Class EventItems {

    /** @type {VillagePoints} */
    pVillage := VillagePoints()

    ;@region GetGoodItem()
    /**
     * Fetch a good event item on a loop
     * @param Num 
     * @param starttime 
     */
    GetGoodItem(Num, starttime) {
        socketcount := 0
        itemcount := 0
        Loop {
            If (!Window.IsActive()) {
                Out.I("Window not found, closing event item reset.")
                Return false
            }
            isSocketed := false
            isPerfect := false
            isGood := false
            Sleep(300)
            If (EventItems().RunFarm(&socketcount, &itemcount, &isSocketed, &isPerfect, &isGood, Num, starttime)) {
                Return true
            }
        }
    }
    ;@endregion

    ;@region RunFarm()
    /**
     * Description
     */
    RunFarm(&socketcount, &itemcount, &isSocketed, &isPerfect, &isGood, Num, starttime) {
        Global ClipBoardInUseBlock := true
        If (!this.CloseInventory()) {
            Out.I("Close inventory failed, continuing.")
        }
        If (!this.OpenOptions()) {
            Out.I ("Error at OpenOptions")
            Return false
        }
        If (!this.LoadSave()) {
            Out.I ("Error at LoadSave")
            Return false
        }
        If (!this.WaitForPlayButtonAndClick()) {
            Out.I ("Error at WaitForPlayButtonAndClick")
            Return false
        }
        If (!this.WaitForVillage()) {
            Out.I ("Error at WaitForVillage")
            Return false
        }
        If (!this.OpenEventStore()) {
            Out.I ("Error at OpenEventStore")
            Return false
        }
        If (!this.BuySelectedItem()) {
            Out.I ("Error at BuySelectedItem")
            Return false
        }
        If (!this.CloseEventStore()) {
            Out.I ("Error at CloseEventStore")
            Return false
        }
        If (!this.OpenInventory()) {
            Out.I ("Error at OpenInventory")
            Return false
        }
        If (this.ItemQualityCheck(&socketcount, &itemcount, &isSocketed, &isPerfect, &isGood, Num, starttime)) {
            Out.I ("Found item")
            Return true
        }
        Return false
    }
    ;@endregion

    ;@region CloseInventory()
    /**
     * Click the close inventory button if red colour is detected
     */
    CloseInventory() {
        c := this.pVillage.pClose.GetColour()
        If (Colours().Diff("0xF50000", c) < 50) {
            val := this.pVillage.pClose.ClickOffsetWhileColour(c)
            Sleep(150)
            Return val
        }
        Return false
    }
    ;@endregion

    ;@region OpenOptions()
    /**
     * Open options and return if on options screen
     */
    OpenOptions() {
        c := this.pVillage.pOptionsOpen.GetColour()
        If (Colours().Diff("0xC6CBDE", c) < 50) {
            Out.D("Opening options")
            this.pVillage.pOptionsOpen.ClickOffsetWhileColour(c, , 2, 2)
        }
        /** @type {Timer} */
        t := Timer()
        t.CoolDownS(1, &isLoop)
        While (!this.IsOptionsOpen() && isLoop) {
            Sleep(17)
        }
        Return this.IsOptionsOpen()
    }

    IsOptionsOpen() {
        c1 := this.pVillage.pOptionsLoadSave.GetColour()
        c2 := this.pVillage.pOptionsCopySave.GetColour()
        c3 := this.pVillage.pOptionsCloudSave.GetColour()
        If (Colours().Diff("0x9FEDAC", c1) < 10 &&
        Colours().Diff("0x9FEDAC", c2) < 10 &&
        Colours().Diff("0x9FEDAC", c3) < 10) {
            ;Out.D("Options open")
            Return true
        }
        ;Out.D("Options closed")
        Return false
    }
    ;@endregion

    ;@region LoadSave()
    /**
     * Description
     */
    LoadSave() {
        If (this.IsOptionsOpen()) {
            this.pVillage.pOptionsLoadSave.ClickOffset(, , 54)
            Sleep(34)
            this.pVillage.pOptionsLoadSave.ClickOffset(, , 54)
            Sleep(150)
            Return true
        }
        Return false
    }
    ;@endregion

    ;@region CopySave()
    /**
     * Description
     */
    CopySave() {
        If (this.IsOptionsOpen()) {
            this.pVillage.pOptionsCopySave.ClickOffset(, , 54)
            Sleep(34)
            this.pVillage.pOptionsCopySave.ClickOffset(, , 54)
            Sleep(150)
            Return true
        }
        Return false
    }
    ;@endregion

    ;@region WaitForVillage()
    /**
     * Description
     */
    WaitForVillage() {
        /** @type {Timer} */
        t := Timer()
        t.CoolDownS(10, &isLoop)
        While (!this.IsVillageLoaded() && isLoop) {
            Sleep(17)
        }
        If (!this.IsVillageLoaded()) {
            Out.I("Failure at 6 Village not found " this.IsVillageLoaded() " "
            this.pVillage.pUITest.GetColour())
        }
        Return this.IsVillageLoaded()
    }
    ;@endregion

    ;@region IsVillageLoaded()
    /**
     * 
     */
    IsVillageLoaded() {
        c := this.pVillage.pUITest.GetColour()
        If (Colours().Diff("0x3B8D9E", c) = 0 || ; U1
        ; TODO Add U2/U5
        Colours().Diff("0x856D26", c) = 0 || ; U3
        Colours().Diff("0x15C17B", c) = 0  ; U4
        ) {
            Return true
        }
        Return false
    }

    ;@endregion

    ;@region OpenEventStore()
    /**
     * Description
     */
    OpenEventStore() {
        If (Window.IsActive()) {
            If (EventItemID = 1) {
                ; Winter
                p := cPoint(915, 231)
                p.ClickOffsetWhileColour(p.GetColour(), , 2, 2)
            }
            If (EventItemID = 2) {
                ; Easter
                p := cPoint(1060, 445)
                p.ClickOffsetWhileColour(p.GetColour(), , 2, 2)
            }
            ; TODO Add other events locations
            Sleep(400)
        }
        Return cPoint(675, 150).GetColour() = "0x32006D" ; TODO May change by event
    }
    ;@endregion

    ;@region BuySelectedItem()
    /**
     * Description
     */
    BuySelectedItem() {
        Global EventItemID, EventItemStoreSlot
        If (Window.IsActive()) {
            If (EventItemID = 1) {
                ; Winter
                Switch EventItemStoreSlot {
                Case 1:
                    cPoint(535, 250).Click(51) ; Buy row 1 l
                Case 2:
                    cPoint(960, 250).Click(51) ; Buy row 1 r
                Case 3:
                    cPoint(551, 343).Click(51) ; Buy row 2 l
                Case 4:
                    cPoint(960, 343).Click(51) ; Buy row 2 r
                Case 5:
                    cPoint(551, 431).Click(51) ; Buy row 3 l
                Case 6:
                    cPoint(960, 431).Click(51) ; Buy row 3 r
                default:
                    cPoint(535, 250).Click(51) ; Buy row 1 l
                }
            }
            If (EventItemID = 2) {
                ; Easter
                Switch EventItemStoreSlot {
                Case 1:
                    cPoint(551, 250).Click(51) ; Buy row 1 l Shell sandles
                Case 2:
                    cPoint(960, 250).Click(51) ; Buy row 1 r Yolken Shield
                Case 3:
                    cPoint(551, 343).Click(51) ; Buy row 2 l Egg Head
                Case 4:
                    cPoint(960, 343).Click(51) ; Buy row 2 r Egg Armor
                Case 5:
                    cPoint(551, 431).Click(51) ; Buy row 3 l A Metal Egg
                default:
                    cPoint(551, 250).Click(51) ; Buy row 1 l Shell sandles
                }
            }
            If (EventItemID = 3) {
                ; St Patricks
                Switch EventItemStoreSlot {
                Case 1:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                Case 2:
                    cPoint(960, 250).Click(51) ; Buy row 1 r
                Case 3:
                    cPoint(551, 343).Click(51) ; Buy row 2 l
                Case 4:
                    cPoint(960, 343).Click(51) ; Buy row 2 r
                Case 5:
                    cPoint(551, 431).Click(51) ; Buy row 3 l
                default:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                }
            }
            If (EventItemID = 4) {
                ; Halloween
                Switch EventItemStoreSlot {
                Case 1:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                Case 2:
                    cPoint(960, 250).Click(51) ; Buy row 1 r
                Case 3:
                    cPoint(551, 343).Click(51) ; Buy row 2 l
                Case 4:
                    cPoint(960, 343).Click(51) ; Buy row 2 r
                Case 5:
                    cPoint(551, 431).Click(51) ; Buy row 3 l
                default:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                }
            }
            If (EventItemID = 5) {
                ; Valentines
                Switch EventItemStoreSlot {
                Case 1:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                Case 2:
                    cPoint(960, 250).Click(51) ; Buy row 1 r
                Case 3:
                    cPoint(551, 343).Click(51) ; Buy row 2 l
                Case 4:
                    cPoint(960, 343).Click(51) ; Buy row 2 r
                Case 5:
                    cPoint(551, 431).Click(51) ; Buy row 3 l
                default:
                    cPoint(551, 250).Click(51) ; Buy row 1 l
                }
            }
            Sleep(400)
        }
        Return true
    }
    ;@endregion

    ;@region CloseEventStore()
    /**
     * Description
     */
    CloseEventStore() {
        Return this.pVillage.pIglooClose.ClickOffsetWhileColour("0xF50000")
    }
    ;@endregion

    ;@region OpenInventory()
    /**
     * Description
     */
    OpenInventory() {
        this.pVillage.pInventoryOpen.WaitWhileNotColour("0xEFCF84")
        Out.D("INVENTORY " this.pVillage.pInventoryOpen.toStringWColour())
        Return this.pVillage.pInventoryOpen.ClickOffsetWhileColour("0xEFCF84")
    }
    ;@endregion

    ;@region ItemQualityCheck()
    /**
     * Description
     */
    ItemQualityCheck(&socketcount, &itemcount, &isSocketed, &isPerfect, &isGood, Num, starttime) {
        /** @type {cPoint} */
        multiselectbutton := cPoint(850, 26)
        multiselectbutton.WaitWhileNotColour("0x3B9132", 200)
        itemcount++
        this.ItemFarmTooltop(itemcount, socketcount, starttime, Num)
        If (Window.IsActive()) {
            DetailsOpen := false
            If (EventItemSocketed) {
                If (EventItemTypeArmour) {
                    ; Armour slot
                    colourSocket := cPoint(525, 270).GetColour()
                    If (colourSocket = "0xFCAE35" || colourSocket = "0xAE674C") {
                        Out.I("Found Socket")
                        socketcount++
                        isSocketed := true
                        cPoint(630, 275).Click(51) ; Open armour item
                        DetailsOpen := true
                    }
                    this.ItemFarmTooltop(itemcount, socketcount, starttime, Num)
                } Else {
                    ; Weapon slot
                    colourSocket := cPoint(244, 279).GetColour()
                    If (colourSocket = "0xFCAE35" || colourSocket = "0xAE674C") {
                        Out.I("Found Socket")
                        socketcount++
                        isSocketed := true
                        cPoint(350, 275).Click(51) ; Open weapon item
                        DetailsOpen := true
                    }
                    this.ItemFarmTooltop(itemcount, socketcount, starttime, Num)
                }
            } Else {
                If (EventItemTypeArmour) {
                    ; Armour slot
                    this.ItemFarmTooltop(itemcount, socketcount, starttime, Num)
                    cPoint(630, 275).Click(51) ; Open armour item
                    DetailsOpen := true
                } Else {
                    ; Weapon slot
                    this.ItemFarmTooltop(itemcount, socketcount, starttime, Num)
                    cPoint(350, 275).Click(51) ; Open weapon item
                    DetailsOpen := true
                }
            }

            If (Window.IsActive() && DetailsOpen) {
                Sleep(72)
                cPoint(1050, 624).MouseMove()
                Sleep(200)

                Try {
                    /** @type {cRect} */
                    var := cRect(190, 120, 816, 491)
                    If (var.ImageSearch(A_ScriptDir "\Images\QualityPerfect.png")) {
                        isPerfect := true
                    }
                    If (var.ImageSearch(A_ScriptDir "\Images\Quality9.png")) {
                        isGood := true
                    }
                    If (var.ImageSearch(A_ScriptDir "\Images\Quality09.png")) {
                        isGood := true
                    }
                } Catch As exc {
                    Out.I("Error searc failed - " exc.Message)
                    MsgBox("Could not conduct the search due to the following error:`n"
                        exc.Message)
                }
                If (EventItemGood && isGood) {
                    If (EventItemSocketed && isSocketed) {
                        Out.I("Found 90% socketed")
                        Return true
                    }
                    If (!EventItemSocketed) {
                        Out.I("Found 90%")
                        Return true
                    }
                }

                If ((EventItemGood || EventItemPerfect) && isPerfect) {
                    If (EventItemSocketed && isSocketed) {
                        Out.I("Found 100% socketed")
                        Return true
                    }
                    If (!EventItemSocketed) {
                        Out.I("Found 100%")
                        Return true
                    }
                }
                If (!EventItemGood && !EventItemPerfect && EventItemSocketed && isSocketed) {
                    Out.I("Found any socketed")
                    Return true
                }
            }
            If (!EventItemGood && !EventItemPerfect && !EventItemSocketed) {
                Out.I("Found any? Set a requirement.")
            }
            If (Window.IsActive()) {
                Sleep(50)
                cPoint(1015, 56, 72) ; Close item
                Sleep(500)
            }
        }
        Return false
    }
    ;@endregion

    ;@region ItemFarmTooltop()
    /**
     * 
     * @param itemcount 
     * @param socketcount 
     * @param starttime 
     * @param Num 
     */
    ItemFarmTooltop(itemcount, socketcount, starttime, Num) {
        timediff := DateDiff(A_Now, starttime, "Seconds")
        If (itemcount > 0 && socketcount > 0) {
            ratio := socketcount / itemcount * 100
            ratio := Format("{1:.2f}", ratio)
        } Else {
            ratio := 0
        }
        cPoint(5, 5).TextTipAtCoord(
            "Stored " Num - 1 " correct items.`nFound " itemcount
            " Items`n" socketcount " of which sockets`n"
            ratio "% of socketed`nSeconds Taken " timediff
            "`nRequire 90%: " BinToStr(EventItemGood)
            "`nRequire 100%: " BinToStr(EventItemPerfect)
            "`nRequire socketed: " BinToStr(EventItemSocketed))
    }
    ;@endregion

    ;@region IsPlayButtonSeen()
    /**
     * 
     * @returns {Integer} 
     */
    IsPlayButtonSeen() {
        If (this.pVillage.pPlay.GetColour() = "0xBC00F5") {
            Return true
        }
        ;Out.D("IsPlayButtonSeen Play button colour: " this.pVillage.pPlay.GetColour())
        Return false
    }
    ;@endregion

    ;@region WaitForPlayButtonAndClick()
    /**
     * 
     */
    WaitForPlayButtonAndClick() {
        i := 20
        While (!this.IsPlayButtonSeen()) {
            Sleep(100)
            i--
            If (i = 0) {
                Out.I("Failure at 5 " this.IsPlayButtonSeen())
                Break
            }
        }
        If (i = 0) {
            Return false
        }

        If (Window.IsActive()) {
            cPoint(624, 525).Click(51) ; Play
            Out.I("Clicked Play to start game")
            Return true
        }
    }
    ;@endregion

    ;@region StoreGoodItem()
    /**
     * 
     */
    StoreGoodItem() {
        i := 20
        ; Storage button in item details
        If (!this.pVillage.pInventoryStorage.ClickOffsetWhileColour("0x007EF5")) {
            Out.I("Failure at 11 Storage button in item details")
            Return false
        }
        Out.I("Item sent to storage")

        If (!this.CloseInventory()) {
            Out.I("Failure at 12 Close Inventory")
            Return false
        }
        Out.I("Closed Inventory")

        If (!this.OpenOptions()) {
            Out.I("Failure at 13 Open Options")
            Return false
        }
        Out.I("Opened Options")

        If (!this.CopySave()) {
            Out.I("Failure at 14 Copy Save")
            Return false
        }
        Out.I("Copied Save")

        If (!this.CloseInventory()) {
            Out.I("Failure at 15 Close Inventory")
            Return false
        }
        Out.I("Closed Inventory after saving good item")
        Return true
    }
    ;@endregion

    ;@region GetStartSave()
    /**
     * Description
     */
    GetStartSave() {
        this.CloseInventory()
        If (!this.OpenOptions()) {
            Return false
        }
        If (!this.CopySave()) {
            Return false
        }
        Out.I("Copied starting save")
        Return true
    }
    ;@endregion
}
