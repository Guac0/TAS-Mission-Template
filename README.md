# TAS Mission Template
 
See the documentation in Eden (comment modules). You can customize and disable the various scripts by looking at initServer.sqf, there is no need to delete files to disable scripts unless specifically stated otherwise.

I would not recommend taking specific scripts from the template out to use in your own missions without consulting Guac as much of the code depends on the majority of the files being present. Instead, copy all the files in the template and simply disable the scripts you don't want to run via the options in initServer.sqf.

The FOB system and the AceHealObject are the only two scripts that need to be setup in the Eden mission file (FOB needs extensive setup, see the FOB Readme/comments in the eden template, while the Ace Heal Object only needs an object named "AceHealObject", preferable a Huron medical container). The FOB system does not need to be setup if it is disabled in initServer.sqf. All other scripts need no setup in eden and just need their script files to be in the mission folder.
Loadout system also needs minor setup but can be skipped, if skipped then the SL gear assignment (radio backpack and cTab rugged tablet) will be skipped and they will only recieve the standard rifleman gear.

Ignore the outdated mission file.

For more information on a specific script, open its files and look at the comments there. Some documentation may be missing or outdated, ask Guac if you have questions.

Known issues:
Even if they are not the Squad Leader, if a player takes any slot in an otherwise-empty squad Arma will consider them to be the Squad Leader and as such will give them the SL's radios and cTab. Workaround: Slot the SL in every squad first, or, in the initial slotting, make sure that the SL slot is taken before pushing into the mission file.

Dependencies:
Shortlist assuming that all scripts are enabled: CBA_A3, ACE3, TFAR, cTab. Recommend you also load 3den Enhanced.
Long list: ACE3 Explosvies, ACE3 Cargo, tfar_antennas, cTab (if cTab loadout script is enabled), tfar (if TFAR loadout script is enabled), CBA_A3 (if AFK script is enabled), ACE3 Interactions (if FOB system is enabled).