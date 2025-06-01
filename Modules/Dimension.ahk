#Requires AutoHotkey v2.0

S.AddSetting("Dimension", "SelectedHeroes", "1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", "Array")
S.AddSetting("Dimension", "DoOnce", false, "bool")

/**
 * Dimension functions related to incrementing Dimensions
 * @module Dimension
 */
Class Dimension {

    ;@region PushDimensions()
    /**
     * Increase dimensions farming start point
     */
    PushDimensions() {
        SelectedHeroes := S.Get("SelectedHeroes")
        If (SelectedHeroes := "") {
            SelectedHeroes := [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
        If (S.Get("DoOnce")) {
            this.PushOnce(SelectedHeroes)
        } Else {
            Loop {
                If (!this.PushOnce(SelectedHeroes)) {
                    Break
                }
            }
        }
    }
    ;@endregion

    ;@region PushOnce()
    /**
     * Progress one Dimension
     */
    PushOnce(SelectedHeroes) {
        this.OpenReincarnationUI()
        this.RestoreHeroes(SelectedHeroes)
        this.CloseReincarnationUI()
        this.OpenBattleMap()
        this.StartFigaroForest()
        If (!this.WaitForComplete()) {
            Return false
        }
        this.OpenDimensionalPortal()
        this.StepIntoGate()
        Return true
    }
    ;@endregion

    ;@region OpenReincarnationUI()
    /**
     * Open the reincarnation screen to import heroes for farming
     */
    OpenReincarnationUI() {

    }
    ;@endregion

    ;@region RestoreHeroes()
    /**
     * Import heroes for farming from reincarnation screen
     */
    RestoreHeroes(SelectedHeroes) {

    }
    ;@endregion

    ;@region CloseReincarnationUI()
    /**
     * Close the reincarnation screen to import heroes for farming
     */
    CloseReincarnationUI() {

    }
    ;@endregion

    ;@region OpenBattleMap()
    /**
     * Open map screen to start fight in Figaro Forest
     */
    OpenBattleMap() {

    }
    ;@endregion

    ;@region StartFigaroForest()
    /**
     * Start auto battling in Figaro Forest
     */
    StartFigaroForest() {

    }
    ;@endregion

    ;@region WaitForComplete()
    /**
     * Wait for dimension run to finish and stop at dragons pike or if fail early
     * exit 
     */
    WaitForComplete() {

    }
    ;@endregion

    ;@region OpenDimensionalPortal()
    /**
     * Open the Dimensional Portal in the village ui
     */
    OpenDimensionalPortal() {

    }
    ;@endregion

    ;@region StepIntoGate()
    /**
     * Use the gateway progression button, could increase dimension or start
     * DW fight based on progress state
     */
    StepIntoGate() {
        If (DimensionalProgressConfirmUI := 1) {
            cPoint(,).Click()
            this.StepThroughDialog()
        } Else {

        }
    }
    ;@endregion

    ;@region StepThroughDialog()
    /**
     * Increment through dialog screens until gone
     */
    StepThroughDialog() {

    }
    ;@endregion
}
