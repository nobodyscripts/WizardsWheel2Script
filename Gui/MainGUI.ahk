#Requires AutoHotkey v2.0


Button_Click_Exit(thisGui, info) {
    ExitApp()
}

Button_Click_Reload(thisGui, info) {
    Reload()
}

Button_Click_Resize(thisGui, info) {
    fGameResize()
}

Button_Click_IronChef(thisGui, info) {
    Window.Activate()
    EquipIronChef()
}

Button_Click_ActiveBattle(thisGui, info) {
    Window.Activate()
    ActiveBattle().Run()
}

Button_Click_EnchantItem(*) {
    Window.Activate()
    ItemEnchanter().EnchantItem()
    Reload()
}

Button_Click_EnchantItemSelected(*) {
    Window.Activate()
    userarray := []
    ItemEnchanter().EnchantItemSelected(userarray)
    Reload()
}

Button_Click_DimensionPushing(*) {
    Window.Activate()
    SelectedHeroes := [1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
    Dimension().PushDimensions(SelectedHeroes, false)
    Reload()
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

    MyGui.Add("Text", "ccfcfcf", "")
    MyBtn := MyGui.Add("Button", "Default w120", "Dimension Pushing")
    MyBtn.OnEvent("Click", Button_Click_DimensionPushing)

    MyGui.Add("Text", "ccfcfcf", "F10")
    MyBtn := MyGui.Add("Button", "Default w120", "Event Items")
    MyBtn.OnEvent("Click", Button_Click_EventItem)

    MyGui.Add("Text", "ccfcfcf", "F11 Autoclicker")

    MyGui.Add("Text", "ccfcfcf", "F12")
    MyBtn := MyGui.Add("Button", "Default w120", "Resize Game")
    MyBtn.OnEvent("Click", Button_Click_Resize)

    MyGui.Add("Text", "ccfcfcf", "")
    MyBtn := MyGui.Add("Button", "Default w120", "Single Item Enchant")
    MyBtn.OnEvent("Click", Button_Click_EnchantItem)

    MyGui.Add("Text", "ccfcfcf", "")
    MyBtn := MyGui.Add("Button", "Default w120", "Single Item Enchant Selected")
    MyBtn.OnEvent("Click", Button_Click_EnchantItemSelected)

    MyGui.Show()
}

Button_Click_EventItem(*) {
    Global EventItemTypeArmour,
        EventItemAmount,
        EventItemGood,
        EventItemPerfect,
        EventItemSocketed,
        EventItemStoreSlot,
        EventItemID

    Out.I("Global Event Items: Amount " EventItemAmount " Good " EventItemGood
        " Perf " EventItemPerfect " Socketed " EventItemSocketed
        " Store " EventItemStoreSlot " Armour " EventItemTypeArmour " EventID " EventItemID)
    optionsGUI := GUI(, "Options: Event Items")
    optionsGUI.Opt("+MinSize +MinSize500x")
    optionsGUI.BackColor := "0c0018"
    optionsGUI.Add("Text", "ccfcfcf",
        "Start running while in inventory screen,`r`nwith save to clipboard and slot free.")

    optionsGUI.Add("Text", "ccfcfcf", "Event Items Amount:")
    optionsGUI.AddEdit()
    If (IsInteger(EventItemAmount) && EventItemAmount > 0) {
        optionsGUI.Add("UpDown", "vAmount Range1-12", EventItemAmount)
    } Else {
        optionsGUI.Add("UpDown", "vAmount Range1-12", 4)
    }

    optionsGUI.Add("Text", , "")

    If (EventItemGood = true) {
        optionsGUI.Add("CheckBox", "vIsGood ccfcfcf checked", "90%+ Quality")
    } Else {
        optionsGUI.Add("CheckBox", "vIsGood ccfcfcf", "90%+ Quality")
    }

    If (EventItemPerfect = true) {
        optionsGUI.Add("CheckBox", "vIsPerfect ccfcfcf checked", "100% Quality")
    } Else {
        optionsGUI.Add("CheckBox", "vIsPerfect ccfcfcf", "100% Quality")
    }

    If (EventItemSocketed = true) {
        optionsGUI.Add("CheckBox", "vIsSocketed ccfcfcf checked", "Socketed")
    } Else {
        optionsGUI.Add("CheckBox", "vIsSocketed ccfcfcf", "Socketed")
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "ccfcfcf", "Season:")

    If (EventItemID > 0 && EventItemID < 5) {
        optionsGUI.Add("DropDownList", "vEventID Choose" EventItemID, [
            "1 Winter",
            "2 Easter",
            "3 St Patricks Day",
            "4 Halloween",
            "5 Valentines"
        ]).OnEvent("Change", ProcessUserEventItemsID)
    } Else {
        optionsGUI.Add("DropDownList", "vEventID Choose1", [
            "1 Winter",
            "2 Easter",
            "3 St Patricks Day",
            "4 Halloween",
            "5 Valentines"
        ]).OnEvent("Change", ProcessUserEventItemsID)
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "ccfcfcf", "Event store slot:")
    Switch (EventItemID) {
    Case 1:
        If (EventItemStoreSlot > 0 && EventItemStoreSlot < 9) {
            optionsGUI.Add("DropDownList", "vStoreSlot Choose" EventItemStoreSlot, [
                "1 Top Left",
                "2 Top Right",
                "3 Left",
                "4 Right",
                "5 Lower Left",
                "6 Lower Right",
                "7 Bottom Left",
                "8 Bottom Right"
            ])
        }
    Case 2:
        If (EventItemStoreSlot > 0 && EventItemStoreSlot < 9) {
            optionsGUI.Add("DropDownList", "vStoreSlot Choose" EventItemStoreSlot, [
                "1 Shell Sandles",
                "2 Yolken Shield",
                "3 Egg Head",
                "4 Egg Armor",
                "5 A Metal Egg (Don't use)"
            ])
        }
    Case 3:
        If (EventItemStoreSlot > 0 && EventItemStoreSlot < 9) {
            optionsGUI.Add("DropDownList", "vStoreSlot Choose" EventItemStoreSlot, [
                "1 Top Left",
                "2 Top Right",
                "3 Left",
                "4 Right",
                "5 Lower Left",
                "6 Lower Right",
                "7 Bottom Left",
                "8 Bottom Right"
            ])
        }
    Case 4:
        If (EventItemStoreSlot > 0 && EventItemStoreSlot < 9) {
            optionsGUI.Add("DropDownList", "vStoreSlot Choose" EventItemStoreSlot, [
                "1 Top Left",
                "2 Top Right",
                "3 Left",
                "4 Right",
                "5 Lower Left",
                "6 Lower Right",
                "7 Bottom Left",
                "8 Bottom Right"
            ])
        }
    Case 5:
        If (EventItemStoreSlot > 0 && EventItemStoreSlot < 9) {
            optionsGUI.Add("DropDownList", "vStoreSlot Choose" EventItemStoreSlot, [
                "1 Top Left",
                "2 Top Right",
                "3 Left",
                "4 Right",
                "5 Lower Left",
                "6 Lower Right",
                "7 Bottom Left",
                "8 Bottom Right"
            ])
        }
    default:
        optionsGUI.Add("DropDownList", "vStoreSlot Choose1", [
            "1 Top Left",
            "2 Top Right",
            "3 Left",
            "4 Right",
            "5 Lower Left",
            "6 Lower Right",
            "7 Bottom Left",
            "8 Bottom Right"
        ])
    }
    If (EventItemID > 0 && EventItemID < 6 && !(EventItemStoreSlot > 0 && EventItemStoreSlot < 9)) {
        optionsGUI.Add("DropDownList", "vStoreSlot Choose1", [
            "1 Top Left",
            "2 Top Right",
            "3 Left",
            "4 Right",
            "5 Lower Left",
            "6 Lower Right",
            "7 Bottom Left",
            "8 Bottom Right"
        ])
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "ccfcfcf", "Item type:")
    If (EventItemTypeArmour) {
        optionsGUI.Add("Radio", "vItemType ccfcfcf", "Weapon")
        optionsGUI.Add("Radio", "ccfcfcf checked", "Armour")
    } Else {
        optionsGUI.Add("Radio", "vItemType ccfcfcf checked", "Weapon")
        optionsGUI.Add("Radio", "ccfcfcf", "Armour")
    }

    optionsGUI.Add("Button", "default", "Run and Save").OnEvent("Click", ProcessUserEventItemsSettings)
    optionsGUI.Add("Button", "default yp", "Save").OnEvent("Click", UserEventItemsSave)
    optionsGUI.Add("Button", "default yp", "Cancel").OnEvent("Click", UserEventItemsCancel)

    ProcessUserEventItemsSettings(*) {
        UserEventItemsSave()
        Window.Activate()
        fEventItemReset()
    }

    ProcessUserEventItemsID(*) {
        optionsGUI.Hide()
        UserEventItemsSave()
        Button_Click_EventItem()
    }

    UserEventItemsSave(*) {
        values := optionsGUI.Submit()
        EventItemTypeArmour := --values.ItemType
        EventItemAmount := values.Amount
        EventItemGood := values.IsGood
        EventItemPerfect := values.IsPerfect
        EventItemSocketed := values.IsSocketed
        EventItemStoreSlot := StrSplit(values.StoreSlot, " ")[1]
        EventItemID := StrSplit(values.EventID, " ")[1]
        Out.I("Saved Event Items: Amount " EventItemAmount " Good " EventItemGood
            " Perf " EventItemPerfect " Socketed " EventItemSocketed
            " Store " EventItemStoreSlot " Armour " EventItemTypeArmour " EventID " EventItemID)
        S.SaveCurrentSettings()
    }

    UserEventItemsCancel(*) {
        optionsGUI.Hide()
    }
    optionsGUI.Show("w300")
}
