//called from fn_GolfRallypoint.sqf
//handles the overrun process for the rallypoint and automatically exits after overrun completes and/or rallypoint is moved

params ["_friendlySide","_enemySides","_radius","_nearEnemies","_nearFriendlies","_nearEnemiesNumber","_nearFriendliesNumber","_rallypointPosATL"];
private _debug = false;

if (_debug) then {
	systemChat "rallypoint a";
};

private _rallyStillExistsCheck = [TAS_rallypointLocations, _rallypointPosATL] call BIS_fnc_findNestedElement;
if (_rallyStillExistsCheck isEqualTo []) exitWith {
	//rally location has been updated!
	_rallyStillExists = false;
	if (_debug) then {
		systemChat "rallypoint exiting";
	};
};

private _rallyStillExists = true;
while {_rallyStillExists} do {

	if (_debug) then {
		systemChat "rallypoint b";
	};

	/*private _nearUnits = nearestObjects [_rallypointPosATL, ["Man"], TAS_fobOverrunDistance];	//wont find vehicles/infantry in vehicles!
	private _nearUnitsAlive = [];
	{ if (alive _x ) then { _nearUnitsAlive set [(count _nearUnitsAlive), _x]; }; } forEach _nearUnits;
	private _nearEnemies = 
	_rallypointPosATL*/

	_rallyStillExistsCheck = [TAS_rallypointLocations, _rallypointPosATL] call BIS_fnc_findNestedElement;
	if (_rallyStillExistsCheck isEqualTo []) exitWith {
		//rally location has been updated!
		_rallyStillExists = false;
		if (_debug) then {
			systemChat "rallypoint exiting";
		};
	};

	//variable setup
		//dont care about performance or I will go insane
	_nearUnits = allUnits select { _x distance _rallypointPosATL < _radius };
	_nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
	_nearEnemiesNumber = count _nearEnemies;
	_nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
	_nearFriendliesNumber = count _nearFriendlies;
	private _nearFriendliesNumberWeighted = _nearFriendliesNumber * TAS_rallyOutnumberFactor;

	//check if overrun
	if (_nearEnemiesNumber > _nearFriendliesNumberWeighted) then {

		if (_debug) then {
			systemChat "rallypoint c";
		};

		//overrun
		private _overrunActive = true;
		private _timeRemaining = TAS_rallyOverrunTimer;
		while {_overrunActive && { (_timeRemaining > 0) && { _rallyStillExists } } } do {

			if (_debug) then {
				systemChat "rallypoint d";
			};

			_rallyStillExistsCheck = [TAS_rallypointLocations, _rallypointPosATL] call BIS_fnc_findNestedElement;
			if (_rallyStillExistsCheck isEqualTo []) exitWith {
				//rally location has been updated!
				_rallyStillExists = false;
				if (_debug) then {
					systemChat "rallypoint exiting";
				};
			};
			
			private _msg = format ["The Golf Rallypoint at grid reference %1 is in danger of being overrun!\n\nNearby Friendlies: %2\nNearby Enemies: %3\n\nTime left until Rallypoint is overrun: %4", mapGridPosition _rallypointPosATL,_nearFriendliesNumber,_nearEnemiesNumber,[((_timeRemaining)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
			_msg remoteExec ["hint"];
			sleep TAS_rallyOverrunInterval;
			_timeRemaining = _timeRemaining - TAS_rallyOverrunInterval;

			//check if overrun is canceled
			_nearEnemies = allUnits select {alive _x && { _x distance _rallypointPosATL < _radius && { side _x in _enemySides } } };
			_nearEnemiesNumber = count _nearEnemies;
			_nearFriendlies = allUnits select {alive _x && { _x distance _rallypointPosATL < _radius && { side _x == _friendlySide } } }; //limitation: does not account for multiple friendlysides
			_nearFriendliesNumber = count _nearFriendlies;
			_nearFriendliesNumberWeighted = _nearFriendliesNumber * TAS_rallyOutnumberFactor;
			if !(_nearEnemiesNumber > _nearFriendliesNumberWeighted) then {
				_overrunActive = false;
			};
		};

		if (_debug) then {
			systemChat "rallypoint e";
		};

		_rallyStillExistsCheck = [TAS_rallypointLocations, _rallypointPosATL] call BIS_fnc_findNestedElement;
		if (_rallyStillExistsCheck isEqualTo []) exitWith {
			//rally location has been updated!
			_rallyStillExists = false;
			if (_debug) then {
				systemChat "rallypoint exiting";
			};
		};

		if (_overrunActive) then {
			private _msg = format ["The Golf Rallypoint at grid reference %1 has been overrun!", mapGridPosition _rallypointPosATL];
			_msg remoteExec ["hint"];

			{_x setDamage 1} forEach TAS_rallypointGolf;
			//TAS_rallypointGolfRespawn call BIS_fnc_removeRespawnPosition;
			private _path = [TAS_rallypointLocations, "Golf Rallypoint"] call BIS_fnc_findNestedElement;
			private _indexOfOldRallyPair = _path select 0;
			TAS_rallypointLocations deleteAt _indexOfOldRallyPair;
		} else {
			private _msg = format ["The Golf Rallypoint at grid reference %1 is no longer in immediate danger of being overrrun!", mapGridPosition _rallypointPosATL];
			_msg remoteExec ["hint"];
		};
	};
	sleep TAS_rallyOverrunInterval;	//check condition for overrun event every config'd interval
};
