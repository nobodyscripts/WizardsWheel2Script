#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 8
#SingleInstance Force
; #Warn All

/**
 * Main script file, run this to activate gui and hotkeys
 */

; Applying these first incase self run functions in includes require them
Global ScriptsLogFile := A_ScriptDir "\MacroCreator.Log"
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
    HotIfWinActive(Window.Title)
    Hotkey("*" Scriptkeys.GetHotkey("Exit"), ExitApp)
    Hotkey("*" Scriptkeys.GetHotkey("Reload"), cReload)
}
Global ClipBoardInUseBlock := false
#HotIf WinActive(Window.Title) and MouseIsOver(Window.Title) and Debug
    ~LButton:: {
        Global ClipBoardInUseBlock
        clientx := clienty := 0
        CoordMode("Mouse", "Client")
        MouseGetPos(&clientx, &clienty)


        /* Out.D(
            "Screen:`t" screenx ", " screeny "`n"
            ;"Window:`t" windowx ", " windowy "`n"
            "Client:`t" clientx ", " clienty "`n"
            ;"`t`t`t   Screen Colour:`t#" SubStr(PixelGetColor(screenx, screeny),3)
            "`t`t`t   Client Colour:`t#" SubStr(PixelGetColor(clientx, clienty), 3)
            ;"Current zone colour: " Points.ZoneSample.GetColour()
        ) */
        /* If (IsSet(ClipBoardInUseBlock) && !ClipBoardInUseBlock) {
            A_Clipboard := "cPoint(" clientx ", " clienty ")"
        } */
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

ExitFunc(ExitReason, ExitCode) {
    Out.I("Script exiting. Due to " ExitReason ".")
}

/**
 * MacroCreator Creates a macro with checks and timings based on recorded
 * user interactions
 * @module MacroCreator
 * @property {Type} property Desc
 * @method Name Desc
 */
Class MacroCreator {
    /** @type {String} String containing the output macro ready to write */
    OutputMacro := ""
    RecordMouseMove := true
    RecordStartWait := true
    Recording := false
    
    ;@region Record()
    /**
     * Record macro
     */
    Record() {
        
    }
    ;@endregion
    
    ;@region StopRecord()
    /**
     * Stop recording macro
     */
    StopRecord() {
        
    }
    ;@endregion

    ;@region OnMouseDown()
    /**
     * Record MouseDown Event
     */
    OnMouseDown() {
        
    }
    ;@endregion

    ;@region OnMouseUp()
    /**
     * Record MouseUp Event
     */
    OnMouseUp() {
        
    }
    ;@endregion

    ;@region OnMouseMove()
    /**
     * Record MouseMove Event
     */
    OnMouseMove() {
        
    }
    ;@endregion

    ;@region OnWait()
    /**
     * Record Wait Event
     */
    OnWait() {
        
    }
    ;@endregion

    ;@region OnKeyDown()
    /**
     * Record KeyDown Event
     */
    OnKeyDown() {
        
    }
    ;@endregion

    ;@region OnKeyUp()
    /**
     * Record KeyUp Event
     */
    OnKeyUp() {
        
    }
    ;@endregion


}