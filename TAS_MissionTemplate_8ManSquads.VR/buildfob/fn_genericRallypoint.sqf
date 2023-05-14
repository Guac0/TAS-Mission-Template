//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//_nearEntities = _sourceUnit nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = _sourceUnit countEnemy _nearEntities;
private _debug = false;

params ["_sourceUnit","_rallyName","_markerVarName"];
if (_debug) then {
	systemChat str _this;
};
private _friendlySide 			= side group _sourceUnit;
private _enemySides 			= [_friendlySide] call BIS_fnc_enemySides;
private _radius 				= TAS_rallyDistance; //parameter from initServer.sqf, default 150
private _nearUnits 				= allUnits select { _x distance _sourceUnit < _radius };
private _nearEnemies 			= _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
private _nearEnemiesNumber 		= count _nearEnemies;
private _nearFriendlies 		= _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
private _nearFriendliesNumber 	= count _nearFriendlies;
private _rallypointPosATL 		= getPosAtl _sourceUnit;
private _rallyObjArray 			= missionNamespace getVariable [_rallyName,nil];
private _groupName				= groupId group _sourceUnit;

if (_debug) then {
	systemChat "a";
	systemChat "_rallyObjArray";
};

private _exit = false;
if (TAS_rallyOutnumber) then {
	if ( _nearEnemiesNumber > _nearFriendliesNumber) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies outnumber friendlies within %1m!",TAS_rallyDistance]};
} else {
	if ( _nearEnemiesNumber > 0 ) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};
};
if (_exit) exitWith {};

if (isNil "_rallyObjArray") then {
	_markerVarName setMarkerAlpha 1; //first time rally is created, set its marker to visible
} else {
	if (isNull (_rallyObjArray select 0)) then {
		if (_debug) then {
			systemChat "a1";
		};
		_markerVarName setMarkerAlpha 1; //if rally destroyed but remaking it, then redo the color
	} else {
		if (_debug) then {
			systemChat "a2";
		};
		{deleteVehicle _x} forEach _rallyObjArray;
		//TAS_rallypointCmdRespawn call BIS_fnc_removeRespawnPosition;
		private _path = [TAS_respawnLocations, _rallyName] call BIS_fnc_findNestedElement;
		private _indexOfOldRallyPair = _path select 0;
		TAS_respawnLocations deleteAt _indexOfOldRallyPair;
	};
}; //if rallypoint already exists, delete it so the new one can be spawned

if (_debug) then {
	systemChat "b";
};

//TAS_rallypointCmdRespawn = [side _sourceUnit, getPos _sourceUnit, "Cmd Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
TAS_respawnLocations pushBack [_rallypointPosATL,_rallyName,_groupName];
publicVariable "TAS_respawnLocations";
_markerVarName setMarkerPosLocal getPos _sourceUnit; //updates the rallypoint's position on map
private _color = "Default";
switch (_friendlySide) do {
	case west: 			{ _color = "colorBLUFOR" 		};
	case east: 			{ _color = "colorOPFOR" 		};
	case independent: 	{ _color = "colorIndependent" 	};
	case civilian: 		{ _color = "colorCivilian" 		};
	default 			{ _color = "colorCivilian" 		};
};
_markerVarName setMarkerColorLocal _color;	//last marker command is public
_markerVarName setMarkerText format ["%1 Rallypoint",_groupName];

if (TAS_useSmallRally == false) then {
	_rallyObjArray = [getPos _sourceUnit, getDir _sourceUnit, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	_rallyObjArray = [getPos _sourceUnit, getDir _sourceUnit, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer
missionNamespace setVariable [_rallyName,_rallyObjArray,true];

[_sourceUnit, format ["%1 Rallypoint established by %2 at gridref %3.", _groupName, name _sourceUnit, mapGridPosition _sourceUnit]] remoteExec ["sideChat", _friendlySide]; //tell everyone on same side about it

if (_debug) then {
	systemChat "c";
};

//systemChat "0";

if (TAS_rallypointOverrun) then {
	[_friendlySide,_enemySides,_radius,_nearEnemies,_nearFriendlies,_nearEnemiesNumber,_nearFriendliesNumber,_rallypointPosATL,_rallyObjArray,_rallyName,_markerVarName] remoteExec ["TAS_fnc_genericRallyOverrun",2]; //run overrun on server to avoid issues with FPS or client disconnect
};

if (_debug) then {
	systemChat "d";
};