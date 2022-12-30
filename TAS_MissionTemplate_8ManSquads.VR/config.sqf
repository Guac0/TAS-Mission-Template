///////////////////////////////////////////////////
///////////////Mission Maker Options///////////////
///////////////////////////////////////////////////



//to view the autoFactionArsenal script helper instructions, see the file at \functions\scripts\autoFactionArsenal.sqf


//if you're adding custom hold actions to your mission, you might want to put them in functions\fn_applyHoldActions.sqf, which has support for re-applying the actions if arma eats them.


//to add a custom fortify preset, go to description.ext and follow the instructions there


//to use the automated reviewer, play the game and execute the following in the debug console:
	//[] call TAS_fnc_automatedReviewer;





//////////////////////////////////
/////Scripts/Functions Options////
//////////////////////////////////



//Initiates Quicksilver's Blue Force Tracking on map/gps
//Customize its settings in scripts/QS_icons if you want to
TAS_bftEnabled 				= true; //default true
//publicVariable "TAS_bftEnabled";


//turn the AFK heal object on or off
//see description of it below in initServer.sqf Code, needs an object in eden named "AceHealObject"
//recommend you keep on as it is a core thing like dynamic groups, only here for easy turning off in case someone forgets the object
//also includes player-only spectator as a secondary option on the same box
//Required Mods: ACE
TAS_aceHealObjectEnabled 		= true; //defaults to true
TAS_aceSpectateObjectEnabled 	= true; //defaults to true
//publicVariable "TAS_aceHealObjectEnabled";
//publicVariable "TAS_aceSpectateObjectEnabled";



//////////////////////////////////
/////////Inventory Options////////
//////////////////////////////////
//just a general note, the template only contains ace arsenals for a reason. Usage of any other arsenal type may result in broken scripts/mods.



//tfar radio assignment init, for SL LR backpack assignment needs SLs to have the preset variable names for SLs(see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: TFAR
TAS_radiosEnabled 		= true; 			//defaults to true
TAS_NoSquadleadLr 		= true; 			//default true. Set to true if you want to use radiomen instead of SLs having the LR backpacks by default (radiomen must have "Radioman" or "RTO" as their role description to be given the backpack)
TAS_radioAdditionals 	= false; 			//default false. Sets channel 2 as an additional at game start. What frequency it is set is controlled by the tfar attributes of each character in eden.
TAS_radioPersonal 		= "TFAR_anprc152"; 	//defaults to the "TFAR_anprc152", used by indep but is standard issue in TAS
TAS_radioBackpack 		= "TFAR_anprc155_coyote"; //defaults to 155 coyote ("TFAR_anprc155_coyote"), change to what you want. Leaving empty ("") will not assign a backpack radio (useful if you preconfigured unique radio loadouts in eden)
//publicVariable "TAS_radiosEnabled";
//publicVariable "TAS_NoSquadleadLr";
//publicVariable "TAS_radioAdditionals";
//publicVariable "TAS_radioPersonal";
//publicVariable "TAS_radioBackpack";


//Assigns player loadouts via config
//It looks at the config files for the given faction and tries to match each player's Role Description with the name of a unit from that faction. If found, it gives them that unit's loadout, if not found, it gives them a Rifleman loadout from that faction
//Note that the actualy inventory items (stuff in uniform and vest and etc) of the player will be overwritten by TAS_populateInventory if that is enabled, but this will still set the clothing, weapons, etc
//To disable loadout assignment on a given unit while keeping the system enabled for other units, place the following in its init box:
	//this setVariable ["TAS_disableConfigLoadoutAssignment",true];
//You can also manually set the loadout names if you don't want it to autodetermine based on the role description. To do this, put the following lines into the init box of the unit (it can have spaces, the underscores are just for easy selection and deletion):
	//this setVariable ["TAS_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];
TAS_useConfigLoadout 	= false; 		//default false
TAS_configLoadoutCustom	= false;		//default false. Set to true if you want to assign override loadouts via the script menu in initPlayerLocal instead of via unit init boxes with the above code
TAS_configFaction 		= "BLU_F"; 		//you can find the config name by placing a unit, right click, log, log faction classname to clipboard
TAS_configUnitPrefix	= "";			//prefix, including space if necessary. Use it when your units are named like 'SF Rifleman', 'SF Team Leader' to avoid retyping, otherwise leave blank
TAS_defaultConfigUnit 	= "Rifleman"; 	//if role description doesn't match any unit in the faction, it falls back to this unit name for the loadout assignment
TAS_configLoadoutNumber = 0; 			//Advanced users only. When multiple loadouts are found, use the # loadout found (zero-based)
//publicVariable "TAS_useConfigLoadout";
//publicVariable "TAS_configLoadoutCustom";
//publicVariable "TAS_configFaction";
//publicVariable "TAS_configUnitPrefix";
//publicVariable "TAS_defaultConfigUnit";
//publicVariable "TAS_configLoadoutNumber";


//Automatically gives appropriate inventory items to players, loosely based on class. Clears eden inventory (but doesnt change clothing or weapons)
	//does NOT give GPS
//Medical: 16x basic bandages, 8x morphine, 3x TQs, 2x epi, 2x 500ml blood
	//If medic, extra 40 basic bandages, 20 morphine, 15 epi, 6 TQs, 10x 500 ml blood, 6x 1000ml blood, 1x PAK
//Ammo: 4x standard primary mags, 4x special mags, 2x pistol mags (if have pistol), 2x launcher mags (if have launcher)
//Misc: 1x entrenching tool
//Grenades: 2x M67s, 2x white smoke, 1x purple smoke
//If engineer, gives 1x toolkit, 1x mine detector
TAS_populateInventory 	= true; //default true
//publicVariable "TAS_populateInventory";





//////////////////////////////////
/////////Respawns Options/////////
//////////////////////////////////



//Choose between respawning with config loadout (default in vanilla, not recommended. set both options to false to pick this option), respawning with gear you had when you died, and respawning with gear that you preset at the arsenal
//for TAS_respawnArsenalGear, loadout is saved whenever the player exits the (ace) arsenal, and there's also an option to manually save your loadout at the AceHealObject
TAS_respawnDeathGear 	= false; //default false --- DO NOT SET BOTH respawnDeathGear AND respawnArsenalGear to true!!!
TAS_respawnArsenalGear 	= true; //default true
//publicVariable "TAS_respawnDeathGear";
//publicVariable "TAS_respawnArsenalGear";


//makes players respawn in ACE spectator.
	//Recommended to be enabled whenever you're using anything with a timer for reinserts (respawn vehicle, wave respawns, FOB system). The various respawn systems will not work correctly if TAS_respawnSpectator is disabled.
		//"anything with a timer" does not include the vanilla respawn timer.
//Can be edited midgame via the Zeus "Manage ACE Spectator Options" module. 
TAS_respawnSpectator 				= true; 	//default false. Enables/disables respawning in spectator.
TAS_respawnSpectatorForceInterface 	= false; 	//default false. If enabled, makes it so that player cannot leave spectator early (disable it to allow them to close spectator and access the arsenal box or whatever while they wait)
TAS_respawnSpectatorHideBody 		= true; 	//default true. Hides the player's body while they are in spectator.
TAS_respawnSpectatorTime 			= 5; 		//default 0 (0 for no automatic ending of spectator after X amount of seconds have passed, such as for one life ops). Ignored if TAS_waveRespawn is enabled.
//publicVariable "TAS_respawnSpectator";
//publicVariable "TAS_respawnSpectatorForceInterface";
//publicVariable "TAS_respawnSpectatorHideBody";
//publicVariable "TAS_respawnSpectatorTime";


//does wave respawns, aka reinserts all dead players at once every set interval of time instead of them individually reinserting.
TAS_waveRespawn						= false;	//default false
TAS_waveTime						= 300;		//default 300 (5 minutes). It can take up to 5-10 seconds for all players to respawn, and respawning is available for a 20 second window as a grace period after each respawn wave.
										//Overwrites TAS_respawnSpectatorTime if TAS_waveRespawn is enabled.
//publicVariable "TAS_waveRespawn";
//publicVariable "TAS_waveTime";


//This script adds a custom system for respawning in a forward logistics vehicle
	//Requires a vehicle named "logistics_vehicle" in your mission (recommend that it is also invincible)
	//After respawning, this forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being TPed to the respawn vic
//Required Mods: ACE
/*add a respawn vehicle with the following in the vehicle init field (give the vehicle a variable name, any name works). Change "Respawn Vehicle 1" to whatever, just keep the quotes. NOTE: If you name things 1, 2, 3, there's no guarentee what order they show up in.
if (isServer) then {
	this spawn {
		waitUntil {!isNil "TAS_respawnInVehicle"};
		if (TAS_respawnInVehicle) then {
			waitUntil {!isNil "TAS_respawnLocations"};
			TAS_respawnLocations pushBack [_this,"Respawn Vehicle 1"];
			[_this,"hd_flag","ColorUNKNOWN","Respawn Vehicle 1",true,5] call TAS_fnc_markerFollow;
			//publicVariable "TAS_respawnLocations";
			_this addMPEventHandler ["MPKilled", {
				params ["_unit", "_killer", "_instigator", "_useEffects"];
				private _path = [TAS_respawnLocations, _unit] call BIS_fnc_findNestedElement;
				if (_path isNotEqualTo []) then {
					diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic removing repsawn vic from list!";
					private _indexOfOldVehiclePair = _path select 0;
					TAS_respawnLocations deleteAt _indexOfOldVehiclePair;
					//publicVariable "TAS_respawnLocations";
				} else {
					diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic cannot find vehicle to remove!";
				};
			}];
		};
	};
};
*/
TAS_respawnInVehicle 		= true; //default false
//publicVariable "TAS_respawnInVehicle";


//turn FOB on/off. if on, it needs some eden setup see documentation elsewhere. setup already done in the template if you dont break it
	//What this does is give every Squad Lead an ace self interact to establish a "Rallypoint" at their position (if no enemies are within the stated range)
	//Rallypoints are respawn positions for the players' side, and if using the large rally, also have a small ammobox
	//FOB system adds an action to every SL (and command engineer) to the "logistics_truck" vehicle to establish a small base with arsenals and a respawn position
	//If you want to disable rallypoints while keeping FOB or vice versa, set the distances from enemies to like 99999 or something absurdly high
//Required Mods: ACE
TAS_fobEnabled 			= true; 	//default false, set to false to disable FOB building and rallypoints
TAS_fobPackup			= false;		//default false, if true it allows the FOB to be packed up again into the original logistics_vehicle
TAS_fobFullArsenals 	= false; 	//default false. Determines whether the resupply crates at the FOB are full arsenals or are identical to the Zeus resupply crates (medical and primary weapon ammo)
TAS_fobDistance 		= 300; 		//default 300 meters, if enemies are within this range then FOB cannot be created
TAS_fobRespawn			= false;	//default false, adds a (vanilla) respawn position at the FOB. FOB will have respawn GUI position regardless of this setting. You might want to disable this if you want players to spawn at main and then use the respawn GUI to respawn at the FOB
TAS_fobOverrun			= false;		//default false. Enables the ability for the FOB to be overrun.
TAS_fobOverrunDestroy	= true;		//default true. Destroys all FOB objects when FOB is overrun (may cause mild damage to units nearby)
TAS_fobOverrunFactor	= 2;		//default 2. Determines how many more enemies than friendlies have to be in TAS_fobDistance of the FOB to begin the overrun sequence. i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
TAS_fobOverrunMinEnemy	= 8;		//default 8. sets the minimum number of enemies nearby to start/continue the overrun
TAS_fobOverrunTimer		= 300;		//default 300 (5 min). Time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
TAS_fobOverrunInterval	= 30;		//default 30 (1 min). determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of TAS_fobOverrunTimer. Values larger than 30 will result in the message fading out between updates
TAS_useSmallRally 		= true; 	//default true, set to true if you want to use the small rallypoint without a supply crate
TAS_rallyDistance 		= 100; 		//default 150 meters, if enemies are within this range then rallypoint cannot be created
TAS_rallyOutnumber 		= true; 	//default true. TRUE makes it so rallypoints are canceled if there are more enemies (units in BIS_enemySides) than friendlies (units of same same as player) in the radius. False cancels rallypoint creation if there are ANY enemies within the radius
TAS_rallypointOverrun 	= false;		//default false. TRUE makes it so rallypoints can be overrun if more enemies than friendlies exist within TAS_rallyDistance
TAS_rallyOutnumberFactor 	= 2;		//default 2. Determines how many more enemies than friendlies have to be in TAS_rallyDistance of the rally to begin the overrun sequence. i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
TAS_rallyOverrunMinEnemy	= 4;		//default 4. sets the minimum number of enemies nearby to start/continue the overrun
TAS_rallyOverrunTimer	= 90;		//default 90 (1.5 min). Time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
TAS_rallyOverrunInterval 	= 15;		//default 15. determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of TAS_rallyOverrunTimer. Values larger than 30 will result in the message fading out between updates
//publicVariable "TAS_fobEnabled";
//publicVariable "TAS_fobPackup";
//publicVariable "TAS_fobFullArsenals";
//publicVariable "TAS_fobDistance";
//publicVariable "TAS_fobRespawn";
//publicVariable "TAS_fobOverrun";
//publicVariable "TAS_fobOverrunDestroy";
//publicVariable "TAS_fobOverrunFactor";
//publicVariable "TAS_fobOverrunMinEnemy";
//publicVariable "TAS_fobOverrunTimer";
//publicVariable "TAS_fobOverrunInterval";
//publicVariable "TAS_useSmallRally";
//publicVariable "TAS_rallyDistance";
//publicVariable "TAS_rallyOutnumber";
//publicVariable "TAS_rallypointOverrun";
//publicVariable "TAS_rallyOutnumberFactor";
//publicVariable "TAS_rallyOverrunMinEnemy";
//publicVariable "TAS_rallyOverrunTimer";
//publicVariable "TAS_rallyOverrunInterval";









//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Advanced Options/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/*

Below you can find various options that are not included in the main list for one of three reasons:
	1. It is illogical to change these settings from the defaults
		For example, adding various zeus modules required to manage other systems enabled in the regular template options, or are just handy in general
		Some, like TAS_resupplyObjectEnabled, are intended to be always enabled even if you don't include the relevant objects from the mission.sqm because 
			they are capable to automatically detecting when they are not required (i.e. you delete the object the resupply creator is attached to)
	2. They have either extremely advanced usage cases that only Guac uses, or are settings for developer work on the template/versioning
		For example, TAS_spawnUnitsOnHC and TAS_templateVersion respectively
	3. They are WIP or known to be broken features which default to disabled. Use at your own risk.
		These are rare and are marked as "feature temp removed", "doesn't work", or "probably works but not promises and rare usage case anyways"

TL;DR: don't scroll down unless you know what you're doing, have been instructed to do so, or are very curious.

*/





//////////////////////////////////
//////////Misc Options////////////
//////////////////////////////////



//Disables vanilla stamina at mission start and on player respawn.
TAS_vanillaStaminaDisabled = true; //defaults to true
//publicVariable "TAS_vanillaStaminaDisabled";


//probably works now but no promises
//Modifies weapon sway (well, aim precison) coefficient and recoil coefficient. 1 is normal, 0 is nothing (but don't use 0, use 0.1)
TAS_doAimCoefChange 	= false; 	//default false
TAS_aimCoef 	  		= 0.5;		//default 0.5; no effect if TAS_doCoefChanges is FALSE
TAS_recoilCoef 	  		= 0.75;		//default 0.75; no effect if TAS_doCoefChanges is FALSE
//publicVariable "TAS_doAimCoefChange";
//publicVariable "TAS_aimCoef";
//publicVariable "TAS_recoilCoef";


//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: CTAB
TAS_ctabEnabled 		= false; //default false (since ctab isnt in scifi modpack)
//publicVariable "TAS_ctabEnabled";


//Removes certain problematic items from arsenal boxes that are otherwise hidden and unremoveable (boxes names must be arsenal_# from 1 to 10, template already gives you 1-3 premade and you can just copy paste those)
//See initPlayer for full list, but this is things like doomsday, hidden brightlights, etc
//possibly broken
TAS_arsenalCurate 		= true; //defaults to true
//publicVariable "TAS_arsenalCurate";





//////////////////////////////////
////////Template Options///////////
//////////////////////////////////



TAS_templateVersion 	= 10.1; //if it's a major release (like 10.0), note that arma will truncate the empty decimal to just '10'
//publicVariable "TAS_templateVersion";


TAS_doTemplateBriefing 	= true;
//publicVariable "TAS_doTemplateBriefing";
TAS_templateBriefing = [
	"1. Fixed various critical typos in FOB system, respawn system, and 3d Group Icons.",
	"2. Miscellaneous background fixed and minor updates.",
	"Known issues: Respawn In Vehicle has approximately a 5% change to not work when you try to click the button. Fix is WIP.",
	"Please visit the 'Mission Template' section in the mission notes (in the top left of the map screen) to be aware of the enabled toggleable features present in this mission.",
	"You will only receive this message once every time you join a mission with a new mission template version."
];
//publicVariable "TAS_templateBriefing"; //is probably a problematically-large var to share 


//Cleans the mission template briefing by removing diary records for options set to FALSE
TAS_cleanBriefing 			= true; //default true. true to enable, false to disable.
//publicVariable "TAS_cleanBriefing"; //don't touch the //publicVariable lines





//////////////////////////////////
////////Scripts Options///////////
//////////////////////////////////



//Special logic in init.sqf for spawning AI directly on HCs. Advanced usage only and requires extensive setup. Do not touch unless Guac tells you to.
TAS_spawnUnitsOnHC 		= false; //default false
//publicVariable "TAS_spawnUnitsOnHC";


//turn TAS_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
//Required Mods: TFAR
TAS_globalTfarEnabled 		= true; //default true, no effect if you dont call it using the trigger or a script
//publicVariable "TAS_globalTfarEnabled";


//Enables the Dynamic Groups system.
TAS_dynamicGroupsEnabled 	= true; //default true
//publicVariable "TAS_dynamicGroupsEnabled";


//Displays markers in the bottom left of the map that display the server's and HC's FPS and number of local groups/units
//might be desirable to turn off if you don't want players to see
TAS_fpsDisplayEnabled 	= true; //default true
//publicVariable "TAS_fpsDisplayEnabled";


//attempts to solve people losing their team color after death by reapplying it on respawn
TAS_fixDeathColor		= true; //default true
//publicVariable "TAS_fixDeathColor";

//trims player group names to get rid of the extra spaces added by the template's need for duplicate group names
TAS_trimGroupNames 		= true;
//publicVariable "TAS_trimGroupNames";





//////////////////////////////////
///////Logistics Options//////////
//////////////////////////////////



//Adds an "Create Resupply Box" action to a whiteboard that spawns the zeus resupply box on the jump target object.
//Useful for allowing players to run logi without zeus intervention to create resupply box.
//Needs the "Create Resupply Box" whiteboard and "Resupply Spawn Helper" parachute jump target from mission.sqm to work
TAS_resupplyObjectEnabled = true; //default true
//publicVariable "TAS_resupplyObjectEnabled";


//FEATURE TEMP REMOVED
//Enables the KP crate filler script, see "KPCF_config" for options 
//NOTE: With default settings, it will add custom behavior to ALL "Land Parachute Target" and "Seismic Map (Whiteboard)" objects in your mission. Disable this setting or change the target objects in KPCF_config if you are using those objects in your mission.
//TAS_kpCratefiller = true;	//default true
////publicVariable "TAS_kpCratefiller";




//////////////////////////////////
//////////Zeus Options////////////
//////////////////////////////////



//Adds two custom resupply modules to Zeus
//Each has 6 magazines of each player's weapon and a bunch of medical
//One spawns the crate at cursor location, other paradrops it (watch for wind!)
//Find the modules under the "Resupply" section in Zeus
//Required Mods: ZEN
TAS_zeusResupply 		= true; //default true
//publicVariable "TAS_zeusResupply";


//Adds zeus module to play info text
TAS_zeusInfoText 		= true; //default true
//publicVariable "TAS_zeusInfoText";


//Adds zeus modules for manually managing group ownership
TAS_zeusHcTransfer 		= true; //default true
//publicVariable "TAS_zeusHcTransfer";


//Adds 3d icons over group leaders' heads for identification purposes, intended to be used during prep time.
	//Automatically activates on mission start, zeus can enable/disable it with a zeus module
TAS_3dGroupIcons 		= true; //default true
//publicVariable "TAS_3dGroupIcons";


//allows zeus to trigger an automatic debug and cleanup of hold actions available in the mission
	//for example, try placing it when people complain that the heal box doesn't work anymore
TAS_zeusActionDebug		= true; //default true
//publicVariable "TAS_zeusActionDebug";


//adds two modules for zeus to manage spectator settings and to apply spectator to units
TAS_zeusSpectateManager	= true; //default true
//publicVariable "TAS_zeusSpectateManager";


//adds a module for zeus to delete all empty groups and mark occupied groups as eligible for deletion once they are empty
TAS_zeusGroupDeletion 	= true; //default true
//publicVariable "TAS_zeusGroupDeletion";


//adds a module to zeus to run the marker follow script
TAS_zeusFollowMarker 	= true; //default true
//publicVariable "TAS_zeusFollowMarker";





//////////////////////////////////
//Client Hotkeys/Actions Options//
//////////////////////////////////



//Script by IndigoFox that adds an ace interact to all windows which breaks them upon use.
//Source: https://www.reddit.com/r/armadev/comments/sv72xa/let_your_players_break_windows_using_ace/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
TAS_aceWindowBreak 		= false; //default false
//publicVariable "TAS_aceWindowBreak";


//hotkey to turn afk script on/off
//Required mods: CBA
TAS_afkEnabled 			= true; //default true
//publicVariable "TAS_afkEnabled";


//hotkey to turn earplugs script on/off
TAS_earplugsEnabled 	= true; //default true
TAS_earplugVolume 		= 0.25; //volume to reduce to when earplugs are in (0 is no volume, 1 is regular). Applies to fadeSound, fadeRadio, fadeSpeech, fadeMusic, and fadeEnvironment.
//publicVariable "TAS_earplugsEnabled";
//publicVariable "TAS_earplugVolume";


//adds a hotkey to mute/unmute music
TAS_musicKeyEnabled 	= true; //default true
//publicVariable "TAS_musicKeyEnabled";





//////////////////////////////////
//////////Admin Options///////////
//////////////////////////////////
//these options are more geared towards logging or other admin actions and should be left at their defaults unless you know what you're doing 



//logging information for certain mods, with optional chat messages
TAS_ModLog 				= true;	//default true
TAS_ModLogShame 		= true; //default true
//publicVariable "TAS_ModLog";
//publicVariable "TAS_ModLogShame";


//tracks various performance statistics for each client and sends the results to the server
TAS_trackPerformance 	= true; //default true, customize specific settings in initPlayerLocal.sqf
//publicVariable "TAS_trackPerformance";


//adds a custom rich presence for people running the discord rich presence mod
TAS_doDiscordUpdate		= true; //default true
TAS_discordUpdateDelay 	= 30; 	//default 30
//publicVariable "TAS_doDiscordUpdate";
//publicVariable "TAS_discordUpdateDelay";


