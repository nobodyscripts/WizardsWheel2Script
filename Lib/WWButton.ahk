#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cButton.ahk

/**
 * WWButton extends cButton 
 * @module WWButton
 * @extends cButton
 */
Class WWButton extends cButton {
    /** 0xFFFFFF
     * @type {String} */
    Active := ""
    /** 0xFFFFFF
     *  @type {String} */
    ActiveMouseOver := ""
    /** 0xFFFFFF
     * @type {String} */
    Inactive := ""
    /** 0xFFFFFF
     * @type {String} */
    Background := ""
    /** 0xFFFFFF
     * @type {String} */
    ActiveSelected := ""
    /** 0xFFFFFF
     * @type {String} */
    InactiveSelected := ""
}