//Spawns one group of the specified type of roamers

params ["_isSmall"];

//setup
private _debug = false;
private _objectiveDistance = TAS_scavRoamersObjectiveDistance;
private _playerDistance = TAS_scavRoamersPlayerDistance;
private _centerZone = getMarkerPos "TAS_ScavZone_Marker";
private _zoneSize = getMarkerSize "TAS_ScavZone_Marker";
private _zoneArea = "TAS_ScavZone_Marker" call BIS_fnc_getArea;
private _scavObjectives = missionNamespace getVariable ["TAS_scavObjectives",[]];
private _blacklistLocations = TAS_scavBlacklistLocations + (missionNamespace getVariable ["TAS_scavExtracts",[]]);
private _enterableBuildings = missionNamespace getVariable ["TAS_scavEnterableBuildingsInAO",[]];
private ["_group"]; //predeclare for locality

private _guardSidePatrol = TAS_scavAiRoamerSide; //todo decide what side -- TAS_scavAiRoamerSide or TAS_scavAiSide
private _guardSideRoam = TAS_scavAiRoamerSide;
private ["_guardClassPatrol","_guardClassRoam"];
switch (_guardSidePatrol) do //need to spawn classnames from the corressponding side
{
	case west: { _guardClassPatrol = "B_Survivor_F" };
	case independent: { _guardClassPatrol = "I_Survivor_F" };
	case east: { _guardClassPatrol = "O_Survivor_F" };
	case civilian: { _guardClassPatrol = "C_man_1" }; //nonhostile
	default { _guardClassPatrol = "I_Survivor_F" };
};
switch (_guardSideRoam) do //need to spawn classnames from the corressponding side
{
	case west: { _guardClassRoam = "B_Survivor_F" };
	case independent: { _guardClassRoam = "I_Survivor_F" };
	case east: { _guardClassRoam = "O_Survivor_F" };
	case civilian: { _guardClassRoam = "C_man_1" }; //nonhostile
	default { _guardClassRoam = "I_Survivor_F" };
};

if (_isSmall) then {
	private _numberRoamersSmall = TAS_scavRoamersSmall;
	private _roamersSmallPatrolChance = TAS_scavRoamersSmallPatrolChance;

	private _attemptsRemaining = 10;
	private _isSuitable = false;

	while {!(_isSuitable) && (_attemptsRemaining > 0)} do {

		private _potentialSpawnpoint = [[_zoneArea]] call BIS_fnc_randomPos; //[[7212.49,5453.83,0],1200,1200,0,true,-1]
		_isSuitable = true;

		if (_debug) then {
			[format ["fn_scavSpawnRoamers attempting to find location for roamers group %1 attempt %2. Potential spawnpoint: %3",(_numberRoamersSmall - TAS_scavNumberOfObjectives) * -1,(_attemptsRemaining - 10) * -1,_potentialSpawnpoint],true] call TAS_fnc_error;
		};

		{
			if (_x distance _potentialSpawnpoint < _objectiveDistance) then {
				_isSuitable = false;
				if (_debug) then {
					[format ["fn_scavSpawnRoamers area is not suitable due to objective blacklist: %1",_x distance _potentialSpawnpoint < _objectiveDistance],true] call TAS_fnc_error;
				};
			};
		} forEach _blacklistLocations;

		if ({_x distance _potentialSpawnpoint < _playerDistance} count allPlayers > 0) then { //don't use spawnpoint if players are nearby 
			_isSuitable = false;
			if (_debug) then {
				[format ["fn_scavSpawnRoamers area is not suitable due to player blacklist: %1",{_x distance _potentialSpawnpoint < _playerDistance} count allPlayers],true] call TAS_fnc_error;
			};
		};

		if (_isSuitable) then {
			if (_debug) then {
				[format ["fn_scavSpawnRoamers area is suitable!"],true] call TAS_fnc_error;
			};

			private _isPatrol = true;
			if (floor(random 100) > _roamersSmallPatrolChance) then {
				_isPatrol = false;
			};
			if (_isPatrol) then {
				_group = createGroup _guardSidePatrol;
			} else {
				_group = createGroup _guardSideRoam;
			};

			private _safeSpawnpoint = [_potentialSpawnpoint, 0, 30, 3, 0, 0, 0, [], _potentialSpawnpoint] call BIS_fnc_findSafePos;
			private _numberUnits = floor(random(3)) + 1; //1-4 units
			for "_i" from 1 to _numberUnits do {
				private ["_unit"];
				if (_isPatrol) then {
					_unit = _group createUnit [_guardClassPatrol, _safeSpawnpoint,[],0,"NONE"];
				} else {
					_unit = _group createUnit [_guardClassRoam, _safeSpawnpoint,[],0,"NONE"];
				};
				//_unit allowDamage false;
				[_unit] call TAS_fnc_scavLoadout;
			};

			if (_isPatrol) then {

				//[_group, _potentialSpawnpoint, 50] call lambs_wp_fnc_taskPatrol;

				//select a few random houses, set them as move waypoints with a small timeout to simulate looting. stealth behavior?
				for "_i" from 1 to 4 do {
					_randomObj = selectRandom _enterableBuildings;
					_objPos = ASLToAGL (getPosASL _randomObj);
					private _waypoint = _group addWaypoint [_objPos, 0];
					_waypoint setWaypointType "MOVE";
					_waypoint setWaypointCompletionRadius 15; //prevent getting stuck in house since moving into house is iffy
					_waypoint setWaypointTimeout [15, 30, 60]; //stick around a little
				};
				_randomObj = selectRandom _enterableBuildings;
				_objPos = ASLToAGL (getPosASL _randomObj);
				private _waypoint = _group addWaypoint [_objPos, 0];
				_waypoint setWaypointType "CYCLE";

				_group setBehaviourStrong "STEALTH";

			} else {

				private _numObjs = count _scavObjectives;
				private _availableObjs = _scavObjectives;
				for "_i" from 1 to (_numObjs - 1) do {
					_randomObj = selectRandom _availableObjs;
					_randomObjLocation = getPos (_randomObj select 0); //the objective box
					_availableObjs = _availableObjs - _randomObj;
					private _waypoint = _group addWaypoint [_randomObj, 0];
					_waypoint setWaypointType "SAD"; //todo replace with move or taskCQB?
					//_waypoint setWaypointCompletionRadius 15; //will auto complete after search
					//_waypoint setWaypointTimeout [min, mid, max]; //will auto complete after search
				};
				private _randomObj = selectRandom _availableObjs;
				private _waypoint = _group addWaypoint [_randomObj, 0];
				_waypoint setWaypointType "CYCLE";

				_group setBehaviourStrong "COMBAT";
				
			};

			_group enableDynamicSimulation true;
			_group setFormation "DIAMOND";
			
		};

		_attemptsRemaining = _attemptsRemaining - 1;
		if (_attemptsRemaining == 0) then {
			[format ["fn_scavSpawnRoamers cannot find acceptable spawnpoint for scav group!"],true] call TAS_fnc_error;
		};
	};

} else {
	private _numberRoamersBig = TAS_scavRoamersBig;
	private _roamersBigPatrolChance = TAS_scavRoamersBigPatrolChance;

	private _attemptsRemaining = 10;
	private _isSuitable = false;

	while {!(_isSuitable) && (_attemptsRemaining > 0)} do {

		private _potentialSpawnpoint = [[_zoneArea]] call BIS_fnc_randomPos;
		_isSuitable = true;

		if (_debug) then {
			[format ["fn_scavSpawnRoamers attempting to find location for roamers group %1 attempt %2. Potential spawnpoint: %3",(_numberRoamersSmall - TAS_scavNumberOfObjectives) * -1,(_attemptsRemaining - 10) * -1,_potentialSpawnpoint],true] call TAS_fnc_error;
		};

		{
			if (_x distance _potentialSpawnpoint < _objectiveDistance) then {
				_isSuitable = false;
				if (_debug) then {
					[format ["fn_scavSpawnRoamers area is not suitable due to objective blacklist: %1",_x distance _potentialSpawnpoint < _objectiveDistance],true] call TAS_fnc_error;
				};
			};
		} forEach _blacklistLocations;

		if ({_x distance _potentialSpawnpoint < _playerDistance} count allPlayers > 0) then { //don't use spawnpoint if players are nearby 
			_isSuitable = false;
			if (_debug) then {
				[format ["fn_scavSpawnRoamers area is not suitable due to player blacklist: %1",{_x distance _potentialSpawnpoint < _playerDistance} count allPlayers],true] call TAS_fnc_error;
			};
		};

		if (_isSuitable) then {
			if (_debug) then {
				[format ["fn_scavSpawnRoamers area is suitable!"],true] call TAS_fnc_error;
			};

			private _isPatrol = true;
			if (floor(random 100) > _roamersBigPatrolChance) then {
				_isPatrol = false;
			};
			if (_isPatrol) then {
				_group = createGroup _guardSidePatrol;
			} else {
				_group = createGroup _guardSideRoam;
			};

			private _safeSpawnpoint = [_potentialSpawnpoint, 0, 30, 3, 0, 0, 0, [], _potentialSpawnpoint] call BIS_fnc_findSafePos;
			private _numberUnits = floor(random(3)) + 5; //5-8 units
			for "_i" from 1 to _numberUnits do {
				private ["_unit"];
				if (_isPatrol) then {
					_unit = _group createUnit [_guardClassPatrol, _safeSpawnpoint,[],0,"NONE"];
				} else {
					_unit = _group createUnit [_guardClassRoam, _safeSpawnpoint,[],0,"NONE"];
				};
				//_unit allowDamage false;
				[_unit] call TAS_fnc_scavLoadout;
			};

			if (_isPatrol) then {

				//[_group, _potentialSpawnpoint, 50] call lambs_wp_fnc_taskPatrol;

				//select a few random houses, set them as move waypoints with a small timeout to simulate looting. stealth behavior?
				for "_i" from 1 to 4 do {
					_randomObj = selectRandom _enterableBuildings;
					_objPos = ASLToAGL (getPosASL _randomObj);
					private _waypoint = _group addWaypoint [_objPos, 0];
					_waypoint setWaypointType "MOVE";
					_waypoint setWaypointCompletionRadius 15; //prevent getting stuck in house since moving into house is iffy
					_waypoint setWaypointTimeout [15, 30, 60]; //stick around a little
				};
				_randomObj = selectRandom _enterableBuildings;
				_objPos = ASLToAGL (getPosASL _randomObj);
				private _waypoint = _group addWaypoint [_objPos, 0];
				_waypoint setWaypointType "CYCLE";

				_group setBehaviourStrong "STEALTH";

			} else {

				private _numObjs = count _scavObjectives;
				private _availableObjs = _scavObjectives;
				for "_i" from 1 to (_numObjs - 1) do {
					private _randomObj = selectRandom _availableObjs;
					private _randomObjLocation = ASLToAGL (getPosASL (_randomObj select 0)); //the objective box
					_availableObjs = _availableObjs - _randomObj;
					private _waypoint = _group addWaypoint [_randomObjLocation, 0];
					_waypoint setWaypointType "SAD"; //todo replace with move or taskCQB?
					//_waypoint setWaypointCompletionRadius 15; //will auto complete after search
					//_waypoint setWaypointTimeout [min, mid, max]; //will auto complete after search
				};
				private _randomObj = selectRandom _availableObjs;
				private _randomObjLocation = ASLToAGL (getPosASL (_randomObj select 0));
				private _waypoint = _group addWaypoint [_randomObjLocation, 0];
				_waypoint setWaypointType "CYCLE";

				_group setBehaviourStrong "COMBAT";
				
			};

			_group enableDynamicSimulation true;
			_group setFormation "DIAMOND";
			
		};

		_attemptsRemaining = _attemptsRemaining - 1;
		if (_attemptsRemaining == 0) then {
			[format ["fn_scavSpawnRoamers cannot find acceptable spawnpoint for scav group!"],true] call TAS_fnc_error;
		};
	};
};

if (isNil "_group") then {
	_group = "dummy"; //idk. maybe do recursive?
};

if (_debug) then { [format ["TAS_fnc_scavSpawnRoamers returning with a value of %1",_group],true] call TAS_fnc_error };
//return the created group. it's up to the caller to update TAS_scavRoamerGroupsSmall
//as that allows for performance/network optimizations if creating multiple in short succession
_group