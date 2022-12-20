//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyHotelUsed == nil) then {rallyHotelUsed = false; publicVariable "rallyHotelUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _enemySides = [side player] call BIS_fnc_enemySides;
private _radius = TAS_rallyDistance; //parameter from initServer.sqf, default 150
private _nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
private _nearFriendlies = allUnits select {_x distance player < _radius AND side _x == playerSide}; //Note: playerSide will not update if player joins group on another side
private _nearEnemiesNumber = count _nearEnemies;
private _nearFriendliesNumber = count _nearFriendlies;
private _playerSide = side group player;

private _exit = false;
if (TAS_rallyOutnumber) then {
	if ( _nearEnemiesNumber > _nearFriendliesNumber) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies outnumber friendleis within %1m!",TAS_rallyDistance]};
} else {
	if ( _nearEnemiesNumber > 0 ) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};
};
if (_exit) exitWith {};

if (TAS_rallyHotelUsed == false) then { "rallypointHotelMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyHotelUsed == true) then {
	{deleteVehicle _x} forEach TAS_rallypointHotel;
	//TAS_rallypointHotelRespawn call BIS_fnc_removeRespawnPosition;
	private _path = [TAS_rallypointLocations, "Hotel Rallypoint"] call BIS_fnc_findNestedElement;
	private _indexOfOldRallyPair = _path select 0;
	TAS_rallypointLocations deleteAt _indexOfOldRallyPair;
}; //if rallypoint already exists, delete it so the new one can be spawned

//TAS_rallypointHotelRespawn = [side player, getPos player, "Hotel Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
TAS_rallypointLocations pushBack [getPosAtl player,"Hotel Rallypoint"];
publicVariable "TAS_rallypointLocations";
"rallypointHotelMarker" setMarkerPos getPos player; //updates the rallypoint's position on map

if (TAS_useSmallRally == false) then {
	TAS_rallypointHotel = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	TAS_rallypointHotel = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

[player, format ["Hotel rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["sideChat", _playerSide]; //tell everyone on same side about it

TAS_rallyHotelUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyHotelUsed"; //might be unneccessary since only 1 person can be SL so don't need public, just exist on SL's machine
										//might also need TAS_rallypointHotelRespawn and TAS_rallypointHotel to be public for functionality in case SL disconnects and is replaced
											//for now, keep local to current SL machine since it's an edge case and would use up much bandwidth to publicVariable