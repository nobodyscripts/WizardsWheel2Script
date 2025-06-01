#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cGUI.ahk

#Include GeneralSettingsGUI.ahk
#Include ScriptHotkeysGUI.ahk
#Include EventItemGUI.ahk
#Include SavingGUI.ahk
#Include UpdatingGUI.ahk

RunGui() {
    GuiBGColour := S.Get("GuiBGColour")
    /** @type {cGui} */
    MyGui := cGui(, "WW2 NobodyScript")
    MyGui.Opt("-SysMenu")
    MyGui.SetUserFontSettings()

    MyGui.Add("Text", "", "Numpad-")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Exit")
    MyBtn.OnEvent("Click", Button_Click_Exit)

    MyGui.Add("Text", "", "Numpad+")
    MyBtn := MyGui.Add("Button", "Default +Background" GuiBGColour " ", "Reload")
    MyBtn.OnEvent("Click", Button_Click_Reload)

    MyGui.Add("Text", "", "Numpad0")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Equip Iron Chef")
    MyBtn.OnEvent("Click", Button_Click_IronChef)

    MyGui.Add("Text", "", "NumpadEnter")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Battle Scripts")
    MyBtn.OnEvent("Click", Button_Click_ActiveBattle)

    MyGui.Add("Text", "", "")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Dimension Pushing")
    MyBtn.OnEvent("Click", Button_Click_DimensionPushing)

    MyGui.Add("Text", "", "F10")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Event Items")
    MyBtn.OnEvent("Click", Button_Click_EventItem)

    MyGui.Add("Text", "", "F11 Autoclicker")

    MyGui.Add("Text", "", "F12")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Resize Game")
    MyBtn.OnEvent("Click", Button_Click_Resize)

    MyGui.Add("Text", "", "")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Single Item Enchant")
    MyBtn.OnEvent("Click", Button_Click_EnchantItem)

    MyGui.Add("Text", "", "")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Single Item Enchant Selected")
    MyBtn.OnEvent("Click", Button_Click_EnchantItemSelected)

    MyGui.Add("Text", "", "")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Edit Script Hotkeys")
    MyBtn.OnEvent("Click", Button_Click_ScriptHotkeys)

    MyGui.Add("Text", "", "General Settings")
    MyBtn := MyGui.Add("Button", "+Background" GuiBGColour " ", "Settings")
    MyBtn.OnEvent("Click", Button_Click_GeneralSettings)

    MyGui.ShowGUIPosition()
    MyGui.MakeGUIResizableIfOversize()
    MyGui.OnEvent("Close", Button_Click_Exit)
    MyGui.OnEvent("Size", MyGui.SaveGUIPositionOnResize.Bind(MyGui))
    OnMessage(0x0003, MyGui.SaveGUIPositionOnMove.Bind(MyGui))
}

Button_Click_Exit(*) {
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
    Dimension().PushDimensions(, false)
    Reload()
}