# TAS Mission Template

[A video guide to this mission template is now available!](https://www.youtube.com/playlist?list=PL8QEpH_FlMhFFts_uTFzbFsb0lDOmx2k9)

## What is this?

This is a mission template for multiplayer missions in [Arma 3](https://store.steampowered.com/app/107410/Arma_3/). Currently, this is used as the standard for missions ran in the TAS Arma Community.

It aims to provide a common baseline of features for mission creators and players to use, as well as more advanced systems intended to be ran on a per-mission basis. Almost all systems can be toggled and/or modified in the configuration file, and a limited number of systems support in-mission editing via Zeus modules.

## Features

- Too many to count!
- I'll update this later.

## How to use
[A video guide to using this mission template is now available!](https://www.youtube.com/playlist?list=PL8QEpH_FlMhFFts_uTFzbFsb0lDOmx2k9)

1. Download the latest version of the mission template from the releases tab in either `.zip` or `.pbo` format.
   - You can pick between squad sizes of six (in one fireteam), eight (in two fireteams), or ten (with two fireteams and a two-member commanding element).
2. Extract the mission template and place the resulting `TAS_MissionTemplate_*ManSquads.VR` folder in your `C:\Users\YourUsernameHere\Documents\Arma 3\mpmissions` folder.
   - Adjust the drive letter and file path as needed.
3. Change the `VR` part of the folder name to the world name of the terrain you want to use for your mission.
   - If you don't know the name, open the terrain in the 3den Editor and open the debug console and execute `worldName` to get the world name of that terrain.
4. Open the mission file in the 3den Editor.
   - It will be under the `mpmissions` folder.
5. You will now be in the 3den Editor view. There are a few distinct sections of the template, such as required items (for scripts to function), useful examples that you can delete if you're not using them, and the players. Read the comment modules scattered around each section and each item in each section to see what's going on.
6. This step is interchangable with the 3den Editor customization step. You should open `config.sqf` and read through each option to configure the Mission Template's scripts settings.
   - Note that enabling some scripts requires corresponding objects in the 3den Editor part of the template to exist, so read the comments carefully before deleting items in the editor view (although the scripts are largely fault-tolerant and will disable themselves if a required object is missing). 
   - However, the default settings in `config.sqf` should be suitable for most missions!
7. Now that you have the Mission Template configured, you can build your mission as normal.
- If you have already built your mission and wish to merge it, make sure to merge it INTO the Mission Template's 3den file, as doing it the other way around will not copy over the script files or mission settings (the ones you configure in the `Settings` tab of the 3den Editor).
8. Make sure to test your mission! In addition to your normal mission testing, you should do the following to make sure you set up the Mission Template correctly:
- When loading and testing the mission, keep an eye out for error messages! These can either be via the `systemchat` text box (gray text in the bottom left), or via the standard Arma error messages with the black boxes in the middle of your screen.
- Respawn to make sure that respawns are functioning correctly.
- Run the automated reviewer script! This is more for collecting mission statistics (very useful for community's mission reviewers who need to review stuff like overall number of units and etc), but it can also point out any custom settings you have applied and a few common errors. To use the automated reviewer, play the mission and execute `[] call fn_automatedReviewer.sqf` in the debug console. The results will be copied to your clipboard after a short time.
- Test the mission both on your local machine and on a dedicated server if possible!

## Dependencies

### Core Dependencies
If any of these mods are missing, the mission template will break completely or work in unexpected ways.
1. [CBA_A3](https://steamcommunity.com/sharedfiles/filedetails/?id=450814997)
2. [ACE3](https://steamcommunity.com/sharedfiles/filedetails/?id=463939057)
3. [Zeus Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=1779063631)

### Modular Dependencies
Specific systems utilize these mods, and these systems will either automatically disable if the required mod is not present, or the Mission Maker can disable the systems in `config.sqf`.
1. [3den Enhanced](https://steamcommunity.com/sharedfiles/filedetails/?id=623475643)
   - Used to set some minor attributes in the `mission.sqm` (3D Editor File). Not important, mostly just recommended due to the additional tools it gives Mission Makers.
2. [Task Force Arrowhead Radio (BETA)](https://steamcommunity.com/sharedfiles/filedetails/?id=894678801)
   - Used for setting radio frequencies and assigning radio items at mission start. Enabled by default.
3. [LAMBS_Danger.fsm](https://steamcommunity.com/sharedfiles/filedetails/?id=1858075458)
   - Used in the `mission.sqm` (3D Editor File) to provide an example of how to use LAMBS modules, as well as to automate some AI actions (garrison, patrol) in systems that spawn AI like the Scavenger System.
4. [E.P.S.M Exomod Remastered](https://steamcommunity.com/sharedfiles/filedetails/?id=2813512977)
   - Only used for fn_addExo, a niche function used only if the Mission Maker manually calls it.
5. [cTab](https://steamcommunity.com/sharedfiles/filedetails/?id=871504836) (Most Editions)
   - Only used to automatically give cTab items at mission start. This is disabled by default.
6. [TAS Unit Mod Redux](https://steamcommunity.com/sharedfiles/filedetails/?id=2769025224)
   - Not a strict dependency, but provides some editor tools specifically made for interacting with the template.
   - Tools: copy map name to clipboard, automatically set author field, export layer to SQF.

## Contributing

Issues are welcome and will be addressed.

Pull requests are welcome and should follow the following guidelines:
1. Global variable names should be prefixed by either `TAS_` or your custom prefix.
2. Any systems you add should have a global enable/disable option in `config.sqf`, as well as additional options where necessary.
3. Zeus modules that you may add should be added according to the standard in `functions\zenCustomModulesRegister.sqf`.
4. Hold actions that you may add should be added according to the standard in `functions\applyHoldActions.sqf`.
5. Where reasonable, organize code as single-file functions registered in `description.ext`.
6. Code should be well-documented, with the minimum being comments at the beginning of any file you add detailing the author, name, parameters, and purpose.
7. Code presence in initialization files like `init.sqf` should be kept to a minimum, ideally a check if your system is enabled in `config.sqf` and then a call to your function (preferably `spawn` instead of `call`).

My response rate will vary according to my current responsibilities, but it will be reasonably prompt.

## Script Extraction / Using pieces of this in your own work

All your derivative work must comply with the license(s) that this work is under. See the licensing section for more details.

This Mission Template and its components, while fairly modular, are intended to be used as one cohesive unit. Assuming your usage case complies with the license(s) this work is under, then you can attempt to take sections of this Mission Template and use them in different works (assuming those works comply with the few restrictions that this work places on derivative work).

However, I reserve the right to limit support for cases that integrate only some of my work, as maintaining skeletonized sections of the codebase is difficult.

## Thank yous and Licensing

Thank you to notable figures in the Arma community who have made their scripts available for use to the community at large. This mission template contains scripts copied in their entirety, modified from the original, or inspired by the original scripts made by the following:
- Quicksilver (QS_Icons Blue Force Tracking script)
- IndigoFox (fn_markCustomObjects.sqf) [BSD 3-Clause License]
- RimmyDownunder
- Gudsawn
- KiloSwiss (Simple Cease Fire Script)
- The TMF mission framework (the briefing template and readme licensing inspiration)
- Others (mostly forum/discord posters who've helped me but I've forgotten their names).
This shared code is licensed under their original terms, usually [APL-SA](https://www.bohemia.net/community/licenses/arma-public-license-share-alike) or adjacent.



This Mission Template overall, namely my first-party contributions, is licensed under [APL-SA](https://www.bohemia.net/community/licenses/arma-public-license-share-alike). Please pay attention to Section 3 of the license, which refers to your specific duties in attribution and maintaining its share-alike status.
If you use this mission template (in its entirity or partially), please do the following:
- Under the Share-Alike requirement, if you fork/modify this mission template, please publish your work in a public GitHub repository and/or public Steam Workshop page (if applicable).
  - If you fork/make a derivative of this mission template in its entirity, please use the naming scheme DERIVATIVE_TAG-TAS, where DERIVATIVE_TAG is your programmer tag or name of your work, and -TAS is my postfix.
- Under the Attribution requirement, please prominently display my name as the original author and a link back to this GitHub page.
  - If you are making a derivative of this mission template and posting it to GitHub or elsewhere, this should go in your README or similar.
  - If you are just making an Arma mission using this template, this can be placed as a map marker in the corner, diary entry, or loading screen author field. Your choice!
- If you create a derivative/fork of this mission template, we reserve the right to integrate any changes or additions into the main TAS mission template in accordance with the Share-Alike provision of APL-SA.
  - Naturally, we will provide proper credit when doing so!
- **Shoot me a message saying that you're using my work! I love seeing people using my work in the wild.**
  - If you can find me, feel free to send me a DM on Discord, or just make an issue on this GitHub page and use it as a chatroom! I won't mind.