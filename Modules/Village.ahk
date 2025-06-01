#Requires AutoHotkey v2.0

#Include ..\Lib\cColours.ahk

;S.AddSetting("TestSection", "TestVar", "true, array, test", "Array")

/**
 * VillagePoints Collection of cPoints for the village screens
 * @module VillagePoints
 * @property {cPoint} UITest Desc
 * @property {cPoint} InventoryStorage Desc
 * @property {cPoint} IglooClose Desc
 * @property {cPoint} InventoryOpen Desc
 * @property {cPoint} OptionsOpen Desc
 * @property {cPoint} OptionsCopySave Desc
 * @property {cPoint} OptionsCloudSave Desc
 * @property {cPoint} OptionsLoadSave Desc
 * @property {cPoint} OptionsClose Desc
 */
Class VillagePoints {
    /** @type {cPoint} */
    UITest := cPoint(1090, 3)
    /** @type {cPoint} */
    InventoryStorage := cPoint(616, 540)
    /** @type {cPoint} */
    IglooClose := cPoint(1012, 58)
    /** @type {cPoint} */
    InventoryOpen := cPoint(1047, 626)
    /** @type {cPoint} */
    OptionsOpen := cPoint(1214, 40)
    /** @type {cPoint} */
    OptionsCopySave := cPoint(796, 231)
    /** @type {cPoint} */
    OptionsCloudSave := cPoint(796, 328)
    /** @type {cPoint} */
    OptionsLoadSave := cPoint(917, 231)
    /** @type {cPoint} */
    OptionsClose := cPoint(1040, 55)
    /** Close inventory button
     * @type {cPoint} */
    Close := cPoint(1031, 61)
    /** @type {cPoint} */
    Play := cPoint(740, 530)
}

/**
 * Village functionality and checks
 * @module Village
 * @method IsVillage
 */
Class Village {

    /** @type {VillagePoints} */
    Points := VillagePoints()

    ;@region IsVillage()
    /**
     * Check if current view is of the Village
     */
    IsVillage() {
        Static ccolours := Colours()
        c := this.Points.UITest.GetColour()
        If (ccolours.Diff("0x3B8D9E", c) = 0 || ; U1
        ; TODO Add U2/U5
        ccolours.Diff("0x856D26", c) = 0 || ; U3
        ccolours.Diff("0x15C17B", c) = 0  ; U4
        ) {
            Return true
        }
        Out.D("IsVillage found: " c)
        Return false
    }
    ;@endregion

    ;@region CloseInventory()
    /**
     * Click the close inventory button if red colour is detected
     */
    CloseInventory() {
        c := this.Points.Close.GetColour()
        If (Colours().Diff("0xF50000", c) < 50) {
            val := this.Points.Close.ClickOffsetWhileColour(c)
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
        c := this.Points.OptionsOpen.GetColour()
        If (Colours().Diff("0xC6CBDE", c) < 50) {
            Out.D("Opening options")
            this.Points.OptionsOpen.ClickOffsetWhileColour(c, , 2, 2)
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
        c1 := this.Points.OptionsLoadSave.GetColour()
        c2 := this.Points.OptionsCopySave.GetColour()
        c3 := this.Points.OptionsCloudSave.GetColour()
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
            this.Points.OptionsLoadSave.ClickOffset(, , 54)
            Sleep(34)
            this.Points.OptionsLoadSave.ClickOffset(, , 54)
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
            this.Points.OptionsCopySave.ClickOffset(, , 54)
            Sleep(34)
            this.Points.OptionsCopySave.ClickOffset(, , 54)
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
        While (!this.IsVillage() && isLoop) {
            Sleep(17)
        }
        If (!this.IsVillage()) {
            Out.I("Failure at 6 Village not found " this.IsVillage() " "
            this.Points.UITest.GetColour())
        }
        Return this.IsVillage()
    }
    ;@endregion

    ;@region OpenEventStore()
    /**
     * Description
     */
    OpenEventStore(EventID) {
        If (Window.IsActive()) {
            If (EventID = 1) {
                ; Winter
                p := cPoint(915, 231)
                p.ClickOffsetWhileColour(p.GetColour(), , 2, 2)
            }
            If (EventID = 2) {
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

    ;@region BuySelectedEventItem()
    /**
     * Description
     */
    BuySelectedEventItem(EventID, EventItemStoreSlot) {
        If (Window.IsActive()) {
            If (EventID = 1) {
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
            If (EventID = 2) {
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
            If (EventID = 3) {
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
            If (EventID = 4) {
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
            If (EventID = 5) {
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
        Return this.Points.IglooClose.ClickOffsetWhileColour("0xF50000")
    }
    ;@endregion

    ;@region OpenInventory()
    /**
     * Description
     */
    OpenInventory() {
        this.Points.InventoryOpen.WaitWhileNotColour("0xEFCF84")
        Out.D("INVENTORY " this.Points.InventoryOpen.toStringWColour())
        Return this.Points.InventoryOpen.ClickOffsetWhileColour("0xEFCF84")
    }
    ;@endregion

}
