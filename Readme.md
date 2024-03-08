# WW2 scripts v1.0.0

Support and news: <https://discord.gg/xu8fXw4CQ8>

Autohotkey V2 script, install V2 of Autohotkey and run the WizardsWheel2.ahk
file to load. Edit the .md files with a text editor for information.

Same key toggles the feature off, if this toggle fails, NumpadSubtract or
NumpadAdd to abort.

Numpad Subtract: Closes the script entirely

Numpad Add: Reloads the script, deactivating anything that is active but keeping
it loaded

Numpad 0: Equip the first skillgem available to benched character then move to
next character.

Be sure to be in the benched character screen and have selected
the skill gems page (so its on the right view), then close the inventory so you
are looking at the character and activate. Will skip characters that have a
skill gem equipped already. Does not validate which skill gem it is equipping,
will also run through 68 characters and may overlap if some are missing from
benches.

Numpad Enter: Battle mode. Maintains the wheel buff state, skills, mimics,
checks buff state and beeps if they expired, clicks wizard.

May not maintain skill up time correctly depending on your timers so adjust if
needed, will have issues with battle timelines where the colour overlay messes
colour checks up. Several events have been accounted for however.

F10: Event item auto reset. This uses the ability to copy the save to the
clipboard to purchase an event item, check if it has socket/perfect/90% quality,
then if not reload the clipboard save to try again.

Set the correct locations to be clicked, restart script if changes made. Be sure
you store your save game in a text file as backup, copy the current save to the
clipboard before running, then on the village screen activate the script. It'll
reset first so if there are any issues you can halt.

F11: Autoclicker set to 17ms. Will work outside the game and disable the keybind
if the LBR script is running to avoid conflicts.

## Notes

Sleep times might need adjusting for your pc, so increase them as needed if
things are skipping. Increments of 17 should add another frame (at 60fps).

My window size (1440p snapped to corner) 1278x664 client size is what the
locations are based on, those are adapted to your window size, so set your
window 'client' to this size for changes or if things don't work. For high
accuracy situations I maximise the window to capture 2560x1369.

All functions have protections to save you in cases of alt tabbing or pop up
windows taking focus, and should cancel in such cases. Functions will try to
setup the area and windows correctly for you so you can stop one and start
another quickly.

## Settings you need

|   Set to this                                           |  What might happen without it                                                                                                 |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
|   Setting                                               |  Reason.                                                                                                                      |
|                                                         |                                                                                                                               |

## Changes

First push of the script modified to match style of LBR script.  

## TODO

Enchanting stop at X affix
Get auto timewarp working
Auto timewarp with selected timeline
Auto sell items via search
Log new colour overlays so they can be added to detection

## Known issues

Most of the scripts are in rough form, require specific setups and are fragile.  
Item reset requires manual editing to suit needs.  
Skill gem application doesn't check for skill gem type before applying.  
Not everything will adapt to resolution changes as it uses image detection.
