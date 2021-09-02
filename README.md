# TAS Mission Template

Placeholder line, this will be replaced by the link to the Youtube tutorial for those that prefer a video guide rather than viewing the comment modules in the template.

See the documentation in Eden (comment modules). You can customize and disable the various scripts by looking at initServer.sqf, there is no need to delete files to disable scripts.

I would not recommend taking specific scripts from the template out to use in your own missions without consulting Guac as much of the code depends on the majority of the files being present. Instead, copy all the files in the template and simply disable the scripts you don't want to run via the options in initServer.sqf (note that this method will lead to some scripts having limited to no functionality if they require on eden setup. See the next line for more information).

Some scripts, like the FOB system and the AceHealObject, need to be setup in the Eden mission file for their full functionality to be present. Because of this, I highly recommend that you build your missions using the entirity of the template (including the mission.sqm, basically follow the tutorial instead of just copying only the script files and not the eden file) because all needed eden setup is already done in the mission file.

For more information on a specific script, open its files and look at the comments there. Ask Guac if you have questions.

Dependencies:

Shortlist assuming that all scripts are enabled: CBA_A3, ACE3, TFAR, cTab, ZEN. Recommend that you also load 3den Enhanced.

Long list: 3den Enhanced (for eden stuff, is not a strict dependency and will load without it), ACE3 Explosvies, ACE3 Cargo, cTab (if cTab loadout script is enabled), Zeus Enhanced (if you have the custom resupply script in the init.sqf), tfar (if TFAR loadout script is enabled), CBA_A3 (if AFK script is enabled), ACE3 Interactions (if FOB system is enabled).