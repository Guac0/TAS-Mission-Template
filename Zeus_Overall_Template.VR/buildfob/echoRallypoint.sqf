//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyEchoUsed == nil) then {rallyEchoUsed = false; publicVariable "rallyEchoUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
_enemySides = [side player] call BIS_fnc_enemySides;
_radius = TAS_rallyDistance; //parameter from initServer.sqf, default 150
_nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
_nearEnemiesNumber = count _nearEnemies;

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};

if (TAS_rallyEchoUsed == false) then { "rallypointEchoMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyEchoUsed == true) then { {deleteVehicle _x} forEach TAS_rallypointEcho; TAS_rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
TAS_rallypointEchoRespawn = [side player, getPos player, "Echo Rallypoint"] call BIS_fnc_addRespawnPosition;

if (TAS_useSmallRally == false) then {
	TAS_rallypointEcho = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	TAS_rallypointEcho = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

"rallypointEchoMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];

TAS_rallyEchoUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyEchoUsed"; //might be unneccessary