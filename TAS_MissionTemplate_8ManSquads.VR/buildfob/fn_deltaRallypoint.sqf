//script file that spawns a squad rallypoint, execVM'd from the SL that uses the action. Unique file for each squad.
//15 instances of first letter uppercase

//if (rallyDeltaUsed == nil) then {rallyDeltaUsed = false; publicVariable "rallyDeltaUsed";}; //if variable is nonexistant, create it (first time setup)

//_nearEntities = player nearEntities [["Man","Car","Tank"],150];
//_nearEnemies = player countEnemy _nearEntities;
private _friendlySide 			= side group player;
private _enemySides 			= [_friendlySide] call BIS_fnc_enemySides;
private _radius 				= TAS_rallyDistance; //parameter from initServer.sqf, default 150
private _nearUnits = allUnits select { _x distance _fobLocation < _radius };
private _nearEnemies = _nearUnits select {alive _x && { side _x in _enemySides && { !(_x getVariable ["ACE_isUnconscious",false]) } } };
private _nearEnemiesNumber = count _nearEnemies;
private _nearFriendlies = _nearUnits select {alive _x && { side _x == _friendlySide && { !(_x getVariable ["ACE_isUnconscious",false]) } } }; //limitation: does not account for multiple friendly sides
private _nearFriendliesNumber = count _nearFriendlies;
private _rallypointPosATL 		= getPosAtl player;

private _exit = false;
if (TAS_rallyOutnumber) then {
	if ( _nearEnemiesNumber > _nearFriendliesNumber) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies outnumber friendleis within %1m!",TAS_rallyDistance]};
} else {
	if ( _nearEnemiesNumber > 0 ) exitWith {_exit = true; systemChat format ["Rallypoint creation failure, enemies are within %1m!",TAS_rallyDistance]};
};
if (_exit) exitWith {};

if (TAS_rallyDeltaUsed == false) then { "rallypointDeltaMarker" setMarkerAlpha 1; };  //first time rally is created, set its marker to visible
if (TAS_rallyDeltaUsed == true) then {
	{deleteVehicle _x} forEach TAS_rallypointDelta;
	//TAS_rallypointDeltaRespawn call BIS_fnc_removeRespawnPosition;
	private _path = [TAS_rallypointLocations, "Delta Rallypoint"] call BIS_fnc_findNestedElement;
	private _indexOfOldRallyPair = _path select 0;
	TAS_rallypointLocations deleteAt _indexOfOldRallyPair;
}; //if rallypoint already exists, delete it so the new one can be spawned

//TAS_rallypointDeltaRespawn = [side player, getPos player, "Delta Rallypoint"] call BIS_fnc_addRespawnPosition; //not private so we can delete later
TAS_rallypointLocations pushBack [_rallypointPosATL,"Delta Rallypoint"];
publicVariable "TAS_rallypointLocations";
"rallypointDeltaMarker" setMarkerPos getPos player; //updates the rallypoint's position on map

if (TAS_useSmallRally == false) then {
	TAS_rallypointDelta = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointComposition.sqf"))] call BIS_fnc_ObjectsMapper; //not private so we can delete later
} else {
	TAS_rallypointDelta = [getPos player, getDir player, call (compile (preprocessFileLineNumbers "buildfob\rallypointSmallComposition.sqf"))] call BIS_fnc_ObjectsMapper;
}; //spawn the rallypoint composition, size depends on mission params in initServer

[player, format ["Delta rallypoint established by %1 at gridref %2.", name player, mapGridPosition player]] remoteExec ["sideChat", _friendlySide]; //tell everyone on same side about it

TAS_rallyDeltaUsed = true; //tell game that the squad's rally is used and so it must be deleted before being respawned
publicVariable "TAS_rallyDeltaUsed"; //might be unneccessary since only 1 person can be SL so don't need public, just exist on SL's machine
										//might also need TAS_rallypointDeltaRespawn and TAS_rallypointDelta to be public for functionality in case SL disconnects and is replaced
											//for now, keep local to current SL machine since it's an edge case and would use up much bandwidth to publicVariable

//systemChat "0";

if (TAS_rallypointOverrun) then {
	[_friendlySide,_enemySides,_radius,_nearEnemies,_nearFriendlies,_nearEnemiesNumber,_nearFriendliesNumber,_rallypointPosATL] spawn {
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
			_nearUnits = allUnits select { _x distance _fobLocation < _radius };
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
					
					private _msg = format ["The Delta Rallypoint at grid reference %1 is in danger of being overrun!\n\nNearby Friendlies: %2\nNearby Enemies: %3\n\nTime left until Rallypoint is overrun: %4", mapGridPosition _rallypointPosATL,_nearFriendliesNumber,_nearEnemiesNumber,[((_timeRemaining)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
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
					private _msg = format ["The Delta Rallypoint at grid reference %1 has been overrun!", mapGridPosition _rallypointPosATL];
					_msg remoteExec ["hint"];

					{_x setDamage 1} forEach TAS_rallypointDelta;
					//TAS_rallypointDeltaRespawn call BIS_fnc_removeRespawnPosition;
					private _path = [TAS_rallypointLocations, "Delta Rallypoint"] call BIS_fnc_findNestedElement;
					private _indexOfOldRallyPair = _path select 0;
					TAS_rallypointLocations deleteAt _indexOfOldRallyPair;
				} else {
					private _msg = format ["The Delta Rallypoint at grid reference %1 is no longer in immediate danger of being overrrun!", mapGridPosition _rallypointPosATL];
					_msg remoteExec ["hint"];
				};
			};
			sleep TAS_rallyOverrunInterval;	//check condition for overrun event every config'd interval
		};
	};
};
