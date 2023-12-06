//Spawns one group of the specified type of roamers

params ["_isSmall"];

//setup
private _debug = false;
private _objectiveDistance = TAS_scavRoamersObjectiveDistance;
private _playerDistance = TAS_scavRoamersPlayerDistance;
private _centerZone = getMarkerPos TAS_scavAoMarker;
private _zoneSize = getMarkerSize TAS_scavAoMarker;
private _zoneArea = TAS_scavAoMarker call BIS_fnc_getArea;
private _scavObjectives = missionNamespace getVariable ["TAS_scavObjectives",[]];
private _blacklistLocations = missionNamespace getVariable ["TAS_scavAllBlacklists",[]];
private _enterableBuildings = missionNamespace getVariable ["TAS_scavEnterableBuildingsInAO",[]];
private ["_group"]; //predeclare for locality

if (_debug) then {
	[format ["fn_scavSpawnRoamers blacklist locations: %3",_blacklistLocations],true] call TAS_fnc_error;
};

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

	private _spawnBuilding = [] call TAS_fnc_scavFindSuitableBuilding;

	private _isPatrol = true;
	if (floor(random 100) > _roamersSmallPatrolChance) then {
		_isPatrol = false;
	};
	if (_isPatrol) then {
		_group = createGroup _guardSidePatrol;
	} else {
		_group = createGroup _guardSideRoam;
	};

	private _safeSpawnpoint = [_spawnBuilding, 10, 50, 3] call BIS_fnc_findSafePos; //spawn units around building
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

		//_group setBehaviourStrong "STEALTH";

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

	//_group enableDynamicSimulation true;
	_group setFormation "DIAMOND";
	
	private _groupID = groupID _group;
	_group setGroupIdGlobal [format ["%1 [Small Roamer]",_groupID]];

} else {
	private _numberRoamersBig = TAS_scavRoamersBig;
	private _roamersBigPatrolChance = TAS_scavRoamersBigPatrolChance;

	private _spawnBuilding = [] call TAS_fnc_scavFindSuitableBuilding;

	private _isPatrol = true;
	if (floor(random 100) > _roamersBigPatrolChance) then {
		_isPatrol = false;
	};
	if (_isPatrol) then {
		_group = createGroup _guardSidePatrol;
	} else {
		_group = createGroup _guardSideRoam;
	};

	private _safeSpawnpoint =[_spawnBuilding, 10, 50, 3] call BIS_fnc_findSafePos; //spawn units around building
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

		//_group setBehaviourStrong "STEALTH";

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

	//_group enableDynamicSimulation true;
	_group setFormation "DIAMOND";

	private _groupID = groupID _group;
	_group setGroupIdGlobal [format ["%1 [Large Roamer]",_groupID]];
	
};

if (isNil "_group") then {
	_group = "dummy"; //idk. maybe do recursive?
};

if (_debug) then { [format ["TAS_fnc_scavSpawnRoamers returning with a value of %1",_group],true] call TAS_fnc_error };
//return the created group. it's up to the caller to update TAS_scavRoamerGroupsSmall
//as that allows for performance/network optimizations if creating multiple in short succession
_group