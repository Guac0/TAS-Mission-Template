if (fobBuilt == true) exitWith {systemChat "FOB already built!"};
if (fobBuilt == false) then { "fobMarker" setMarkerAlpha 1; }; //first time rally is created, set its marker to visible
FOB_objects = [getPos logistics_vehicle, getDir logistics_vehicle, call (compile (preprocessFileLineNumbers "buildfob\fobComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the fob composition
{_x setPos (getPos logistics_vehicle);} forEach [fob_respawn_blu,fob_respawn_ind,fob_respawn_opf]; //move the fob's respawn modules to the new rallypoint (must be placed in eden)
"fobMarker" setMarkerPos getPos logistics_vehicle; //updates the rallypoint's position on map
_fobArsenals = nearestObjects [position logistics_vehicle, ["B_CargoNet_01_ammo_F"], 25]; //add arsenals to appropraite boxes
{ [_x, true] call ace_arsenal_fnc_initBox; ["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal; } forEach _fobArsenals;
[[blufor, "HQ"], format ["FOB established by %1 at gridref %2.", name player, mapGridPosition logistics_vehicle]] remoteExec ["sideChat", side player];
fobBuilt = true;
publicVariable "fobBuilt";