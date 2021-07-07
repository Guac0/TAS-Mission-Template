//scipt file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//11 instances of squad name to replace
//_nearestUnits = nearestObjects [player,["Man","Car","Tank"],150];//if enemies are within 150m, exit with fail message
//if ( { _x countSide _nearestUnits > 0 } forEach (player call BIS_fnc_enemySides); ) exitWith {systemChat "Rallypoint creation failire, enemies are within 150m!"};
if (alphaRallyUsed == false) then { "rallypointAlphaMarker" setMarkerAlpha 1; }; //first time rally is created, set its marker to visible
if (alphaRallyUsed == true) then { {deleteVehicle _x} forEach rallypoint_alpha; }; //if rallypoint already exists, delete it so the new one can be spawned
rallypoint_alpha = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the rallypoint composition
{_x setPos (getPos player);} forEach [rallypoint_alpha_respawn_blu,rallypoint_alpha_respawn_ind,rallypoint_alpha_respawn_opf]; //move the squad's respawn modules to the new rallypoint (must be placed in eden)
"rallypointAlphaMarker" setMarkerPos getPos player; //updates the rallypoint's position on map
[player, format ["Group rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["groupChat", group player];
alphaRallyUsed = true; //tell people that the squad's rally is used and so it must be deleted before being respawned
publicVariable "alphaRallyUsed"; //might be unneccessary