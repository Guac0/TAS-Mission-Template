//TODO make function, fix teleporting into vehicle

disableSerialization;
private ["_respawnMode","_respawnLocations","_respawnGUI","_respawnLocationsNumber","_background","_button","_currentSpacing","_currentNestedIndex","_currentRespawnLocation","_currentRespawnLocationName"];

hint "Please close any displays (such as Arsenal) before being shown the respawn GUI!";
systemChat "Please close any displays (such as Arsenal) before being shown the respawn GUI!"; //this too because while in arsenal, hints are hidden
waitUntil {!(localNamespace getVariable ["TAS_aceArsenalOpen",false])}; //wait until ace arsenal is exited to avoid gui errors
//sleep 0.1; //wait for ace arsenal to fully exit
//waitUntil { isnull ( uinamespace getvariable "RSCDisplayArsenal" ) }; //wait until vanilla arsenal is exited, this (sometimes?) throws errors when in ace arsenal (returns nil), so do it after the ace arsenal check

hint "You are now being shown the respawn GUI. If unexpected behavior occurs (such as selecting an option but nothing occuring), contact Zeus.";
systemChat "You are now being shown the respawn GUI. If unexpected behavior occurs (such as selecting an option but nothing occuring), contact Zeus.";

_respawnMode = _this;
if (_respawnMode == "vehicle") then { _respawnLocations = TAS_respawnVehicles};
//_respawnLocations = _this select 1;
_respawnLocationsNumber = count _respawnLocations;
//create display for our controls
_respawnGui = findDisplay 46 createDisplay "RscDisplayEmpty"; //uses main screen as basis
uiNamespace setVariable ["TAS_respawnGUI", _respawnGui];	//to get around restrictions about disableSerialization in normal local variables

//Add pre defined buttons for each admin diary entry to be clicked on
//background
_background = _respawnGui ctrlCreate ["IGUIBack", -1];
_background ctrlSetPosition [0.25,0,0.5,0.11+(0.08*(_respawnLocationsNumber+1))]; //xywh
_background ctrlSetBackgroundColor [0,0,0,0.5]; //black
//_background ctrlSetBackgroundColor [1,0,0,0.5]; //red, duh
//_background ctrlSetBackgroundColor [0,1,1,0.5]; //cyan
_background ctrlCommit 0;

_menuInfoButton = _respawnGui ctrlCreate ["RscButton", -1]; 
_menuInfoButton ctrlSetPosition [0.275,0.03,0.45,0.05];
_menuInfoButton ctrlSetText ("Choose Your Respawn Location");
_menuInfoButton buttonSetAction 'systemChat "Hit one of the other buttons that actually does something, not the title card!"';
_menuInfoButton ctrlCommit 0;

//sample data: TAS_respawnVehicles = [[vic1,"Respawn Vic 1"],[vic2,"Respawn Vic 2"],[vic3,"Respawn Vic 3"]];
TAS_inRespawnMenu = true;
_currentSpacing = 1;
for "_i" from 0 to (_respawnLocationsNumber - 1) do { //-1 to account for zero-based arrays
	_currentNestedIndex = _respawnLocations select _i;
	_currentRespawnLocation = _currentNestedIndex select 0;
	_currentRespawnLocationName = _currentNestedIndex select 1;
	if ("TAS_zeus" in str _currentRespawnLocation) then {
		_currentRespawnLocation = format ["var_%1",_currentRespawnLocation];
	};
	if (typeName _currentRespawnLocation == "STRING") then { //translate from string to object if set by the zeus module or other method that sets vehicleVarName during runtime instead of via eden editor var name field
		_currentRespawnLocation = missionNamespace getVariable [_currentRespawnLocation,objNull];
	};
	if (!isNull _currentRespawnLocation) then {
		if (alive _currentRespawnLocation) then {
			_button = _respawnGui ctrlCreate ["RscButton", -1]; 
			_button ctrlSetPosition [0.275,0.03 + 0.08 * _currentSpacing,0.45,0.05];
			switch (_respawnMode) do {
				case "vehicle": {
					_button ctrlSetText format ["Respawn in %1",_currentRespawnLocationName];
					_button buttonSetAction format [ //TODO add side compat //if ((side player != side group %1) && (side group %1 != sideUnknown )) exitWith {hint 'Targetted respawn vehicle is under the control of another side!'; systemChat 'Targetted respawn vehicle is under the control of another side!`};
						"if (%1 emptyPositions 'cargo' == 0) exitWith {hint 'Passenger seats of targetted respawn vehicle are full!'; systemChat 'Passenger seats of targetted respawn vehicle are full!'}; player moveInCargo %1; (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",
						_currentRespawnLocation
					]; /*'(uiNamespace getVariable ["TAS_respawnGUI",displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;'*/ //player moveInCargo _currentRespawnLocation
				};
				case "rallypoint": {
					_button ctrlSetText format ["Respawn at %1",_currentRespawnLocationName];
					_button buttonSetAction format ["player setPosAsl (getPosAsl %1); (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",_currentRespawnLocation];
				};
				default {
					_button ctrlSetText format ["Respawn at %1",_currentRespawnLocationName];
					_button buttonSetAction format ["player setPosAsl (getPosAsl %1); (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",_currentRespawnLocation];
				};
			};
			_button ctrlCommit 0;
			_currentSpacing = _currentSpacing + 1;
		};
	};
};

_escapeButton = _respawnGui ctrlCreate ["RscButton", -1]; 
_escapeButton ctrlSetPosition [0.275,0.03 + 0.08 * _currentSpacing,0.45,0.05];
_escapeButton ctrlSetText ("[DEBUG] Exit Respawn GUI (Cannot Reopen!!!)");
_escapeButton buttonSetAction "(uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;";
_escapeButton ctrlCommit 0;

//systemChat "starting loop";
while {TAS_inRespawnMenu} do { //respawn the menu if player closes it without picking an option
	if (isNull _respawnGui) then {
		//systemChat "re-activiating display";
		
		//create display for our controls
		_respawnGui = findDisplay 46 createDisplay "RscDisplayEmpty"; //uses main screen as basis
		uiNamespace setVariable ["TAS_respawnGUI", _respawnGui];	//to get around restrictions about disableSerialization in normal local variables

		//Add pre defined buttons for each admin diary entry to be clicked on
		//background
		_background = _respawnGui ctrlCreate ["IGUIBack", -1];
		_background ctrlSetPosition [0.25,0,0.5,0.11+(0.08*(_respawnLocationsNumber+1))]; //xywh
		_background ctrlSetBackgroundColor [0,0,0,0.5]; //black
		//_background ctrlSetBackgroundColor [1,0,0,0.5]; //red, duh
		//_background ctrlSetBackgroundColor [0,1,1,0.5]; //cyan
		_background ctrlCommit 0;

		_menuInfoButton = _respawnGui ctrlCreate ["RscButton", -1]; 
		_menuInfoButton ctrlSetPosition [0.275,0.03,0.45,0.05];
		_menuInfoButton ctrlSetText ("Choose Your Respawn Location");
		_menuInfoButton buttonSetAction 'systemChat "Hit one of the other buttons that actually does something, not the title card!"';
		_menuInfoButton ctrlCommit 0;

		//sample data: TAS_respawnVehicles = [[vic1,"Respawn Vic 1"],[vic2,"Respawn Vic 2"],[vic3,"Respawn Vic 3"]];
		TAS_inRespawnMenu = true;
		_currentSpacing = 1;
		for "_i" from 0 to (_respawnLocationsNumber - 1) do { //-1 to account for zero-based arrays
			_currentNestedIndex = _respawnLocations select _i;
			_currentRespawnLocation = _currentNestedIndex select 0;
			_currentRespawnLocationName = _currentNestedIndex select 1;
			if (!isNull _currentRespawnLocation) then {
				if (alive _currentRespawnLocation) then {
					_button = _respawnGui ctrlCreate ["RscButton", -1]; 
					_button ctrlSetPosition [0.275,0.03 + 0.08 * _currentSpacing,0.45,0.05];
					switch (_respawnMode) do {
						case "vehicle": {
							_button ctrlSetText format ["Respawn in %1",_currentRespawnLocationName];
							_button buttonSetAction format [
								"if (%1 emptyPositions 'cargo' == 0) exitWith {hint 'Passenger seats of targetted respawn vehicle are full!'; systemChat 'Passenger seats of targetted respawn vehicle are full!'}; player moveInCargo %1; (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",
								_currentRespawnLocation
							]; /*'(uiNamespace getVariable ["TAS_respawnGUI",displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;'*/ //player moveInCargo _currentRespawnLocation
						};
						case "rallypoint": {
							_button ctrlSetText format ["Respawn at %1",_currentRespawnLocationName];
							_button buttonSetAction format ["player setPosAsl (getPosAsl %1); (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",_currentRespawnLocation];
						};
						default {
							_button ctrlSetText format ["Respawn at %1",_currentRespawnLocationName];
							_button buttonSetAction format ["player setPosAsl (getPosAsl %1); (uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;",_currentRespawnLocation];
						};
					};
					_button ctrlCommit 0;
					_currentSpacing = _currentSpacing + 1;
				};
			};
		};

		_escapeButton = _respawnGui ctrlCreate ["RscButton", -1]; 
		_escapeButton ctrlSetPosition [0.275,0.03 + 0.08 * _currentSpacing,0.45,0.05];
		_escapeButton ctrlSetText ("[DEBUG] Exit Respawn GUI (Cannot Reopen!!!)");
		_escapeButton buttonSetAction "(uiNamespace getVariable ['TAS_respawnGUI',displayNull]) closeDisplay 1; TAS_inRespawnMenu = false;";
		_escapeButton ctrlCommit 0;
	};
	sleep 0.25;
};
//systemChat "ending loop";

//add respawn position
/*
if (isServer) then {
	this spawn {
		waitUntil {!isNil "TAS_respawnInVehicle"};
		if (TAS_respawnInVehicle) then {
			waitUntil {!isNil "TAS_respawnVehicles"};
			TAS_respawnVehicles pushBack [_this,"Respawn Vehicle 1"];
			publicVariable "TAS_respawnVehicles";
		};
	};
};
*/

hintSilent ""; //clear hint