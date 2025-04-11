#Requires AutoHotkey v2.0

#Include Navigate.ahk
#Include cTimer.ahk

/**
 * Game Window management class 1278*664
 * @module cGameWindow
 * @property {String} Title Window title description string, as used to match 
 * windows in ahk
 * @property {Integer} W Width
 * @property {Integer} H Height
 * @property {Integer} X Horizontal position
 * @property {Integer} Y Vertical position
 * @method __New Constructor
 * @method RelW Convert from default client resolution to current resolution
 * @method RelH Convert from default client resolution to current resolution
 * @method Activate Activate window
 * @method IsActive Check if window active focus
 * @method Exist Check if window exists
 * @method IsPanel Check if game has panel open
 * @method AreGameSettingsCorrect Runtime settings checks
 * @method IsPanelTransparent
 * @method IsPanelTransparentCorrectCheck
 * @method IsAspectRatioCorrect
 * @method IsAspectRatioCorrectCheck
 * @method IsPanelSmoothed
 * @method IsPanelSmoothedCheck
 * @method IsDarkBackgroundOn
 * @method IsDarkBackgroundCheck
 * @method IsTreesSetCheck
 * @method IsAFKOn
 * @method AFKFix
 */
Class cGameWindow {
    ;@region Properties
    /** @type {String} Window title description string, as used to match windows
     * in ahk
     */
    Title := "Wizard's Wheel 2 ahk_class UnityWndClass ahk_exe Wizard's Wheel 2.exe"
    /** @type {DateTime} Time since window check last failed and logged */
    LastLogged := 0
    /** @type {Integer} Window Width */
    W := 0
    /** @type {Integer} Window Height */
    H := 0
    /** @type {Integer} Window Horizontal Position X */
    X := 0
    /** @type {Integer} Window Vertical Position Y */
    Y := 0
    /** @type {Integer} Default client width by which scaling is set */
    DefW := 1278
    /** @type {Integer} Default client height by which scaling is set */
    DefH := 664
    ;@endregion

    ;@region __New()
    /**
     * Create new GameWindow class to handle window size and checks
     * @constructor
     * @param {String} Title AHK formatted window selection string
     */
    __New(Title := "") {
        If (Title != "") {
            this.Title := Title
        }
        this.Exist()
    }
    ;@endregion

    ;@region Relative Coordinates
    ; Convert positions from default size client resolution to current
    ; resolution to allow higher accuracy
    RelW(PosW) {
        Return PosW / this.DefW * this.W
    }

    ; Convert positions from default size client resolution to current
    ; resolution to allow higher accuracy
    RelH(PosH) {
        Return PosH / this.DefH * this.H
    }
    ;@endregion

    ;@region Activate()
    /**
     * Activate window
     * (Updates GameWindow properties when used)
     * @returns {Boolean} Does window exist (and is therefore activated)
     */
    Activate() {
        If (!this.Exist()) {
            Out.I("Error: Window doesn't exist.")
            Return false ; Don't check further
        }
        If (!WinActive(this.Title)) {
            WinActivate(this.Title)
        }
        Return true
    }
    ;@endregion

    ;@region IsActive()
    /**
     * Is Game Window active
     * (Updates GameWindow properties when used)
     * @returns {Boolean} False if !exist or !active
     */
    IsActive() {
        If (!this.Exist()) {
            If (this.LastLogged = 0) {
                this.LastLogged := A_Now
                Out.I("Error: Window doesn't exist.")
                Return false
            }
            If (DateDiff(A_Now, this.LastLogged, "Seconds") >= 10) {
                Out.I("Error: Window doesn't exist.")
                this.LastLogged := A_Now
            }
            Return false
        }
        If (!WinActive(this.Title)) {
            ; Because this can be spammed lets limit rate the error log
            If (this.LastLogged = 0) {
                this.LastLogged := A_Now
                Out.D("Window not active.")
                Return false
            }
            If (DateDiff(A_Now, this.LastLogged, "Seconds") >= 10) {
                Out.D("Window not active.")
                this.LastLogged := A_Now
            }
            Return false
        }
        Return true
    }
    ;@endregion

    ;@region Exist()
    /**
     * Fill xywh values and return bool of existance of window
     * (Updates GameWindow properties when used)
     * @returns {Boolean} Does this.Title exist
     */
    Exist() {
        If (WinExist(this.Title)) {
            Try {
                WinGetClientPos(&valX, &valY, &valW, &valH, this.Title)
                this.X := valX
                this.Y := valY
                this.W := valW
                this.H := valH
            } Catch As err {
                Out.I(
                    "Error: Window doesn't exist. Error getting client position."
                )
                Out.E(err)
                Return false
            }
            Return true
        }
        this.X := this.Y := this.W := this.H := 0
        Return false
    }
    ;@endregion

    ;@region IsPanel()
    /**
     * Check for panel being open
     * @returns {Boolean} True/False, True if a main panel is active
     */
    IsPanel() {
        Try {
            targetColour := Points.Misc.PanelBG.GetColour()
            ; If its afk mode return as well, let afk check handle
            If (targetColour = Colours()
            .Background || targetColour = Colours()
            .BackgroundAFK) {
                ; Found panel background colour
                Return true
            }
            If (targetColour = Colours()
            .BackgroundSpotify) {
                Out.I(
                    "Spotify colour warp detected, please avoid using spotify desktop."
                )
                Return true
            }
        } Catch As exc {
            Out.I("Error 19: Panel transparency check failed - " exc.Message)
            MsgBox("Could not conduct the search due to the following error:`n" exc
                .Message)
        }
        Return false
    }
    ;@endregion

    ;@region AwaitPanel()
    /**
     * Await the panel appearing after being triggered
     * @returns {Boolean} 
     */
    AwaitPanel(maxS := 5) {
        If (!this.IsActive()) {
            Return false ; Kill if no game
        }
        /** @type {Timer} */
        lTimer := Timer()
        lTimer.CoolDownS(maxS, &Waiting)
        while(!this.IsPanel() && Waiting) {
            Sleep(17)
        }
        Return this.IsPanel()
    }
    ;@endregion

    ;@region AwaitPanelClose()
    /**
     * Await the panel closing after being triggered
     * @returns {Boolean} 
     */
    AwaitPanelClose(maxS := 5) {
        If (!this.IsActive()) {
            Return false ; Kill if no game
        }
        /** @type {Timer} */
        lTimer := Timer()
        lTimer.CoolDownS(maxS, &Waiting)
        while(this.IsPanel() && Waiting) {
            Sleep(17)
        }
        Return !this.IsPanel()
    }
    ;@endregion
}
