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
		5: BOOL - whether to add grenades to the supply box
		6: STRING - classname of box to spawn
		7: STRING or NUMBER - height to paradrop supply crate at
		8: BOOL - whether to empty the box before adding the resupply items to it. Optional, default TRUE.


	Returns:
		OBJECT - created ammobox

	Examples:
		[[500,2200,0],true,true,false,true,true,"B_CargoNet_01_ammo_F"] call TAS_fnc_AmmoCrate; OR [ResupplySpawnHelper,true,true,false,,true,true,false,true,true,"B_CargoNet_01_ammo_F"] call TAS_fnc_AmmoCrate; OR [[500,2200,0],true,true,false,true,true,"B_CargoNet_01_ammo_F"] execVM "scripts\AmmoCrate.sqf"; OR [ResupplySpawnHelper,true,true,false,true,true,"B_CargoNet_01_ammo_F"] execVM "scripts\AmmoCrate.sqf";
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
private _paradropHeight		= _this select 7;	//NOTE: doesn't always work well
private _emptyBox			= _this select 8;	
//validate inputs. TODO check for data types
/*{
	if (isNil _x) exitWith {
		["Missing arguments!"] call BIS_fnc_error;
	};
} forEach [_position,_isPara,_addMedical,_addBasicAmmo,_addAdvancedAmmo,_addGrenades]; //TODO check that this exits entire function and not just the forEach. NOTE: NOT boxClass
*/

//validate and/or convert _position
switch (typeName _position) do
{
	case "ARRAY": { _position = ASLToATL _position }; //ZEN gives us ASL, we need ATL
	case "OBJECT": { _position = getPosATL _position };
	default { if (true) exitWith { ["Invalid position data type given! Given %1, expected ARRAY or OBJECT!",typeName _position] call BIS_fnc_error; }; }; //TODO check that this exits entire function and not just the switch. also, yes, requires a IF for some reason. TODO find better way
};

//box setup
if (isNil _boxClass) then {
	_boxClass = "B_CargoNet_01_ammo_F";
};
if (isNil _emptyBox) then {
	_emptyBox = true;
};
if (typeName _boxClass == "OBJECT") then {
	private _box = _boxClass;
} else {
	private _box = _boxClass createVehicle _position;
};
if (_emptyBox) then {
	clearItemCargoGlobal _box;
	clearWeaponCargoGlobal _box;
	clearMagazineCargoGlobal _box;
};

if (_paradropHeight isEqualType "") then {
	if (isNil _paradropHeight) then {
		_paradropHeight = 250;
	} else {
		_paradropHeight = parseNumber _paradropHeight;
	};
};
//spawns box in air, gives parachute and auto-renewing smoke
if (_isPara) then {
	private _height = _position select 2;
	_height = _height + _paradropHeight;
	_box setPosATL [_position select 0, _position select 1, _height];

	private _parachute = "B_parachute_02_F" createVehicle [0,0,0];
	_parachute setPosASL (getPosASL _box);
	_box attachTo [_parachute, [0, 0, 0]];
	
	//infinite smoke while resupply is not on the ground
	_box spawn {
		sleep 5; //it pauses midair when initially being made, so wait for that to finish
		while {(speed _this) > 0.1} do { //usually ~1 while falling in parachute
			private _smoke = "SmokeShellPurple" createVehicle [0,0,0];
			_smoke attachTo [_this, [0, 0, 0]];
			sleep 30;													//smoke grenade lasts for 60 seconds when handheld, but seems to be like half that when attached like this (or might just be a scheduler issue?). NOTE: underground correction will not occur until this loop is exited (so might be a bit after it lands)
		};
		if (((getPosATL _this) select 2) < 0) then { 	//might have edge case if it lands on a building and clips into it, but that's hard to check for
			[_this,0.5] call BIS_fnc_setHeight; 		//correct position to slightly above ground (it'll fall back down on its own). Arma is supposed to already do this, but doesn't always.
		};
	};
};

//add medical in priority order
if (_addMedical) then {
	_box addItemCargoGlobal ["ACE_fieldDressing", 100];
	_box addItemCargoGlobal ["ACE_morphine", 40];
	_box addItemCargoGlobal ["ACE_epinephrine", 20];
	_box addItemCargoGlobal ["ACE_bloodIV_500", 30];
	_box addItemCargoGlobal ["ACE_bloodIV", 15]; //1000 ml each
	_box addItemCargoGlobal ["ACE_tourniquet", 15];
	_box addItemCargoGlobal ["ACE_Earplugs", 10];
	_box addItemCargoGlobal ["ACE_personalAidKit",5];
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

//box is probably too heavy to carry/drag (600 for carry, 800 for drag) but just in case let's make it possible
[_box, true, [0, 2, 0], 0] remoteExecCall ['ace_dragging_fnc_setCarryable'];
[_box, true, [0, 2, 0], 0] remoteExecCall ['ace_dragging_fnc_setDraggable'];

_box //return reference to created box