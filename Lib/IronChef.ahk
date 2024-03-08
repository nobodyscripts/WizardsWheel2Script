#Requires AutoHotkey v2.0

EquipIronChef() {
    loop (68) {
        colour := PixelGetColor(WinRelPosW(950), WinRelPosH(450))
        if (colour = "0x37636D") {
            fSlowClick(950, 600, 51)
            Sleep(51)
            fSlowClick(700, 220, 51)
            Sleep(51)
        }
        fSlowClick(800, 40, 51)
        Sleep(300)
    }
}