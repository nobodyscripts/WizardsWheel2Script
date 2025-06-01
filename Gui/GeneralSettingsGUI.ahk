#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cGUI.ahk
#Include ..\ScriptLib\cLogging.ahk

Button_Click_GeneralSettings(thisGui, info) {
    EnableLogging := S.Get("EnableLogging")
    Verbose := S.Get("Verbose")
    Debug := S.Get("Debug")
    DebugAll := S.Get("DebugAll")
    LogBuffer := S.Get("LogBuffer")
    TimestampLogs := S.Get("TimestampLogs")
    CheckForUpdatesEnable := S.Get("CheckForUpdatesEnable")
    CheckForUpdatesReleaseOnly := S.Get("CheckForUpdatesReleaseOnly")
    GuiFontBold := S.Get("GuiFontBold")
    GuiFontItalic := S.Get("GuiFontItalic")
    GuiFontStrike := S.Get("GuiFontStrike")
    GuiFontUnderline := S.Get("GuiFontUnderline")
    GuiFontSize := S.Get("GuiFontSize")
    GuiFontWeight := S.Get("GuiFontWeight")
    GuiFontName := S.Get("GuiFontName")
    GuiBGColour := S.Get("GuiBGColour")
    GuiFontColour := S.Get("GuiFontColour")
    /** @type {cGUI} */
    settingsGUI := cGui(, "General Settings")
    settingsGUI.Opt("")
    settingsGUI.SetUserFontSettings()

    If (EnableLogging = true) {
        settingsGUI.Add("CheckBox", "vLogging checked",
            "Enable Logging")
    } Else {
        settingsGUI.Add("CheckBox", "vLogging", "Enable Logging")
    }

    If (Verbose = true) {
        settingsGUI.Add("CheckBox", "vVerbose cff8800 checked",
            "Enable Verbose Logging")
    } Else {
        settingsGUI.Add("CheckBox", "vVerbose cff8800", "Enable Verbose Logging")
    }

    If (Debug = true) {
        settingsGUI.Add("CheckBox", "vDebug cff5100 checked",
            "Enable Debug Logging")
    } Else {
        settingsGUI.Add("CheckBox", "vDebug cff5100", "Enable Debug Logging")
    }

    If (DebugAll = true) {
        settingsGUI.Add("CheckBox", "vDebugAll cff0000 checked",
            "Enable DebugAll Logging")
    } Else {
        settingsGUI.Add("CheckBox", "vDebugAll cff0000", "Enable DebugAll Logging")
    }

    If (LogBuffer = true) {
        settingsGUI.Add("CheckBox", "vLogBuffer checked",
            "Enable Log Buffer (Reduce disk writes)")
    } Else {
        settingsGUI.Add("CheckBox", "vLogBuffer", "Enable Log Buffer (Reduce disk writes)")
    }

    If (TimestampLogs = true) {
        settingsGUI.Add("CheckBox", "vTimestampLogs checked",
            "Enable Log Timestamps")
    } Else {
        settingsGUI.Add("CheckBox", "vTimestampLogs",
            "Enable Log Timestamps")
    }

    If (CheckForUpdatesEnable = true) {
        settingsGUI.Add("CheckBox", "vCheckForUpdatesEnable checked",
            "Enable Check For Updates")
    } Else {
        settingsGUI.Add("CheckBox", "vCheckForUpdatesEnable",
            "Enable Check For Updates")
    }

    If (CheckForUpdatesReleaseOnly = true) {
        settingsGUI.Add("CheckBox",
            "vCheckForUpdatesReleaseOnly checked",
            "Enable Check For Releases Only")
    } Else {
        settingsGUI.Add("CheckBox", "vCheckForUpdatesReleaseOnly",
            "Enable Check For Releases Only")
    }

    If (GuiFontBold = true) {
        settingsGUI.Add("CheckBox", "vGuiFontBold checked",
            "Enable GUI Font Bold")
    } Else {
        settingsGUI.Add("CheckBox", "vGuiFontBold",
            "Enable GUI Font Bold")
    }

    If (GuiFontItalic = true) {
        settingsGUI.Add("CheckBox", "vGuiFontItalic checked",
            "Enable GUI Font Italic")
    } Else {
        settingsGUI.Add("CheckBox", "vGuiFontItalic",
            "Enable GUI Font Italic")
    }

    If (GuiFontStrike = true) {
        settingsGUI.Add("CheckBox", "vGuiFontStrike checked",
            "Enable GUI Font Strikethrough")
    } Else {
        settingsGUI.Add("CheckBox", "vGuiFontStrike",
            "Enable GUI Font Strikethrough")
    }

    If (GuiFontUnderline = true) {
        settingsGUI.Add("CheckBox", "vGuiFontUnderline checked",
            "Enable GUI Font Underline")
    } Else {
        settingsGUI.Add("CheckBox", "vGuiFontUnderline",
            "Enable GUI Font Underline")
    }

    settingsGUI.Add("Text", "", "GUI Font Size:")
    settingsGUI.AddEdit("cDefault")
    If (IsInteger(GuiFontSize) || IsFloat(GuiFontSize)) {
        settingsGUI.Add("UpDown", "vGuiFontSize Range6-50",
            GuiFontSize)
    } Else {
        settingsGUI.Add("UpDown", "vGuiFontSize Range6-50",
            S.GetDefault("GuiFontSize"))
    }

    settingsGUI.Add("Text", "", "GUI Font Weight:")
    settingsGUI.AddEdit("cDefault")
    If (IsInteger(GuiFontWeight) || IsFloat(GuiFontWeight)) {
        settingsGUI.Add("UpDown", "vGuiFontWeight Range0-9",
            GuiFontWeight)
    } Else {
        settingsGUI.Add("UpDown", "vGuiFontWeight Range0-9",
            S.GetDefault("GuiFontWeight"))
    }

    settingsGUI.Add("Text", "", "GUI Font Name (blank for default):")

    arr := [
        ""
    ]
    Loop Reg "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", "KVR" {
        arr.InsertAt(2, RegExReplace(A_LoopRegName, "\W+\((TrueType|OpenType|All res)\)"))
    }
    preselectfont := 1
    For id, value IN arr {
        If (value = GuiFontName) {
            preselectfont := id
        }
    }
    settingsGUI.AddDropDownList("vGuiFontName Choose" preselectfont, arr)

    settingsGUI.Add("Text", "", "GUI Background Colour:")
    settingsGUI.AddEdit("cDefault vGuiBGColour w140", GuiBGColour)

    settingsGUI.Add("Text", "", "GUI Font Colour:")
    settingsGUI.AddEdit("cDefault vGuiFontColour w140", GuiFontColour)

    settingsGUI.Add("Button", "+Background" GuiBGColour " default", "Save").OnEvent("Click",
        ProcessUserGeneralSettings)
    settingsGUI.Add("Button", "+Background" GuiBGColour " yp", "Cancel").OnEvent("Click",
        CloseUserGeneralSettings)

    settingsGUI.Add("Button", "+Background" GuiBGColour " xs", "Install script to Start Menu").OnEvent("Click",
        InstallShortcuts)
    settingsGUI.Add("Button", "+BackgroundRed yp", "Reset all settings").OnEvent("Click",
        ResetSettings)
    settingsGUI.Add("Button", "+BackgroundYellow yp", "Reset all logs").OnEvent("Click",
        ResetLogs)
    settingsGUI.Add("Button", "+BackgroundYellow xs", "Force check for updates").OnEvent("Click",
        ForceCheckForUpdates)

    settingsGUI.ShowGUIPosition()
    settingsGUI.MakeGUIResizableIfOversize()
    settingsGUI.OnEvent("Size", settingsGUI.SaveGUIPositionOnResize.Bind(settingsGUI))
    OnMessage(0x0003, settingsGUI.SaveGUIPositionOnMove.Bind(settingsGUI))

    ProcessUserGeneralSettings(*) {
        Temp := thisGui.Gui
        Saving := SavingGUI()
        settingsGUI.Hide()
        Temp.Hide()
        Saving.Show()
        values := settingsGUI.Submit()
        S.Set("EnableLogging", values.Logging)
        S.Set("Verbose", values.Verbose)
        S.Set("Debug", values.Debug)
        S.Set("DebugAll", values.DebugAll)
        S.Set("LogBuffer", values.LogBuffer)
        S.Set("TimestampLogs", values.TimestampLogs)
        S.Set("CheckForUpdatesEnable", values.CheckForUpdatesEnable)
        S.Set("CheckForUpdatesReleaseOnly", values.CheckForUpdatesReleaseOnly)
        S.Set("GuiFontBold", values.GuiFontBold)
        S.Set("GuiFontItalic", values.GuiFontItalic)
        S.Set("GuiFontStrike", values.GuiFontStrike)
        S.Set("GuiFontUnderline", values.GuiFontUnderline)
        S.Set("GuiFontSize", values.GuiFontSize)
        S.Set("GuiFontWeight", values.GuiFontWeight)
        S.Set("GuiFontName", values.GuiFontName)
        S.Set("GuiBGColour", values.GuiBGColour)
        S.Set("GuiFontColour", values.GuiFontColour)
        S.SaveCurrentSettings()
        Out.UpdateSettings(S.Get("EnableLogging"), S.Get("Verbose"), S.Get("Debug"), S.Get("DebugAll"), S.Get("LogBuffer"), S.Get("TimestampLogs"))
        Reload()
    }

    CloseUserGeneralSettings(*) {
        settingsGUI.Hide()
    }

    InstallShortcuts(*) {
        full_command_line := DllCall("GetCommandLine", "str")

        If !(A_IsAdmin || RegExMatch(full_command_line, " /restart(?!\S)")) {
            Try {
                Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptDir '\Installer.ahk"'
            }
            Return
        }
        MsgBox("Could not run without Admin")
        Out.D("A_IsAdmin: " A_IsAdmin "`nCommand line: " full_command_line)
    }

    ResetSettings(*) {
        /** @type {cLog} */
        Global Out
        Out := ""
        HasPressed := MsgBox("Remove all ini files? This resets all settings.",
            "Setting Reset?", "0x1 0x100 0x10")
        If (HasPressed = "OK") {
            arr := []
            Loop Files A_ScriptDir "\*", 'F' {
                If (StrLower(A_LoopFileExt) = "ini") {
                    Try {
                        FileDelete(A_LoopFileFullPath)
                        arr.Push(A_LoopFileFullPath)
                    }
                }
            }
            list := ""
            For (value in arr) {
                list .= "Deleted: " value "`n"
            }
            MsgBox("Setting Reset Complete.`n" list)
        }
        Out := cLog()
        Reload()
    }

    ResetLogs(*) {
        /** @type {cLog} */
        Global Out
        Out := ""
        HasPressed := MsgBox("Remove all log files? This resets all logs.",
            "Log Reset?", "0x1 0x100 0x10")
        If (HasPressed = "OK") {
            arr := []
            Loop Files A_ScriptDir "\*", 'F' {
                If (StrLower(A_LoopFileExt) = "log") {
                    Try {
                        FileDelete(A_LoopFileFullPath)
                        arr.Push(A_LoopFileFullPath)
                    }
                }
            }
            list := ""
            For (value in arr) {
                list .= "Deleted: " value "`n"
            }
            MsgBox("Log Reset Complete`n" list)
        }
        Out := cLog()
        Reload()
    }

    ForceCheckForUpdates(*) {
        Temp := thisGui.Gui
        Saving := SavingGUI()
        settingsGUI.Hide()
        Temp.Hide()
        Saving.Show()

        S.Set("CheckForUpdatesLastCheck", 20000101120000)
        S.SaveCurrentSettings()
        Reload()
    }
}
