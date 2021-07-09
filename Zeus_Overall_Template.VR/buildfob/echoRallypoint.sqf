//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//14 instances of first letter uppercase, 1 instance of full word
//if (rallyEchoUsed == nil) then {rallyEchoUsed = false; publicVariable "rallyEchoUsed";}; //if variable is nonexistant, create it (first time setup)
_nearestUnits = nearestObjects [player,["Man","Car","Tank"],150];//if enemies are within 150m, exit with fail message
_enemySides = playerSide call BIS_fnc_enemySides;
if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "Rallypoint creation failure, enemies are within 150m!"};
if (rallyEchoUsed == false) then { "rallypointEchoMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (rallyEchoUsed == true) then { {deleteVehicle _x} forEach rallypointEcho; rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
rallypointEchoRespawn = [side player, getPos player, "Echo Rallypoint"] call BIS_fnc_addRespawnPosition;
if (useSmallRally == false) then {
	rallypointEcho = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	rallypointEcho = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer
"rallypointEchoMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];
rallyEchoUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "rallyEchoUsed"; //might be unneccessary