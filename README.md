# TAS Mission Template

View the video guide to this mission template for Arma 3 here: https://www.youtube.com/watch?v=g_OlNxJ2ERA.

See the documentation in Eden (comment modules). You can customize and disable the various scripts by looking at initServer.sqf, there is no need to delete files to disable scripts.

I would not recommend taking specific scripts from the template out to use in your own missions without consulting Guac as much of the code depends on the majority of the files being present. Instead, copy all the files in the template and simply disable the scripts you don't want to run via the options in initServer.sqf (note that this method will lead to some scripts having limited to no functionality if they require any Eden setup. See the next line for more information).

Some scripts, like the FOB system and the AceHealObject, need to be setup in the Eden mission file for their full functionality to be present. Because of this, I highly recommend that you build your missions using the entirety of the template (including the mission.sqm, basically follow the tutorial instead of just copying only the script files and not the eden file) because all needed eden setup is already done in the provided mission file.

For more information on a specific script, open its files and look at the comments there. Ask Guac if you have questions.

Dependencies:

Shortlist assuming that all scripts are enabled: CBA_A3, ACE3, TFAR, cTab, ZEN. Recommend that you also load 3den Enhanced.

Long list: 3den Enhanced (for eden stuff, is not a strict dependency and will load without it), ACE3 Explosvies, ACE3 Cargo, cTab (if cTab loadout script is enabled), Zeus Enhanced (if you have the custom resupply script in the init.sqf), tfar (if TFAR loadout script is enabled), CBA_A3 (if AFK script is enabled), ACE3 Interactions (if FOB system is enabled).

Thank you to notable figures in the Arma community who have made their scripts available for use to the community at large. This mission template contains scripts copied in their entirety, modified from the original, or inspired by the original scripts made by Quicksilver, IndigoFox, RimmyDownunder, and others (mostly forum/discord posters who've helped me but I've forgotten their names).