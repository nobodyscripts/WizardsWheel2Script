#Requires AutoHotkey v2.0

Button_Click_Exit(thisGui, info) {
    ExitApp()
}

Button_Click_Reload(thisGui, info) {
    cReload()
}

Button_Click_Resize(thisGui, info) {
    fGameResize()
}


Button_Click_IronChef(thisGui, info) {
    WinActivate(WW2WindowTitle)
    EquipIronChef()
}

Button_Click_ActiveBattle(thisGui, info) {
    WinActivate(WW2WindowTitle)
    fActiveBattle()
}

RunGui() {
    MyGui := Gui(, "WW2 NobodyScript")
    MyGui.Opt("-SysMenu")
    MyGui.BackColor := "0c0018"


    MyGui.Add("Text", "ccfcfcf", "Numpad-")
    MyBtn := MyGui.Add("Button", "Default w80", "Exit")
    MyBtn.OnEvent("Click", Button_Click_Exit)

    MyGui.Add("Text", "ccfcfcf", "Numpad+")
    MyBtn := MyGui.Add("Button", "Default w80", "Reload")
    MyBtn.OnEvent("Click", Button_Click_Reload)

    MyGui.Add("Text", "ccfcfcf", "Numpad0")
    MyBtn := MyGui.Add("Button", "Default w120", "Equip Iron Chef")
    MyBtn.OnEvent("Click", Button_Click_IronChef)

    MyGui.Add("Text", "ccfcfcf", "NumpadEnter")
    MyBtn := MyGui.Add("Button", "Default w120", "Battle Scripts")
    MyBtn.OnEvent("Click", Button_Click_ActiveBattle)

    MyGui.Add("Text", "ccfcfcf", "F10")
    MyBtn := MyGui.Add("Button", "Default w120", "Event Items")
    MyBtn.OnEvent("Click", Button_Click_EventItem)

    MyGui.Add("Text", "ccfcfcf", "F11 Autoclicker")

    MyGui.Add("Text", "ccfcfcf", "F12")
    MyBtn := MyGui.Add("Button", "Default w120", "Resize Game")
    MyBtn.OnEvent("Click", Button_Click_Resize)

    MyGui.Show()
}

Button_Click_EventItem(*) {
    global EventItemTypeArmour,
        EventItemAmount,
        EventItemGood,
        EventItemPerfect,
        EventItemSocketed,
        EventItemStoreSlot

    Log("Global Event Items: Amount " EventItemAmount " Good " EventItemGood
        "`nPerf " EventItemPerfect " Socketed " EventItemSocketed
        "`nStore " EventItemStoreSlot " Type " EventItemTypeArmour)
    optionsGUI := GUI(, "Options: Event Items")
    optionsGUI.Opt("+Owner +MinSize +MinSize500x")
    optionsGUI.BackColor := "0c0018"

    optionsGUI.Add("Text", "ccfcfcf", "Event Items Amount:")
    optionsGUI.AddEdit()
    If (IsInteger(EventItemAmount) && EventItemAmount > 0) {
        optionsGUI.Add("UpDown", "vAmount Range1-12", EventItemAmount)
    } else {
        optionsGUI.Add("UpDown", "vAmount Range1-12", 4)
    }

    optionsGUI.Add("Text", , "")

    if (EventItemGood = true) {
        optionsGUI.Add("CheckBox", "vIsGood ccfcfcf checked", "90%+ Quality")
    } else {
        optionsGUI.Add("CheckBox", "vIsGood ccfcfcf", "90%+ Quality")
    }

    if (EventItemPerfect = true) {
        optionsGUI.Add("CheckBox", "vIsPerfect ccfcfcf checked", "100% Quality")
    } else {
        optionsGUI.Add("CheckBox", "vIsPerfect ccfcfcf", "100% Quality")
    }

    if (EventItemSocketed = true) {
        optionsGUI.Add("CheckBox", "vIsSocketed ccfcfcf checked", "Socketed")
    } else {
        optionsGUI.Add("CheckBox", "vIsSocketed ccfcfcf", "Socketed")
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "ccfcfcf", "Event store slot:")
    if (EventItemStoreSlot = 1) {
        optionsGUI.Add("Radio", "vStoreSlot ccfcfcf checked", "1 TopLeft")
    } else {
        optionsGUI.Add("Radio", "vStoreSlot ccfcfcf", "1 TopLeft")
    }
    if (EventItemStoreSlot = 2) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "2 TopRight")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "2 TopRight")
    }
    if (EventItemStoreSlot = 3) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "3 Left")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "3 Left")
    }
    if (EventItemStoreSlot = 4) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "4 Right")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "4 Right")
    }
    if (EventItemStoreSlot = 5) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "5 LowerLeft")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "5 LowerLeft")
    }
    if (EventItemStoreSlot = 6) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "6 LowerRight")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "6 LowerRight")
    }
    if (EventItemStoreSlot = 7) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "7 BottomLeft")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "7 BottomLeft")
    }
    if (EventItemStoreSlot = 8) {
        optionsGUI.Add("Radio", "ccfcfcf checked", "8 BottomRight")
    } else {
        optionsGUI.Add("Radio", "ccfcfcf", "8 BottomRight")
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "ccfcfcf", "Item type:")
    if (EventItemTypeArmour) {
        optionsGUI.Add("Radio", "vItemType ccfcfcf", "Weapon")
        optionsGUI.Add("Radio", "ccfcfcf checked", "Armour")
    } else {
        optionsGUI.Add("Radio", "vItemType ccfcfcf checked", "Weapon")
        optionsGUI.Add("Radio", "ccfcfcf", "Armour")
    }

    optionsGUI.Add("Button", "default", "OK").OnEvent("Click", ProcessUserEventItemsSettings)
    ;    optionsGUI.OnEvent("Close", ProcessUserEventItemsSettings)
    ProcessUserEventItemsSettings(*) {
        values := optionsGUI.Submit()
        Log("Event Items: Amount " values.Amount " Good " values.IsGood
            "`nPerf " values.IsPerfect " Socketed " values.IsSocketed
            "`nStore " values.StoreSlot " Type " values.ItemType)
        EventItemTypeArmour := values.ItemType--
        EventItemAmount := values.Amount
        EventItemGood := values.IsGood
        EventItemPerfect := values.IsPerfect
        EventItemSocketed := values.IsSocketed
        EventItemStoreSlot := values.StoreSlot
        WinActivate(WW2WindowTitle)
        fEventItemReset()
    }
    optionsGUI.Show("w300")
}