#Requires AutoHotkey v2.0

#Include cHotkeys.ahk

; ------------------- Keybinds -------------------

; Customise these to match your keybinds or change to these ingame
; Make sure to reload() (F2) if you change these while running
; https://www.autohotkey.com/docs/v2/KeyList.htm for a list of possible keys

/** @type {cHotkeys} */
Global Scriptkeys := cHotkeys()

Scriptkeys.IsScriptHotkeys := true

Scriptkeys.sFilename := A_ScriptDir "\ScriptHotkeys.ini"

Scriptkeys.Hotkeys["Exit"] := cHotkey("Exit", Map("EN-US", "NumpadSub", "EN-GB", "NumpadSub",
    "Other", "NumpadSub"), "Default")

Scriptkeys.Hotkeys["Reload"] := cHotkey("Reload", Map("EN-US", "NumpadAdd", "EN-GB",
    "NumpadAdd", "Other", "NumpadAdd"), "Default")

Scriptkeys.Hotkeys["AutoClicker"] := cHotkey("AutoClicker", Map("EN-US", "F11",
    "EN-GB", "F11", "Other", "F11"), "Default")

Scriptkeys.Hotkeys["GameResize"] := cHotkey("GameResize", Map("EN-US", "F12",
    "EN-GB", "F12", "Other", "F12"), "Default")

Scriptkeys.Hotkeys["IronChef"] := cHotkey("IronChef", Map("EN-US", "Numpad0",
    "EN-GB", "Numpad0", "Other", "Numpad0"), "Default")

Scriptkeys.Hotkeys["ActiveBattle"] := cHotkey("ActiveBattle", Map("EN-US", "NumpadEnter",
    "EN-GB", "NumpadEnter", "Other", "NumpadEnter"), "Default")

Scriptkeys.Hotkeys["EventItemReset"] := cHotkey("EventItemReset", Map("EN-US", "F10",
    "EN-GB", "F10", "Other", "F10"), "Default")

If (!IsSet(DisableScriptKeysInit)) {
    Scriptkeys.initHotkeys(IsSecondary)
}
