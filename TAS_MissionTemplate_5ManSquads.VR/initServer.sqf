///////////////////////////////////////////
////////////Mission Maker Options//////////
///////////////////////////////////////////



//////////////////////////////////
/////Scripts/Functions Options////
//////////////////////////////////



//turn afk script on/off
//Required mods: CBA
TAS_afkEnabled = true; //set to false to disable AFK script from being added
publicVariable "TAS_afkEnabled"; //don't touch any of the publicVariable lines

//turn TAS_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
//Required Mods: TFAR
TAS_globalTfarEnabled = true; //default true, no effect if you dont call it using the trigger or a script
publicVariable "TAS_globalTfarEnabled";

//Enables the Dynamic Groups system.
TAS_dynamicGroupsEnabled = true; //default true
publicVariable "TAS_dynamicGroupsEnabled";

//Initiates Quicksilver's Blue Force Tracking on map/gps
//Customize its settings in scripts/QS_icons if you want to
TAS_bftEnabled = true; //default true
publicVariable "TAS_bftEnabled";

//turn the AFK heal object on or off
//see description of it below in initServer.sqf Code, needs an object in eden named "AceHealObject"
//recommend you keep on as it is a core thing like dynamic groups, only here for easy turning off in case someone forgets the object
//also includes player-only spectator as a secondary option on the same box
//Required Mods: ACE
TAS_aceHealObjectEnabled = true; //defaults to true
TAS_aceSpectateObjectEnabled = true; //defaults to true
publicVariable "TAS_aceHealObjectEnabled";
publicVariable "TAS_aceSpectateObjectEnabled";

//Displays markers in the bottom left of the map that display the server's and HC's FPS and number of local groups/units
//might be desirable to turn off if you don't want players to see
TAS_fpsDisplayEnabled = true; //default true
publicVariable "TAS_fpsDisplayEnabled";

//Special logic in init.sqf for spawning AI directly on HCs. Advanced usage only and requires extensive setup. Do not touch unless Guac tells you to.
TAS_spawnUnitsOnHC = false; //default false
publicVariable "TAS_spawnUnitsOnHC";

//Script by IndigoFox that adds an ace interact to all windows which breaks them upon use.
//Source: https://www.reddit.com/r/armadev/comments/sv72xa/let_your_players_break_windows_using_ace/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
TAS_aceWindowBreak = false; //default false
publicVariable "TAS_aceWindowBreak";



//////////////////////////////////
/////////Inventory Options////////
//////////////////////////////////



//Disables vanilla stamina at mission start and on player respawn.
TAS_vanillaStaminaDisabled = true; //defaults to true
publicVariable "TAS_vanillaStaminaDisabled";

//tfar radio assignment init, for SL LR backpack assignment needs SLs to have the preset variable names for SLs(see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: TFAR
TAS_radiosEnabled = true; //defaults to true
TAS_NoSquadleadLr = false; //default false. Set to true if you want to use radiomen instead of SLs having the LR backpacks by default (radiomen must have "Radioman" or "RTO" as their role description to be given the backpack)
TAS_radioAdditionals = false; //default false. Sets channel 2 as an additional at game start. What frequency it is set is controlled by the tfar attributes of each character in eden.
TAS_radioPersonal = "TFAR_anprc152"; //defaults to the "TFAR_anprc152", used by indep but is standard issue in TAS
TAS_radioBackpack = "TFAR_anprc155_coyote"; //defaults to 155 coyote ("TFAR_anprc155_coyote"), change to what you want. Leaving empty ("") will not assign a backpack radio (useful if you preconfigured unique radio loadouts in eden)
publicVariable "TAS_radiosEnabled";
publicVariable "TAS_NoSquadleadLr";
publicVariable "TAS_radioAdditionals";
publicVariable "TAS_radioPersonal";
publicVariable "TAS_radioBackpack";

//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: CTAB
TAS_ctabEnabled = false; //default false (since ctab isnt in scifi modpack)
publicVariable "TAS_ctabEnabled";

//Automatically gives appropriate inventory items to players, loosely based on class. Clears eden inventory (but doesnt change clothing or weapons)
//Medical: 16x basic bandages, 8x morphine, 3x TQs, 2x epi, 2x 500ml blood
	//If medic, extra 40 basic bandages, 20 morphine, 15 epi, 6 TQs, 10x 500 ml blood, 6x 1000ml blood, 1x PAK
//Ammo: 4x standard primary mags, 4x special mags, 2x pistol mags (if have pistol), 2x launcher mags (if have launcher)
//Misc: 1x entrenching tool
//Grenades: 2x M67s, 2x white smoke, 1x purple smoke
//If engineer, gives 1x toolkit, 1x mine detector
TAS_populateInventory = true; //default true
publicVariable "TAS_populateInventory";



//////////////////////////////////
//Respawns and Logistics Options//
//////////////////////////////////



//This script adds a custom system for respawning in a forward logistics vehicle
//Requires a vehicle named "logistics_vehicle" in your mission (recommend that it is also invincible)
//After respawning, this forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being TPed to the respawn vic
//Required Mods: ACE
TAS_respawnInVehicle = false; //default false
TAS_respawnInVehicleTime = 50; //default 50, note that this is in addition to the respawn timer
publicVariable "TAS_respawnInVehicle";
publicVariable "TAS_respawnInVehicleTime";

//Adds two custom resupply modules to Zeus
//Each has 6 magazines of each player's weapon and a bunch of medical
//One spawns the crate at cursor location, other paradrops it (watch for wind!)
//Find the modules under the "Resupply" section in Zeus
//Required Mods: ZEN
TAS_zeusResupply = true; //default true
publicVariable "TAS_zeusResupply";

//Choose between respawning with config loadout (default in vanilla, not recommended. set both options to false to pick this option), respawning with gear you had when you died, and respawning with gear that you preset at the arsenal
//players save their loadout at the heal object
TAS_respawnDeathGear = false; //default false --- DO NOT SET BOTH respawnDeathGear AND respawnArsenalGear to true!!!
TAS_respawnArsenalGear = true; //default true
publicVariable "TAS_respawnDeathGear";
publicVariable "TAS_respawnArsenalGear";

//Adds an "Create Resupply Box" action to a whiteboard that spawns the zeus resupply box on the jump target object.
//Useful for allowing players to run logi without zeus intervention to create resupply box.
//Needs the "Create Resupply Box" whiteboard and "Resupply Spawn Helper" parachute jump target from mission.sqm to work
TAS_resupplyObjectEnabled = true; //default true
publicVariable "TAS_resupplyObjectEnabled";

//turn FOB on/off, if on needs some eden setup see documentation elsewhere. setup already done in the template if you dont break it
//What this does is give every Squad Lead an ace self interact to establish a "Rallypoint" at their position (if no enemies are within the stated range)
//Rallypoints are respawn positions for the players' side, and if using the large rally, also have a small ammobox
//FOB system adds an action to every SL (and command engineer) to the "logistics_truck" vehicle to establish a small base with arsenals and a respawn position
//If you want to disable rallypoints while keeping FOB or vice versa, set the distances from enemies to like 99999 or something absurdly high
//Required Mods: ACE
TAS_fobEnabled = false; //default false, set to false to disable FOB building and rallypoints
TAS_fobFullArsenals = false; //default false. Determines whether the resupply crates at the FOB are full arsenals or are identical to the Zeus resupply crates (medical and primary weapon ammo)
TAS_fobDistance = 300; //default 300 meters, if enemies are within this range then FOB cannot be created
TAS_useSmallRally = true; //default true, set to true if you want to use the small rallypoint without a supply crate
TAS_rallyDistance = 150; //default 150 meters, if enemies are within this range then rallypoint cannot be created
publicVariable "TAS_fobEnabled";
publicVariable "TAS_fobFullArsenals";
publicVariable "TAS_fobDistance";
publicVariable "TAS_useSmallRally";
publicVariable "TAS_rallyDistance";



//to add a custom fortify preset, go to description.ext and follow the instructions there





///////////////////////////////////////////
//////initServer.sqf Code, don't touch/////
///////////////////////////////////////////

if (TAS_respawnInVehicle) then {
	if (isNil "logistics_vehicle") then {
		systemchat "WARNING: TAS_respawnInVehicle requires that the logistics_vehicle to be present in your mission, but it does not exist! Expect errors!";
		diag_log text "TAS-Mission-Template WARNING: TAS_respawnInVehicle requires that the logistics_vehicle to be present in your mission, but it does not exist! Expect errors!";
	} else {
		missionNamespace setVariable ["TAS_respawnVehicle",logistics_vehicle];
	};
};

//dynamic groups code
["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered

//If AceHealObject does not exist but options that require it are turned on, then display a warning that those options will be disabled
if ((isNil "AceHealObject") && (TAS_respawnArsenalGear || TAS_aceHealObjectEnabled || TAS_aceSpectateObjectEnabled)) then {
	systemchat "WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
	diag_log text "TAS-Mission-Template WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
};

//automated (non-zeus) ace heal by Guac
//Instantly ace full heals all players within 100m
//requires object named AceHealObject in mission file
//for some reason doesn't work on flagpoles, perhaps the point where the action is attached to is at the top of the pole, too far away to count as close enough to show up for player?
if (!isNil "AceHealObject") then { //check if the ace heal object actually exists so we dont get errors
	if (TAS_aceHealObjectEnabled) then {
		[
			AceHealObject,											// Object the action is attached to
			"Heal All Entities in 100m",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{_nearPlayers = AceHealObject nearEntities ["Man", 100]; {[objNull, _x] call ace_medical_treatment_fnc_fullHeal} forEach _nearPlayers},													// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			1,													// Action duration [s]
			5,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation, is JIP compatible
	} else {
		//systemChat "Ace Heal Object disabled.";
	};
	if (TAS_aceSpectateObjectEnabled) then {
		//enter spectator action
		[
			AceHealObject,											// Object the action is attached to
			"Enter Spectator",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ [true, false, false] call ace_spectator_fnc_setSpectator },													// Code executed on completion,* 0: Spectator state of local client <BOOL> (default: true) * 1: Force interface <BOOL> (default: false)* 2: Hide player (if alive) <BOOL> (default: false)
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			2,													// Action duration [s]
			4,													// Priority, 0-6
			false,												// Remove on completion
			false												// Show in unconscious state 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation, is JIP compatible
	} else {
		//systemChat "Ace Spectate Object disabled.";
	};
	if (TAS_respawnArsenalGear) then {
		[
			AceHealObject,											// Object the action is attached to
			"Save Loadout",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ player setVariable ["arsenalLoadout",getUnitLoadout player]; },												// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			2,													// Action duration [s]
			3,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation, is JIP compatible
	} else {
		//systemChat "Respawn with Arsenal Loadout disabled.";
		//diag_log text "Respawn with Arsenal Loadout disabled.";
	};
};

if (TAS_resupplyObjectEnabled) then { //check if the ace heal object actually exists so we dont get errors
	if ((!isNil "CreateResupplyObject") && (!isNil "ResupplySpawnHelper")) then {
		[
			CreateResupplyObject,											// Object the action is attached to
			"Spawn Resupply Box",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{[] execVM "scripts\AmmoCrateFromAction.sqf";},													// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			1,													// Action duration [s]
			5,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] remoteExec ["BIS_fnc_holdActionAdd", 0, CreateResupplyObject];	// MP compatible implementation, is JIP compatible
	} else { //if resupply object stuff is turned on but missing the objects needed for it to work, then display a warning that the resupply system will be disabled.
		systemChat "WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
		diag_log text "TAS-Mission-Template WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
	};
};
//Register TAS_globalTFAR as a function
if (TAS_globalTFAREnabled) then {
	TAS_fnc_globalTFAR = compile preprocessFile "scripts\TAS_globalTFAR.sqf";
	//systemChat "TAS Global TFAR System enabled (server debug).";
} else {
	//systemChat "TAS Global TFAR System disabled (server debug).";
};

//setup fob variables if fob system is enabled
if (TAS_fobEnabled) then {
	//{ 
	//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
	//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
	TAS_fobBuilt = false;
	publicVariable "TAS_fobBuilt";
	TAS_rallyCmdUsed = false;
	publicVariable "TAS_rallyCmdUsed";
	TAS_rallyAlphaUsed = false;
	publicVariable "TAS_rallyAlphaUsed";
	TAS_rallyBravoUsed = false;
	publicVariable "TAS_rallyBravoUsed";
	TAS_rallyCharlieUsed = false;
	publicVariable "TAS_rallyCharlieUsed";
	TAS_rallyDeltaUsed = false;
	publicVariable "TAS_rallyDeltaUsed";
	TAS_rallyEchoUsed = false;
	publicVariable "TAS_rallyEchoUsed";
	TAS_rallyFoxtrotUsed = false;
	publicVariable "TAS_rallyFoxtrotUsed";
};

//show fps script by Mildly Interested/Bassbeard
//Code here is for main server, headless client is in init.sqf
if (TAS_fpsDisplayEnabled) then {
	[] execVM "scripts\show_fps.sqf";
	diag_log text "TAS-Mission-Template --------------------[Executed show_fps on Server]--------------------"; //will show in server logs
};