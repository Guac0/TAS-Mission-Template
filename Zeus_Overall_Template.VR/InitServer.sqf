////////////////////////////////////
/////////Mission Maker Options//////
////////////////////////////////////

//turn afk script on/off
AfkEnabled = true; //set to false to disable AFK script from being added
publicVariable "AfkEnabled";

//turn FOB on/off, if on needs some eden setup see documentation elsewhere
FOBEnabled = false; //set to false to disable FOB building and rallypoints
publicVariable "FOBEnabled";
useSmallRally = true; //set to true if you want to use the small rallypoint without a supply crate
publicVariable "useSmallRally";

//turn TAS_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
TAS_globalTFAREnabled = true;
publicVariable "TAS_globalTFAREnabled";

//tfar radio assignment init, for SL LR backpack assignment needs SLs to have the preset variable names for SLs(see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
autoRadioLoadoutsEnabled = true; //defaults to true
publicVariable "autoRadioLoadoutsEnabled";
radioPersonal = "TFAR_anprc152"; //defaults to the 152, used by indep but is standard issue in TAS
publicVariable "radioPersonal";
radioBackpack = "TFAR_anprc155_coyote"; //defaults to 155 coyote
publicVariable "radioBackpack";

//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
ctabEnabled = false; //default false (since ctab isnt in scifi modpack)
publicVariable "ctabEnabled";

//turn the AFK heal object on or off
//see description of it below in initServer.sqf Code, needs an object in eden named "AceHealObject"
//recommend you keep on as it is a core thing like dynamic groups, only here for easy turning off in case someone forgets the object
aceHealObjectEnabled = true; //defaults to true
publicVariable "aceHealObjectEnabled";





/////////////////////////////////////
/////////initServer.sqf Code/////////
/////////////////////////////////////

//dynamic groups code
["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered

//automated (non-zeus) ace heal by Guac
//Instantly ace full heals all players within 100m
//requires object named AceHealObject in mission file
//for some reason doesn't work on flagpoles, perhaps the point where the action is attached to is at the top of the pole, too far away to count as close enough to show up for player?
if (aceHealObjectEnabled) then {
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
		0,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation, is JIP compatible
} else {
	systemChat "Ace Heal Object disabled.";
};

//Register TAS_globalTFAR as a function
if (TAS_globalTFAREnabled) then {
	TAS_fnc_globalTFAR = compile preprocessFile "Scripts\TAS_globalTFAR.sqf";
} else {
	systemChat "TAS Global TFAR System disabled."
};



//setup fob variables if fob system is enabled
if (FOBEnabled) then {
	//{ 
	//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
	//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
	fobBuilt = false;
	publicVariable "fobBuilt";
	rallyCmdUsed = false;
	publicVariable "rallyCmdUsed";
	rallyAlphaUsed = false;
	publicVariable "rallyAlphaUsed";
	rallyBravoUsed = false;
	publicVariable "rallyBravoUsed";
	rallyCharlieUsed = false;
	publicVariable "rallyCharlieUsed";
	rallyDeltaUsed = false;
	publicVariable "rallyDeltaUsed";
	rallyEchoUsed = false;
	publicVariable "rallyEchoUsed";
	rallyFoxtrotUsed = false;
	publicVariable "rallyFoxtrotUsed";
};
