//dynamic groups code
if (TAS_dynamicGroupsEnabled) then {
	["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered
};

//If AceHealObject does not exist but options that require it are turned on, then display a warning that those options will be disabled
if ((isNil "AceHealObject") && (TAS_respawnArsenalGear || TAS_aceHealObjectEnabled || TAS_aceSpectateObjectEnabled)) then {
	systemchat "WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
	diag_log text "TAS-Mission-Template WARNING: You have turned on mission template options that require the AceHealObject to be present in your mission, but it does not exist! Disabling functions that require the heal object to be present...";
};

//debug info for presence of the resupply object if it is enabled
if (TAS_resupplyObjectEnabled) then {
	if ((isNil "CreateResupplyObject") || (isNil "ResupplySpawnHelper")) then {
		systemChat "WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
		diag_log text "TAS-Mission-Template WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
	};
};

//hold actions are locally applied in fn_applyHoldActions (executed from initPlayerLocal.sqf)

//several systems use TAS_respawnLocations so for simplicity let's just always have it be declared
if (isNil "TAS_respawnLocations") then { //mightve already been set up elsewhere
	TAS_respawnLocations = [];
	publicVariable "TAS_respawnLocations";
};

//setup fob variables if fob system is enabled
if (TAS_fobEnabled) then {
	//{ 
	//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
	//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
	TAS_fobBuilt = false;
	publicVariable "TAS_fobBuilt";
	TAS_fobDestroyed = false;
	publicVariable "TAS_fobDestroyed";

	if !(isNil "logistics_vehicle") then {	//do not do marker follow if fob vehicle is missing
		[logistics_vehicle,"hd_flag","ColorUNKNOWN","FOB Vehicle",true,5] spawn TAS_fnc_markerFollow; //TODO make this turn greyed out after FOB has been placed
	};
};

if (TAS_rallypointsEnabled) then {
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
	TAS_rallyGolfUsed = false;
	publicVariable "TAS_rallyGolfUsed";
	TAS_rallyHotelUsed = false;
	publicVariable "TAS_rallyHotelUsed";
	TAS_rallyReconUsed = false;
	publicVariable "TAS_rallyReconUsed";
	if (isNil "TAS_respawnLocations") then { //mightve already been set up elsewhere
		TAS_respawnLocations = [];
		publicVariable "TAS_respawnLocations";
	};
};

//show fps script by Mildly Interested/Bassbeard
//Code here is for main server, headless client is in init.sqf
if (TAS_fpsDisplayEnabled) then {
	[] spawn TAS_fnc_showFps;
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

if (TAS_waveRespawn) then {
	[] spawn TAS_fnc_waveRespawn;
};

if (TAS_3dGroupIcons) then {
	[] spawn TAS_fnc_autoDisableGroupIcons;
};

if (TAS_markCustomObjectsMap) then {
	[] spawn TAS_fnc_markCustomObjects;
};

if (TAS_scavSystemEnabled) then {
	[] spawn {
		sleep 1; //wait after map screen
		[] spawn TAS_fnc_scavServerInit;
	};
};

//at bottom because has sleep. NOTE: no longer needs to be at the bottom due to 'spawn' being added
if (TAS_respawnInVehicle) then {
	[] spawn { //spawn due to sleep. if not spawned, then the sleep will hold this up.
		TAS_respawnLocations = [];
		sleep 30; //should be enough time for waitUntil in object init fields to activate, plus extra time for zeus to manually configure a vic (not really enough time but didnt want to do too long so that testing it doesnt take too long)
		if (count TAS_respawnLocations == 0) then { //add fallback respawn vehicle if no other respawn vehicles are made
			if (isNil "logistics_vehicle") then {
				systemchat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
				diag_log text "TAS-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, and the fallback 'logistics vehicle' does not exist either!";
			} else {
				
				[logistics_vehicle,"Default Respawn Vehicle"] spawn TAS_fnc_assignRespawnVicInit;
				
				systemChat "WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
				diag_log text "TAS-Mission-Template WARNING: Respawn In Vehicle is enabled but no vehicles are set as respawn vehicles, adding 'logistics_vehicle' as a respawn vehicle as a fallback!";
			};
		};
		publicVariable "TAS_respawnLocations";
	};
};