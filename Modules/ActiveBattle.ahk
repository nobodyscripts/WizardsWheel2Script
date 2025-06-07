#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cPoint.ahk
#Include ..\ScriptLib\cRect.ahk

S.AddSetting("ActiveBattle", "MimicClickEnable", true, "Bool")
S.AddSetting("ActiveBattle", "GemBoostEnable", true, "Bool")
S.AddSetting("ActiveBattle", "JewelBoostEnable", true, "Bool")
S.AddSetting("ActiveBattle", "WizardClickEnable", true, "Bool")
S.AddSetting("ActiveBattle", "SkillsClickEnable", true, "Bool")
S.AddSetting("ActiveBattle", "WheelClickEnable", true, "Bool")
S.AddSetting("ActiveBattle", "ArtifactClickEnable", true, "Bool")

fActiveBattle(*) {
    Window.Activate()
    ActiveBattle().Run()
}

/**
 * ActiveBattle functions for during combat and checking combat state
 * @module ActiveBattle
 */
Class ActiveBattle {
    ;@region Properties
    /** @type {Bool} */
    CanUseJewelBoost := false
    /** @type {Bool} */
    CanUseGemBoost := false
    /** @type {cPoint} */
    AreaSample := cPoint(1120, 8)
    /** @type {cRect} */
    JewelBuffCheck := cRect(571, 136, 704, 160)
    /** @type {cPoint} */
    GemBuffCheck := cPoint(1192, 239)
    /** @type {cPoint} */
    GemBuffConfirm := cPoint(832, 377)
    /** @type {cPoint} */
    SpeedBoostWheel := cPoint(1196, 575)
    /** @type {cPoint} */
    WizardCheck := cPoint(1003, 660)
    /** @type {cPoint} */
    Skill1 := cPoint(1123, 463)
    /** @type {cPoint} */
    Skill2 := cPoint(1183, 462)
    /** @type {cPoint} */
    Skill3 := cPoint(1243, 464)
    /** @type {cRect} */
    SpeedBoostWheelCheck := cRect(1168, 560, 1221, 589)
    /** @type {cRect} */
    MimicArea := cRect(287, 168, 1005, 486)

    ; Inventory top 5 slots for artifacts
    /** @type {cPoint} */
    Inv1 := cPoint(29, 442)
    /** @type {cRect} */
    Inv1Text := cRect(18, 444, 35, 457)
    /** @type {cPoint} */
    Inv2 := cPoint(77, 440)
    /** @type {cRect} */
    Inv2Text := cRect(69, 443, 89, 460)
    /** @type {cPoint} */
    Inv3 := cPoint(28, 492)
    /** @type {cRect} */
    Inv3Text := cRect(16, 495, 36, 512)
    /** @type {cPoint} */
    Inv4 := cPoint(81, 495)
    /** @type {cRect} */
    Inv4Text := cRect(70, 495, 88, 511)
    /** @type {cPoint} */
    Inv5 := cPoint(26, 545)
    /** @type {cRect} */
    Inv5Text := cRect(17, 548, 35, 563)

    /** To be used for jewel buff, needs colour samples
     * @type {cPoint} */
    Inv6 := cPoint(79, 545)

    LeftBar := cPoint(1, 164)
    TopBar := cPoint(634, 5)
    RightBar := cPoint(1274, 206)
    ;@endregion

    ;@region Run()
    /**
     * Activate all enabled maintainers for mid combat
     */
    Run() {
        StartFeatureOrReload()
        GemBoostEnable := S.Get("GemBoostEnable")
        JewelBoostEnable := S.Get("JewelBoostEnable")
        MimicClickEnable := S.Get("MimicClickEnable")
        WizardClickEnable := S.Get("WizardClickEnable")
        SkillsClickEnable := S.Get("SkillsClickEnable")
        WheelClickEnable := S.Get("WheelClickEnable")
        ArtifactClickEnable := S.Get("ArtifactClickEnable")
        Loop {
            If (WheelClickEnable) {
                this.MaintainWheel()
            }
            If (SkillsClickEnable) {
                this.MaintainSkills()
            }
            If (MimicClickEnable) {
                this.MaintainMimics()
            }
            If (GemBoostEnable) {
                this.RefreshGemBoost()
            }
            If (JewelBoostEnable) {
                this.RefreshJewelBoost()
            }
            If (WizardClickEnable) {
                this.MaintainWizard()
            }
            If (ArtifactClickEnable) {
                this.MaintainArtifacts()
            }
        }

        toggle := !toggle
    }
    ;@endregion

    ;@region IsRoundActive()
    /**
     * Is the round active
     * @returns {Boolean} 
     */
    IsRoundActive() {
        LeftBarColour := this.LeftBar.GetColour()
        TopBarColour := this.TopBar.GetColour()
        RightBarColour := this.RightBar.GetColour()
        If (LeftBarColour = TopBarColour && RightBarColour = TopBarColour) {
            Return true
        }
        Out.I("Round active false: " LeftBarColour)
        Return false
    }
    ;@endregion

    ;@region HasWheelSlowed()
    /**
     * Has speed boost wheel reduced in speed from max
     */
    HasWheelSlowed() {
        If (Window.IsActive()) {
            found := this.SpeedBoostWheelCheck.PixelSearch()
            If (found and found[1] != 0) {
                Return true
            }
        }
        ; Halloween filter
        If (Window.IsActive()) {
            found := this.SpeedBoostWheelCheck.PixelSearch("0x9F9FE5")
            If (found and found[1] != 0) {
                Return true
            }
        }
        ; Winter filter
        If (Window.IsActive()) {
            found := this.SpeedBoostWheelCheck.PixelSearch("0xE5E5FF")
            If (found and found[1] != 0) {
                Return true
            }
        }
        Return false
    }
    ;@endregion

    ;@region IsWizardChanged()
    /**
     * Has wizard appearance changed
     */
    IsWizardChanged() {
        Static lastWizardColour := ""
        colour := this.WizardCheck.GetColour()
        If (colour != "0xFFFFFF" || colour != "0x000000") {
            Return false
        }
        If (lastWizardColour = "") {
            lastWizardColour := colour
            Return false
        }
        If (colour != lastWizardColour) {
            lastWizardColour := colour
            Return true
        }
        Return false
    }
    ;@endregion

    ;@region IsLevelDragonPike()
    /**
     * Is current level Dragon Pike
     */
    IsLevelDragonPike() {
        colour := this.AreaSample.GetColour()
        If (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
            Return true
        }
        Out.I("Area Sample Col " colour)
        Return false
    }
    ;@endregion

    ;@region IsJewelBuffActive()
    /**
     * Description
     */
    IsJewelBuffActive() {
        ; Search for yellow text for active buff
        ; Search for FBFF00
        If (this.JewelBuffCheck.PixelSearch("0xFBFF00", 30)) {
            Return true
        }
        ; Search for E3E580
        If (this.JewelBuffCheck.PixelSearch("0xE3E580", 30)) {
            Return true
        }
        ; Search for FDCA00
        If (this.JewelBuffCheck.PixelSearch("0xFDCA00", 30)) {
            Return true
        }
        Return false
    }
    ;@endregion

    ;@region IsGemBuffActive()
    /**
     * Description
     */
    IsGemBuffActive() {
        colour := this.GemBuffCheck.GetColour()
        If (colour = "0xFFFFFF" || colour = "0xE5E5FF" || colour = "0xF5F5F5") {
            Return true
        }
        Out.I("Gem buff inactive, found colour " colour)
        Return false
    }
    ;@endregion

    ;@region UseGemBoost()
    /**
     * Purchase gem boost (3 gem icon)
     */
    UseGemBoost() {
        Out.D("Gem boost available")
        If (!this.IsGemBuffActive()) {
            this.GemBuffCheck.ClickOffset()
            this.GemBuffConfirm.WaitWhileNotColourS("0x9FEDAC", 1)
            If (this.GemBuffConfirm.IsColour("0x9FEDAC"))
                this.GemBuffConfirm.ClickOffset()
        }
    }
    ;@endregion

    ;@region UseJewelBoost()
    /**
     * Use an available jewel boost
     */
    UseJewelBoost() {
        If (!this.IsJewelBuffActive()) {
            If (!(this.Inv6.GetColour() = this.LeftBar.GetColour())) {
                Out.D("Jewel boost available")
                Out.D("Inv6 colour sample is " this.Inv6.GetColour())
                SoundBeep()
            } Else {
                Out.I("Jewel boost check aborted as no jewel found to use.")
                Out.D("Inv6 " this.Inv6.GetColour() " left bar " this.LeftBar.GetColour())
            }
        }
    }
    ;@endregion

    ;@region RefreshJewelBoost()
    /**
     * Description
     */
    RefreshJewelBoost() {
        If (!this.IsJewelBuffActive() && this.IsRoundActive()) {
            this.UseJewelBoost()
        }
    }
    ;@endregion

    ;@region RefreshGemBoost()
    /**
     * Description
     */
    RefreshGemBoost() {
        If (!this.IsGemBuffActive() && this.IsRoundActive()) {
            this.UseGemBoost()
        }
    }
    ;@endregion

    MaintainWheel(spamTen := false) {
        If (!Window.Activate()) {
            MsgBox("Wizard's Wheel 2: Window not found")
            Reload()
            Return ; Kill the loop if the window closes
        }
        If (!this.IsRoundActive()) {
            Return
        }
        If (Window.IsActive()) {
            If (spamTen = false) {
                If (this.HasWheelSlowed()) {
                    this.SpeedBoostWheel.ClickOffset()
                    this.SpeedBoostWheel.ClickOffset()
                    this.SpeedBoostWheel.ClickOffset()
                }
                Return
            }
            Loop 15 {
                this.SpeedBoostWheel.ClickOffset()
            }
        }
    }

    ;@region MaintainSkills()
    /**
     * Click skills when they are off cooldown during a battle
     */
    MaintainSkills() {
        If (!Window.Exist()) {
            MsgBox("Wizard's Wheel 2: Window not found")
            Reload()
            Return ; Kill the loop if the window closes
        }
        Window.Activate()
        If (!this.IsRoundActive()) {
            Return
        }
        If (Window.IsActive()) {
            this.Skill1.Click() ; (skill 1, left)
            this.Skill1.Click() ; (skill 1, left)
            Sleep(51)
            this.Skill2.Click() ; (skill 2, center)
            this.Skill2.Click() ; (skill 2, center)
            Sleep(51)
            this.Skill3.Click() ; (skill 3, right)
            this.Skill3.Click() ; (skill 3, right)
        }
    }
    ;@endregion

    ;@region MaintainMimics()
    /**
     * Click Mimics when they appear during a battle
     */
    MaintainMimics() {
        ; tongue colour e86a73
        If (!Window.Exist()) {
            MsgBox("Wizard's Wheel 2: Window not found")
            Reload()
            Return ; Kill the loop if the window closes
        }
        Window.Activate()
        If (!this.IsRoundActive()) {
            Return
        }
        If (Window.IsActive()) {
            found := this.MimicArea.PixelSearch("0xE86A73")
            If (found and found[1] != 0) {
                fCustomClick(found[1], found[2])
                Return
            }
        }
        ; Halloween version
        If (Window.IsActive()) {
            found := this.MimicArea.PixelSearch("0x88569A")
            If (found and found[1] != 0) {
                fCustomClick(found[1], found[2])
                Return
            }
        }
        ; Winter version
        If (Window.IsActive()) {
            found := this.MimicArea.PixelSearch("0xE1B6CB")
            If (found and found[1] != 0) {
                fCustomClick(found[1], found[2])
                Return
            }
        }
    }
    ;@endregion

    ;@region MaintainWizard()
    /**
     * Click wizard if it appears
     */
    MaintainWizard() {
        If (this.IsWizardChanged()) {
            this.WizardCheck.ClickOffset()
        }
    }
    ;@endregion

    ;@region MaintainArtifacts()
    /**
     * Description
     */
    MaintainArtifacts(slot1 := true, slot2 := true, slot3 := true, slot4 := true, slot5 := true) {
        If (slot1 && !this.Inv1Text.PixelSearch("0x000000", 30)) {
            this.Inv1.ClickOffset()
        }
        If (slot2 && !this.Inv2Text.PixelSearch("0x000000", 30)) {
            this.Inv2.ClickOffset()
        }
        If (slot3 && !this.Inv3Text.PixelSearch("0x000000", 30)) {
            this.Inv3.ClickOffset()
        }
        If (slot4 && !this.Inv4Text.PixelSearch("0x000000", 30)) {
            this.Inv4.ClickOffset()
        }
        If (slot5 && !this.Inv5Text.PixelSearch("0x000000", 30)) {
            this.Inv5.ClickOffset()
        }

    }
    ;@endregion
}
