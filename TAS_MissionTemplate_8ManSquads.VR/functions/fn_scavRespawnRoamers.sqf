

while {true} do {
	private _groupsRoamersSmall = missionNamespace getVariable ["TAS_scavRoamerGroupsSmall",[]]; //grab it again each loop in case we need to update
	private _groupsRoamersBig = missionNamespace getVariable ["TAS_scavRoamerGroupsBig",[]];
	private _numberRoamersSmall = TAS_scavRoamersSmall;
	private _numberRoamersBig = TAS_scavRoamersBig;
	private _roamerGroupsSmall = []; //rebuild known good groups
	private _roamerGroupsBig = [];

	{
		if !(isNull _x) then {
			if !((count(units _x)) == 0) then { //group needs to exist and have at least 1 unit to be good
				_roamerGroupsSmall pushBack _x;
			};
		};
	} forEach _groupsRoamersSmall;
	{
		if !(isNull _x) then {
			if !((count(units _x)) == 0) then {
				_roamerGroupsBig pushBack _x;
			};
		};
	} forEach _groupsRoamersBig;

	if ((count _roamerGroupsSmall) < _numberRoamersSmall) then {
		private _difference = (count _roamerGroupsSmall) - _goodGroupsSmall;
		while {_difference > 0} do {
			private _group = [true] call TAS_fnc_scavSpawnRoamers; //can be null if doesnt find an acceptable spawnpoint
			if (_group isNotEqualTo "dummy") then {
				_roamerGroupsSmall pushBack _group;
				_difference = _difference - 1;
			};
		};
	};
	if ((count _roamerGroupsBig) < _numberRoamersBig) then {
		private _difference = (count _roamerGroupsBig) - _goodGroupsBig;
		while {_difference > 0} do {
			private _group = [true] call TAS_fnc_scavSpawnRoamers; //can be null if doesnt find an acceptable spawnpoint
			if (_group isNotEqualTo "dummy") then {
				_roamerGroupsBig pushBack _group;
				_difference = _difference - 1;
			};
		};
	};

	//update groups
	missionNamespace setVariable ["TAS_scavRoamerGroupsSmall",_roamerGroupsSmall,true];
	missionNamespace setVariable ["TAS_scavRoamerGroupsBig",_roamerGroupsBig,true];

	sleep TAS_scavSleepInterval;
};