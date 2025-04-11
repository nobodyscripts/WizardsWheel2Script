#Requires AutoHotkey v2.0

#Include Logging.ahk

; ------------------- Settings -------------------
; Loads UserSettings.ini values for the rest of the script to use

;@region Globals definition
Global EnableLogging := false
Global Debug := false
Global Verbose := false
Global TimestampLogs := true
Global LogBuffer := true
Global CheckForUpdatesEnable := true
Global CheckForUpdatesReleaseOnly := true
Global CheckForUpdatesLastCheck := 0

Global EventItemTypeArmour,
    EventItemAmount,
    EventItemGood,
    EventItemPerfect,
    EventItemSocketed,
    EventItemStoreSlot,
    EventItemID
;@endregion

/**
 * Single instance of a script setting object
 * @property Name Name of the setting and global var name
 * @property DefaultValue Default value for non developers
 * @property NobodyDefaultValue Default value for developer
 * @property DataType Internal custom datatype string {bool | int | array}
 * @property Category Ini file category heading
 * @method __new Constructor
 * @method ValueToString Converts value to file writable string
 * @method SetCommaDelimStrToArr Set global of this.Name to an array of value
 * split by comma
 */
Class singleSetting {
    ;@region Properties
    /**
     * Name of the setting and global var name
     * @type {String} 
     */
    Name := ""
    /**
     * Default value for non developers
     * @type {String | Integer | Any} 
     */
    DefaultValue := 0
    /**
     * Default value for developer
     * @type {String | Integer | Any} 
     */
    NobodyDefaultValue := 0
    /**
     * Internal custom datatype string
     * @type {String} 
     */
    DataType := "bool"
    /**
     * Ini file category heading
     * @type {String} 
     */
    Category := "Default"
    ;@endregion

    ;@region __new()
    /**
     * Constructs class and provides object back, has defaults for all except 
     * iName
     * @constructor
     * @param iName Name of the setting and global var
     * @param {Integer} iDefaultValue Default value set in script
     * @param {Integer} iNobodyDefaultValue Default value set for developer
     * @param {String} [iDataType="bool"] Internal custom datatype
     * @param {String} [iCategory="Default"] Ini file section heading name
     * @returns {singleSetting} Returns (this)
     */
    __New(iName, iDefaultValue := 0, iNobodyDefaultValue := 0, iDataType :=
        "bool", iCategory := "Default") {
        this.Name := iName
        this.DefaultValue := iDefaultValue
        this.NobodyDefaultValue := iNobodyDefaultValue
        this.DataType := iDataType
        this.Category := iCategory
        Return this
    }
    ;@endregion

    ;@region ValueToString()
    /**
     * Convert value to file writable string
     * @param {Any} value Defaults to getting value of the global variable
     * @returns {String | Integer | Any} 
     */
    ValueToString(value := %this.Name%) {
        Switch (StrLower(this.DataType)) {
        Case "bool":
            Return BinaryToStr(value)
        Case "array":
            Return ArrToCommaDelimStr(value)
        default:
            Return value
        }
    }
    ;@endregion

    ;@region SetCommaDelimStrToArr()
    /**
     * Set global of this.Name to an array of value split by comma
     * @param var Value comma seperated string to split into array
     */
    SetCommaDelimStrToArr(var) {
        %this.Name% := StrSplit(var, " ", ",.")
    }
    ;@endregion
}

/**
 * cSettings - Stores settings data
 * @property sFilename Full file path to ini file for settings
 * @property sFileSection Ini section heading for settings
 * @property sUseNobody Use developer default settings toggle
 * @property Map Map to store singleSettings objects per global var name
 * @method initSettings Load Map with defaults, check if file, load if possible,
 * return loaded state
 * @method loadSettings Load script settings into global vars, runs UpdateSettings
 * first to add missing settings rather than reset to defaults if some settings
 * exist
 * @method UpdateSettings Adds missing settings using defaults if some settings 
 * don't exist
 * @method WriteDefaults Write default settings to ini file, does not wipe other
 * removed settings
 * @method SaveCurrentSettings Save current Map to ini file converting to format
 * safe for storage
 * @method WriteToIni Write (key, value) to ini file within (section) heading
 * @method IniToVar Reads ini value for (name) in (section) from (file) and 
 * returns as string or Boolean
 */
Class cSettings {
    ;@region Properties
    /**
     * Full file path to ini file for settings
     * @type {String} 
     */
    sFilename := A_ScriptDir "\UserSettings.ini"
    /**
     * Ini section heading for settings
     * @type {String}
     */
    sFileSection := "Default"
    /**
     * Use developer default settings toggle
     * @type {Boolean}
     */
    sUseNobody := false
    /**
     * Map to store singleSettings objects per global var name
     * @type {Map<string, singleSetting>}
     */
    Map := Map()
    ;@endregion

    ;@region initSettings()
    /**
     * Load Map with defaults, check if file, load if possible, return loaded 
     * state
     * @param {Integer} secondary Is script the main script or a spammer (for 
     * paths)
     * @returns {Boolean} 
     */
    initSettings(secondary := false) {
        Global Debug

        ;@region Settings map initialization
        this.Map := Map()

        this.Map["EnableLogging"] := singleSetting("EnableLogging", false, true,
            "bool", "Default")
        this.Map["TimestampLogs"] := singleSetting("TimestampLogs", true, true,
            "bool", "Default")
        this.Map["CheckForUpdatesEnable"] := singleSetting(
            "CheckForUpdatesEnable", true, true, "bool", "Updates")
        this.Map["CheckForUpdatesReleaseOnly"] := singleSetting(
            "CheckForUpdatesReleaseOnly", true, true, "bool", "Updates")
        this.Map["CheckForUpdatesLastCheck"] := singleSetting(
            "CheckForUpdatesLastCheck", 0, 0, "int", "Updates")
        this.Map["Debug"] := singleSetting("Debug", false, true, "bool",
            "Debug")
        this.Map["Verbose"] := singleSetting("Verbose", false, true, "bool",
            "Debug")
        this.Map["LogBuffer"] := singleSetting("LogBuffer", true, true, "bool",
            "Debug")
        this.Map["EventItemAmount"] := singleSetting(
            "EventItemAmount", 4, 4, "int", "EventItem")
        this.Map["EventItemGood"] := singleSetting("EventItemGood", true, true,
            "bool", "EventItem")
        this.Map["EventItemPerfect"] := singleSetting("EventItemPerfect", true, true,
            "bool", "EventItem")
        this.Map["EventItemSocketed"] := singleSetting("EventItemSocketed", true, true, "bool", "EventItem")
        this.Map["EventItemStoreSlot"] := singleSetting(
            "EventItemStoreSlot", 1, 1, "int", "EventItem")
        this.Map["EventItemTypeArmour"] := singleSetting("EventItemTypeArmour", true, true,
            "bool", "EventItem")
        this.Map["EventItemID"] := singleSetting(
            "EventItemID", 1, 1, "int", "EventItem")

        ;@endregion

        If (!secondary) {
            If (FileExist(A_ScriptDir "\IsNobody")) {
                this.sUseNobody := true
                Debug := true
                Out.I("Settings: Using Nobody Defaults")
            }
            If (!FileExist(this.sFilename)) {
                Out.I("No UserSettings.ini found, writing default file.")
                this.WriteDefaults(this.sUseNobody)
            }
            If (this.loadSettings()) {
                UpdateDebugLevel()
                Out.I("Loaded settings.")
            } Else {
                Return false
            }
            Return true
        } Else {
            this.sFilename := A_ScriptDir "\..\UserSettings.ini"
            If (this.loadSettings()) {
                UpdateDebugLevel()
                Out.I("Loaded settings.")
            } Else {
                Return false
            }
            Return true
        }
    }
    ;@endregion

    ;@region loadSettings()
    /**
     * Load script settings into global vars, runs UpdateSettings first to add
     * missing settings rather than reset to defaults if some settings exist
     * @returns {Boolean} False if error
     */
    loadSettings() {
        ;@region Globals
        Global EnableLogging := false
        Global Debug := false
        Global Verbose := false
        Global TimestampLogs, LogBuffer

        Global CheckForUpdatesEnable, CheckForUpdatesReleaseOnly,
            CheckForUpdatesLastCheck

        Global EventItemTypeArmour,
            EventItemAmount,
            EventItemGood,
            EventItemPerfect,
            EventItemSocketed,
            EventItemStoreSlot,
            EventItemID
        ;@endregion

        this.UpdateSettings()
        For (setting in this.Map) {
            Try {
                If (StrLower(this.Map[setting].DataType) != "array") {
                    %this.Map[setting].Name% := ;
                        this.IniToVar(this.Map[setting].Name, this.Map[setting]
                            .Category)
                } Else {
                    ; special handling for array datatypes
                    %this.Map[setting].Name% := CommaDelimStrToArr( ;
                        this.IniToVar(this.Map[setting].Name, this.Map[setting]
                            .Category))
                }
            } Catch As exc {
                If (exc.Extra) {
                    Out.I("Error 35: LoadSettings failed - " exc.Message "`n" exc
                        .Extra)
                } Else {
                    Out.I("Error 35: LoadSettings failed - " exc.Message)
                }
                MsgBox("Could not load all settings, making new default " .
                    "UserSettings.ini")
                Out.I("Attempting to write a new default UserSettings.ini.")
                this.WriteDefaults(this.sUseNobody)
                Return false
            }
        }
        Return true
    }
    ;@endregion

    ;@region UpdateSettings()
    /**
     * Adds missing settings using defaults if some settings don't exist
     */
    UpdateSettings() {
        For (setting in this.Map) {
            Try {
                test := this.IniToVar(this.Map[setting].Name, this.Map[setting]
                    .Category)
            } Catch {
                If (!this.sUseNobody) {
                    this.WriteToIni(this.Map[setting].Name, this.Map[setting].ValueToString(
                        this.Map[setting].DefaultValue), this.Map[setting].Category
                    )
                } Else {
                    this.WriteToIni(this.Map[setting].Name, this.Map[setting].ValueToString(
                        this.Map[setting].NobodyDefaultValue), this.Map[setting
                    ].Category)
                }
            }
        }
    }
    ;@endregion

    ;@region WriteDefaults()
    /**
     * Write default settings to ini file, does not wipe other removed settings
     * @param isnobody Flag for developer default settings
     */
    WriteDefaults(isnobody) {
        If (isnobody) {
            For (setting in this.Map) {
                this.WriteToIni(this.Map[setting].Name, this.Map[setting].ValueToString(
                    this.Map[setting].NobodyDefaultValue), this.Map[setting].Category
                )
            }
        } Else {
            For (setting in this.Map) {
                this.WriteToIni(this.Map[setting].Name, this.Map[setting].ValueToString(
                    this.Map[setting].DefaultValue), this.Map[setting].Category
                )
            }
        }
    }
    ;@endregion

    ;@region SaveCurrentSettings()
    /**
     * Save current Map to ini file converting to format safe for storage
     */
    SaveCurrentSettings() {
        For (setting in this.Map) {
            this.WriteToIni(this.Map[setting].Name, ;
                this.Map[setting].ValueToString(), this.Map[setting].Category)
        }
    }
    ;@endregion

    ;@region WriteToIni()
    /**
     * Write (key, value) to ini file within (section) heading
     * @param key Name of setting
     * @param value Value of setting
     * @param {String} [section="Default"] 
     */
    WriteToIni(key, value, section := this.sFileSection) {
        IniWrite(value, this.sFilename, section, key)
    }
    ;@endregion

    ;@region IniToVar()
    /**
     * Reads ini value for (name) in (section) from (file) and returns as 
     * string or Boolean
     * @param name 
     * @param {String} section 
     * @param {String} file 
     * @returns {Integer | String} 
     */
    IniToVar(name, section := this.sFileSection, file := this.sFilename) {
        var := IniRead(file, section, name)
        Switch var {
        Case "true":
            Return true
        Case "false":
            Return false
        default:
            Return var
        }
    }
    ;@endregion
}
