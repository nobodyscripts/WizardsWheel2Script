#Requires AutoHotkey v2.0

;S.AddSetting("TestSection", "TestVar", "true, array, test", "Array")

Global HasOutputStartupString := false

/**
 * ItemEnchanter Enchant items until affix is found visually
 * @module ItemEnchanter
 * @property {Type} property Desc
 * @method Name Desc
 */
Class ItemEnchanter {
    /** @type {Type} Desc */
    property := 0

    /** @type {Affixes} Desc */
    Affixes := Affixes()

    ;@region EnchantItem()
    /**
     * Enchant a single item in the enchanter
     */
    EnchantItem() {
        Loop {
            If (this.ScanItem()) {
                Break
            }
            cPoint(400, 305).ClickOffset()
            Sleep(17)
        }
        MsgBox("Done")
    }
    ;@endregion

    ;@region EnchantItem()
    /**
     * Enchant a single item in the enchanter
     */
    EnchantItemSelected(arr) {
        Loop {
            If (this.ScanSelectedAffixes(arr)) {
                Break
            }
            cPoint(400, 305).ClickOffset()
            Sleep(51)
        }
        MsgBox("Done")
    }
    ;@endregion

    ;@region EnchantAll()
    /**
     * Enchant a all items in the enchanter
     */
    EnchantAll() {

    }
    ;@endregion

    ;@region FindMerchant()
    /**
     * Search the armour store for an item 'of Merchant'
     */
    FindMerchant() {

    }
    ;@endregion

    ;@region ScanItem()
    /**
     * Scan an item for prefixes and suffixes matching image scans
     */
    ScanItem() {
        isNormPrefix := false
        isNormSuffix := false
        isEternal := false
        isAid := false
        isBlazing := false
        singleitem := cRect(263, 256, 626, 310)
        For (id, value IN this.Affixes.Elevated.Prefixes) {
            If (value.IsAffix(singleitem)) {
                Return true
            }
        }
        For (id, value IN this.Affixes.Elevated.Suffixes) {
            If (value.IsAffix(singleitem)) {
                Return true
            }
        }
        For (id, value IN this.Affixes.Norm.Prefixes) {
            If (value.IsAffix(singleitem)) {
                isNormPrefix := true
                If (value.Name = "Eternal") {
                    isEternal := true
                }
                Break
            }

        }
        For (id, value IN this.Affixes.Norm.Suffixes) {
            If (value.IsAffix(singleitem)) {
                isNormSuffix := true
                If (value.Name = "Blazing") {
                    isBlazing := true
                }
                If (value.Name = "Aid") {
                    isAid := true
                }
                Break
            }
        }
        ; If we don't match either and its not elevated then we need to record one
        If (!isNormPrefix || !isNormSuffix) {
            reason := "err"
            If (!isNormPrefix) {
                reason := "Prefix"
            }
            If (!isNormSuffix) {
                reason := "Suffix"
            }
            If (!isNormPrefix && !isNormSuffix) {
                reason := "Prefix and Suffix"
            }
            MsgBox("Found no matching " reason)
            Return true
        }
        ; If we match eternal blazing we've likely matched the selected filter so stop
        If (isEternal && isBlazing) {
            this.EternalBlazingReset()
            Return false
        }
        If (isEternal && isAid) {
            this.EternalAidReset()
            Return false
        }
        Return false
    }
    ;@endregion

    ;@region ScanEnchanterSlots()
    /**
     * Scan the enchanter to find the boxes which contain item information
     */
    ScanEnchanterSlots() {

    }
    ;@endregion

    ;@region EternalBlazingReset()
    /**
     * Reset enchant if Eternal + Blazing detected
     */
    EternalBlazingReset() {
        cPoint(865, 524).Click() ; second dropdown
        Sleep(200)
        cPoint(839, 572).Click() ; Darkness
        Sleep(200)
        cPoint(400, 305).ClickOffset() ; Enchant item
        Sleep(200)
        cPoint(865, 524).Click() ; second dropdown
        Sleep(200)
        cPoint(854, 542).Click() ; Blazing
        Sleep(200)
    }
    ;@endregion

    ;@region EternalAidReset()
    /**
     * Reset enchant if Eternal + Aid is detected
     */
    EternalAidReset() {
        cPoint(865, 524).Click() ; second dropdown
        Sleep(200)
        cPoint(865, 524).Click() ; Antivenom
        Sleep(200)
        cPoint(400, 305).ClickOffset() ; Enchant item
        Sleep(200)
        cPoint(865, 524).Click() ; second dropdown
        Sleep(200)
        cPoint(840, 446).Click() ; Aid
        Sleep(200)
    }
    ;@endregion

    ;@region ScanSelectedAffixes()
    /**
     * Scan for an array of preselected affixes and ignore all else
     */
    ScanSelectedAffixes(Array) {
        Global HasOutputStartupString
        Array := [
            "Haste",
            "Spelunkers",
            "Preeminence",
            "HumanShifting",
            "Shifting"
        ]
        isNormPrefix := false
        isNormSuffix := false
        isEternal := false
        isAid := false
        isBlazing := false
        If (!HasOutputStartupString) {
            Out.I("Searching for selected affixes: " ArrToCommaDelimStr(Array))
            HasOutputStartupString := true
        }

        singleitem := cRect(263, 256, 626, 310)

        ; If 'shifting' special case
        If (ArrayHas("Shifting", Array) && this.Affixes.Special.Item[2].IsAffix(singleitem)) {
            MsgBox("Matched on Shifting")
            Return true

        }

        For (id, value IN this.Affixes.Elevated.Prefixes) {
            If (ArrayHas(value.Name, Array)) {
                If (value.IsAffix(singleitem)) {
                    MsgBox("Matched on " value.Name)
                    Return true
                }
            }
        }
        For (id, value IN this.Affixes.Elevated.Suffixes) {
            If (ArrayHas(value.Name, Array)) {
                If (value.Name = "Necromancer") {
                    If (value.IsAffix(singleitem) && !this.Affixes.Special.Item[1].IsAffix(singleitem)) {
                        MsgBox("Matched on " value.Name)
                        Return true
                    }
                } Else {
                    If (value.IsAffix(singleitem)) {
                        MsgBox("Matched on " value.Name)
                        Return true
                    }
                }
            }
        }
        For (id, value IN this.Affixes.Norm.Prefixes) {
            If (ArrayHas(value.Name, Array) || value.Name = "Eternal") {
                If (value.IsAffix(singleitem)) {
                    isNormPrefix := true
                    If (value.Name = "Eternal") {
                        isEternal := true
                    }
                    Break
                }
            }
        }
        For (id, value IN this.Affixes.Norm.Suffixes) {
            If (ArrayHas(value.Name, Array) || value.Name = "Aid" ||
            value.Name = "Blazing") {
                If (value.IsAffix(singleitem)) {
                    isNormSuffix := true
                    If (value.Name = "Blazing") {
                        isBlazing := true
                    }
                    If (value.Name = "Aid") {
                        isAid := true
                    }
                    Break
                }
            }
        }
        ; If we match eternal blazing we've likely matched the selected filter so stop
        If (isEternal && isBlazing) {
            this.EternalBlazingReset()
            Return false
        }
        If (isEternal && isAid) {
            this.EternalAidReset()
            Return false
        }
        Return false

        /**
         * 
         * @param Name Affix name
         * @param affixList Simple array of Affix names selected by user
         */
        ArrayHas(Name, affixList) {
            For (id, value IN affixList) {
                If (value = Name) {
                    Return true
                }
            }
            Return false
        }
    }
    ;@endregion
}

/**
 * Affix Object defining the image and affix details for scanning in the ui
 * @module Affix
 * 
 * @param Name 
 * @param Pos Prefix 0 Suffix 1
 * @param imgW 
 * @param imgH 
 * @param bgCol 
 * @returns {Affix} 
 * 
 * @method Name Desc
 */
Class Affix {
    /** @type {Type} Desc */
    property := 0

    ;@region Affix()
    /**
     * Does item have affix (prefix or suffix)
     * @param Name
     * @param Pos Prefix 0 Suffix 1
     * @param imgW
     * @param imgH
     * @param bgCol
     * @returns {Affix}
     */
    __New(Name, Pos, imgW, imgH, bgCol) {
        this.Name := Name
        this.Pos := Pos
        this.imgW := imgW
        this.imgH := imgH
        this.bgCol := bgCol
        Switch (this.Pos) {
        Case -1:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Item" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.D("Error at loadpicture prefix")
                Out.D(OutputVar.What)
            }
        Case 0:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Prefix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.D("Error at loadpicture prefix")
                Out.D(OutputVar.What)
            }
        Case 1:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Suffix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.D("Error at loadpicture suffix")
                Out.D(OutputVar.What)
            }
        default:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Prefix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.D("Error at loadpicture prefix")
                Out.D(OutputVar.What)
            }
        }
        If (this.Pos = 0) {

        } Else {

        }
        Return this
    }
    ;@endregion

    ;@region IsAffix()
    /**
     * Does item have affix (prefix or suffix)
     * @param {cRect} rect 
     */
    IsAffix(rect) {
        Try {
            If (rect.ImageSearch("HBITMAP:*" this.Img, this.bgCol)) {
                Return true
            }
        } Catch Error As OutputVar {
            Out.D("Error at imagesearch")
            Out.D(OutputVar.What)
        }
        /*
                If (this.Pos = 0) {
        
                } Else {
        If (rect.ImageSearch(A_ScriptDir "\Images\Suffix" this.Name ".png")) {
            Return true
        }
        } */
        Return false
    }
    ;@endregion
}

/** @type {Map} Nested struct
 * @property {Object} Elevated - {Prefixes, Suffixes, NotCaptured}
 * @property {Object} Norm - {Prefixes, Suffixes, NotCaptured}
 */
Class Affixes {
    Elevated := {
        Prefixes: [
            Affix("Earthly", 0, 62, 26, "721A04"),
            Affix("Fruitful", 0, 58, 18, "721A04"),
            Affix("Glimmering", 0, 95, 24, "721A04"),
            Affix("Jokers", 0, 56, 17, "721A04"),
            Affix("Mammoth", 0, 83, 18, "721A04"),
            Affix("Mechanized", 0, 94, 21, "721A04"),
            Affix("Mercurial", 0, 77, 21, "B96345"),
            Affix("Monumental", 0, 103, 22, "B96345"),
            Affix("Perforating", 0, 94, 21, "721A04"),
            Affix("Preeminence", 0, 107, 18, "721A04"),
            Affix("Savants", 0, 74, 25, "B96345"),
            Affix("Serrated", 0, 74, 20, "721A04"),
            Affix("Spelunkers", 0, 93, 18, "721A04")
        ],
        Suffixes: [
            Affix("Agony", 1, 53, 23, "721A04"),
            Affix("Anima", 1, 90, 23, "721A04"),
            Affix("Bolting", 1, 61, 24, "721A04"),
            Affix("Crusading", 1, 84, 25, "721A04"),
            Affix("Ether", 1, 50, 23, "721A04"),
            Affix("Glamour", 1, 69, 16, "721A04"),
            Affix("Igniting", 1, 61, 20, "B96345"),
            Affix("Lightless", 1, 75, 21, "721A04"),
            Affix("Necromancer", 1, 108, 15, "721A04"),
            Affix("Radiance", 1, 76, 22, "B96345"),
            Affix("Supereons", 1, 86, 21, "721A04"),
        ],
        NotCaptured: [
            Affix("Acuminating", -1, 0, 0, ""),
            Affix("Behemoth's", -1, 0, 0, ""),
            Affix("Brilliance", -1, 0, 0, ""), ; May not exist
            Affix("Infestation", -1, 0, 0, ""),
            Affix("Overlord", -1, 0, 0, "")
        ]
    },
    Norm := {
        Prefixes: [
            Affix("Acute", 0, 47, 17, "721A04"),
            Affix("Adaptable", 0, 83, 22, "721A04"),
            Affix("Charmed", 0, 75, 19, "721A04"),
            Affix("Colossal", 0, 62, 18, "721A04"),
            Affix("Diamond", 0, 70, 18, "721A04"),
            Affix("DragonShifting", 0, 124, 21, "B96345"),
            Affix("Dynamic", 0, 70, 23, "721A04"),
            Affix("Eternal", 0, 0, 0, "B96345"),
            Affix("Fortuitous", 0, 85, 19, "721A04"),
            Affix("Furtive", 0, 61, 17, "721A04"),
            Affix("Healthy", 0, 62, 20, "721A04"),
            Affix("HumanShifting", 0, 121, 21, "721A04"),
            Affix("Jesters", 0, 62, 17, "721A04"),
            Affix("Learners", 0, 77, 18, "721A04"),
            Affix("Light", 0, 41, 21, "721A04"), ; Is both prefix and suffix
            Affix("Looters", 0, 66, 16, "721A04"),
            Affix("Lucrative", 0, 79, 17, "721A04"),
            Affix("MagicShifting", 0, 109, 21, "721A04"),
            Affix("Massive", 0, 67, 23, "B96345"),
            Affix("Modified", 0, 68, 19, "721A04"),
            Affix("Momentous", 0, 97, 20, "B96345"),
            Affix("Natural", 0, 61, 18, "721A04"),
            Affix("NatureShifting", 0, 121, 21, "721A04"),
            Affix("Piercing", 0, 67, 22, "721A04"),
            Affix("Precise", 0, 60, 21, "721A04"),
            Affix("Professors", 0, 90, 17, "B96345"),
            Affix("Reinforced", 0, 87, 18, "721A04"),
            Affix("Scholars", 0, 71, 18, "721A04"),
            Affix("Sharp", 0, 48, 21, "721A04"),
            Affix("Shiny", 0, 44, 21, "721A04"),
            Affix("Spiked", 0, 53, 19, "721A04"),
            Affix("Stalwart", 0, 0, 0, "721A04"),
            Affix("Sturdy", 0, 54, 20, "721A04"),
            Affix("Quicksilver", 0, 90, 19, "721A04"),
            Affix("TechShifting", 0, 101, 21, "721A04"),
            Affix("Troubadours", 0, 105, 17, "721A04"),
            Affix("UndeadShifting", 0, 115, 20, "B96345"),
            Affix("Vicious", 0, 56, 17, "721A04"),
            Affix("Vigorous", 0, 72, 16, "721A04")
        ],
        Suffixes: [
            Affix("Aid", 1, 28, 20, "721A04"),
            Affix("Anatomy", 1, 74, 20, "721A04"),
            Affix("Antivenom", 1, 90, 17, "721A04"),
            Affix("Bear", 1, 39, 18, "721A04"),
            Affix("Blazing", 1, 58, 21, "721A04"),
            Affix("Colossus", 1, 69, 19, "721A04"),
            Affix("Darkness", 1, 76, 18, "721A04"),
            Affix("Deception", 1, 82, 21, "721A04"),
            Affix("Defiance", 1, 70, 19, "721A04"),
            Affix("Efficiency", 1, 77, 21, "721A04"),
            Affix("Evasion", 1, 63, 18, "721A04"),
            Affix("Eons", 1, 41, 20, "B96345"),
            Affix("Greed", 1, 50, 18, "721A04"),
            Affix("Haste", 1, 48, 19, "721A04"),
            Affix("HolyWar", 1, 38, 24, "721A04"),
            Affix("Honing", 1, 55, 21, "B96345"),
            Affix("Light", 1, 42, 21, "721A04"),
            Affix("Mastery", 1, 73, 24, "B96345"),
            Affix("Meditation", 1, 90, 21, "B96345"),
            Affix("Merchants", 1, 83, 20, "B96345"),
            Affix("Might", 1, 46, 21, "721A04"), ; Armour
            Affix("Nether", 1, 58, 19, "721A04"),
            Affix("Pain", 1, 41, 23, "721A04"),
            Affix("Plumage", 1, 71, 23, "721A04"),
            Affix("QuickStrikes", 1, 42, 17, "721A04"),
            Affix("Replenishing", 1, 100, 21, "721A04"),
            Affix("Ruse", 1, 39, 17, "721A04"),
            Affix("Serpent", 1, 67, 19, "721A04"),
            Affix("Soul", 1, 34, 17, "721A04"),
            Affix("Subterfuge", 1, 90, 21, "721A04"),
            Affix("Taming", 1, 61, 22, "721A04"),
            Affix("Time", 1, 24, 20, "B96345"),
            Affix("Thunder", 1, 67, 17, "721A04"),
            Affix("Venom", 1, 64, 21, "721A04"),
            Affix("Wit", 1, 24, 17, "721A04")
        ],
        NotCaptured: [
            Affix("Boss", 0, 0, 0, "721A04"),
            Affix("Flaming", 0, 0, 0, "721A04"),
            Affix("Giants", 0, 0, 0, "721A04"),
            Affix("Swarming", 0, 0, 0, "721A04"),
            Affix("Tigers", 0, 0, 0, "721A04"),
            Affix("Lich", 1, 0, 0, "721A04"),
            Affix("Plague", 1, 0, 0, "721A04"),
        ]
    },
    Special := {
        Item: [
            Affix("Necromancer", -1, 122, 18, "721A04"),
            Affix("Shifting", -1, 60, 21, "B96345")
        ]
    }
}
/*
Mana flow,
Perforating,
Universal,
Displacing,
Preeminence,
Glimmering,
Mammoth,
Fruitful,
Crusading,
Glimmering,
Spelunker,
serrated,
Savant,
Fruitful,
Compression,

Acuminating,
Behemoth,
Brilliance,
Infestation,
Interstellar,
Overlord,
Boss,
Colossal,
Flaming,
Giant,
Swarming,
Tiger,
Troubadour,
Lich
*/
