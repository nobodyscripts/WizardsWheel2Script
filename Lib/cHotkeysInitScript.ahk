#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cHotkeys.ahk

; ------------------- Keybinds -------------------

; Customise these to match your keybinds or change to these ingame
; Make sure to reload() (F2) if you change these while running
; https://www.autohotkey.com/docs/v2/KeyList.htm for a list of possible keys

/** @type {cHotkeys} */
Global Scriptkeys := cHotkeys()

Scriptkeys.IsScriptHotkeys := true

Scriptkeys.sFilename := A_ScriptDir "\ScriptHotkeys.ini"

Scriptkeys.Hotkeys["Exit"] := cHotkey("Exit", Map("EN-US", "F1", "EN-GB", "F1",
    "Other", "F1"), "Default")

Scriptkeys.Hotkeys["Reload"] := cHotkey("Reload", Map("EN-US", "F2", "EN-GB",
    "F2", "Other", "F2"), "Default")

Scriptkeys.Hotkeys["ActiveBattle"] := cHotkey("ActiveBattle", Map("EN-US", "F3",
    "EN-GB", "F3", "Other", "F3"), "Default")

Scriptkeys.Hotkeys["EventItemReset"] := cHotkey("EventItemReset", Map("EN-US", "F4",
    "EN-GB", "F4", "Other", "F4"), "Default")

Scriptkeys.Hotkeys["IronChef"] := cHotkey("IronChef", Map("EN-US", "F5",
    "EN-GB", "F5", "Other", "F5"), "Default")

Scriptkeys.Hotkeys["ItemEnchant"] := cHotkey("ItemEnchant", Map("EN-US", "F6",
    "EN-GB", "F6", "Other", "F6"), "Default")

Scriptkeys.Hotkeys["DimensionPushing"] := cHotkey("DimensionPushing", Map("EN-US",
    "F7", "EN-GB", "F7", "Other", "F7"), "Default")

Scriptkeys.Hotkeys["AutoClicker"] := cHotkey("AutoClicker", Map("EN-US", "F11",
    "EN-GB", "F11", "Other", "F11"), "Default")

Scriptkeys.Hotkeys["GameResize"] := cHotkey("GameResize", Map("EN-US", "F12",
    "EN-GB", "F12", "Other", "F12"), "Default")

If (!IsSet(DisableScriptKeysInit)) {
    Scriptkeys.initHotkeys()
}
