/*
	Author: Guac
	
	Sets given unit's loadout by comparing its roleDescription to unit names in the given faction to search, with fallbacks if no matches are found.
	Do not use in cases where roleDescription does not exist, such as in singleplayer or on units without a set roleDescription.
	Note that some mods are cursed and use invisible characters instead of spaces and thus will fail ordinary name checks
		For example, CUP ION has it like this: "FieldÂ Medic"
		If you experience errors, then spawn a unit in zeus and execute this code in its ZEN code box to get its REAL name: 
			private _name = getText (configFile >> "cfgVehicles" >> typeOf _this >> "displayName"); copyToClipboard _name; systemChat _name;

	[player,TAS_configFaction,"Rifleman",""] call TAS_fnc_assignLoadoutFromConfig;
*/
params ["_givenUnit","_faction","_defaultUnitName","_prefix"];
private ["_unit"]; //do it here to avoid reptition in the switch
private _roleDescription = roleDescription _givenUnit;
private _debug = false;

if (_debug) then { systemChat "a"; };

if (_givenUnit getVariable ["TAS_disableConfigLoadoutAssignment",false]) exitWith { systemChat "Your loadout has not been assigned from config due to the Mission Maker disabling it for you in particular." }; //exit script if unit has been flagged to not have a changed loadout.

if ((_givenUnit getVariable ["TAS_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"]) isNotEqualTo "Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player") then { //skip if on the default
	_roleDescription = _givenUnit getVariable ["TAS_overrideConfigLoadoutName",_defaultUnitName];
	_roleDescription = format ["%1%2",_prefix,_roleDescription];	//account for prefix
} else {
	/*if (isNil _roleDescription) then { //TODO arma always registers this as being nil for some reason???
		systemChat roleDescription player;
		systemChat roleDescription _givenUnit;
		systemChat format ["fn_assignLoadoutFromConfig: Given unit has no role description%1, using provided default unit name instead!",_roleDescription];
		_roleDescription = _defaultUnitName;
	};*/

	if ((_roleDescription find "@") != -1) then { //-1 indicates no @ sign. If unit has @ sign, parse it and only count text before it (remove group info)
		private _roleDescriptionArray = _roleDescription splitString "@"; //splits string into array with values separated by @ sign, so "AAA@BBB" becomes "[AAA,BBB]"
		_roleDescription = _roleDescriptionArray select 0;
	};

	if ((_roleDescription find "[") != -1) then { //remove info about assigned color team if player has it
		private _indexOfBracket = _roleDescription find "[";
		_roleDescription = _roleDescription select [0,(_indexOfBracket - 1)]; //-1 to remove the space before it
	};
	_roleDescription = format ["%1%2",_prefix,_roleDescription];	//account for prefix
};

if (_debug) then { systemChat format ["b %1",_roleDescription]; };

private _matchingUnitArray = ("(configname _x iskindOf 'CAManBase') && (getNumber (_x >> 'scope') >= 2) && (gettext (_x >> 'faction') == _faction) && (gettext (_x >> 'displayName') == _roleDescription)" configClasses (configfile >> "CfgVehicles")) apply {configName _x};
if (_debug) then { systemChat format ["c %1",_matchingUnitArray]; };
switch (count _matchingUnitArray) do {
	case 0: { //no results, so first try to basic rifleman, then take any unit
		_matchingUnitArray = ("(configname _x iskindOf 'CAManBase') && (getNumber (_x >> 'scope') >= 2) && (gettext (_x >> 'faction') == _faction) && (gettext (_x >> 'displayName') == _defaultUnitName)" configClasses (configfile >> "CfgVehicles")) apply {configName _x};
		if (count _matchingUnitArray == 0) then {
			_matchingUnitArray = ("(configname _x iskindOf 'CAManBase') && (getNumber (_x >> 'scope') >= 2) && (gettext (_x >> 'faction') == _faction)" configClasses (configfile >> "CfgVehicles")) apply {configName _x};
		};
		_unit = _matchingUnitArray select 0;
		if (isServer) then {
			systemChat "fn_assignLoadoutFromConfig: Role description did not match a unit type in the given faction, fallback loadout assigned!";
		};
	};
	case 1: { //only one result found, good
		_unit = _matchingUnitArray select 0;
	};
	default { //either multiple or negative results found, uh...... This can occur for some vanilla NATO units where combat patrol units are also returned in addition to the normal units
		_unit = _matchingUnitArray select TAS_configLoadoutNumber;
		//systemChat str count _matchingUnitArray;
		//systemChat str _matchingUnitArray;
		//systemChat "Warning: fn_assignLoadoutFromConfig has encountered unexpected state when attempting to match loadouts. It is possible that multiple matching loadouts were found; attempting to use the first loadout found.";
		if (isServer) then {
			systemChat "fn_assignLoadoutFromConfig: Multiple compatible loadouts were found, attempting to use the best one available!";
		};
	};
};

private _loadout = getUnitLoadout _unit;
_givenUnit setUnitLoadout _loadout;

if (_debug) then { systemChat format ["d"]; };