#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cGUI.ahk

Button_Click_EventItem(*) {
    EventItemTypeArmour := S.Get("EventItemTypeArmour")
    EventItemAmount := S.Get("EventItemAmount")
    EventItemGood := S.Get("EventItemGood")
    EventItemPerfect := S.Get("EventItemPerfect")
    EventItemSocketed := S.Get("EventItemSocketed")
    EventItemStoreSlot := S.Get("EventItemStoreSlot")
    EventID := S.Get("EventID")

    Out.I("Global Event Items: Amount " EventItemAmount " Good " EventItemGood
        " Perf " EventItemPerfect " Socketed " EventItemSocketed
        " Store " EventItemStoreSlot " Armour " EventItemTypeArmour " EventID " EventID)
    optionsGUI := cGui(, "Event Items")
    optionsGUI.SetUserFontSettings()

    optionsGUI.Add("Text", "",
        "Start running while in inventory screen,`r`nwith save to clipboard and slot free.")

    optionsGUI.Add("Text", "", "Event Items Amount:")
    optionsGUI.AddEdit()
    If (IsInteger(EventItemAmount) && EventItemAmount > 0) {
        optionsGUI.Add("UpDown", "vAmount Range1-12", EventItemAmount)
    } Else {
        optionsGUI.Add("UpDown", "vAmount Range1-12", 4)
    }

    optionsGUI.Add("Text", , "")

    If (EventItemGood = true) {
        optionsGUI.Add("CheckBox", "vIsGood  checked", "90%+ Quality")
    } Else {
        optionsGUI.Add("CheckBox", "vIsGood ", "90%+ Quality")
    }

    If (EventItemPerfect = true) {
        optionsGUI.Add("CheckBox", "vIsPerfect  checked", "100% Quality")
    } Else {
        optionsGUI.Add("CheckBox", "vIsPerfect ", "100% Quality")
    }

    If (EventItemSocketed = true) {
        optionsGUI.Add("CheckBox", "vIsSocketed  checked", "Socketed")
    } Else {
        optionsGUI.Add("CheckBox", "vIsSocketed ", "Socketed")
    }

    optionsGUI.Add("Text", , "")
    optionsGUI.Add("Text", "", "Season:")

    If (EventID > 0 && EventID < 5) {
        optionsGUI.Add("DropDownList", "vEventID Choose" EventID, [
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
    optionsGUI.Add("Text", "", "Event store slot:")
    Switch (EventID) {
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
    If (EventID > 0 && EventID < 6 && !(EventItemStoreSlot > 0 && EventItemStoreSlot < 9)) {
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
    optionsGUI.Add("Text", "", "Item type:")
    If (EventItemTypeArmour) {
        optionsGUI.Add("Radio", "vItemType ", "Weapon")
        optionsGUI.Add("Radio", " checked", "Armour")
    } Else {
        optionsGUI.Add("Radio", "vItemType  checked", "Weapon")
        optionsGUI.Add("Radio", "", "Armour")
    }

    optionsGUI.Add("Button", "default", "Run and Save").OnEvent("Click", ProcessUserEventItemsSettings)
    optionsGUI.Add("Button", "yp", "Save").OnEvent("Click", UserEventItemsSave)
    optionsGUI.Add("Button", "yp", "Cancel").OnEvent("Click", UserEventItemsCancel)

    optionsGUI.ShowGUIPosition()
    optionsGUI.MakeGUIResizableIfOversize()
    optionsGUI.OnEvent("Size", optionsGUI.SaveGUIPositionOnResize.Bind(optionsGUI))
    OnMessage(0x0003, optionsGUI.SaveGUIPositionOnMove.Bind(optionsGUI))

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

        S.Set("EventItemTypeArmour", --values.ItemType)
        S.Set("EventItemAmount", values.Amount)
        S.Set("EventItemGood", values.IsGood)
        S.Set("EventItemPerfect", values.IsPerfect)
        S.Set("EventItemSocketed", values.IsSocketed)
        S.Set("EventItemStoreSlot", StrSplit(values.StoreSlot, " ")[1])
        S.Set("EventID", StrSplit(values.EventID, " ")[1])
        Out.I("Saved Event Items: Amount " S.Get("EventItemAmount")
        " Good " S.Get("EventItemGood")
        " Perf " S.Get("EventItemPerfect")
        " Socketed " S.Get("EventItemSocketed")
        " Store " S.Get("EventItemStoreSlot")
        " Armour " S.Get("EventItemTypeArmour")
        " EventID " S.Get("EventID"))
        S.SaveCurrentSettings()
    }

    UserEventItemsCancel(*) {
        optionsGUI.Hide()
    }
}
