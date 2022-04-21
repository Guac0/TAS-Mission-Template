//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyFoxtrotUsed == nil) then {rallyFoxtrotUsed = false; publicVariable "rallyFoxtrotUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _enemySides = [side player] call BIS_fnc_enemySides;
private _radius = TAS_rallyDistance; //parameter from initServer.sqf, default 150
private _nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
private _nearEnemiesNumber = count _nearEnemies;
private _playerSide = side group player;

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};

if (TAS_rallyFoxtrotUsed == false) then { "rallypointFoxtrotMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyFoxtrotUsed == true) then { {deleteVehicle _x} forEach TAS_rallypointFoxtrot; TAS_rallypointFoxtrotRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
TAS_rallypointFoxtrotRespawn = [side player, getPos player, "Foxtrot Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
"rallypointFoxtrotMarker" setMarkerPos getPos player; //updates the rallypoint's position on map

if (TAS_useSmallRally == false) then {
	TAS_rallypointFoxtrot = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	TAS_rallypointFoxtrot = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

[player, format ["Foxtrot rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["sideChat", _playerSide]; //tell everyone on same side about it

TAS_rallyFoxtrotUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyFoxtrotUsed"; //might be unneccessary since only 1 person can be SL so don't need public, just exist on SL's machine
										//might also need TAS_rallypointFoxtrotRespawn and TAS_rallypointFoxtrot to be public for functionality in case SL disconnects and is replaced
											//for now, keep local to current SL machine since it's an edge case and would use up much bandwidth to publicVariable
