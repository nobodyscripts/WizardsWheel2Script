#Requires AutoHotkey v2.0

S.AddSetting("ItemEnchant", "ItemEnchantSelectedAffixes", "", "Array")

Global HasOutputStartupString := false
/*

Issues:
Jokers false detection, preeminence found on weapons but not armour, rest not
found during farming session
Weapons: Igniting
Armour: Jokers, Serrated, UndeadShifting, Preeminence

Block from enchanter scans:
*/

/**
 * ItemEnchanter Enchant items until affix is found visually
 * @module ItemEnchanter
 * @property {Type} property Desc
 * @method Name Desc
 */
Class ItemEnchanter {
    /** @type {Affixes} */
    Affixes := Affixes()

    /** "Item is enchanted" pixel check FFFFFF
     * @type {cPoint} */
    Enchanted := cPoint(590, 150)
    /** Sample of primary item background area, to check if colour vanishes when
     * resetting dropdowns on start
     *  @type {cPoint} */
    ItemSample := cPoint(618, 263)
    /**  @type {cPoint} */
    leftDropDownClick := cPoint(623, 523)
    /** @type {cRect} */
    leftDropDown := cRect(516, 504, 688, 538)
    /**  @type {cPoint} */
    rightDropDownClick := cPoint(865, 524)
    /** @type {cRect} */
    rightDropDown := cRect(758, 506, 930, 535)
    /** @type {cRect} */
    singleitem := cRect(263, 256, 626, 310)
    /**  @type {cPoint} */
    SingleItemEdge := cPoint(400, 305)
    /**  @type {cPoint} */
    Eternal := cPoint(615, 542)
    /**  @type {cPoint} */
    Darkness := cPoint(839, 572)
    /**  @type {cPoint} */
    EnchantItemClick := cPoint(400, 305)
    /**  @type {cPoint} */
    Blazing := cPoint(854, 542)
    /**  @type {cPoint} */
    Antivenom := cPoint(865, 524)
    /**  @type {cPoint} */
    Aid := cPoint(840, 446)

    ;@region EnchantItem()
    /**
     * Enchant a single item in the enchanter
     */
    EnchantItem() {
        isWeapon := false
        this.ResetDropdownsOnStart(&isWeapon)
        Loop {
            Start := A_TickCount
            If (this.ScanItem(&isWeapon)) {
                Break
            }
            this.ItemEnchantReset(&isWeapon)
            this.CheckForItem(&isWeapon)
            ;Out._OutputDebug("Loop " (A_TickCount - start) / 1000)
            this.SingleItemEdge.ClickOffset(, , 17)
            Sleep(17)
        }
        MsgBox("Done")
    }
    ;@endregion

    ;@region EnchantItemSelected()
    /**
     * Enchant a single item in the enchanter
     */
    EnchantItemSelected() {
        isWeapon := false
        this.ResetDropdownsOnStart(&isWeapon)
        arr := S.Get("ItemEnchantSelectedAffixes")
        If (Type(arr) != "Array") {
            Out.E("Enchant item selected found a non array from settings.")
        }
        Loop {
            Start := A_TickCount
            If (this.ScanSelectedAffixes(&isWeapon, arr)) {
                Break
            }
            this.ItemEnchantReset(&isWeapon)
            this.CheckForItem(&isWeapon)
            ;Out._OutputDebug("Loop " (A_TickCount - start) / 1000)
            this.SingleItemEdge.ClickOffset(, , 17)
            Sleep(17)
        }
        MsgBox("Done")
    }
    ;@endregion

    ;@region ResetDropdownsOnStart()
    /**
     * Description
     */
    ResetDropdownsOnStart(&isWeapon) {
        this.EternalReset()

        Sample := this.ItemSample.GetColour()
        this.EternalAidReset()
        isWeapon := false
        If (Sample != this.ItemSample.GetColour()) {
            this.EternalBlazingReset()
            isWeapon := true
        }

        If (!this.leftDropDown.PixelSearch("000000")) {
            Return false
        }
        If (Sample != this.ItemSample.GetColour()) {
            Return false
        }
        If (!this.rightDropDown.PixelSearch("000000")) {
            Return false
        }
        Return true
    }
    ;@endregion

    ;@region CheckForItem()
    /**
     * Description
     */
    CheckForItem(&isWeapon) {
        Sample := this.ItemSample.GetColour()
        If (Sample = "0x721A04" || Sample = "0xB96345") {
            Return true
        }
        isWeapon := !isWeapon
        this.EternalReset()
        If (!isWeapon) {
            this.EternalAidReset()
        } Else {
            this.EternalBlazingReset()
        }
        If (!this.leftDropDown.PixelSearch("000000")) {
            Return false
        }
        If (Sample = this.ItemSample.GetColour()) {
            Return false
        }
        If (!this.rightDropDown.PixelSearch("000000")) {
            Return false
        }
        Return true
    }
    ;@endregion

    ;@region ScanItem()
    /**
     * Scan an item for prefixes and suffixes matching image scans
     */
    ScanItem(&isWeapon) {
        isNormPrefix := false
        isNormSuffix := false
        isEternal := false
        isAid := false
        isBlazing := false
        For (id, value IN this.Affixes.Elevated.Prefixes) {
            If (value.IsAffix(this.singleitem, isWeapon)) {
                Sleep(200)
                Return true
            }
        }
        For (id, value IN this.Affixes.Elevated.Suffixes) {
            If (value.IsAffix(this.singleitem, isWeapon)) {
                Sleep(200)
                Return true
            }
        }
        For (id, value IN this.Affixes.Norm.Prefixes) {
            If (value.IsAffix(this.singleitem, isWeapon)) {
                isNormPrefix := true
                If (value.Name = "Eternal") {
                    isEternal := true
                }
                Break
            }

        }
        For (id, value IN this.Affixes.Norm.Suffixes) {
            If (value.IsAffix(this.singleitem, isWeapon)) {
                isNormSuffix := true
                If (isWeapon && value.Name = "Blazing") {
                    isBlazing := true
                }
                If (!isWeapon && value.Name = "Aid") {
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
        If (isWeapon && isEternal && isBlazing) {
            this.EternalBlazingReset()
            Return false
        }
        If (!isWeapon && isEternal && isAid) {
            this.EternalAidReset()
            Return false
        }
        Return false
    }
    ;@endregion

    ;@region ItemEnchantReset()
    ItemEnchantReset(&isWeapon) {
        If (!this.Enchanted.IsColour("0xFFFFFF")) {
            Return true
        }
        If (isWeapon) {
            this.EternalBlazingReset()
        } Else {
            this.EternalAidReset()
        }
        If (!this.leftDropDown.PixelSearch("000000")) {
            Return false
        }
        If (!this.rightDropDown.PixelSearch("000000")) {
            Return false
        }
        Return true
    }
    ;@endregion

    ;@region EternalReset()
    /**
     * Reset enchant if Eternal not detected on start
     */
    EternalReset() {
        this.leftDropDownClick.Click(17) ; first dropdown
        Sleep(34)
        this.Eternal.Click(17) ; eternal
        Sleep(34)
    }
    ;@endregion

    ;@region EternalBlazingReset()
    /**
     * Reset enchant if Eternal + Blazing detected
     */
    EternalBlazingReset() {
        this.rightDropDownClick.Click(17) ; second dropdown
        Sleep(34)
        this.Darkness.Click(17) ; Darkness
        Sleep(34)
        this.EnchantItemClick.ClickOffset(17) ; Enchant item
        Sleep(34)
        this.rightDropDownClick.Click(17) ; second dropdown
        Sleep(34)
        this.Blazing.Click(17) ; Blazing
        Sleep(34)
    }
    ;@endregion

    ;@region EternalAidReset()
    /**
     * Reset enchant if Eternal + Aid is detected
     */
    EternalAidReset() {
        this.rightDropDownClick.Click(17) ; second dropdown
        Sleep(34)
        this.Antivenom.Click(17) ; Antivenom
        Sleep(34)
        this.EnchantItemClick.ClickOffset(17) ; Enchant item
        Sleep(34)
        this.rightDropDownClick.Click(17) ; second dropdown
        Sleep(34)
        this.Aid.Click(17) ; Aid
        Sleep(34)
    }
    ;@endregion

    ;@region ScanSelectedAffixes()
    /**
     * Scan for an array of preselected affixes and ignore all else
     */
    ScanSelectedAffixes(&isWeapon, arr := []) {
        Global HasOutputStartupString

        If (Type(arr) != "Array" || arr = []) {
            Out.I("No affix selected, aborting.")
            Return false
        }
        isEternal := false
        isAid := false
        isBlazing := false
        If (!HasOutputStartupString) {
            Out.I("Searching for selected affixes: " ArrToCommaDelimStr(arr))
            HasOutputStartupString := true
        }

        ; If 'shifting' special case
        If (ArrayHas("Shifting", arr) &&
        this.Affixes.Special.Item[2].IsAffix(this.singleitem, isWeapon)) {
            MsgBox("Matched on Shifting")
            Sleep(200)
            Return true
        }

        For (id, value IN this.Affixes.Elevated.Prefixes) {
            If (ArrayHas(value.Name, arr)) {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    MsgBox("Matched on " value.Name)
                    Sleep(200)
                    Return true
                }
            }
        }
        For (id, value IN this.Affixes.Elevated.Suffixes) {
            If (ArrayHas(value.Name, arr)) {
                If (value.Name = "Necromancer") {
                    If (value.IsAffix(this.singleitem, isWeapon) &&
                    !this.Affixes.Special.Item[1].IsAffix(this.singleitem, isWeapon)) {
                        MsgBox("Matched on " value.Name)
                        Sleep(200)
                        Return true
                    }
                } Else {
                    If (value.IsAffix(this.singleitem, isWeapon)) {
                        MsgBox("Matched on " value.Name)
                        Sleep(200)
                        Return true
                    }
                }
            }
        }
        For (id, value IN this.Affixes.Norm.Prefixes) {
            If (ArrayHas(value.Name, arr)) {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    MsgBox("Matched on " value.Name)
                    Sleep(200)
                    Return true
                }
            }
            If (value.Name = "Eternal") {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    isEternal := true
                    Break
                }
            }
        }
        For (id, value IN this.Affixes.Norm.Suffixes) {
            If (ArrayHas(value.Name, arr)) {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    MsgBox("Matched on " value.Name)
                    Sleep(200)
                    Return true
                }
            }
            If (isWeapon && value.Name = "Blazing") {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    isBlazing := true
                    Break
                }
            }
            If (!isWeapon && value.Name = "Aid") {
                If (value.IsAffix(this.singleitem, isWeapon)) {
                    isAid := true
                    Break
                }
            }
        }

        ; If we match eternal blazing we've likely matched the selected filter so stop
        If (isWeapon && isEternal && isBlazing) {
            this.EternalBlazingReset()
            Return false
        }
        If (!isWeapon && isEternal && isAid) {
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
                If (StrLower(value) = StrLower(Name)) {
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
 * @param Wep Weapon only
 * @param Arm Armour only
 * @returns {Affix} 
 * 
 * @method Name Desc
 */
Class Affix {
    /** Name of affix
     * @type {String} */
    Name := ""
    /** Position of affix (prefix or suffix)
     * @type {Boolean} */
    Pos := 0
    /** Image width
     * @type {Type} */
    imgW := 0
    /** Image height
     * @type {Type} */
    imgH := 0
    /** Image background colour
     * @type {String} */
    bgCol := 0
    /** Is affix for weapon only
     * @type {Boolean} */
    Wep := 0
    /** Is affix for armour only
     * @type {Boolean} */
    Arm := 0

    ;@region Affix()
    /**
     * Does item have affix (prefix or suffix)
     * @param Name
     * @param Pos Prefix 0 Suffix 1
     * @param imgW
     * @param imgH
     * @param bgCol
     * @param Wep
     * @returns {Affix}
     */
    __New(Name, Pos, imgW, imgH, bgCol, Wep, Arm) {
        this.Name := Name
        this.Pos := Pos
        this.imgW := imgW
        this.imgH := imgH
        this.bgCol := bgCol
        this.Wep := Wep
        this.Arm := Arm
        Switch (this.Pos) {
        Case -1:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Item" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.E("Issue at loadpicture suffix")
                Out.E(OutputVar)
            }
        Case 0:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Prefix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.E("Issue at loadpicture suffix")
                Out.E(OutputVar)
            }
        Case 1:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Suffix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.E("Issue at loadpicture suffix")
                Out.E(OutputVar)
            }
        default:
            Try {
                this.Img := LoadPicture(A_ScriptDir "\Images\Prefix" this.Name ".png", "GDI+", &OutImageType)
            } Catch Error As OutputVar {
                Out.E("Issue at loadpicture suffix")
                Out.E(OutputVar)
            }
        }
        Return this
    }
    ;@endregion

    isCorrectType(isWeapon) {
        If (this.Wep && isWeapon) {
            Return true
        }
        If (this.Arm && !isWeapon) {
            Return true
        }
        If (!this.Arm && !this.Wep) {
            Return true
        }
        Return false
    }

    ;@region IsAffix()
    /**
     * Does item have affix (prefix or suffix)
     * @param {cRect} rect 
     */
    IsAffix(rect, isWeapon) {
        If (!this.isCorrectType(isWeapon)) {
            Out.V("Ignoring " this.Name)
            Return false
        }
        Try {
            If (rect.ImageSearch("HBITMAP:*" this.Img, this.bgCol, 100)) {
                Return true
            }
        } Catch Error As OutputVar {
            Out.D("Error at imagesearch")
            Out.E(OutputVar)
        }
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
            Affix("Earthly", 0, 62, 26, "721A04", true, false),
            Affix("Fruitful", 0, 58, 18, "721A04", false, false),
            Affix("Glimmering", 0, 95, 24, "721A04", false, false),
            Affix("Jokers", 0, 56, 17, "721A04", false, true),
            Affix("Mammoth", 0, 83, 18, "721A04", true, false),
            Affix("Mechanized", 0, 94, 21, "721A04", true, false),
            Affix("Mercurial", 0, 77, 21, "B96345", true, false),
            Affix("Monumental", 0, 103, 22, "B96345", true, false),
            Affix("Perforating", 0, 94, 21, "721A04", true, false),
            Affix("Savants", 0, 74, 25, "B96345", false, true),
            Affix("Serrated", 0, 74, 20, "721A04", false, true),
            Affix("Spelunkers", 0, 93, 18, "721A04", false, true)
        ],
        Suffixes: [
            Affix("Agony", 1, 53, 23, "721A04", true, false),
            Affix("Anima", 1, 90, 23, "721A04", true, false),
            Affix("Bolting", 1, 61, 24, "721A04", true, false),
            Affix("Crusading", 1, 84, 25, "721A04", true, false),
            Affix("Ether", 1, 50, 23, "721A04", true, false),
            Affix("Glamour", 1, 69, 16, "721A04", false, true),
            Affix("Igniting", 1, 61, 20, "B96345", true, false),
            Affix("Lightless", 1, 75, 21, "721A04", true, false),
            Affix("Necromancer", 1, 108, 15, "721A04", false, false),
            Affix("Preeminence", 1, 107, 18, "721A04", false, false), ; Harder better timeline
            Affix("Radiance", 1, 76, 22, "B96345", true, false),
            Affix("Supereons", 1, 86, 21, "721A04", true, false),
        ],
        NotCaptured: [
            Affix("Acuminating", -1, 0, 0, "", true, false), ; Growth timeline
            Affix("Behemoth's", -1, 0, 0, "", true, false), ; Giants Timeline
            Affix("Brilliance", -1, 0, 0, "", true, false), ; May not exist
            Affix("Infestation", -1, 0, 0, "", false, true), ; Bee timeline
            Affix("Overlord", -1, 0, 0, "", false, false) ; Boss timeline
        ]
    },
    Norm := {
        Prefixes: [
            Affix("Acute", 0, 47, 17, "721A04", true, false),
            Affix("Adaptable", 0, 83, 22, "721A04", false, false),
            Affix("Charmed", 0, 75, 19, "721A04", true, false),
            Affix("Colossal", 0, 62, 18, "721A04", false, true), ; D2+
            Affix("Diamond", 0, 70, 18, "721A04", false, true), ; Diamond timeline
            Affix("DragonShifting", 0, 124, 21, "B96345", false, true),
            Affix("Dynamic", 0, 70, 23, "721A04", true, false),
            Affix("Eternal", 0, 58, 19, "B96345", false, false),
            Affix("Fortuitous", 0, 85, 19, "721A04", true, false),
            Affix("Furtive", 0, 61, 17, "721A04", false, true),
            Affix("Healthy", 0, 62, 20, "721A04", false, true),
            Affix("HumanShifting", 0, 121, 21, "721A04", false, true),
            Affix("Jesters", 0, 62, 17, "721A04", false, true),
            Affix("Learners", 0, 77, 18, "721A04", false, true),
            Affix("Light", 0, 41, 21, "721A04", false, true), ; Is both prefix and suffix
            Affix("Looters", 0, 66, 16, "721A04", false, true),
            Affix("Lucrative", 0, 79, 17, "721A04", false, false),
            Affix("MagicShifting", 0, 109, 21, "721A04", false, true),
            Affix("Massive", 0, 64, 18, "721A04", true, false),
            Affix("Modified", 0, 68, 19, "721A04", true, false),
            Affix("Momentous", 0, 97, 20, "B96345", true, false),
            Affix("Natural", 0, 61, 18, "721A04", true, false),
            Affix("NatureShifting", 0, 121, 21, "721A04", false, true),
            Affix("Piercing", 0, 67, 22, "721A04", true, false),
            Affix("Precise", 0, 60, 21, "721A04", true, false),
            Affix("Reinforced", 0, 87, 18, "721A04", false, true),
            Affix("Scholars", 0, 71, 18, "721A04", false, false),
            Affix("Sharp", 0, 48, 21, "721A04", true, false),
            Affix("Shiny", 0, 44, 21, "721A04", false, false),
            Affix("Spiked", 0, 53, 19, "721A04", false, true),
            Affix("Stalwart", 0, 0, 0, "721A04", false, false),
            Affix("Sturdy", 0, 54, 20, "721A04", false, true),
            Affix("Quicksilver", 0, 90, 19, "721A04", true, false),
            Affix("TechShifting", 0, 101, 21, "721A04", false, true),
            Affix("Troubadours", 0, 105, 17, "721A04", false, true), ; D2+
            Affix("UndeadShifting", 0, 115, 20, "B96345", false, true),
            Affix("Vicious", 0, 56, 17, "721A04", true, false),
            Affix("Vigorous", 0, 72, 16, "721A04", false, true)
        ],
        Suffixes: [
            Affix("Aid", 1, 28, 20, "721A04", false, true),
            Affix("Anatomy", 1, 74, 20, "721A04", false, true),
            Affix("Antivenom", 1, 90, 17, "721A04", false, true),
            Affix("Bear", 1, 39, 18, "721A04", false, true),
            Affix("Blazing", 1, 58, 21, "721A04", true, false),
            Affix("Colossus", 1, 69, 19, "721A04", false, true),
            Affix("Darkness", 1, 76, 18, "721A04", true, false),
            Affix("Deception", 1, 82, 21, "721A04", true, false),
            Affix("Defiance", 1, 70, 19, "721A04", false, true),
            Affix("Efficiency", 1, 77, 21, "721A04", true, false),
            Affix("Evasion", 1, 63, 18, "721A04", false, true),
            Affix("Eons", 1, 41, 20, "B96345", true, false),
            Affix("Greed", 1, 50, 18, "721A04", false, true),
            Affix("Haste", 1, 48, 19, "721A04", false, true),
            Affix("HolyWar", 1, 38, 24, "721A04", true, false),
            Affix("Honing", 1, 55, 21, "B96345", true, false), ; Growth timeline
            Affix("Light", 1, 42, 21, "721A04", true, false),
            Affix("Mastery", 1, 73, 24, "B96345", false, false), ; Harder better timeline
            Affix("Meditation", 1, 90, 21, "B96345", false, true),
            Affix("Might", 1, 46, 21, "721A04", false, true),
            Affix("Nether", 1, 58, 19, "721A04", true, false),
            Affix("Pain", 1, 41, 23, "721A04", true, false),
            Affix("Plumage", 1, 71, 23, "721A04", false, true),
            Affix("QuickStrikes", 1, 57, 18, "721A04", true, false),
            Affix("Replenishing", 1, 100, 21, "721A04", false, true),
            Affix("Ruse", 1, 39, 17, "721A04", false, true),
            Affix("Serpent", 1, 67, 19, "721A04", true, false), ; Poison timeine
            Affix("Soul", 1, 34, 17, "721A04", true, false),
            Affix("Subterfuge", 1, 90, 21, "721A04", false, true),
            Affix("Taming", 1, 61, 22, "721A04", false, true),
            Affix("Time", 1, 24, 20, "B96345", false, false),
            Affix("Thunder", 1, 67, 17, "721A04", true, false),
            Affix("Venom", 1, 64, 21, "721A04", true, false),
            Affix("Wit", 1, 24, 17, "721A04", false, true)
        ],
        NotCaptured: [
            Affix("Boss", 0, 0, 0, "721A04", true, false), ; Boss fight timeline
            Affix("Flaming", 0, 0, 0, "721A04", true, false), ; May be dynamic now
            Affix("Giants", 0, 0, 0, "721A04", true, false), ; Giants Timeline
            Affix("Swarming", 0, 0, 0, "721A04", false, true), ; Bee timeline
            Affix("Tigers", 0, 0, 0, "721A04", false, true), ; Faster stronger timeline
            Affix("Lich", 1, 0, 0, "721A04", false, true) ; Zombie timeline
        ]
    },
    Special := {
        Item: [
            Affix("Necromancer", -1, 122, 18, "721A04", false, true), ; Zombie land timeline
            Affix("Shifting", -1, 60, 21, "B96345", false, false) ; Fake affix to select all shifting
        ]
    },
    ShopOnly := {
        Prefix: [
            Affix("Professors", 0, 90, 17, "B96345", true, false)
        ],
        Suffix: [
            Affix("Merchants", 1, 83, 20, "B96345", false, true)
        ]
    }
}
