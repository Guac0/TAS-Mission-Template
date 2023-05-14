/*
TAS Arsenal Curate Script
Written by: Guac
Given an array of (stringified) arsenal crate variable names, checks if the configured mods are loaded and removes problematic items from the arsenals. Only works with ace arsenals.

Parameters:
Array - strings of arsenal crate variable names to curate the ace arsenals therein

Example:
["arsenal_1","arsenal_2","arsenal_3","arsenal_4","arsenal_5","arsenal_6","arsenal_7","arsenal_8","arsenal_9","arsenal_10"] spawn TAS_fnc_arsenalCurate;
*/

_arsenalsToCheckString = _this;

private _debugCurate = false;
if (_debugCurate) then { systemChat "a"; };
{
	if (_debugCurate) then { systemChat format ["b %1",_x]; };

	//do some fancy stuff before removing items to account for arsenals that don't actually exist.
	private _arsenal = _x;
	_arsenal = missionNamespace getVariable [_arsenal, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _arsenal) then {
		
		//RHS USAF Doomsday
		if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { 
			if (_debugCurate) then { systemChat "c"; };
			[_arsenal, ["rhsusf_5Rnd_doomsday_Buck","rhsusf_8Rnd_doomsday_Buck"]] call ace_arsenal_fnc_removeVirtualItems;
		};

		//TAS Flashlights
		if (isClass(configFile >> "CfgPatches" >> "TAS_BrightLite")) then { 
			if (_debugCurate) then { systemChat "d"; };
			[_arsenal, ["TAS_acc_brightlite_sniper","TAS_acc_brightlite_high","TAS_acc_brightlite_low","TAS_acc_brightlite_static","TAS_acc_nightlite_sniper","TAS_acc_nightlite_high","TAS_acc_nightlite_low","TAS_acc_nightlite_static"]] call ace_arsenal_fnc_removeVirtualItems;
		};

		//TAS Doomsday
		if (isClass(configFile >> "CfgPatches" >> "TAS_Revolver")) then { 
			if (_debugCurate) then { systemChat "e"; };
			[_arsenal, ["TAS_6Rnd_doomsday_Buck"]] call ace_arsenal_fnc_removeVirtualItems; //TAS_6Rnd_FRAG too?
		};

		//LAGO stuff
		if (isClass(configFile >> "CfgPatches" >> "LAGO_Biken")) then { //just check for biken main mod b/c lazy and not checking for each of them
			if (_debugCurate) then { systemChat "f"; };
			[_arsenal, ["LAGO_Biken","LAGO_KU3K","LAGO_KU5K","LAGO_KU98K_NSK","LAGO_KUoooK","LAGO_SCannon","LAGO_CP"]] call ace_arsenal_fnc_removeVirtualItems; //TAS_6Rnd_FRAG too?
		};

		//M82 stuff
		if (isClass(configFile >> "CfgPatches" >> "GX_M82A2_Weapon")) then { //just check for biken main mod b/c lazy and not checking for each of them
			if (_debugCurate) then { systemChat "f"; };
			[_arsenal, ["GX_M82A2_10Rnd_HE_Mag","GX_M82A2_10Rnd_HEDP_Mag"]] call ace_arsenal_fnc_removeVirtualItems; //TAS_6Rnd_FRAG too?
		};

		//template for adding more
		/*
		if (isClass(configFile >> "CfgPatches" >> "cfgPatchesNameOfMod")) then {
			if (_debugCurate) then { systemChat "g"; };
			[_arsenal, ["classname1","classname2"]] call ace_arsenal_fnc_removeVirtualItems; //Remember that classnames must be case sensitive, and that ace arsenal (sometimes) lies and says that they're lowercase! Get the real name from the config files or elsewhere!
		};
		*/

	};
} forEach _arsenalsToCheckString;
if (_debugCurate) then { systemChat "g"; };