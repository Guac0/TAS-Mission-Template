
private _debug = true;
private _markers = [];
private _extracts = [];
{
	private _object = _x;
	_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _object) then {
		_marker = createMarkerLocal [format ["%1_Marker",_x],getPos _object];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTextLocal "Extraction Point";
		_marker SetMarkerTypeLocal "mil_start";
		_marker setMarkerAlpha 0; //broadcast
		_markers pushback _marker;

		_extracts pushBack _object;
	} else {
		//["fn_scavServerInit: missing at least one extraction point!",true] call TAS_fnc_error;
	};
} forEach ["TAS_extract_1","TAS_extract_2","TAS_extract_3","TAS_extract_4","TAS_extract_5","TAS_extract_6","TAS_extract_7","TAS_extract_8","TAS_extract_9","TAS_extract_10"];

//spawn objectives and make markers
//private _scavZone = triggerArea TAS_ScavZone_Marker;
private _centerZone = getMarkerPos "TAS_ScavZone_Marker";
private _buildings = _centerZone nearObjects ["Building",(getMarkerSize "TAS_ScavZone_Marker") select 0];
private _enterableBuildings = _buildings select {count ([_x] call BIS_fnc_buildingPositions) > 6};
private _objectivesToMake = TAS_scavNumberOfObjectives;
private _scavObjectives = [];
private _blacklistLocations = TAS_scavBlacklistLocations + _extracts;
private _attemptsRemaining = _objectivesToMake * 10;

if (_debug) then {
	[format ["fn_scavServerInit enterable buildings: %1",_enterableBuildings],true] call TAS_fnc_error;
};

while {(_objectivesToMake > 0) && (_attemptsRemaining > 0)} do { //dont get caught in a forever loop

	if (_debug) then {
		[format ["fn_scavServerInit attempting to find location for objective %1 attempt %2",(_objectivesToMake - TAS_scavNumberOfObjectives) * -1,(_attemptsRemaining - 100) * -1],true] call TAS_fnc_error;
	};

	private _potentialObjective = selectRandom _enterableBuildings;
	private _isSuitable = true;

	{
		if (_x distance _potentialObjective < TAS_scavObjectiveDistanceThreshold) then {
			_isSuitable = false;
			if (_debug) then {
				[format ["fn_scavServerInit building is not suitable due to objective blacklist: %1",_x distance _potentialObjective < TAS_scavObjectiveDistanceThreshold],true] call TAS_fnc_error;
			};
		};
	} forEach _blacklistLocations;

	if ({_x distance _potentialObjective < TAS_scavPlayerDistanceThreshold} count allPlayers > 0) then { //don't create an objective if players are nearby 
		_isSuitable = false;
		if (_debug) then {
			[format ["fn_scavServerInit building is not suitable due to player blacklist: %1",{_x distance _potentialObjective < TAS_scavPlayerDistanceThreshold} count allPlayers],true] call TAS_fnc_error;
		};
	};

	if (_isSuitable) then {
		if (_debug) then {
			[format ["fn_scavServerInit building is suitable!"],true] call TAS_fnc_error;
		};

		private _objectiveBox = createVehicle ["VirtualReammoBox_camonet_F",(_potentialObjective buildingPos 0),[],0,"CAN_COLLIDE"]; //empty cache
		_objectiveBox addItemCargoGlobal ["TAS_RationPizza", TAS_scavStartingValuables];
		_objectiveBox allowDamage false;
		private _objectiveGroupGuard = createGroup east;
		private _objectiveGroupPatrol = createGroup east;
		for "_i" from 1 to 6 do {
			private _unit = _objectiveGroupGuard createUnit ["O_Survivor_F", getPos _objectiveBox,[],0,"NONE"];
			[_unit] call TAS_fnc_scavLoadout;
		};
		for "_i" from 1 to 3 do {
			private _unit = _objectiveGroupPatrol createUnit ["O_Survivor_F", getPos _objectiveBox,[],0,"NONE"];
			[_unit] call TAS_fnc_scavLoadout;
		};
		[_objectiveGroupGuard, _objectiveBox, 10,[],true,false,2,false] call lambs_wp_fnc_taskGarrison;
		[_objectiveGroupPatrol, _objectiveBox, 50] call lambs_wp_fnc_taskPatrol;
		//todo enable dysim
		
		[_objectiveGroupGuard,_objectiveGroupPatrol] spawn { //heal units in case lambs teleport hurts them
			sleep 5;
			{
				private _group = _x;
				{
					[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
				} forEach (units _group);
			} forEach _this;
		};

		_marker = createMarkerLocal [format ["ScavObj_%1_Marker",_objectivesToMake],_objectiveBox];
		_marker setMarkerColorLocal "ColorPink";
		_marker setMarkerTextLocal "Cache Location";
		_marker SetMarkerTypeLocal "mil_destroy";
		_marker setMarkerAlpha 0; //broadcast
		_markers pushback _marker;
		
		_scavObjectives pushBack [_objectiveBox,[_objectiveGroupGuard,_objectiveGroupPatrol],_marker];
		_blacklistLocations pushBack _objectiveBox;

		_objectivesToMake = _objectivesToMake - 1;
		
	};

	_attemptsRemaining = _attemptsRemaining - 1;
};

if (_debug) then {
	[format ["fn_scavServerInit found objectives: %1",_scavObjectives],true] call TAS_fnc_error;
};

missionNamespace setVariable ["TAS_scavObjectives",_scavObjectives,true];
missionNamespace setVariable ["TAS_scavTaskMarkers",_markers,true];
missionNamespace setVariable ["TAS_scavExtracts",_extracts,true];

//spawn new objs as needed and create more markers