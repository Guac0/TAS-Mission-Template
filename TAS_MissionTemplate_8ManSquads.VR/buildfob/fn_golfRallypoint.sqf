//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyGolfUsed == nil) then {rallyGolfUsed = false; publicVariable "rallyGolfUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _friendlySide 			= side group player;
private _enemySides 			= [_friendlySide] call BIS_fnc_enemySides;
private _radius 				= TAS_rallyDistance; //parameter from initServer.sqf, default 150
private _nearUnits = allUnits select { _x distance player < _radius };
private _nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
private _nearEnemiesNumber = count _nearEnemies;
private _nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
private _nearFriendliesNumber = count _nearFriendlies;
private _rallypointPosATL 		= getPosAtl player;

private _exit = false;
if (TAS_rallyOutnumber) then {
	if ( _nearEnemiesNumber > _nearFriendliesNumber) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies outnumber friendlies within %1m!",TAS_rallyDistance]};
} else {
	if ( _nearEnemiesNumber > 0 ) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};
};
if (_exit) exitWith {};

if (TAS_rallyGolfUsed == false) then { "rallypointGolfMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyGolfUsed == true) then {
	{deleteVehicle _x} forEach TAS_rallypointGolf;
	//TAS_rallypointGolfRespawn call BIS_fnc_removeRespawnPosition;
	private _path = [TAS_respawnLocations, "Golf Rallypoint"] call BIS_fnc_findNestedElement;
	private _indexOfOldRallyPair = _path select 0;
	TAS_respawnLocations deleteAt _indexOfOldRallyPair;
}; //if rallypoint already exists, delete it so the new one can be spawned

//TAS_rallypointGolfRespawn = [side player, getPos player, "Golf Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
TAS_respawnLocations pushBack [_rallypointPosATL,"Golf Rallypoint"];
publicVariable "TAS_respawnLocations";
"rallypointGolfMarker" setMarkerPosLocal getPos player; //updates the rallypoint's position on map
private _color = "Default";
switch (_friendlySide) do {
	case west: { _color = "colorBLUFOR" };
	case east: { _color = "colorOPFOR" };
	case independent: { _color = "colorIndependent" };
	case civilian: { _color = "colorCivilian" };
	default { _color = "colorCivilian" };
};
"rallypointGolfMarker" setMarkerColorLocal _color;	//last marker command is public
"rallypointGolfMarker" setMarkerText format ["%1 Rallypoint",groupId group player];

if (TAS_useSmallRally == false) then {
	TAS_rallypointGolf = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	TAS_rallypointGolf = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

[player, format ["%1 Rallypoint established by %2 at gridref %3.", groupId group player, name player, mapGridPosition player]] remoteExec ["sideChat", _friendlySide]; //tell everyone on same side about it

TAS_rallyGolfUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyGolfUsed"; //might be unneccessary since only 1 person can be SL so don't need public, just exist on SL's machine
										//might also need TAS_rallypointGolfRespawn and TAS_rallypointGolf to be public for functionality in case SL disconnects and is replaced
											//for now, keep local to current SL machine since it's an edge case and would use up much bandwidth to publicVariable

//systemChat "0";

if (TAS_rallypointOverrun) then {
	[_friendlySide,_enemySides,_radius,_nearEnemies,_nearFriendlies,_nearEnemiesNumber,_nearFriendliesNumber,_rallypointPosATL] remoteExec ["TAS_fnc_GolfRallyOverrun",2]; //run overrun on server to avoid issues with FPS or client disconnect
};
