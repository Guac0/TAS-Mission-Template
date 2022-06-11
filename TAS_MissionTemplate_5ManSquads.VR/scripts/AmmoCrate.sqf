/*
	Author: Guac

	Description:
		Spawns a crate at given position (including airborne if specified) that contains various resupply materials.

	Parameter(s):
		0: can be one of:
			ARRAY - position ATL (or position2d, but discouraged)
			OBJECT - object where supply box should be placed at
		1: BOOL - whether to parachute the supply box in at a altitude of 250m
		2: BOOL - whether to add medical items to the supply box
		3: BOOL - whether to add primary weapon ammo to the supply box (gives the current ammo loaded). Recommended that you do NOT set both this AND 4 to TRUE as they do the same thing different ways.
		4: BOOL - whether to add primary ammo, handgun ammo, and launcher ammo to the supply box and use experimental methods to determine correct magazines to add
		5: BOOL - whether to add medical items to the supply box
		6: STRING - classname of box to spawn


	Returns:
		OBJECT - created ammobox

	Examples:
		[resupplyLandingHelper,true,true,false,true,false,B_CargoNet_01_ammo_F"] call TAS_fnc_AmmoCrate; OR [resupplyLandingHelper,true,true,false,true,false,B_CargoNet_01_ammo_F"] execVM "scripts\AmmoCrate.sqf";
*/

/*params [
	["_position", [0,0,0], [[]]],
	["_attachedObject", objNull, [objNull]],
];*/
//TODO replace these with PARAMS
private _position 			= _this select 0;
private _isPara 			= _this select 1;
private _addMedical 		= _this select 2;
private _addBasicAmmo 		= _this select 3;
private _addAdvancedAmmo 	= _this select 4;
private _addGrenades 		= _this select 5;
private _boxClass			= _this select 6;

//validate inputs. TODO check for data types
{
	if (isNil _x) exitWith {
		["Missing arguments!"] call BIS_fnc_error;
	};
} forEach [_position,_isPara,_addMedical,_addBasicAmmo,_addAdvancedAmmo,_addGrenades,_boxClass]; //TODO check that this exits entire function and not just the forEach

//validate and/or convert _position
switch (typeName _position) do
{
	case "ARRAY": { /*nothing, valid data type*/ };
	case "OBJECT": { _position = getPosATL _position };
	default { exitWith { ["Invalid position data type given! Given %1, expected ARRAY or OBJECT!",typeName _position] call BIS_fnc_error; }; }; //TODO check that this exits entire function and not just the switch
};

private _box = _boxClass createVehicle _position;
clearItemCargoGlobal _box; clearWeaponCargoGlobal _box; clearMagazineCargoGlobal _box;

//spawns box in air, gives parachute and auto-renewing smoke
if (_isPara) then {
	private _height = _position select 2;
	_height = _height + 250;
	_box setPosATL [_position select 0, _position select 1, _height];

	private _parachute = "B_parachute_02_F" createVehicle [0,0,0];
	_parachute setPosASL (getPosASL _box);
	_box attachTo [_parachute, [0, 0, 0]];
		
	//infinite smoke while resupply is not on the ground
	_box spawn {
		while {!(isTouchingGround _this)} do {
			sleep 30;													//TODO test duration of smoke
			private _smoke = "SmokeShellRed" createVehicle [0,0,0];
			_smoke attachTo [_this, [0, 0, 0]];
		};
	};
};

//add medical in priority order
if (_addMedical) then {
	_box addItemCargoGlobal ["ACE_fieldDressing", 100];
	_box addItemCargoGlobal ["ACE_morphine", 40];
	_box addItemCargoGlobal ["ACE_epinephrine", 20];
	_box addItemCargoGlobal ["ACE_bloodIV_500", 30];
	_box addItemCargoGlobal ["ACE_bloodIV", 15]; //1000 ml
	_box addItemCargoGlobal ["ACE_tourniquet", 15];
	_box addItemCargoGlobal ["ACE_Earplugs", 10];
};

//add 6 magazines for each player's primary weapon, based on currently equiped magazine OR (if player has no magazines loaded) CBA's best guess at a compatible magazine
if (_addBasicAmmo) then {
	{
		// Current player is saved in variable _x
		if (primaryWeapon _x != "") then { 													//don't add primary ammo if player has no primary weapon
			if (count (primaryWeaponMagazine _x) > 0) then { 								//only add magazines if player has magazine(s) loaded
				for "_i" from 0 to ((count primaryWeaponMagazine _x) - 1) do {				//grab GL/other underbarrel rounds too if applicable
					_box addMagazineCargoGlobal [primaryWeaponMagazine _x select _i, 6];
				};
			} else {																		//if player has no magazines loaded (i.e. fully out of ammo), then take our best guess from CBA compat magazines IF weapon has any compatible magazines
				if (count ([primaryWeapon _x] call CBA_fnc_compatibleMagazines) > 0) then { //only do this if there's actually valid magazines for the gun
					_box addMagazineCargoGlobal [[primaryWeapon _x] call CBA_fnc_compatibleMagazines select 0,6];
				};
			};
		};
	} forEach allPlayers;
};

if (_addAdvancedAmmo) then {
	{
		
		if (primaryWeapon _x != "") then { 																		//don't add primary ammo if player has no primary weapon
			if (count ([primaryWeapon _x] call CBA_fnc_compatibleMagazines) > 0) then {							//checks if weapon actually has compatible ammo
				_box addMagazineCargoGlobal [[primaryWeapon _x] call CBA_fnc_compatibleMagazines select 0,4]; 	//adds CBA's best guess for ammo
				if (count ([primaryWeapon _x] call CBA_fnc_compatibleMagazines) > 1) then {  					//adds CBA's second best guess for ammo (for tracer rounds for rifles, HE rounds for launchers, and the like) if any exists
					_box addMagazineCargoGlobal [[primaryWeapon _x] call CBA_fnc_compatibleMagazines select 1,4];
				};
			};
		};

		if (handgunWeapon _x != "") then { 																		//don't add primary ammo if player has no primary weapon
			if (count ([handgunWeapon _x] call CBA_fnc_compatibleMagazines) > 0) then {							//checks if weapon actually has compatible ammo
				_box addMagazineCargoGlobal [[handgunWeapon _x] call CBA_fnc_compatibleMagazines select 0,2]; 	//adds CBA's best guess for ammo
			};
		};
		
		if (secondaryWeapon _x != "") then { 																	//don't add ammo if player has no weapon
			if (count ([secondaryWeapon _x] call CBA_fnc_compatibleMagazines) > 0) then {						//checks if weapon actually has compatible ammo
				_box addMagazineCargoGlobal [[secondaryWeapon _x] call CBA_fnc_compatibleMagazines select 0,2]; //adds two rounds of CBA's best guess for ammo
				if (count ([secondaryWeapon _x] call CBA_fnc_compatibleMagazines) > 1) then {  					//adds two rounds of CBA's second best guess for ammo (for tracer rounds for rifles, HE rounds for launchers, and the like) if any exists
					_box addMagazineCargoGlobal [[secondaryWeapon _x] call CBA_fnc_compatibleMagazines select 1,2];
				};
			};
		};

	} forEach allPlayers;
};

if (_addGrenades) then { //add two m67s and two white smoke grenades for each player
	{
		_box addItemCargoGlobal ["HandGrenade",2];
		_box addItemCargoGlobal ["SmokeShell",2];
	} forEach allPlayers;
};

_box