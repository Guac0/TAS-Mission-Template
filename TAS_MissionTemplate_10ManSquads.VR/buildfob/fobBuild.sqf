//builds a fob with arsenals and repair boxes
//if (isNil fobBuilt) then {fobBuilt = false; publicVariable "fobBuilt";}; ////if variable is nonexistant, create it (first time setup)

if (TAS_fobBuilt == true) exitWith {systemChat "FOB already built!"}; //fail if fob has already been built

//_nearestUnits = nearestObjects [player,["Man","Car","Tank"],300];//if enemies are within 150m, exit with fail message
//_enemySides = playerSide call BIS_fnc_enemySides;
//if ( { _x countSide _nearestUnits > 0 } forEach _enemySides ) exitWith {systemChat "FOB creation failure, enemies are within 300m!"};
//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _enemySides = [side player] call BIS_fnc_enemySides;
private _radius = TAS_fobDistance; //parameter from initServer.sqf, default 300
private _nearEnemies = allUnits select {_x distance player < _radius AND side _x in _enemySides};
private _nearEnemiesNumber = count _nearEnemies;

if ( _nearEnemiesNumber > 0 ) exitWith {systemChat format ["FOB creation failure, enemies are within %1m!",TAS_fobDistance]};

if (TAS_fobBuilt == false) then { "fobMarker" setMarkerAlpha 1; }; //first time fob is created, set its marker to visible

fobobjects = [getPos logistics_vehicle, getDir logistics_vehicle, call (compile (preprocessFileLineNumbers "buildfob\fobComposition.sqf"))] call BIS_fnc_ObjectsMapper; //spawn the fob composition, public in case we want to delete like we do rallypoints (currently not used)
private _fobArsenals = nearestObjects [position logistics_vehicle, ["B_CargoNet_01_ammo_F"], 25]; //select boxes for arsenals
if (TAS_fobFullArsenals) then { //full arsenals
	{
		[_x, true] call ace_arsenal_fnc_initBox;
		["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;
	} forEach _fobArsenals;
} else { //limited dynamic resupply
	{
		private _box = _x;
		clearItemCargoGlobal _box; clearWeaponCargoGlobal _box; clearMagazineCargoGlobal _box;
		
		{
			// Current result is saved in variable _x
			_box addMagazineCargoGlobal [primaryWeaponMagazine _x select 0, 6]; 
		} forEach allPlayers;
		
		//add medical in priority order
		_box addItemCargoGlobal ["ACE_fieldDressing", 75];
		_box addItemCargoGlobal ["ACE_morphine", 40];
		_box addItemCargoGlobal ["ACE_epinephrine", 20];
		_box addItemCargoGlobal ["ACE_bloodIV_500", 20];
		_box addItemCargoGlobal ["ACE_bloodIV", 10]; //1000 ml
		_box addItemCargoGlobal ["ACE_tourniquet", 15];
		_box addItemCargoGlobal ["ACE_Earplugs", 10];
	} forEach _fobArsenals;
};


fobRespawn = [side player, getPos player, "FOB Respawn"] call BIS_fnc_addRespawnPosition;
"fobMarker" setMarkerPos getPos logistics_vehicle; //updates the rallypoint's position on map

private _playerSide = side group player;
[[_playerSide, "HQ"], format ["FOB established by %1 at gridref %2.", name player, mapGridPosition logistics_vehicle]] remoteExec ["sideChat", side player];
TAS_fobBuilt = true;
publicVariable "TAS_fobBuilt"; //might also need public variables for fobObjects and fobRespawn if we want to delete them but currently we don't so...
									//for now, keep those 2 local to current builder's machine since it's an edge case and would use up much bandwidth to publicVariable