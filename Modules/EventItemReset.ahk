#Requires AutoHotkey v2.0

#Include Village.ahk
#Include ..\ScriptLib\Misc.ahk

S.AddSetting("EventItem", "EventItemAmount", 4, "int")
S.AddSetting("EventItem", "EventItemGood", true, "bool")
S.AddSetting("EventItem", "EventItemPerfect", true, "bool")
S.AddSetting("EventItem", "EventItemSocketed", true, "bool")
S.AddSetting("EventItem", "EventItemStoreSlot", 1, "int")
S.AddSetting("EventItem", "EventItemTypeArmour", true, "bool")
S.AddSetting("EventItem", "EventID", 1, "int")

; ID 1 winter
; ID 2 Easter
; ID 3 St patricks
; ID 4 Halloween
; ID 5 Valentines

fEventItemReset(*) {
    Static on10 := False
    Out.I(Scriptkeys.GetHotkey("EventItemReset") ": Pressed")
    Window.Activate()
    EventItemAmount := S.Get("EventItemAmount")
    If (!IsInteger(EventItemAmount)) {
        MsgBox("Amount must be an integer. Exiting.")
        Reload()
    }
    If (on10 := !on10) {
        Count := EventItemAmount
        Num := 1 ; Iterator
        starttime := A_Now
        Out.I("Started")

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
                If (!EventItems().StoreGoodItem()) {
                    Break
                }
                Sleep(300)
                Count--
                Num++
            }
            Reload()
        }
    } Else {
        Reload()
    }
}

/**
 * EventItems Description
 * @module EventItems
 * @property {Type} property Desc
 * @method CloseInventory Desc
 */
Class EventItems {

    /** @type {Village} */
    V := Village()

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
        If (!this.V.CloseInventory()) {
            Out.I("Close inventory failed, continuing.")
        }
        If (!this.V.OpenOptions()) {
            Out.I("Error at OpenOptions")
            Return false
        }
        If (!this.V.LoadSave()) {
            Out.I("Error at LoadSave")
            Return false
        }
        If (!this.WaitForPlayButtonAndClick()) {
            Out.I("Error at WaitForPlayButtonAndClick")
            Return false
        }
        If (!this.V.WaitForVillage()) {
            Out.I("Error at WaitForVillage")
            Return false
        }
        If (!this.V.OpenEventStore(S.Get("EventID"))) {
            Out.I("Error at OpenEventStore")
            Return false
        }
        If (!this.V.BuySelectedEventItem(S.Get("EventID"), S.Get("EventItemStoreSlot"))) {
            Out.I("Error at BuySelectedItem")
            Return false
        }
        If (!this.V.CloseEventStore()) {
            Out.I("Error at CloseEventStore")
            Return false
        }
        If (!this.V.OpenInventory()) {
            Out.I("Error at OpenInventory")
            Return false
        }
        If (this.ItemQualityCheck(&socketcount, &itemcount, &isSocketed, &isPerfect, &isGood, Num, starttime)) {
            Out.I("Found item")
            Return true
        }
        Return false
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
            If (S.Get("EventItemSocketed")) {
                If (S.Get("EventItemTypeArmour"))
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
            If (S.Get("EventItemTypeArmour")) {
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
            safepoint := cPoint(1050, 624)
            safepoint.WaitWhileNotColour("0x1F1F1F")
            Sleep(34)
            safepoint.MouseMove()
            Sleep(34)

            Try {
                /** @type {cRect} */
                var := cRect(190, 120, 816, 491)
                If (var.ImageSearch(A_ScriptDir "\Images\QualityPerfect.png", "37636d")) {
                    isPerfect := true
                }
                If (var.ImageSearch(A_ScriptDir "\Images\Quality9.png", "37636d")) {
                    isGood := true
                }
                If (var.ImageSearch(A_ScriptDir "\Images\Quality09.png", "37636d")) {
                    isGood := true
                }
            } Catch As exc {
                Out.I("Error searc failed - " exc.Message)
                MsgBox("Could not conduct the search due to the following error:`n"
                    exc.Message)
            }
            If (S.Get("EventItemGood") && isGood) {
                If (S.Get("EventItemSocketed") && isSocketed) {
                    Out.I("Found 90% socketed")
                    Return true
                }
                If (!S.Get("EventItemSocketed")) {
                    Out.I("Found 90%")
                    Return true
                }
            }

            If ((S.Get("EventItemGood") || S.Get("EventItemPerfect")) && isPerfect) {
                If (S.Get("EventItemSocketed") && isSocketed) {
                    Out.I("Found 100% socketed")
                    Return true
                }
                If (!S.Get("EventItemSocketed")) {
                    Out.I("Found 100%")
                    Return true
                }
            }
            If (!S.Get("EventItemGood") && !S.Get("EventItemPerfect") && S.Get("EventItemSocketed") && isSocketed) {
                Out.I("Found any socketed")
                Return true
            }
        }
        If (!S.Get("EventItemGood") && !S.Get("EventItemPerfect") && !S.Get("EventItemSocketed")) {
            Out.I("Found any? Set a requirement.")
        }
        If (Window.IsActive() && DetailsOpen) {
            If (!this.V.CloseInventory()) {
                Out.I("Close inventory failed after opening socketed item details " this.V.Points.Close.GetColour())
                Return false
            }
            multiselectbutton.WaitWhileNotColour("0x3B9132", 200)
            If (!this.V.CloseInventory()) {
                Out.I("Close inventory failed after opening socketed item " this.V.Points.Close.GetColour())
                Return false
            }
            If (!this.V.WaitForVillage()) {
                Out.I("Wait for village failed after closing item details " this.V.Points.Close.GetColour())
                Return false
            }
        }

        If (Window.IsActive() && !DetailsOpen) {
            multiselectbutton.WaitWhileNotColour("0x3B9132", 200)
            If (!this.V.CloseInventory()) {
                Out.I("Close inventory failed without opening item " this.V.Points.Close.GetColour())
                Return false
            }
            If (!this.V.WaitForVillage()) {
                Out.I("Wait for village failed without opening item " this.V.Points.Close.GetColour())
                Return false
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
            "`nRequire 90%: " BinToStr(S.Get("EventItemGood"))
            "`nRequire 100%: " BinToStr(S.Get("EventItemPerfect"))
            "`nRequire socketed: " BinToStr(S.Get("EventItemSocketed")))
    }
    ;@endregion

    ;@region IsPlayButtonSeen()
    /**
     * 
     * @returns {Integer} 
     */
    IsPlayButtonSeen() {
        If (this.V.Points.Play.GetColour() = "0xBC00F5") {
            Return true
        }
        ;Out.D("IsPlayButtonSeen Play button colour: " this.V.Points.Play.GetColour())
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
        If (!this.V.Points.InventoryStorage.ClickOffsetWhileColour("0x007EF5")) {
            Out.I("Failure at 11 Storage button in item details")
            Return false
        }
        Out.I("Item sent to storage")

        If (!this.V.CloseInventory()) {
            Out.I("Failure at 12 Close Inventory")
            Return false
        }
        Out.I("Closed Inventory")

        this.V.WaitForVillage()

        If (!this.V.OpenOptions()) {
            Out.I("Failure at 13 Open Options")
            Return false
        }
        Out.I("Opened Options")

        If (!this.V.CopySave()) {
            Out.I("Failure at 14 Copy Save")
            Return false
        }
        Out.I("Copied Save")

        If (!this.V.CloseInventory()) {
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
        this.V.CloseInventory()
        If (!this.V.OpenOptions()) {
            Return false
        }
        If (!this.V.CopySave()) {
            Return false
        }
        Out.I("Copied starting save")
        Return true
    }
    ;@endregion
}
