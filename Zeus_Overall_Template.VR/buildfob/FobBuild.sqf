//builds a fob with arsenals and repair boxes
//if (isNil fobBuilt) then {fobBuilt = false; publicVariable "fobBuilt";}; ////if variable is nonexistant, create it (first time setup)

if (TAS_fobBuilt == true) exitWith {systemChat "FOB already built!"}; //fail if fob has already been built

//_nearestUnits = nearestObjects [player,["Man","Car","Tank"],300];//if enemies are within 150m, exit with fail message
//_enemySides = playerSide call BIS_fnc_enemySides;
//if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "FOB creation failure, enemies are within 300m!"};
//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
_enemySides = [side player] call BIS_fnc_enemySides;
_radius = 300;
_nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
_nearEnemiesNumber = count _nearEnemies;

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat "FOB creation failure, enemies are within 300m!"};

if (TAS_fobBuilt == false) then { "fobMarker" setMarkerAlpha 1; }; //first time fob is created, set its marker to visible

FOB_objects = [getPos logistics_vehicle, getDir logistics_vehicle, call (compile (preprocessFileLineNumbers "buildfob\fobComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the fob composition
_fobArsenals = nearestObjects [position logistics_vehicle, ["B_CargoNet_01_ammo_F"], 25]; //add unlimited arsenals to appropraite boxes, maybe change
{ [_x, true] call ace_arsenal_fnc_initBox; ["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal; } forEach _fobArsenals;

fobRespawn = [side player, getPos player, "FOB Respawn"] call BIS_fnc_addRespawnPosition;
"fobMarker" setMarkerPos getPos logistics_vehicle; //updates the rallypoint's position on map

[[blufor, "HQ"], format ["FOB established by %1 at gridref %2.", name player, mapGridPosition logistics_vehicle]] remoteExec ["sideChat", side player];
TAS_fobBuilt = true;
publicVariable "TAS_fobBuilt";