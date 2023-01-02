# TAS Mission Template

View the video guide to this mission template for Arma 3 here: https://www.youtube.com/playlist?list=PL8QEpH_FlMhFFts_uTFzbFsb0lDOmx2k9.

See the documentation in Eden (comment modules). You can customize and disable the various scripts by looking at config.sqf, there is no need to delete files to disable scripts.

I would not recommend taking specific scripts from the template out to use in your own missions without consulting Guac as much of the code depends on the majority of the files being present. Instead, copy all the files in the template and simply disable the scripts you don't want to run via the options in config.sqf (note that this method will lead to some scripts having limited to no functionality if they require any Eden setup. See the next line for more information).

Some scripts, like the FOB system and the AceHealObject, need to be setup in the Eden mission file for their full functionality to be present. Because of this, I highly recommend that you build your missions using the entirety of the template (including the mission.sqm, basically follow the tutorial instead of just copying only the script files and not the eden file) because all needed eden setup is already done in the provided mission file.

For more information on a specific script, open its files and look at the comments there as well as its description in config.sqf (if it has one). Ask Guac if you have questions.

## Dependencies:

3den Enhanced (for eden stuff, is not a strict dependency and will load without it), ACE3, cTab (if cTab loadout script is enabled), Zeus Enhanced, Task Force Arrowhead Radio, CBA_A3

## Thank yous and disclaimers

Thank you to notable figures in the Arma community who have made their scripts available for use to the community at large. This mission template contains scripts copied in their entirety, modified from the original, or inspired by the original scripts made by Quicksilver, IndigoFox, RimmyDownunder, Gudsawn, and others (mostly forum/discord posters who've helped me but I've forgotten their names).

I haven't actually looked at the legal docs for Arma in detail (but this is probably valid as far as I know), but unless otherwise noted, you are not allowed to use any of the first party contributions to this repository (i.e. my code and community members' code) for your own projects without getting written approval from me (Guac#5223 on Discord, feel free to ask me, I'll probably approve your usage). Content from other users which I've included and/or modified goes under their original policies, which is usually "feel free to use with credit to the original author". Unless otherwise clearly noted, this code is provided "as-is", and I am not responsible for any damage caused by use or misuse of this code.