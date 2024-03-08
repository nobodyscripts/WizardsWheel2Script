#Requires AutoHotkey v2.0

#Include Functions.ahk

/*
Defines the locations resolution independant for pixel checks
*/

Class RelCoord {
    x := 0
    y := 0

    SetCoordRel(xin, yin) {
        this.x := WinRelPosLargeW(xin)
        this.y := WinRelPosLargeH(yin)
        return this
    }

    NewCoordManual(xin, yin) {
        this.x := xin
        this.y := yin
        return this
    }

    Click(delay := 34) {
        fCustomClick(this.x, this.y, delay)
    }

    ClickOffset(xOffset := 1, yOffset := 1, delay := 34) {
        fCustomClick(this.x + xOffset, this.y + yOffset, delay)
    }

    toString() {
        return "X: " this.x " Y: " this.y
    }

}
/* 
SampleCoord() {
    o := RelCoord()
    o.SetCoordRel(2130, 420)
    return o
} */
