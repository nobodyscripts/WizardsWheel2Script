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

Button_Click_EventItem(thisGui, info) {
    WinActivate(WW2WindowTitle)
    fEventItemReset()
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
    MyGui.Opt("+AlwaysOnTop -SysMenu +Owner")

    MyGui.Add("Text", , "Numpad-")
    MyBtn := MyGui.Add("Button", "Default w80", "Exit")
    MyBtn.OnEvent("Click", Button_Click_Exit)

    MyGui.Add("Text", , "Numpad+")
    MyBtn := MyGui.Add("Button", "Default w80", "Reload")
    MyBtn.OnEvent("Click", Button_Click_Reload)

    MyGui.Add("Text", , "Numpad0")
    MyBtn := MyGui.Add("Button", "Default w120", "Equip Iron Chef")
    MyBtn.OnEvent("Click", Button_Click_IronChef)

    MyGui.Add("Text", , "NumpadEnter")
    MyBtn := MyGui.Add("Button", "Default w120", "Battle Scripts")
    MyBtn.OnEvent("Click", Button_Click_ActiveBattle)

    MyGui.Add("Text", , "F10")
    MyBtn := MyGui.Add("Button", "Default w120", "Event Items")
    MyBtn.OnEvent("Click", Button_Click_EventItem)


    MyGui.Add("Text", , "F11 Autoclicker")

    MyGui.Add("Text", , "F12")
    MyBtn := MyGui.Add("Button", "Default w120", "Resize Game")
    MyBtn.OnEvent("Click", Button_Click_Resize)

    MyGui.Show()
}