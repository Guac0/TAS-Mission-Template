if !(isServer) then {
	[format ["fn_scavFindSuitableBuildings is not being executed on server, errors are possible!"],false] call TAS_fnc_error;
};

private _blacklistLocations = missionNamespace getVariable ["TAS_scavAllBlacklists",[]];
private _enterableBuildings = missionNamespace getVariable ["TAS_scavEnterableBuildingsInAO",[]]; //this variable is stored only on the server!
private _isSuitable = false;
private _attemptsRemaining = 10;
private _debug = false;
private _potentialObjective = objNull;

while {!(_isSuitable) && (_attemptsRemaining > 0)} do { //dont get caught in a forever loop

	_potentialObjective = selectRandom _enterableBuildings;
	_isSuitable = true;

	if (isNull _potentialObjective) then {
		_isSuitable = false;
		[format ["fn_scavFindSuitableBuilding has somehow managed to find a null potential objective: %1",_potentialObjective],true] call TAS_fnc_error;
	} else {

		if (_debug) then { //wait until after the null check to avoid error
			[format ["fn_scavFindSuitableBuilding attempting to find suitable building, remaining attempts: %1. Checking building %2 at %3.",_attemptsRemaining,_potentialObjective, getPos _potentialObjective],true] call TAS_fnc_error;
		};

		{
			if (_x distance _potentialObjective < TAS_scavObjectiveDistanceThreshold) then {
				_isSuitable = false;
				if (_debug) then {
					[format ["fn_scavFindSuitableBuilding building is not suitable due to objective blacklist: %1",_x distance _potentialObjective < TAS_scavObjectiveDistanceThreshold],true] call TAS_fnc_error;
				};
			};
		} forEach _blacklistLocations;

		if ([_potentialObjective] call TAS_fnc_scavCheckIfNearbyPlayer) then {
		//if ({_x distance _potentialObjective < TAS_scavPlayerDistanceThreshold} count allPlayers > 0) then { //don't create an objective if players are nearby 
			_isSuitable = false;
			if (_debug) then {
				[format ["fn_scavFindSuitableBuilding building is not suitable due to player blacklist: %1",count (allPlayers select { _x distance2D _potentialObjective < TAS_scavPlayerDistanceThreshold})],true] call TAS_fnc_error;
			};
		};
	
	};

	_attemptsRemaining = _attemptsRemaining - 1;

	if (_attemptsRemaining < 0) exitWith {[format ["fn_scavFindSuitableBuilding cannot find suitable building before search timeout! Attempting recursive call!"],false] call TAS_fnc_error; _potentialObjective = [] call TAS_fnc_scavFindSuitableBuilding; _potentialObjective}; //return objNull

};

if (_debug) then {
	[format ["fn_scavFindSuitableBuilding returning with %1",_potentialObjective],true] call TAS_fnc_error;
};

if (isNull _potentialObjective) then {
	_potentialObjective = [] call TAS_fnc_scavFindSuitableBuilding;
	[format ["fn_scavFindSuitableBuilding attempted to return with null building. New building: %1",_potentialObjective],true] call TAS_fnc_error;
};
_potentialObjective //return building