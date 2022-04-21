params [["_position", [0,0,0], [[]], 3], ["_attachedObject", objNull, [objNull]]];
private _position = _this select 0;
private _h = _position param [2, 0];
_h = _h + 75;
_position set [2, _h];
private _box = "B_CargoNet_01_ammo_F" createVehicle [0,0,0];
_box setPosATL _position;

parachute_1 = "B_parachute_02_F" createVehicle [0,0,0];
parachute_1 setPosASL (getPosASL _box);
_box attachTo [parachute_1, [0, 0, 0]];

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

_smoke = "SmokeShellRed" createVehicle [0,0,0];
_smoke attachTo [_box, [0, 0, 0]];