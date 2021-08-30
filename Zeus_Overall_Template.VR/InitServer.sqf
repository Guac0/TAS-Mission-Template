////////////////////////////////////
/////////Mission Maker Options//////
////////////////////////////////////

//turn afk script on/off
//Required mods: CBA
TAS_afkEnabled = true; //set to false to disable AFK script from being added
publicVariable "TAS_afkEnabled";

//turn FOB on/off, if on needs some eden setup see documentation elsewhere
//Required Mods: ACE
TAS_fobEnabled = false; //default false, set to false to disable FOB building and rallypoints
publicVariable "TAS_fobEnabled";
TAS_fobUseFullArsenals = false; //default false. Determines whether the resupply crates at the FOB are full arsenals or are identical to the Zeus resupply crates (medical and primary weapon ammo)
publicVariable "TAS_fobUseFullArsenals";
TAS_fobDistance = 300; //default 300 meters, if enemies are within this range then FOB cannot be created
publicVariable "TAS_fobDistance";
TAS_useSmallRally = true; //set to true if you want to use the small rallypoint without a supply crate
publicVariable "TAS_useSmallRally";
TAS_rallyDistance = 150; //default 150 meters, if enemies are within this range then rallypoint cannot be created
publicVariable "TAS_rallyDistance";

//turn TAS_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
//Required Mods: TFAR
TAS_globalTFAREnabled = true; //default true, no effect if you dont call it using the trigger or a script
publicVariable "TAS_globalTFAREnabled";

//tfar radio assignment init, for SL LR backpack assignment needs SLs to have the preset variable names for SLs(see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: TFAR
TAS_autoRadioLoadoutsEnabled = true; //defaults to true
publicVariable "TAS_autoRadioLoadoutsEnabled";
TAS_radioPersonal = "TFAR_anprc152"; //defaults to the 152, used by indep but is standard issue in TAS
publicVariable "TAS_radioPersonal";
TAS_radioBackpack = "TFAR_anprc155_coyote"; //defaults to 155 coyote, change to what you wnat
publicVariable "TAS_radioBackpack";

//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: CTAB
TAS_ctabEnabled = false; //default false (since ctab isnt in scifi modpack)
publicVariable "TAS_ctabEnabled";

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
publicVariable "TAS_aceHealObjectEnabled";
TAS_aceSpectateObjectEnabled = true; //defaults to true
publicVariable "TAS_aceSpectateObjectEnabled";

//This script adds a custom system for respawning in a forward logistics vehicle
//Requires a vehicle named "logistics_vehicle" in your mission (recommend that it is also invincible)
//After respawning, this forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being TPed to the respawn vic
//Required Mods: ACE
TAS_respawnInVehicle = false; //default false
publicVariable "TAS_respawnInVehicle";
TAS_respawnInVehicleTime = 50; //default 50, note that this is in addition to the respawn timer
publicVariable "TAS_respawnInVehicleTime";

//Adds two custom resupply modules to Zeus
//Each has 6 magazines of each player's weapon and a bunch of medical
//One spawns the crate at cursor location, other paradrops it (watch for wind!)
//Find the modules under the "Resupply" section in Zeus
//Required Mods: ZEN
TAS_zeusResupply = true; //default true
publicVariable "TAS_zeusResupply";

//Choose between respawning with config loadout (default in vanilla, not recommended), respawning with gear you had when you died, and respawning with gear that you preset at the arsenal
//players save their loadout at the heal object
TAS_respawnWithDeathGear = false; //default false
publicVariable "TAS_respawnDeathGear";
TAS_respawnWithArsenalGear = true; //default true
publicVariable "TAS_respawnArsenalGear";



/////////////////////////////////////
/////////initServer.sqf Code/////////
/////////////////////////////////////

//dynamic groups code
["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered

//automated (non-zeus) ace heal by Guac
//Instantly ace full heals all players within 100m
//requires object named AceHealObject in mission file
//for some reason doesn't work on flagpoles, perhaps the point where the action is attached to is at the top of the pole, too far away to count as close enough to show up for player?
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
		2,													// Action duration [s]
		5,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation, is JIP compatible
} else {
	systemChat "Ace Heal Object disabled.";
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
	systemChat "Ace Spectate Object disabled.";
};

if (TAS_respawnWithArsenalGear) then {
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
	systemChat "Respawn with Arsenal Loadout disabled.";
};

//Register TAS_globalTFAR as a function
if (TAS_globalTFAREnabled) then {
	TAS_fnc_globalTFAR = compile preprocessFile "Scripts\TAS_globalTFAR.sqf";
} else {
	systemChat "TAS Global TFAR System disabled."
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
