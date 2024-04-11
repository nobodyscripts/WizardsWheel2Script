#Requires AutoHotkey v2.0

; ------------------- Settings -------------------
; Loads UserSettings.ini values for the rest of the script to use

global EnableLogging := false
global Debug := false
global EventItemTypeArmour,
    EventItemAmount,
    EventItemGood,
    EventItemPerfect,
    EventItemSocketed,
    EventItemStoreSlot

class cSettings {
    sFilename := A_ScriptDir "\UserSettings.ini"
    sFileSection := "Default"
    sUseNobody := false
    defaultNobodySettings := {
        EnableLogging: "true",
        EventItemAmount: "4",
        EventItemGood: "true",
        EventItemPerfect: "false",
        EventItemSocketed: "true",
        EventItemStoreSlot: 1,
        EventItemTypeArmour: "true"
    }
    defaultSettings := {
        EnableLogging: "false",
        EventItemAmount: "4",
        EventItemGood: "true",
        EventItemPerfect: "false",
        EventItemSocketed: "true",
        EventItemStoreSlot: 1,
        EventItemTypeArmour: "true"
    }
    loadedSettings := {}
    /*
    __Init() {     } */

    initSettings(secondary := false) {
        global Debug
        if (!secondary) {
            if (FileExist(A_ScriptDir "\IsNobody")) {
                this.sUseNobody := true
                Debug := true
                OutputDebug("Settings: Using Nobody Defaults.`r`n")
                Log("Settings: Using Nobody Defaults")
            }
            if (!FileExist(this.sFilename)) {
                OutputDebug("No UserSettings.ini found, writing default file.`r`n")
                Log("No UserSettings.ini found, writing default file.")
                this.WriteDefaults()
            }
            if (this.loadSettings()) {
                Log("Loaded settings.")
            } else {
                return false
            }
            return true
        } else {
            this.sFilename := A_ScriptDir "\..\UserSettings.ini"
            if (this.loadSettings()) {
                Log("Loaded settings.")
            } else {
                return false
            }
            return true
        }
    }

    loadSettings() {
        global EnableLogging, Debug
        global EventItemTypeArmour,
            EventItemAmount,
            EventItemGood,
            EventItemPerfect,
            EventItemSocketed,
            EventItemStoreSlot
        try {
            EnableLogging := this.loadedSettings.EnableLogging :=
                IniToVar(this.sFilename, this.sFileSection, "EnableLogging")
            EventItemAmount := this.loadedSettings.EventItemAmount :=
                IniToVar(this.sFilename, "EventItems", "EventItemAmount")
            EventItemGood := this.loadedSettings.EventItemGood :=
                IniToVar(this.sFilename, "EventItems", "EventItemGood")
            EventItemPerfect := this.loadedSettings.EventItemPerfect :=
                IniToVar(this.sFilename, "EventItems", "EventItemPerfect")
            EventItemSocketed := this.loadedSettings.EventItemSocketed :=
                IniToVar(this.sFilename, "EventItems", "EventItemSocketed")
            EventItemStoreSlot := this.loadedSettings.EventItemStoreSlot :=
                IniToVar(this.sFilename, "EventItems", "EventItemStoreSlot")
            EventItemTypeArmour := this.loadedSettings.EventItemTypeArmour :=
                IniToVar(this.sFilename, "EventItems", "EventItemTypeArmour")


            Debug := IniToVar(this.sFilename, "Debug", "Debug")
        } catch as exc {
            if (exc.Extra) {
                Log("Error 35: LoadSettings failed - " exc.Message "`n" exc.Extra)
            } else {
                Log("Error 35: LoadSettings failed - " exc.Message)
            }
            MsgBox("Could not load all settings, making new default UserSettings.ini")
            Log("Attempting to write a new default UserSettings.ini.")
            this.WriteDefaults()
            return false
        }
        return true
    }

    /* saveSettings() {
        IniWrite("this is a new value", this.sFilename, this.sFileSection, "key")
    
    } */

    WriteToIni(key, value, section := this.sFileSection) {
        IniWrite(value, this.sFilename, section, key)
    }

    WriteDefaults() {
        global Debug
        if (this.sUseNobody) {
            this.WriteToIni("EnableLogging", this.defaultNobodySettings.EnableLogging)
            this.WriteToIni("EventItemAmount", this.defaultNobodySettings.EventItemAmount, "EventItems")
            this.WriteToIni("EventItemGood", this.defaultNobodySettings.EventItemGood, "EventItems")
            this.WriteToIni("EventItemPerfect", this.defaultNobodySettings.EventItemPerfect, "EventItems")
            this.WriteToIni("EventItemSocketed", this.defaultNobodySettings.EventItemSocketed, "EventItems")
            this.WriteToIni("EventItemStoreSlot", this.defaultNobodySettings.EventItemStoreSlot, "EventItems")
            this.WriteToIni("EventItemTypeArmour", this.defaultNobodySettings.EventItemTypeArmour, "EventItems")
        } else {
            this.WriteToIni("EnableLogging", this.defaultSettings.EnableLogging)
            this.WriteToIni("EventItemAmount", this.defaultSettings.EventItemAmount, "EventItems")
            this.WriteToIni("EventItemGood", this.defaultSettings.EventItemGood, "EventItems")
            this.WriteToIni("EventItemPerfect", this.defaultSettings.EventItemPerfect, "EventItems")
            this.WriteToIni("EventItemSocketed", this.defaultSettings.EventItemSocketed, "EventItems")
            this.WriteToIni("EventItemStoreSlot", this.defaultSettings.EventItemStoreSlot, "EventItems")
            this.WriteToIni("EventItemTypeArmour", this.defaultSettings.EventItemTypeArmour, "EventItems")
        }
        this.WriteToIni("Debug", BinaryToStr(Debug), "Debug")
    }
}

IniToVar(file, section, name) {
    var := IniRead(file, section, name)
    switch var {
        case "true":
            return true
        case "false":
            return false
        default:
            return var
    }
}

BinaryToStr(var) {
    if (var) {
        return "true"
    }
    return "false"
}