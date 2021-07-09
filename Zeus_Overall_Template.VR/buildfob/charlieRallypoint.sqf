//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//14 instances of first letter uppercase, 1 instance of full word
//if (rallyCharlieUsed == nil) then {rallyCharlieUsed = false; publicVariable "rallyCharlieUsed";}; //if variable is nonexistant, create it (first time setup)
_nearestUnits = nearestObjects [player,["Man","Car","Tank"],150];//if enemies are within 150m, exit with fail message
_enemySides = playerSide call BIS_fnc_enemySides;
if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "Rallypoint creation failure, enemies are within 150m!"};
if (rallyCharlieUsed == false) then { "rallypointCharlieMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (rallyCharlieUsed == true) then { {deleteVehicle _x} forEach rallypointCharlie; rallypointCharlieRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
rallypointCharlieRespawn = [side player, getPos player, "Charlie Rallypoint"] call BIS_fnc_addRespawnPosition;
if (useSmallRally == false) then {
	rallypointCharlie = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	rallypointCharlie = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer
"rallypointCharlieMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];
rallyCharlieUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "rallyCharlieUsed"; //might be unneccessary