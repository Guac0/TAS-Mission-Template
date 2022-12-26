while {!(TAS_fobDestroyed)} do {
	/*private _nearUnits = nearestObjects [TAS_fobPositionATL, ["Man"], TAS_fobOverrunDistance];	//wont find vehicles/infantry in vehicles!
	private _nearUnitsAlive = [];
	{ if (alive _x ) then { _nearUnitsAlive set [(count _nearUnitsAlive), _x]; }; } forEach _nearUnits;
	private _nearEnemies = 
	TAS_fobPositionATL*/

	//variable setup
		//dont care about performance or I will go insane
	private _friendlySide = TAS_fobSide;
	private _enemySides = [_friendlySide] call BIS_fnc_enemySides;
	private _fobLocation = TAS_fobPositionATL;
	private _radius = TAS_fobOverrunDistance; //parameter from initServer.sqf, default 300
	private _nearEnemies = allUnits select {alive _x && { _x distance _fobLocation < _radius && { side _x in _enemySides } } };
	private _nearEnemiesNumber = count _nearEnemies;
	private _nearFriendlies = allUnits select {alive _x && { _x distance _fobLocation < _radius && { side _x == _friendlySide } } }; //limitation: does not account for multiple friendlysides
	private _nearFriendliesNumber = count _nearFriendlies;

	//account for mission setting overrun factor
	private _nearFriendliesNumberWeighted = _nearFriendliesNumber * TAS_fobOverrunFactor;

	//check if overrun
	if (_nearEnemiesNumber > _nearFriendliesNumberWeighted) then {
		//overrun
		private _overrunActive = true;
		private _timeRemaining = TAS_fobOverrunTimer;
		while (_overrunActive && (_timeRemaining > 0)) do {
			private _msg = format ["The Forward Operating Base at grid reference %1 is in danger of being overrun!\n\nNearby Friendlies: %2\nNearby Enemies: %3\n\nTime left until FOB is abandoned: %4", mapGridPosition TAS_fobPositionATL,_nearFriendliesNumber,_nearEnemiesNumber,_timeRemaining];
			_msg remoteExec ["hint"];
			sleep TAS_fobOverrunInterval;
			_timeRemaining = _timeRemaining - TAS_fobOverrunInterval;

			//check if overrun is canceled
			private _nearEnemies = allUnits select {alive _x && { _x distance _fobLocation < _radius && { side _x in _enemySides } } };
			private _nearEnemiesNumber = count _nearEnemies;
			private _nearFriendlies = allUnits select {alive _x && { _x distance _fobLocation < _radius && { side _x == _friendlySide } } }; //limitation: does not account for multiple friendlysides
			private _nearFriendliesNumber = count _nearFriendlies;
			private _nearFriendliesNumberWeighted = _nearFriendliesNumber * TAS_fobOverrunFactor;
			if !(_nearEnemiesNumber > _nearFriendliesNumberWeighted) then {
				_overrunActive = false;
			};
		};
		if (_overrunActive) then {
			private _msg = format ["The Forward Operating Base at grid reference %1 has been overrun!", mapGridPosition TAS_fobPositionATL];
			_msg remoteExec ["hint"];
			TAS_fobBuilt = false;
			publicVariable "TAS_fobBuilt";
			TAS_fobDestroyed = true;
			publicVariable "TAS_fobDestroyed";

			//DESTROY FOB
			//hide marker and reset to origin
			"fobMarker" setMarkerAlpha 0.5;
			"fobMarker" setMarkerColor "ColorGrey";
			//"fobMarker" setMarkerPos [0,0,0];

			//clean up objects
			//{deleteVehicle _x} forEach TAS_fobObjects;

			//disable arsenals but keep normal inventories
			private _fobArsenals = nearestObjects [_fobLocation, ["B_CargoNet_01_ammo_F"], 25]; 
			if (TAS_fobFullArsenals) then { //full arsenals
				{
					[_x, true] call ace_arsenal_fnc_removeBox;
					//["AmmoboxInit",[_x,true]] call BIS_fnc_arsenal;
				} forEach _fobArsenals;
			};

			//remove respawn GUI stuff
			//TAS_rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;
			if (TAS_fobRespawn) then {
				TAS_fobRespawn call BIS_fnc_removeRespawnPosition;
			};
			private _path = [TAS_rallypointLocations, "Forward Operating Base"] call BIS_fnc_findNestedElement;
			private _indexOfOldRallyPair = _path select 0;
			TAS_rallypointLocations deleteAt _indexOfOldRallyPair;
		} else {
			private _msg = format ["The Forward Operating Base at grid reference %1 is no longer in immediate danger of being overrrun!", mapGridPosition TAS_fobPositionATL];
			_msg remoteExec ["hint"];
		};
	};
	sleep TAS_fobOverrunInterval;	//check condition for overrun event every config'd interval
};




//hint parseText "<img image='f4.jpg' <img size='20' /> ";