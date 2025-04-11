#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 8
#SingleInstance Force
; #Warn All

/**
 * Main script file, run this to activate gui and hotkeys
 */

; Applying these first incase self run functions in includes require them
Global ScriptsLogFile := A_ScriptDir "\WizardsWheel2.Log"
Global IsSecondary := false

#Include Lib\hGlobals.ahk

#Include Gui\MainGUI.ahk

#Include Lib\ScriptSettings.ahk
#Include Lib\Functions.ahk
#Include Lib\Navigate.ahk
#Include Lib\cGameWindow.ahk
#Include Lib\cHotkeysInitScript.ahk
#Include Lib\hModules.ahk

#Include Lib\ScriptSettings.ahk

#Include Gui\MainGUI.ahk

SendMode("Input") ; Support for vm
; Can be Input, Event, Play, InputThenPlay if Input doesn't work for you

DetectHiddenWindows(true)
Persistent() ; Prevent the script from exiting automatically.

/** @type {cSettings} */
Global settings := cSettings()

If (!settings.initSettings()) {
    ; If the first load fails, it attempts to write a new config, this retrys
    ; loading after that first failure
    ; Hardcoding 2 attempts because a loop could continuously error
    Sleep(50)
    If (!settings.initSettings()) {
        MsgBox(
            "Script failed to load settings, script closing, try restarting.")
        ExitApp()
    }
}
Out.I("Script loaded")
RunGui()
; Setup script hotkeys
CreateScriptHotkeys()

; ------------------- Readme -------------------
/*
See Readme.md for readme
Run this file to load script
*/

; ------------------- Script Triggers -------------------

CreateScriptHotkeys() {
    Hotkey("*" Scriptkeys.GetHotkey("AutoClicker"), fAutoClicker)
    HotIfWinActive(Window.Title)
    Hotkey("*" Scriptkeys.GetHotkey("Exit"), ExitApp)
    Hotkey("*" Scriptkeys.GetHotkey("Reload"), cReload)
    Hotkey("*" Scriptkeys.GetHotkey("GameResize"), fGameResize)
}
Global ClipBoardInUseBlock := false
#HotIf WinActive(Window.Title) and MouseIsOver(Window.Title) and Debug
    ~LButton:: {
        Global ClipBoardInUseBlock
        screenx := screeny := windowx := windowy := clientx := clienty := 0
        CoordMode("Mouse", "Screen")
        MouseGetPos(&screenx, &screeny)
        CoordMode("Mouse", "Window")
        MouseGetPos(&windowx, &windowy)
        CoordMode("Mouse", "Client")
        MouseGetPos(&clientx, &clienty)

        Out.D(
            "Screen:`t" screenx ", " screeny "`n"
            ;"Window:`t" windowx ", " windowy "`n"
            "Client:`t" clientx ", " clienty "`n"
            ;"`t`t`t   Screen Colour:`t#" SubStr(PixelGetColor(screenx, screeny),3)
            "`t`t`t   Client Colour:`t#" SubStr(PixelGetColor(clientx, clienty),3)
            ;"Current zone colour: " Points.ZoneSample.GetColour()
        )
        ; A_Clipboard := "cPoint(" clientx ", " clienty ")"
    }

    ~WheelDown:: {
        Out.D("Wheel down")
    }

    ~WheelUp:: {
        Out.D("Wheel up")
    }
#HotIf

MouseIsOver(WinTitle) {
    MouseGetPos , , &Win
    Return WinExist(WinTitle " ahk_id " Win)
}

fAutoClicker(*) {
    Static on11 := false
    Out.I("F11: Pressed")
    ;Window.Exist()
    If (on11 := !on11) {
        While (on11) {
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
        cReload()
    }
}

fGameResize(*) {
    Out.I("F12: Pressed")
    If (!Window.Exist()) {
        Return
    }
    If (WinGetMinMax(Window.Title) != 0) {
        WinRestore(Window.Title)
    }
    ; Changes size of client window for windows 11
    WinMove(, , 1294, 703, Window.Title)
    WinWait(Window.Title)
    Window.Exist()
    If (Window.W != "1278" || Window.H != "664") {
        Out.I(
            "Resized window to 1294*703 client size should be 1278*664, found: " Window
            .W "*" Window.H)
    }
}
/* 
fMineStart(*) {
    Static on13 := false
    Out.I("Insert: Pressed")
    InitScriptHotKey()
    If (on13 := !on13) {
        Out.I("Insert: Mine Mantainer Activated")
        ;fMineMaintainer()
    } Else {
        Out.I("Insert: Resetting")
        cReload()
        Return
    }
} */

ExitFunc(ExitReason, ExitCode) {
    Out.I("Script exiting. Due to " ExitReason ".")
}
