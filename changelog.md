# Major Release v12.0 (bazinga!)

## Major Enhancements/New Systems
1. Brought 5 and 10 man template mission.sqm variations up to version parity
2. Deprecated 5 man template version in favor for a 6 man template version, as a 6 man version is more popular and a 5 man version can be derived from it by simply deleting a squad member from each squad.
3. Add Scavenger System and Zeus modules for it
4. Add Punish Civilian Killers System and Zeus modules for it
5. Add Cease Fire Zone by KiloSwiss
6. Add Mark Unit System with marker and 3d icons on marked units, config entry to automatically allow mark action to be used by all players, and zeus module for it
7. Separate Zeus modules into Main, Logistics/Respawns, Systems, and Punish/Protect Civilian Killers sections
8. Add rhs_fixer.bat to fix various errors that RHS units have when attempting to use them with spawnUnits.sqf
## Minor enhancements
1. Add attack dog script and zeus module by BenfromTTG and collected by Bassbeard, with minor edits by me.
2. Add fn_playCornerVideo by Freddo and curated by Bassbeard, which plays a provided video in the corner of each player's screen.
3. Add fn_addExo and zeus module, which attempts to equip the provided unit with a Exosuit roughly corresponding to their role name. This function automatically disables itself if the required mod (ExoMod Remastered) is not present.
4. Update release builder tools to once again include the alternate mission.sqms.
5. Add fn_aceJuggernaut by Bassbeard and zeus module for it (made by me) which makes a unit invincible until they have been hit a certain number of times, plus edits to prevent premature death.
6. Add fn_burnUnitOrArea function and Zeus module to set player(s) on fire using Ace's system.
7. Enabled Zeus Composition Scripts.
8. Updated fn_arsenalCurate to include m82 HE ammunition.
9. Increased documentation on fn_respawnGUI courtesy of Corny.
10. Add additional debug to fn_applyHoldActions.
11. Rewrite fn_error to be more powerful, copy error to server, and display error to logged-in Zeuses/Admins if they are the local user.
12. Add modularity to allow to multiple sides to use fn_briefing with different briefings for each side.
13. Standardize all role checks for RTO to check for either RTO or Radioman role names.
14. Added zeus modules to create zeus entities for the logged in admin and Guac.
15. Add example configuration to set max view distance for CH View Distance and to force rendering grass.
16. Minor refactor to fn_markerFollow to force it to run server-side for better performance and user-disconnect failure compatibility.
17. Refactor fn_showFps to make it into a function, be user-agnostic, and have a zeus module to activate it on a unit.
## Bugfixing
1. Fixed fn_drawBlood's multiplayer compatibility (donating unit now correctly loses blood).
2. Fixed missing variables preventing VASS from saving player loadout and bank between missions.
3. Fixed missing dependencies in mission.sqm (should work correctly when only using the core mods: CBA, ACE, TFAR, etc).
4. Fixed broken status display in fn_globalTfar's zeus module due to missing missionNamespace status variable.
## Zeus/Player QoL
1. Reduced fn_drawBlood's action time from 6 to 4 seconds.
2. Update populateInventory to use advanced medical items.
3. Update fn_automatedReviewer to check all the new config variables.

**Full Changelog**: https://github.com/Guac0/TAS-Mission-Template/compare/v11.2...v12.0

**Playerside changelog**:
1. Added various torture zeus modules for Zeuses to use on the playerbase (set units on fire, spawn attack dog, timeout player, make unit into juggernaut, etc). Fun times ahead!
2. Added Cease Fire Zone, which Zeus may apply to arsenal areas to prevent weapons from being fired near them. Y'know, cause y'all couldn't behave...
3. Added an optional system that punishes players for killing multiple civilians. Disabled by default (which I'm sure that many of you are thankful for).
4. Fixed drawing blood not actually lowering the donator's blood levels, and make the draw blood action faster to complete. Why yes, you can in fact drain enough blood from someone to kill them.