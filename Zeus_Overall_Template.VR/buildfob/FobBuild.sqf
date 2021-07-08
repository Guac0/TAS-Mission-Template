//builds a fob with arsenals and repair boxes
//if (isNil fobBuilt) then {fobBuilt = false; publicVariable "fobBuilt";}; ////if variable is nonexistant, create it (first time setup)
if (fobBuilt == true) exitWith {systemChat "FOB already built!"}; //fail if fob has already been built
_nearestUnits = nearestObjects [player,["Man","Car","Tank"],300];//if enemies are within 150m, exit with fail message
_enemySides = playerSide call BIS_fnc_enemySides;
if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "FOB creation failure, enemies are within 300m!"};
if (fobBuilt == false) then { "fobMarker" setMarkerAlpha 1; }; //first time fob is created, set its marker to visible
FOB_objects = [getPos logistics_vehicle, getDir logistics_vehicle, call (compile (preprocessFileLineNumbers "buildfob\fobComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the fob composition
fobRespawn = [side player, getPos player, "FOB Respawn"] call BIS_fnc_addRespawnPosition;
"fobMarker" setMarkerPos getPos logistics_vehicle; //updates the rallypoint's position on map
_fobArsenals = nearestObjects [position logistics_vehicle, ["B_CargoNet_01_ammo_F"], 25]; //add arsenals to appropraite boxes
{ [_x, true] call ace_arsenal_fnc_initBox; ["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal; } forEach _fobArsenals;
[[blufor, "HQ"], format ["FOB established by %1 at gridref %2.", name player, mapGridPosition logistics_vehicle]] remoteExec ["sideChat", side player];
fobBuilt = true;
publicVariable "fobBuilt";