#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cGUI.ahk
#Include ..\ScriptLib\cLogging.ahk

ItemEnchanterElevated(*) {
    Window.Activate()
    ItemEnchanter().EnchantItem()
    Reload()
}

ItemEnchanterSelected(*) {
    Window.Activate()
    ItemEnchanter().EnchantItemSelected()
    Reload()
}

Button_Click_ItemEnchanter(thisGui, info) {
    /** @type {ItemEnchanter} */
    IE := ItemEnchanter()
    GuiBGColour := S.Get("GuiBGColour")
    SetttingArray := S.Get("ItemEnchantSelectedAffixes")

    /** @type {cGUI} */
    optionsGui := cGui(, "Item Enchanter Settings")
    optionsGui.Opt("")
    optionsGui.SetUserFontSettings()

    optionsGui.AddText("", "Elevated Prefixes")
    For value in IE.Affixes.Elevated.Prefixes {
        If (IsAffixInArr(SetttingArray, value.Name)) {
            optionsGui.Add("CheckBox", "vIEPrefix" value.Name " checked", value.Name)
        } Else {
            optionsGui.Add("CheckBox", "vIEPrefix" value.Name, value.Name)
        }
    }

    optionsGui.AddText("ys", "Prefixes")
    For value in IE.Affixes.Norm.Prefixes {
        If (IsAffixInArr(SetttingArray, value.Name)) {
            optionsGui.Add("CheckBox", "vIEPrefix" value.Name " checked", value.Name)
        } Else {
            optionsGui.Add("CheckBox", "vIEPrefix" value.Name, value.Name)
        }
    }

    optionsGui.AddText("ys", "Elevated Suffixes")
    For value in IE.Affixes.Elevated.Suffixes {
        If (IsAffixInArr(SetttingArray, value.Name)) {
            optionsGui.Add("CheckBox", "vIESuffix" value.Name " checked", value.Name)
        } Else {
            optionsGui.Add("CheckBox", "vIESuffix" value.Name, value.Name)
        }
    }

    optionsGui.AddText("ys", "Suffixes")
    For value in IE.Affixes.Norm.Suffixes {
        If (IsAffixInArr(SetttingArray, value.Name)) {
            optionsGui.Add("CheckBox", "vIESuffix" value.Name " checked", value.Name)
        } Else {
            optionsGui.Add("CheckBox", "vIESuffix" value.Name, value.Name)
        }
    }

    optionsGui.AddText("ys", "Elevated Not Found")
    For value in IE.Affixes.Elevated.NotCaptured {
        optionsGui.Add("CheckBox", "+disabled vIEPrefix" value.Name, value.Name)
    }

    optionsGui.AddText("ys", "Normal Not Found")
    For value in IE.Affixes.Norm.NotCaptured {
        optionsGui.Add("CheckBox", "+disabled vIEPrefix" value.Name, value.Name)
    }

    optionsGui.AddText("xs",
        "Before starting ensure only the 1 item is viewable`r`nin the enchanter that you wish to change the affixes of.")

    optionsGui.Add("Button", "+Background" GuiBGColour, "Find Elevated").OnEvent("Click",
        ItemEnchanterElevated)

    optionsGui.Add("Button", "+Background" GuiBGColour " yp", "Find Selected").OnEvent("Click",
        ItemEnchanterSelected)

    optionsGui.Add("Button", "+Background" GuiBGColour " default yp", "Save").OnEvent("Click",
        ProcessUserItemEnchanter)
    optionsGui.Add("Button", "+Background" GuiBGColour " yp", "Cancel").OnEvent("Click",
        CloseUserItemEnchanter)
    optionsGui.Add("Button", "+Background" GuiBGColour " yp", "Reset To Default").OnEvent("Click",
        ResetUserItemEnchanter)

    optionsGui.ShowGUIPosition()
    optionsGui.MakeGUIResizableIfOversize()
    optionsGui.OnEvent("Size", optionsGui.SaveGUIPositionOnResize.Bind(optionsGui))
    OnMessage(0x0003, optionsGui.SaveGUIPositionOnMove.Bind(optionsGui))

    ProcessUserItemEnchanter(*) {
        Temp := thisGui.Gui
        Saving := SavingGUI()
        optionsGui.Hide()
        Temp.Hide()
        Saving.Show()
        values := optionsGui.Submit()
        selected := ""
        For value in IE.Affixes.Elevated.Prefixes {
            formname := "IEPrefix" value.Name
            If (values.%formname%) {
                selected .= value.Name ", "
            }
        }
        For value in IE.Affixes.Norm.Prefixes {
            formname := "IEPrefix" value.Name
            If (values.%formname%) {
                selected .= value.Name ", "
            }
        }
        For value in IE.Affixes.Elevated.Suffixes {
            formname := "IESuffix" value.Name
            If (values.%formname%) {
                selected .= value.Name ", "
            }
        }
        For value in IE.Affixes.Norm.Suffixes {
            formname := "IESuffix" value.Name
            If (values.%formname%) {
                selected .= value.Name ", "
            }
        }
        S.Set("ItemEnchantSelectedAffixes", SubStr(selected, 1, -2))
        S.SaveCurrentSettings()
        Reload()
    }

    CloseUserItemEnchanter(*) {
        optionsGui.Hide()
    }

    IsAffixInArr(arr, affixName) {
        For name in arr {
            If (StrLower(name) = StrLower(affixName)) {
                Return true
            }
        }
        Return false
    }

    ResetUserItemEnchanter(*) {
        Temp := thisGui.Gui
        Saving := SavingGUI()
        optionsGui.Hide()
        Temp.Hide()
        Saving.Show()
        values := optionsGui.Submit()
        S.Set("ItemEnchantSelectedAffixes", "")
        S.SaveCurrentSettings()
        Reload()
    }
}
