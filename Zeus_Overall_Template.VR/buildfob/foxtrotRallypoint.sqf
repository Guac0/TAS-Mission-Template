//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyFoxtrotUsed == nil) then {rallyFoxtrotUsed = false; publicVariable "rallyFoxtrotUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
_enemySides = [side player] call BIS_fnc_enemySides;
_radius = TAS_rallyDistance; //parameter from initServer.sqf, default 150
_nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
_nearEnemiesNumber = count _nearEnemies;

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};

if (TAS_rallyFoxtrotUsed == false) then { "rallypointFoxtrotMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyFoxtrotUsed == true) then { {deleteVehicle _x} forEach TAS_rallypointFoxtrot; TAS_rallypointFoxtrotRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
TAS_rallypointFoxtrotRespawn = [side player, getPos player, "Foxtrot Rallypoint"] call BIS_fnc_addRespawnPosition;

if (TAS_useSmallRally == false) then {
	TAS_rallypointFoxtrot = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	TAS_rallypointFoxtrot = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

"rallypointFoxtrotMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];

TAS_rallyFoxtrotUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyFoxtrotUsed"; //might be unneccessary