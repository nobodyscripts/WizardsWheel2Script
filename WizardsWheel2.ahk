#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 4
#SingleInstance Force

#Include Lib\Functions.ahk
#Include Lib\Coords.ahk

#Include Lib\ActiveBattle.ahk
#Include Lib\IronChef.ahk
#Include Lib\EventItemReset.ahk

global X, Y, W, H
global WW2WindowTitle := "Wizard's Wheel 2 ahk_class UnityWndClass ahk_exe Wizard's Wheel 2.exe"

if WinExist(WW2WindowTitle) {
    WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle)
    ;Log("X " X ", Y " Y ", W " W ", H " H)
}

#HotIf WinActive(WW2WindowTitle)
*NumpadSub:: {
    ;Wildcard shortcut * to allow functions to work while looping with
    ; modifiers held
    ExitApp()
}

*NumpadAdd:: {
    Reload()
}

*Numpad0:: {
    EquipIronChef()
}

*NumpadEnter:: { ; Ingame script
    static toggle := true
    if (toggle = false) {
        ToolTip()
    } else {
        Log("X " X ", Y " Y ", W " W ", H " H)
        ToolTip("Active wheel clicking", 100, 80)
        fWWClickWheel(true) ; Run as timer doesn't execute straight away
        fWWClickSkills()
        fWWClickMimics()
    }
    SetTimer(fWWClickWheel, 72 * (toggle))
    SetTimer(fWWClickSkills, 50000 * (toggle))
    SetTimer(fWWClickMimics, 72 * (toggle))
    SetTimer(HasGemBuffExpired, 1000 * (toggle))
    SetTimer(HasJewelBuffExpired, 1000 * (toggle))
    SetTimer(HasWizardAppeared, 1000 * (toggle))

    toggle := !toggle
}

*F11:: { ; Autoclicker
    Static on11 := False
    Log("F11: Pressed")
    ;InitGameWindow()
    if (IsLBRScriptActive()) {
        return
    }
    If (on11 := !on11) {
        while (on11) {
            MouseClick("left", , , , , "D")
            Sleep(17)
            ; Must be higher than 16.67 which is a single frame of 60fps
            MouseClick("left", , , , , "U")
            Sleep(17)
        }
    } Else {
        ; Do one click when killing, so that we reset the click state
        MouseClick("left", , , , , "D")
        Sleep(17)
        MouseClick("left", , , , , "U")
        Sleep(17)
        Reload()
    }
}

*F10:: { ; Item purchase save spamming
    Static on10 := False
    Log("F10: Pressed")
    If (on10 := !on10) {
        fEventItemReset()
    } Else {
        Reload()
    }
}

; Test script to reset timewarp

TestReset() {
    return
    /*     fSlowClickRelL(2400, 155)
    Sleep(300)
    fSlowClickRelL(2400, 155)
    Sleep(300)
    fSlowClickRelL(2400, 155)
    Sleep(300)
    fSlowClickRelL(2400, 155)
    Sleep(300)
    fSlowClickRelL(2400, 155)
    Sleep(4000)
    ToolTip(" ", 5, 5)
    SetTimer(ToolTip, -500)
    SendMode("Event")
    MouseMove(WinRelPosLargeW(1646), WinRelPosLargeH(1200), 2)
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(1300), , , "D")
    Sleep(50)
    MouseMove(WinRelPosLargeW(1646), WinRelPosLargeH(250), 2)
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(250), , , "U")
    Sleep(250)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(1300), , , "D")
    Sleep(50)
    MouseMove(WinRelPosLargeW(1646), WinRelPosLargeH(250), 2)
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(250), , , "U")
    Sleep(250)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(1300), , , "D")
    Sleep(50)
    MouseMove(WinRelPosLargeW(1646), WinRelPosLargeH(250), 2)
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(1646), WinRelPosLargeH(250), , , "U")
    Sleep(250)
    ; open temple
    MouseClick("left", WinRelPosLargeW(2500), WinRelPosLargeH(800), , , "D")
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(2500), WinRelPosLargeH(800), , , "U")
    Sleep(300)
    ; Timewarp
     MouseClick("left", WinRelPosLargeW(1300), WinRelPosLargeH(250), , , "D")
    Sleep(50)
    MouseClick("left", WinRelPosLargeW(1300), WinRelPosLargeH(250), , , "U") */
}
