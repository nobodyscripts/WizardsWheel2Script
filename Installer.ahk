#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 8
#SingleInstance Force

#Include ScriptLib\cLogging.ahk
#Include ScriptLib\cSettings.ahk

/** @type {cLog} */
Out := cLog(A_ScriptDir "\Secondaries.log", true, 3, false)

S.initSettings()
S.AddSetting("Installer", "IsInstalled", true, "bool")
S.SaveCurrentSettings()

InstallScript()
;@region InstallScript()
InstallScript(*) {
    full_command_line := DllCall("GetCommandLine", "str")

    If !(A_IsAdmin || RegExMatch(full_command_line, " /restart(?!\S)")) {
        Try {
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        }
        Return
    }
    Try {
        ShortcutFolder := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\NobodyScripts"
        If (!DirExist(ShortcutFolder)) {
            DirCreate(ShortcutFolder)
        }
        ; WizardsWheel2 shortcut
        FileCreateShortcut(A_ScriptDir "\WizardsWheel2.ahk", ShortcutFolder "\WizardsWheel2 NobodyScript.lnk",
            ShortcutFolder, ,
            "Start the WizardsWheel2 Script by Nobody")

        ; Updater shortcut
        FileCreateShortcut(A_ScriptDir "\Update.ahk", ShortcutFolder "\Update WizardsWheel2.lnk", ShortcutFolder, ,
            "Update WizardsWheel2 Script")

        ; Uninstaller shortcut
        FileCreateShortcut(A_ScriptDir "\Uninstaller.ahk", ShortcutFolder "\Uninstall WizardsWheel2.lnk", ShortcutFolder, ,
            "Remove WizardsWheel2 Script")
        If (FileExist(ShortcutFolder "\WizardsWheel2 NobodyScript.lnk")) {
            MsgBox("Shortcuts created in Start Menu")
        } Else {
            MsgBox("Failed to create shortcuts")
        }
    } Catch Error As OutputVar {
        Out.E(OutputVar)
    }
}
;@endregion
