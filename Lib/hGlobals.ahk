#Requires AutoHotkey v2.0

/**
 * File contains globals reused between scripts
 */

Global TimestampLogs := true

If (!IsSet(EnableLogging)) {
    Global EnableLogging := true
}

If (!IsSet(Debug)) {
    Global Debug := true
}

If (!IsSet(Verbose)) {
    Global Verbose := true
}

If (!IsSet(LogBuffer)) {
    Global LogBuffer := true
}

/** @type {cLog} Global cLog object
 * Using Out instead of Log as thats taken by a func
 */
Global Out := cLog(ScriptsLogFile, true, 3)

/**
 * @type {cGameWindow} Game window class global
 */
Global Window := cGameWindow(
    "Wizard's Wheel 2 ahk_class UnityWndClass ahk_exe Wizard's Wheel 2.exe")