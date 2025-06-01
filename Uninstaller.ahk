#Requires AutoHotkey v2.0
#MaxThreadsPerHotkey 8
#SingleInstance Force

#Include ScriptLib\cLogging.ahk
#Include ScriptLib\cSettings.ahk

/** @type {cLog} */
Out := cLog(A_ScriptDir "\Secondaries.log", true, 3, false)

S.initSettings()
S.AddSetting("Installer", "IsInstalled", false, "bool")
S.SaveCurrentSettings()

UninstallScript()

;@region UninstallScript()
/**
 * 
 */
UninstallScript(*) {
    full_command_line := DllCall("GetCommandLine", "str")

    If !(A_IsAdmin || RegExMatch(full_command_line, " /restart(?!\S)")) {
        Try {
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
        }
        Return
    }
    Try {
        ShortcutFolder := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\NobodyScripts"
        If (DirExist(ShortcutFolder)) {
            If (FileExist(ShortcutFolder "\WizardsWheel2 NobodyScript.lnk")) {
                FileDelete(ShortcutFolder "\WizardsWheel2 NobodyScript.lnk")
            }
            If (FileExist(ShortcutFolder "\Update WizardsWheel2.lnk")) {
                FileDelete(ShortcutFolder "\Update WizardsWheel2.lnk")
            }
            If (FileExist(ShortcutFolder "\Uninstall WizardsWheel2.lnk")) {
                FileDelete(ShortcutFolder "\Uninstall WizardsWheel2.lnk")
            }
            DirDelete(ShortcutFolder, 0)
        }
        HasPressed := MsgBox("Delete script folder? This removes everything in " A_ScriptDir,
            "Delete folder?", "0x1 0x100 0x10")
        If (HasPressed = "OK") {
            DirDelete(A_ScriptDir, 1)
        }
    } Catch Error As OutputVar {
        Out.E(OutputVar)
    }
}
;@endregion
