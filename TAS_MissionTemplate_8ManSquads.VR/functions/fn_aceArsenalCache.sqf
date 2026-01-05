/*
	Author: Guac

	Requirements: ACE Arsenal
	
	Description:
	Each arsenal placed in the mission is stored as a unique entry in the mission file. If the arsenal has lots of items, it takes up lots of space. This caches many arsenals into a single one to save file space.

	Return: true

	Examples: 
	[TAS_aceArsenalCacheItems,TAS_aceArsenalCacheBoxes] spawn TAS_fnc_aceArsenalCache; //Add arsenals with values as set in config.sqf for the local player
	[["Item1","Item2","Item3"],["arsenal_1","arsenal_2"]] spawn TAS_fnc_aceArsenalCache; //Add arsenals only for the local player
	[["Item1","Item2","Item3"],["arsenal_1","arsenal_2"]] remoteExec ["TAS_fnc_aceArsenalCache"]; //Add arsenals for all players. NOTE: if the arsenals are large, try not to send their contents over the network using remoteexec!
*/
params ["_arsenalContents","_arsenals"];

{
	if (!isNil _x) then { //check if this variable name exists
		private _arsenalBox = missionNamespace getVariable [_x, objNull];
		if (!isNull _arsenalBox) then { //check if the object this variable refers to exists
			[_arsenalBox, _arsenalContents] call ace_arsenal_fnc_initBox;
		} else {
			[format ["TAS_fnc_aceArsenalCache called with nonexistant box %1",_x],true] spawn TAS_fnc_error;
		};
	} else {
		[format ["TAS_fnc_aceArsenalCache called with nonexistant string/box %1",_x],true] spawn TAS_fnc_error;
	};
} forEach _arsenals;

true