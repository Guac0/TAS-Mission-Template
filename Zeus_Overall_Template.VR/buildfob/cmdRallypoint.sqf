//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//14 instances of first letter uppercase, 1 instance of full word
//if (rallyCmdUsed == nil) then {rallyCmdUsed = false; publicVariable "rallyCmdUsed";}; //if variable is nonexistant, create it (first time setup)
if ( player countEnemy nearestObjects [player,["Man","Car","Tank"],150] > 0 ) exitWith {systemChat "Rallypoint creation failure, enemies are within 150m!"};
if (rallyCmdUsed == false) then { "rallypointCmdMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (rallyCmdUsed == true) then { {deleteVehicle _x} forEach rallypointCmd; rallypointCmdRespawn call BIS_fnc_removeRespawnPosition;}; //if rallypoint already exists, delete it so the new one can be spawned
rallypointCmdRespawn = [side player, getPos player, "Command Rallypoint"] call BIS_fnc_addRespawnPosition;
if (useSmallRally == false) then {
	rallypointCmd = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper;
} else {
	rallypointCmd = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer
"rallypointCmdMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];
rallyCmdUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "rallyCmdUsed"; //might be unneccessary