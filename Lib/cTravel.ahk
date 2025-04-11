#Requires AutoHotkey v2.0

#Include Navigate.ahk
#Include cZone.ahk
#Include Functions.ahk
#Include ../Navigate/Header.ahk

/** @type {cTravel} */
Global Travel := cTravel()

/**
 * Travel class, contains functions and sub classes for travel to areas, tabs
 * or windows in lbr.
 * @module cTravel
 * @Private _OpenAny Takes functions and provides the logic for the
 * .Open methods
 * @method ResetScroll Reset scroll by swapping tabs
 * @method ResetAreaScroll Reset scroll state in open panel
 * @method OpenAreas Open areas panel
 * @method OpenAreasLeafGalaxy
 * @method OpenAreasSacredNebula
 * @method OpenAreasEnergyBelt
 * @method OpenAreasFireFields
 * @method OpenAreasSoulRealm
 * @method OpenAreasQuark
 * @method OpenAreasEvents
 * @method IsOnEventPanel
 * @method ClosePanel Closes open panel or open settings
 * @method ClosePanelIfActive Closes open panel only if open
 * @method OpenSettings Open settings panel
 * @method ScrollAmountUp Scroll wheel up by an amount
 * @method ScrollAmountDown Scroll wheel down by an amount
 * @method ScrollResetToTop Reset scroll position in a window using modifiers
 *  
 * @property {TheInfernalDesert} TheInfernalDesert Travel class for 
 * TheInfernalDesert
 * @property {CursedHalloween} CursedHalloween Travel class for Cursed Halloween
 * @property {AnteLeafton} AnteLeafton Travel class for Ante Leafton
 * @property {AstralOasis} AstralOasis Travel class for Astral Oasis
 * @property {BiotiteForest} BiotiteForest Travel class for Biotite Forest
 * @property {BlackLeafHole} BlackLeafHole Travel class for Black Leaf Hole
 * @property {BlacklightVerge} BlacklightVerge Travel class for Blacklight Verge
 * @property {BlackPlanetEdge} BlackPlanetEdge Travel class for Black Planet Edge
 * @property {BluePlanetEdge} BluePlanetEdge Travel class for Blue Planet Edge
 * @property {ButterflyField} ButterflyField Travel class for Butterfly Field
 * @property {CursedKokkaupunki} CursedKokkaupunki Travel class for Cursed Kokkaupunki
 * @property {DiceyMeadows} DiceyMeadows Travel class for Dicey Meadows
 * @property {DimensionalTapestry} DimensionalTapestry Travel class for Dimensional Tapestry
 * @property {EnergyShrine} EnergyShrine Travel class for Energy Shrine
 * @property {EnergySingularity} EnergySingularity Travel class for Energy Singularity
 * @property {FarmField} FarmField Travel class for Farm Field
 * @property {FireFieldsPortal} FireFieldsPortal Travel class for Fire Fields Portal
 * @property {FireUniverse} FireUniverse Travel class for Fire Universe
 * @property {FlameBrazier} FlameBrazier Travel class for Flame Brazier
 * @property {GlintingThicket} GlintingThicket Travel class for Glinting Thicket
 * @property {GreenPlanetEdge} GreenPlanetEdge Travel class for Green Planet Edge
 * @property {HomeGarden} HomeGarden Travel class for Home Garden
 * @property {Kokkaupunki} Kokkaupunki Travel class for Kokkaupunki
 * @property {LatsyrcWodash} LatsyrcWodash Travel class for Latsyrc Wodash
 * @property {LeafsinkHarbor} LeafsinkHarbor Travel class for Leafsink Harbor
 * @property {MountMoltenfury} MountMoltenfury Travel class for Mount Moltenfury
 * @property {Mountain} Mountain Travel class for Mountain
 * @property {NeighborsGarden} NeighborsGarden Travel class for Neighbors' Garden
 * @property {PlanckScope} PlanckScope Travel class for Planck Scope
 * @property {PlasmaForest} PlasmaForest Travel class for Plasma Forest
 * @property {PrimordialEthos} PrimordialEthos Travel class for Primordial Ethos
 * @property {PurplePlanetEdge} PurplePlanetEdge Travel class for Purple Planet Edge
 * @property {QuantumAether} QuantumAether Travel class for Quantum Aether
 * @property {QuarkNexus} QuarkNexus Travel class for Quark Nexus
 * @property {QuarkPortal} QuarkPortal Travel class for Quark Portal
 * @property {RedPlanetEdge} RedPlanetEdge Travel class for Red Planet Edge
 * @property {ShadowCrystal} ShadowCrystal Travel class for Shadow Crystal
 * @property {ShadowLighthouse} ShadowLighthouse Travel class for Shadow Lighthouse
 * @property {Sombrynth} Sombrynth Travel class for Sombrynth
 * @property {SoulCrypt} SoulCrypt Travel class for Soul Crypt
 * @property {SoulForge} SoulForge Travel class for Soul Forge
 * @property {SoulPortal} SoulPortal Travel class for Soul Portal
 * @property {SoulTemple} SoulTemple Travel class for Soul Temple
 * @property {Space} Space Travel class for Space
 * @property {SparkBubble} SparkBubble Travel class for Spark Bubble
 * @property {SparkPortal} SparkPortal Travel class for Spark Portal
 * @property {SparkRange} SparkRange Travel class for Spark Range
 * @property {TenebrisField} TenebrisField Travel class for Tenebris Field
 * @property {TerrorGraveyard} TerrorGraveyard Travel class for Terror Graveyard
 * @property {THEVOID} THEVOID Travel class for THE VOID
 * @property {TheAbandonedResearchStation} TheAbandonedResearchStation Travel class for The Abandoned Research Station
 * @property {TheAbyss} TheAbyss Travel class for The Abyss
 * @property {TheAncientSanctum} TheAncientSanctum Travel class for The Ancient Sanctum
 * @property {TheCelestialPlane} TheCelestialPlane Travel class for The Celestial Plane
 * @property {TheCheesePub} TheCheesePub Travel class for The Cheese Pub
 * @property {TheCoalMine} TheCoalMine Travel class for The Coal Mine
 * @property {TheCursedPyramid} TheCursedPyramid Travel class for The Cursed Pyramid
 * @property {TheDarkGlade} TheDarkGlade Travel class for The Dark Glade
 * @property {TheDoomedTree} TheDoomedTree Travel class for The Doomed Tree
 * @property {TheExaltedBridge} TheExaltedBridge Travel class for The Exalted Bridge
 * @property {TheFabricoftheLeafverse} TheFabricoftheLeafverse Travel class for The Fabric of the Leafverse
 * @property {TheFireTemple} TheFireTemple Travel class for The Fire Temple
 * @property {TheHiddenSea} TheHiddenSea Travel class for The Hidden Sea
 * @property {TheHollow} TheHollow Travel class for The Hollow
 * @property {TheInnerCursedPyramid} TheInnerCursedPyramid Travel class for The Inner Cursed Pyramid
 * @property {TheLeafTower} TheLeafTower Travel class for The Leaf Tower
 * @property {TheLoneTree} TheLoneTree Travel class for The Lone Tree
 * @property {TheMoon} TheMoon Travel class for The Moon
 * @property {TheMythicalGarden} TheMythicalGarden Travel class for The Mythical Garden
 * @property {TheShadowCavern} TheShadowCavern Travel class for The Shadow Cavern
 * @property {TheVolcano} TheVolcano Travel class for The Volcano
 * @property {VialofLife} VialofLife Travel class for Vial of Life
 * @property {VilewoodCemetery} VilewoodCemetery Travel class for Vilewood Cemetery
 * @property {YourHouse} YourHouse Travel class for Your House
 * <jsdocmarker>
 */
Class cTravel {
    ;@region Travel classes definition

    ;@endregion

    ;@region ScrollAmountDown()
    /**
     * Scroll downwards in a panel by ticks
     * @param {number} [amount=1] Amount to scroll in ticks of mousewheel
     * @param {number} [extraDelay=0] Add ms to the sleep timers
     */
    ScrollAmountDown(amount := 1, extraDelay := 0) {
        While (amount > 0) {
            If (!Window.IsActive() || !Window.IsPanel()) {
                Break
            } Else {
                ControlClick(, Window.Title, , "WheelDown")
                Sleep(NavigateTime + extraDelay)
                amount--
            }
        }
    }
    ;@endregion

    ;@region ScrollAmountUp()
    /**
     * Scroll upwards in a panel by ticks
     * @param {number} [amount=1] Amount to scroll in ticks of mousewheel
     * @param {number} [extraDelay=0] Add ms to the sleep timers
     */
    ScrollAmountUp(amount := 1, extraDelay := 0) {
        While (amount > 0) {
            If (!Window.IsActive() || !Window.IsPanel()) {
                Break
            } Else {
                ControlClick(, Window.Title, , "WheelUp")
                Sleep(NavigateTime + extraDelay)
                amount--
            }
        }
    }
    ;@endregion

}
