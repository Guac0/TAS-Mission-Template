private _debug = false;

if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers starting while loop!"],true] call TAS_fnc_error };

while {true} do {
	private _groupsRoamersSmall = missionNamespace getVariable ["TAS_scavRoamerGroupsSmall",[]]; //grab it again each loop in case we need to update
	private _groupsRoamersBig = missionNamespace getVariable ["TAS_scavRoamerGroupsBig",[]];
	private _numberRoamersSmall = TAS_scavRoamersSmall;
	private _numberRoamersBig = TAS_scavRoamersBig;
	private _roamerGroupsSmall = []; //rebuild known good groups
	private _roamerGroupsBig = [];

	if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers starting scan!"],true] call TAS_fnc_error };
	
	{
		private _group = _x;
		if !(isNull _group) then {
			if !((count (units _group)) == 0) then { //group needs to exist and have at least 1 unit to be good
				// check if it has any alive units before marking it as good
				private _isGood = false;
				{
					private _unit = _x;
					if (alive _unit) then {
						_isGood = true;
					};
				} forEach (units _group);
				if (_isGood) then { 
					if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers small roamer group is not null and has %1 units and at least some are alive!",count (units _x)],true] call TAS_fnc_error };
					_roamerGroupsSmall pushBack _group;
				};
				
				if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers small roamer group is not null and has %1 units!",count (units _x)],true] call TAS_fnc_error };
			} else {
				if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers small roamer group has 0 units!"],true] call TAS_fnc_error };
			};

		} else {
			if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers small roamer group is null!"],true] call TAS_fnc_error };
		};
	} forEach _groupsRoamersSmall;
	{
		private _group = _x;
		if !(isNull _group) then {
			if !((count (units _group)) == 0) then { //group needs to exist and have at least 1 unit to be good
				// check if it has any alive units before marking it as good
				private _isGood = false;
				{
					private _unit = _x;
					if (alive _unit) then {
						_isGood = true;
					};
				} forEach (units _group);
				if (_isGood) then { 
					if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers Big roamer group is not null and has %1 units and at least some are alive!",count (units _x)],true] call TAS_fnc_error };
					_roamerGroupsBig pushBack _group;
				};
				
				if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers Big roamer group is not null and has %1 units!",count (units _x)],true] call TAS_fnc_error };
			} else {
				if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers Big roamer group has 0 units!"],true] call TAS_fnc_error };
			};

		} else {
			if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers Big roamer group is null!"],true] call TAS_fnc_error };
		};
	} forEach _groupsRoamersBig;

	if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers small roamers groups found: %1. Small roamer groups expected: %2",_roamerGroupsSmall,_numberRoamersSmall],true] call TAS_fnc_error };
	if ((count _roamerGroupsSmall) < _numberRoamersSmall) then {
		private _difference = _numberRoamersSmall - (count _roamerGroupsSmall);
		while {_difference > 0} do {
			private _group = [true] call TAS_fnc_scavSpawnRoamers; //can be null if doesnt find an acceptable spawnpoint
			if (_group isNotEqualTo "dummy") then {
				_roamerGroupsSmall pushBack _group;
				_difference = _difference - 1;
			};
			if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers difference found, spawning new roamers of %1!",_group],true] call TAS_fnc_error };
		};
	};
	if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers Big roamers groups found: %1. Big roamer groups expected: %2",_roamerGroupsBig,_numberRoamersBig],true] call TAS_fnc_error };
	if ((count _roamerGroupsBig) < _numberRoamersBig) then {
		private _difference = _numberRoamersBig - (count _roamerGroupsBig);
		while {_difference > 0} do {
			private _group = [false] call TAS_fnc_scavSpawnRoamers; //can be null if doesnt find an acceptable spawnpoint
			if (_group isNotEqualTo "dummy") then {
				_roamerGroupsBig pushBack _group;
				_difference = _difference - 1;
			};
			if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers difference found, spawning new roamers of %1!",_group],true] call TAS_fnc_error };
		};
	};

	//update groups
	missionNamespace setVariable ["TAS_scavRoamerGroupsSmall",_roamerGroupsSmall,true];
	missionNamespace setVariable ["TAS_scavRoamerGroupsBig",_roamerGroupsBig,true];

	if (_debug) then { [format ["TAS_fnc_scavRespawnRoamers updating variables and sleeping for %1!",TAS_scavSleepInterval],true] call TAS_fnc_error };

	sleep TAS_scavSleepInterval;
};