#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 4
#SingleInstance Force

#Include Lib\Functions.ahk
#Include Lib\Coords.ahk

#Include Modules\ActiveBattle.ahk
#Include Modules\IronChef.ahk
#Include Modules\EventItemReset.ahk
#Include Modules\GameResize.ahk

#Include Gui\MainGUI.ahk

SendMode("Input") ; Support for vm
; Can be Input, Event, Play, InputThenPlay if Input doesn't work for you

global X, Y, W, H
global WW2WindowTitle := "Wizard's Wheel 2 ahk_class UnityWndClass ahk_exe Wizard's Wheel 2.exe"

if WinExist(WW2WindowTitle) {
    WinGetClientPos(&X, &Y, &W, &H, WW2WindowTitle)
    ;Log("X " X ", Y " Y ", W " W ", H " H)
}

RunGui()

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
    fActiveBattle()
}

*F10:: { ; Item purchase save spamming
    fEventItemReset()
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

*F12:: {
    fGameResize()
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