//do not touch
TAS_templateVersion = "v9.0.0";
publicVariable "TAS_templateVersion";
//you can now proceed to touch things (below this line, that is)

///////////////////////////////////////////
////////////Mission Maker Options//////////
///////////////////////////////////////////



//////////////////////////////////
/////Scripts/Functions Options////
//////////////////////////////////

//Cleans the mission template briefing by removing diary records for options set to FALSE
TAS_cleanBriefing = true; //default true
publicVariable "TAS_cleanBriefing";

//turn afk script on/off
//Required mods: CBA
TAS_afkEnabled = true; //set to false to disable AFK script from being added
publicVariable "TAS_afkEnabled"; //don't touch any of the publicVariable lines

//turn earplugs script on/off
TAS_earplugsEnabled = true; //default true
TAS_earplugVolume = 0.25; //volume to reduce to when earplugs are in (0 is no volume, 1 is regular). Applies to fadeSound, fadeRadio, fadeSpeech, fadeMusic, and fadeEnvironment.
publicVariable "TAS_earplugsEnabled";
publicVariable "TAS_earplugVolume";

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

//possibly broken, effects are small if any
//Modifies weapon sway (well, aim precison) coefficient and recoil coefficient. 1 is normal, 0 is nothing (but don't use 0, use 0.1)
TAS_doCoefChanges = false; 	//default false
TAS_aimCoef 	  = 0.5;	//default 0.5; no effect if TAS_doCoefChanges is FALSE
TAS_recoilCoef 	  = 0.75;	//default 0.75; no effect if TAS_doCoefChanges is FALSE
publicVariable "TAS_doAimCoefChange";
publicVariable "TAS_aimCoef";
publicVariable "TAS_recoilCoef";

//tfar radio assignment init, for SL LR backpack assignment needs SLs to have the preset variable names for SLs(see template)
//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
//Required Mods: TFAR
TAS_radiosEnabled = true; //defaults to true
TAS_NoSquadleadLr = true; //default true. Set to true if you want to use radiomen instead of SLs having the LR backpacks by default (radiomen must have "Radioman" or "RTO" as their role description to be given the backpack)
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

//Assigns player loadouts via config
//It looks at the config files for the given faction and tries to match each player's Role Description with the name of a unit from that faction. If found, it gives them that unit's loadout, if not found, it gives them a Rifleman loadout from that faction
//Note that the actualy inventory items (stuff in uniform and vest and etc) of the player will be overwritten by TAS_populateInventory if that is enabled, but this will still set the clothing, weapons, etc
//To disable loadout assignment on a given unit while keeping the system enabled for other units, place the following in its init box: this setVariable ["TAS_disableConfigLoadoutAssignment",true];
//You can also manually set the loadout names if you don't want it to autodetermine based on the role description. To do this, put the following lines into the init box of the unit:
	//this setVariable ["TAS_overrideConfigLoadout",true];
	//this setVariable ["TAS_overrideConfigLoadoutName","Display name of unit in given faction whose loadout should be given to this player"];
TAS_useConfigLoadout = false; 		//default false
TAS_configFaction = "BLU_F"; 		//you can find the config name by placing a unit, right click, log, log faction classname to clipboard
TAS_defaultConfigUnit = "Rifleman"; //if role description doesn't match any unit in the faction, it falls back to this unit name for the loadout assignment
TAS_configLoadoutNumber = 0; 		//Advanced users only. When multiple loadouts are found, use the # loadout found (zero-based)
publicVariable "TAS_useConfigLoadout";
publicVariable "TAS_configFaction";
publicVariable "TAS_defaultConfigUnit";
publicVariable "TAS_configLoadoutNumber";

//Automatically gives appropriate inventory items to players, loosely based on class. Clears eden inventory (but doesnt change clothing or weapons)
//Medical: 16x basic bandages, 8x morphine, 3x TQs, 2x epi, 2x 500ml blood
	//If medic, extra 40 basic bandages, 20 morphine, 15 epi, 6 TQs, 10x 500 ml blood, 6x 1000ml blood, 1x PAK
//Ammo: 4x standard primary mags, 4x special mags, 2x pistol mags (if have pistol), 2x launcher mags (if have launcher)
//Misc: 1x entrenching tool
//Grenades: 2x M67s, 2x white smoke, 1x purple smoke
//If engineer, gives 1x toolkit, 1x mine detector
TAS_populateInventory = true; //default true
publicVariable "TAS_populateInventory";

//Removes certain problematic items from arsenal boxes that are otherwise hidden and unremoveable (boxes names must be arsenal_# from 1 to 10, template already gives you 1-3 premade and you can just copy paste those)
//See initPlayer for full list, but this is things like doomsday, hidden brightlights, etc
TAS_arsenalCurate = true; //defaults to true
publicVariable "TAS_arsenalCurate";



//////////////////////////////////
//Respawns and Logistics Options//
//////////////////////////////////



//This script adds a custom system for respawning in a forward logistics vehicle
//Requires a vehicle named "logistics_vehicle" in your mission (recommend that it is also invincible)
//After respawning, this forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being TPed to the respawn vic
//Required Mods: ACE
/*add a respawn vehicle with the following in the vehicle init field (give the vehicle a variable name, any name works). Change "Respawn Vehicle 1" to whatever, just keep the quotes. NOTE: If you name things 1, 2, 3, there's no guarentee what order they show up in.
if (isServer) then {
	this spawn {
		waitUntil {!isNil "TAS_respawnInVehicle"};
		if (TAS_respawnInVehicle) then {
			waitUntil {!isNil "TAS_respawnVehicles"};
			TAS_respawnVehicles pushBack [_this,"Respawn Vehicle 1"];
			[_this,"hd_flag","ColorUNKNOWN","Respawn Vehicle 1",true,60] call TAS_fnc_followMarker;
			publicVariable "TAS_respawnVehicles";
		};
	};
};
*/
TAS_respawnInVehicle = false; //default false
TAS_respawnInVehicleTime = 50; //default 50, note that this is in addition to the respawn timer
publicVariable "TAS_respawnInVehicle";
publicVariable "TAS_respawnInVehicleTime";

//Choose between respawning with config loadout (default in vanilla, not recommended. set both options to false to pick this option), respawning with gear you had when you died, and respawning with gear that you preset at the arsenal
//for TAS_respawnArsenalGear, loadout is saved whenever the player exits the (ace) arsenal, and there's also an option to manually save your loadout at the AceHealObject
TAS_respawnDeathGear = false; //default false --- DO NOT SET BOTH respawnDeathGear AND respawnArsenalGear to true!!!
TAS_respawnArsenalGear = true; //default true
publicVariable "TAS_respawnDeathGear";
publicVariable "TAS_respawnArsenalGear";

//Adds an "Create Resupply Box" action to a whiteboard that spawns the zeus resupply box on the jump target object.
//Useful for allowing players to run logi without zeus intervention to create resupply box.
//Needs the "Create Resupply Box" whiteboard and "Resupply Spawn Helper" parachute jump target from mission.sqm to work
TAS_resupplyObjectEnabled = true; //default true
publicVariable "TAS_resupplyObjectEnabled";

//FEATURE TEMP REMOVED
//Enables the KP crate filler script, see "KPCF_config" for options 
//NOTE: With default settings, it will add custom behavior to ALL "Land Parachute Target" and "Seismic Map (Whiteboard)" objects in your mission. Disable this setting or change the target objects in KPCF_config if you are using those objects in your mission.
//TAS_kpCratefiller = true;	//default true
//publicVariable "TAS_kpCratefiller";

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
TAS_rallyRespawnTime = 50; //how long to make players wait before being able to TP to rallypoint
TAS_rallyOutnumber = true; //default true. TRUE makes it so rallypoints are canceled if there are more enemies (units in BIS_enemySides) than friendlies (units of same same as player) in the radius. False cancels rallypoint creation if there are ANY enemies within the radius
publicVariable "TAS_fobEnabled";
publicVariable "TAS_fobFullArsenals";
publicVariable "TAS_fobDistance";
publicVariable "TAS_useSmallRally";
publicVariable "TAS_rallyDistance";
publicVariable "TAS_rallyRespawnTime";
publicVariable "TAS_rallyOutnumber";



//to add a custom fortify preset, go to description.ext and follow the instructions there



//////////////////////////////////
//////////Zeus Options///////////
//////////////////////////////////

//Adds two custom resupply modules to Zeus
//Each has 6 magazines of each player's weapon and a bunch of medical
//One spawns the crate at cursor location, other paradrops it (watch for wind!)
//Find the modules under the "Resupply" section in Zeus
//Required Mods: ZEN
TAS_zeusResupply = true; //default true
publicVariable "TAS_zeusResupply";

//Adds zeus module to play info text
TAS_zeusInfoText = true; //default true
publicVariable "TAS_zeusInfoText";

//Adds zeus modules for manually managing group ownership
TAS_zeusHcTransfer = true;
publicVariable "TAS_zeusHcTransfer";



//////////////////////////////////
//////////Admin Options///////////
//////////////////////////////////
//these options are more geared towards logging or other admin actions and should be left at their defaults unless you know what you're doing 



//logging information for certain mods, with optional chat messages
TAS_ModLog 		= true;	//default true
TAS_ModLogShame = true; //default true
publicVariable "TAS_ModLog";
publicVariable "TAS_ModLogShame";



///////////////////////////////////////////
//////initServer.sqf Code, don't touch/////
///////////////////////////////////////////



if (TAS_respawnInVehicle) then {
	TAS_respawnVehicles = [];
	sleep 3; //should be enough time for waitUntil in object init fields to activate
	if (count TAS_respawnVehicles == 0) then { //add fallback respawn vehicle if no other respawn vehicles are made
		if (isNil "logistics_vehicle") then {
			systemchat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
			diag_log text "TAS-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
		} else {
			[logistics_vehicle,"hd_flag","ColorUNKNOWN","Default Respawn Vehicle",true,60] call TAS_fnc_followMarker;
			TAS_respawnVehicles pushBack [logistics_vehicle,"Default Respawn Vehicle"];
			systemChat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
			diag_log text "TAS-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
		};
	};
	publicVariable "TAS_respawnVehicles";
};

//dynamic groups code
if (TAS_dynamicGroupsEnabled) then {
	["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered
};

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
			"Manually Save Loadout",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ private _loadout = [player] call CBA_fnc_getLoadout; player setVariable ["TAS_arsenalLoadout",_loadout]; },												// Code executed on completion
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
			{[ResupplySpawnHelper,false,true,false,true,true,"B_CargoNet_01_ammo_F",250] call TAS_fnc_AmmoCrate;},													// Code executed on completion
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
/*if (TAS_globalTFAREnabled) then {
	//TAS_fnc_globalTFAR = compile preprocessFile "scripts\TAS_globalTFAR.sqf";
	//systemChat "TAS Global TFAR System enabled (server debug).";
} else {
	//systemChat "TAS Global TFAR System disabled (server debug).";
};*/

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
	TAS_rallypointLocations = [];
	publicVariable "TAS_rallypointLocations";
};

//show fps script by Mildly Interested/Bassbeard
//Code here is for main server, headless client is in init.sqf
if (TAS_fpsDisplayEnabled) then {
	[] execVM "functions\scripts\show_fps.sqf";
	diag_log text "TAS-Mission-Template --------------------[Executed show_fps on Server]--------------------"; //will show in server logs
};

//handle radio settings broadcast
/*TAS_radioSettings = [];
{
	private _addToArray = _x;
	if (_x == true) then {_addToArray = 1};
	if (_x == false) then {_addToArray = 0};
	TAS_radioSettings pushBack _x;
} forEach [TAS_radiosEnabled,TAS_NoSquadleadLr,TAS_radioAdditionals,TAS_radioPersonal,TAS_radioBackpack];
publicVariable TAS_radioSettings;

//handle fob settings broadcast
TAS_fobSettings = [];
{
	private _addToArray = _x;
	if (_x == true) then {_addToArray = 1};
	if (_x == false) then {_addToArray = 0};
	TAS_fobSettings pushBack _x;
} forEach [TAS_fobEnabled,TAS_fobFullArsenals,TAS_fobDistance,TAS_useSmallRally,TAS_rallyDistance];
publicVariable TAS_fobSettings;*/