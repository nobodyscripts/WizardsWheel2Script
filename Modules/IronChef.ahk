#Requires AutoHotkey v2.0

;S.AddSetting("TestSection", "TestVar", "true, array, test", "Array")

EquipIronChef() {
    loop (68) {
        colour := cPoint(950, 450).GetColour()
        if (colour = "0x37636D") {
            cPoint(950, 600).Click(51)
            Sleep(51)
            cPoint(700, 220).Click(51)
            Sleep(51)
        }
        cPoint(800, 40).Click(51)
        Sleep(300)
    }
}