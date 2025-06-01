#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cPoint.ahk
#Include ..\ScriptLib\cRect.ahk

;S.AddSetting("TestSection", "TestVar", "true, array, test", "Array")

/**
 * ActiveBattle functions for during combat and checking combat state
 * @module ActiveBattle
 */
Class ActiveBattle {
    /** @type {Bool} */
    CanUseJewelBoost := false
    /** @type {Bool} */
    CanUseGemBoost := false
    /** @type {cPoint} */
    AreaSample := cPoint(,)
    /** @type {cPoint} */
    JewelBuffCheck := cPoint(,)
    /** @type {cPoint} */
    GemBuffCheck := cPoint(,)
    /** @type {cPoint} */
    SpeedBoostWheel := cPoint(,)
    /** @type {cPoint} */
    WizardCheck := cPoint(,)
    /** @type {cPoint} */
    Skill1 := cPoint(,)
    /** @type {cPoint} */
    Skill2 := cPoint(,)
    /** @type {cPoint} */
    Skill3 := cPoint(,)
    /** @type {cRect} */
    SpeedBoostWheelCheck := cRect(, , ,)
    /** @type {cRect} */
    MimicArea := cRect(, , ,)

    ;@region Run()
    /**
     * Activate all enabled maintainers for mid combat
     */
    Run() {
        Static toggle := true
        If (toggle) {
            this.MaintainWheel(true) ; Run as timer doesn't execute straight away
            this.MaintainSkills()
            this.MaintainMimics()
        }
        SetTimer(this.MaintainWheel, 72 * (toggle))
        SetTimer(this.MaintainSkills, 72 * (toggle))
        SetTimer(this.MaintainMimics, 72 * (toggle))
        SetTimer(this.RefreshGemBoost, 72 * (toggle))
        SetTimer(this.RefreshJewelBoost, 72 * (toggle))
        SetTimer(this.MaintainWizard, 72 * (toggle))

        toggle := !toggle
    }
    ;@endregion

    ;@region IsRoundActive()
    /**
     * Is the round active
     * @returns {Boolean} 
     */
    IsRoundActive() {
        LeftBarColour := cPoint(1, 164).GetColour()
        TopBarColour := cPoint(634, 5).GetColour()
        RightBarColour := cPoint(1274, 206).GetColour()
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
        colour := this.JewelBuffCheck.GetColour()
        If (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
            Return true
        }
        Out.I("Jewel col " colour)
        Return false
    }
    ;@endregion

    ;@region IsGemBuffActive()
    /**
     * Description
     */
    IsGemBuffActive() {
        colour := this.GemBuffCheck.GetColour()
        If (colour = "0xFFFFFF" || colour = "0xE5E5FF") {
            Return true
        }
        Out.I("Gem col " colour)
        Return false
    }
    ;@endregion
    /*
    IsGemBuffActive() {
        ; Search for yellow text for active buff
        ; Search for FBFF00
        found := cRect(1074, 274, 1490, 315)
        found.PixelSearch("0xFBFF00")
        If (found && found[1] > 0) {
            Return true
        }
        ; Search for E3E580
        found := cRect(1074, 274, 1490, 315)
        found.PixelSearch("0xE3E580")
        If (found && found[1] > 0) {
            Return true
        }
        Return false
    } */

    ;@region UseGemBoost()
    /**
     * Purchase gem boost (3 gem icon)
     */
    UseGemBoost() {
        If (this.CanUseGemBoost) {
            SoundBeep()
        }
    }
    ;@endregion

    ;@region UseJewelBoost()
    /**
     * Use an available jewel boost
     */
    UseJewelBoost() {
        If (this.CanUseJewelBoost) {
            SoundBeep()
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
        ;2392 1272 (1440)
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
}
