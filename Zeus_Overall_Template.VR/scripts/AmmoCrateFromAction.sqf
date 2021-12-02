//params [["_position", [0,0,0], [[]], 3], ["_attachedObject", objNull, [objNull]]];
private _position = getPos ResupplySpawnHelper;
private _box = "B_supplyCrate_F" createVehicle _position;
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