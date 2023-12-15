/*
Replaces the given unit's loadout with a exosuit loadout from ExoMod Remastered (iirc the tan British Marines).
Replaces uniform/vest/weapons, but tries to keep the same inventory items + adds appropriate ammo and special meds.
Sets respawn loadout of the player (if enabled in mission options) to the exosuit.

[player] call TAS_fnc_addExo;
*/

params ["_unit"];

if !(isClass(configFile >> "CfgPatches" >> "PhoenixSystems_Exosuits")) exitWith {["fn_addExo called but EXOMOD is not loaded!",true] call TAS_fnc_error};

private _roleDescription = roleDescription _unit;
private _roleDescriptionSimple = roleDescription _unit; //we'll use this in a sec

if ((_roleDescription find "@") != -1) then { //-1 indicates no @ sign. If unit has @ sign, parse it and only count text before it (remove group info)
	private _roleDescriptionArray = _roleDescription splitString "@"; //splits string into array with values separated by @ sign, so "AAA@BBB" becomes "[AAA,BBB]"
	_roleDescriptionSimple = _roleDescriptionArray select 0;
};
if ((_roleDescription find "[") != -1) then { //remove info about assigned color team if _unit has it
	private _indexOfBracket = _roleDescription find "[";
	_roleDescriptionSimple = _roleDescription select [0,(_indexOfBracket - 1)]; //-1 to remove the space before it
};

{
	_unit removeMagazine _x;
} forEach magazines _unit;
_unit removeItems "Health_Syringe";
_unit removeItems "Battery_Full";

private _weaponItems = primaryWeaponItems _unit;
private _uniformItems = uniformItems _unit;
private _vestItems = vestItems _unit;
private _backpackItems = backpackItems _unit;

removeBackpack _unit;

_unit forceAddUniform "ACU_Multicam_PS_Nakolenniki";

switch (true) do
{
	//cmd
	case ("Officer" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Leader";
	};
	case ("JTAC" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Rifleman";
	};
	case (("Combat Life Saver" in _roleDescriptionSimple) || ("Medic" in _roleDescriptionSimple) || ("medic" in _roleDescriptionSimple)): {
		_unit addVest "Vest_Thor_Assault";
	};
	case ("EW Specialist" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Rifleman";
	};

	//recon
	case ("Recon Team Leader" in _roleDescriptionSimple): {

	};
	case ("Recon Paramedic" in _roleDescriptionSimple): {
		
	};
	case ("Recon Demo Specialist" in _roleDescriptionSimple): {
		
	};
	case ("Recon Sharpshooter" in _roleDescriptionSimple): {
		
	};

	//air
	case ("Pilot" in _roleDescriptionSimple): {

	};
	case ("Copilot" in _roleDescriptionSimple): {
		
	};

	//armor
	case ("Commander" in _roleDescriptionSimple): {

	};
	case ("Gunner" in _roleDescriptionSimple): {
		
	};
	case ("Driver" in _roleDescriptionSimple): {
		
	};

	//squad (medic is in cmd section)
	case ("Squad Leader" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Leader";
	};
	case ("RTO" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Rifleman";
	};
	case ("Machinegunner" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Machinegunner";
	};
	case ("Team Leader" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Leader";
	};
	case ("Autorifleman" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Machinegunner";
	};
	case ("Rifleman (AT)" in _roleDescriptionSimple): {
		_unit addVest "Vest_Thor_Assault";
	};

	//other, feel free to add more if you have custom names
	case ("Zeus" in _roleDescriptionSimple): {
		
	};
	default {
		_unit addVest "Vest_Thor_Rifleman";
	};
};

_unit addBackpack selectRandom ["Exosuit_MK2_Mult_L","Exosuit_MK2_Mult_AAM","Exosuit_MK2_Mult_AAL","Exosuit_MK2_Mult_AA","Exosuit_MK2_Mult_A"]; //Exosuit_MK2_Mult_H
_unit addHeadgear selectRandom ["Odin_Full","Odin_NolenseFull","Odin_Clear","Odin_NoMaskLense"];
_unit addWeaponGlobal "NVTG_mk9";
_unit addGoggles "G_Bandanna_tan";

_unit removeItems "Health_Syringe";
_unit removeItems "Battery_Full";
for "_i" from 1 to 2 do { _unit addItem "Battery_Full" };

//Reapply uniform items
{
	//make sure items can fit due to different uniform sizes
	if ( _unit canAddItemToUniform _x ) then {
		_unit addItemToUniform _x;
	}else{
		if ( _unit canAddItemToVest _x ) then {
			_unit addItemToVest _x;
		}else{
			//Just add it to the backpack if not
			_unit addItemToBackpack _x;
		};
	};
} forEach _uniformItems;
{
	//make sure items can fit due to different uniform sizes
	if ( _unit canAddItemToUniform _x ) then {
		_unit addItemToUniform _x;
	}else{
		if ( _unit canAddItemToVest _x ) then {
			_unit addItemToVest _x;
		}else{
			//Just add it to the backpack if not
			_unit addItemToBackpack _x;
		};
	};
} forEach _vestItems;
{
	//make sure items can fit due to different uniform sizes
	if ( _unit canAddItemToUniform _x ) then {
		_unit addItemToUniform _x;
	}else{
		if ( _unit canAddItemToVest _x ) then {
			_unit addItemToVest _x;
		}else{
			//Just add it to the backpack if not
			_unit addItemToBackpack _x;
		};
	};
} forEach _backpackItems;

if (handgunWeapon _unit != "") then {
	//for "_i" from 1 to 1 do { _unit addItem ([handgunWeapon _unit] call CBA_fnc_compatibleMagazines select 0) };
	if (count ([handgunWeapon _unit] call CBA_fnc_compatibleMagazines) > 0) then {									
		for "_i" from 1 to 1 do { _unit addItem ([handgunWeapon _unit] call CBA_fnc_compatibleMagazines select 0) };
	};
	{
		if (_x != "this") then {
			if (count ([configFile >> "CfgWeapons" >> handgunWeapon _unit >> _x] call CBA_fnc_compatibleMagazines) > 0) then {									//checks if weapon actually has compatible ammo
				for "_i" from 1 to 1 do { _unit addItem ([configFile >> "CfgWeapons" >> handgunWeapon _unit >> _x] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
			};
		};
	} forEach (getArray (configFile >> "CfgWeapons" >> (handgunWeapon _unit) >> "muzzles"));
};
if (secondaryWeapon _unit != "") then {
	//for "_i" from 1 to 2 do { _unit addItem ([secondaryWeapon _unit] call CBA_fnc_compatibleMagazines select 0) }; //add launcher ammo if _unit has launcher
	if (count ([secondaryWeapon _unit] call CBA_fnc_compatibleMagazines) > 0) then {									
		for "_i" from 1 to 2 do { _unit addItem ([secondaryWeapon _unit] call CBA_fnc_compatibleMagazines select 0) };
		if (count ([secondaryWeapon _unit] call CBA_fnc_compatibleMagazines) > 1) then {  								
			for "_i" from 1 to 2 do { _unit addItem ([secondaryWeapon _unit] call CBA_fnc_compatibleMagazines select 1) }; 
		};
	};
	{
		if (_x != "this") then {
			if (count ([configFile >> "CfgWeapons" >> secondaryWeapon _unit >> _x] call CBA_fnc_compatibleMagazines) > 0) then {									//checks if weapon actually has compatible ammo
				for "_i" from 1 to 2 do { _unit addItem ([configFile >> "CfgWeapons" >> secondaryWeapon _unit >> _x] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
				if (count ([configFile >> "CfgWeapons" >> secondaryWeapon _unit >> _x] call CBA_fnc_compatibleMagazines) > 1) then {  								//adds CBA's second best guess for ammo (for tracer rounds for rifles, HE rounds for launchers, and the like) if any exists
					for "_i" from 1 to 2 do { _unit addItem ([configFile >> "CfgWeapons" >> secondaryWeapon _unit >> _x] call CBA_fnc_compatibleMagazines select 1) }; //standard ammo
				};
			};
		};
	} forEach (getArray (configFile >> "CfgWeapons" >> (secondaryWeapon _unit) >> "muzzles"));
};

switch (true) do
{
	//cmd
	case (("Officer" in _roleDescriptionSimple) || ("Squad Leader" in _roleDescriptionSimple) || ("Team Leader" in _roleDescriptionSimple)): {
		
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "1Rnd_HE_Grenade_shell" ) then {
				_unit addItem "1Rnd_HE_Grenade_shell";
			};
		};
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "1Rnd_Pellet_Grenade_shell_lxWS" ) then {
				_unit addItem "1Rnd_Pellet_Grenade_shell_lxWS";
			};
		};
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "ACE_40mm_Flare_red" ) then {
				_unit addItem "ACE_40mm_Flare_red";
			};
		};
		switch (floor random 3) do {
			case 0: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_65x39_caseless_black_mag_tracer" ) then {
						_unit addItem "100Rnd_65x39_caseless_black_mag_tracer";
					};
				};
				_unit addWeaponGlobal "arifle_MX_GL_Black_F";
			};
			case 1: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_580x42_Mag_Tracer_F" ) then {
						_unit addItem "100Rnd_580x42_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_NCAR15_GL_F";
			};
			case 2: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "150Rnd_556x45_Drum_Mag_Tracer_F" ) then {
						_unit addItem "150Rnd_556x45_Drum_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_SPAR_01_GL_blk_F";
			};
			case 3: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "75rnd_762x39_AK12_Mag_Tracer_F" ) then {
						_unit addItem "75rnd_762x39_AK12_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_AK12_GL_F";
			};
			case 4: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_580x42_Mag_Tracer_F" ) then {
						_unit addItem "100Rnd_580x42_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_CTAR_GL_blk_F";
			};
		};
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "1Rnd_HE_Grenade_shell" ) then {
				_unit addItem "1Rnd_HE_Grenade_shell";
			};
		};
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "1Rnd_Pellet_Grenade_shell_lxWS" ) then {
				_unit addItem "1Rnd_Pellet_Grenade_shell_lxWS";
			};
		};
		for "_i" from 1 to 4 do {
			if ( _unit canAdd "ACE_40mm_Flare_red" ) then {
				_unit addItem "ACE_40mm_Flare_red";
			};
		};
	};

	case (("Machinegunner" in _roleDescriptionSimple) || ("Autorifleman" in _roleDescriptionSimple)): {
		switch (floor random 3) do {
			case 0: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "150Rnd_93x64_Mag" ) then {
						_unit addItem "150Rnd_93x64_Mag";
					};
				};
				_unit addWeaponGlobal "MMG_01_black_F";
			};
			case 1: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "130Rnd_338_Mag" ) then {
						_unit addItem "130Rnd_338_Mag";
					};
				};
				_unit addWeaponGlobal "MMG_02_black_F";
			};
			/*case 2: { //ffaa dependency
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "ffaa_556x45_mg4" ) then {
						_unit addItem "ffaa_556x45_mg4";
					};
				};
				_unit addWeaponGlobal "ffaa_armas_mg4";
			};
			*/
		};
	};

	default {  
		switch (floor random 5) do {
			case 0: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_65x39_caseless_black_mag_tracer" ) then {
						_unit addItem "100Rnd_65x39_caseless_black_mag_tracer";
					};
				};
				_unit addWeaponGlobal "arifle_MX_SW_Black_F";
			};
			case 1: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_580x42_Mag_Tracer_F" ) then {
						_unit addItem "100Rnd_580x42_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_NCAR15_MG_F";
			};
			case 2: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "150Rnd_556x45_Drum_Mag_Tracer_F" ) then {
						_unit addItem "150Rnd_556x45_Drum_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_SPAR_01_blk_F";
			};
			case 3: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "75rnd_762x39_AK12_Mag_Tracer_F" ) then {
						_unit addItem "75rnd_762x39_AK12_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_AK12_F";
			};
			case 4: {
				for "_i" from 1 to 8 do {
					if ( _unit canAdd "100Rnd_580x42_Mag_Tracer_F" ) then {
						_unit addItem "100Rnd_580x42_Mag_Tracer_F";
					};
				};
				_unit addWeaponGlobal "arifle_CTARS_blk_F";
			};
		};
	};
};

{_unit addPrimaryWeaponItem _x} forEach _weaponItems;

private _loadout = [_unit] call CBA_fnc_getLoadout;
_unit setVariable ["TAS_arsenalLoadout",_loadout];

private _imag  =  "<img size='8' image='media\logo256x256.paa' align='center'/>";
private _output = "<br/><t color='#cc6600' size='3' align='center'>EXOSUIT POWER ONLINE</t><br/><br/>";
private _output2 = "<t>You have equiped an exosuit!</t><br/><br/><t>Your weaponry has been replaced as your exosuit can utilize heavier weapons (both in caliber and in mag size).</t><br/><br/><t>Press CONTROL+SPACE to perform a jumpkit-assisted jump, and TAB to change the jump mode.</t><br/><br/><t>Press CONTROL+1 to consume a battery to replenish your systems.</t><br/><br/><br/><br/><t>Meta notes:</t><br/><t>Your old inventory has been (mostly) preserved.</t><br/><t>If you dislike your new loadout, activate the exosuit equip action again to randomize your gear.</t><br/><t>Additionally, see the ace arsenal in the ammo box in close proximity to equip weapon attachments.</t><br/><t>If you have low ammo, free up some space in your inventory and activate the exosuit action again.</t>";
hint parseText (_output + "<br/><br/>" + _output2 + "<br/><br/>" + _imag + "<br/>");
//hint parseText (_output + "<br/><br/>" + _output2 + "<br/><br/>");
