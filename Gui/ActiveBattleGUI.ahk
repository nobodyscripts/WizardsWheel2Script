#Requires AutoHotkey v2.0

#Include ..\ScriptLib\cGUI.ahk

Button_Click_ActiveBattle(*) {
    GemBoostEnable := S.Get("GemBoostEnable")
    JewelBoostEnable := S.Get("JewelBoostEnable")
    MimicClickEnable := S.Get("MimicClickEnable")
    WizardClickEnable := S.Get("WizardClickEnable")
    SkillsClickEnable := S.Get("SkillsClickEnable")
    WheelClickEnable := S.Get("WheelClickEnable")
    ArtifactClickEnable := S.Get("ArtifactClickEnable")

    /** @type {cGui} */
    optionsGUI := cGui(, "Active Battle")
    optionsGUI.SetUserFontSettings()
    optionsGUI.Add("Text", "", "Start running while in combat.")

    If (GemBoostEnable = true) {
        optionsGUI.Add("CheckBox", "vGemBoostEnable checked", "Enable Gem Boost")
    } Else {
        optionsGUI.Add("CheckBox", "vGemBoostEnable", "Enable Gem Boost")
    }

    If (JewelBoostEnable = true) {
        optionsGUI.Add("CheckBox", "vJewelBoostEnable checked", "Enable Jewel Boost")
    } Else {
        optionsGUI.Add("CheckBox", "vJewelBoostEnable", "Enable Jewel Boost")
    }
    optionsGUI.Add("Text", "", "Uses Jewel in 6th slot, caution if other items might fill that slot.")

    If (MimicClickEnable = true) {
        optionsGUI.Add("CheckBox", "vMimicClickEnable checked", "Enable Mimic Clicker")
    } Else {
        optionsGUI.Add("CheckBox", "vMimicClickEnable", "Enable Mimic Clicker")
    }

    If (WizardClickEnable = true) {
        optionsGUI.Add("CheckBox", "vWizardClickEnable checked", "Enable Wizard Clicker")
    } Else {
        optionsGUI.Add("CheckBox", "vWizardClickEnable", "Enable Wizard Clicker")
    }

    If (SkillsClickEnable = true) {
        optionsGUI.Add("CheckBox", "vSkillsClickEnable checked", "Enable Skills Clicker")
    } Else {
        optionsGUI.Add("CheckBox", "vSkillsClickEnable", "Enable Skills Clicker")
    }

    If (WheelClickEnable = true) {
        optionsGUI.Add("CheckBox", "vWheelClickEnable checked", "Enable Wheel Clicker")
    } Else {
        optionsGUI.Add("CheckBox", "vWheelClickEnable", "Enable Wheel Clicker")
    }

    If (ArtifactClickEnable = true) {
        optionsGUI.Add("CheckBox", "vArtifactClickEnable checked", "Enable Artifact Clicker")
    } Else {
        optionsGUI.Add("CheckBox", "vArtifactClickEnable", "Enable Artifact Clicker")
    }

    optionsGUI.Add("Text", "", "Uses item in slot 1-5, caution if other items might fill that slot.")

    optionsGUI.Add("Button", "default", "Run and Save").OnEvent("Click", ProcessUserActiveBattlesSettings)
    optionsGUI.Add("Button", "default yp", "Save").OnEvent("Click", UserActiveBattlesSave)
    optionsGUI.Add("Button", "default yp", "Cancel").OnEvent("Click", UserActiveBattlesCancel)

    optionsGUI.ShowGUIPosition()
    optionsGUI.MakeGUIResizableIfOversize()
    optionsGUI.OnEvent("Size", optionsGUI.SaveGUIPositionOnResize.Bind(optionsGUI))
    OnMessage(0x0003, optionsGUI.SaveGUIPositionOnMove.Bind(optionsGUI))

    ProcessUserActiveBattlesSettings(*) {
        UserActiveBattlesSave()
        Window.Activate()
        fActiveBattle()
    }

    UserActiveBattlesSave(*) {
        values := optionsGUI.Submit()

        S.Set("GemBoostEnable", values.GemBoostEnable)
        S.Set("JewelBoostEnable", values.JewelBoostEnable)
        S.Set("MimicClickEnable", values.MimicClickEnable)
        S.Set("WizardClickEnable", values.WizardClickEnable)
        S.Set("SkillsClickEnable", values.SkillsClickEnable)
        S.Set("WheelClickEnable", values.WheelClickEnable)
        S.Set("ArtifactClickEnable", values.ArtifactClickEnable)
        S.SaveCurrentSettings()
    }

    UserActiveBattlesCancel(*) {
        optionsGUI.Hide()
    }
}
