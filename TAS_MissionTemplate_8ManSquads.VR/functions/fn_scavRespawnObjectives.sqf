

while {true} do {
	private _objectives = missionNamespace getVariable ["TAS_scavObjectives",[]]; //grab it again each loop in case we need to update
	private _outdatedObjectives = [];
	private _newObjectives = [];
	private _guardSide = TAS_scavAiSide;
	private ["_guardClass"];
	switch (_guardSide) do //need to spawn classnames from the corressponding side
	{
		case west: { _guardClass = "B_Survivor_F" };
		case independent: { _guardClass = "I_Survivor_F" };
		case east: { _guardClass = "O_Survivor_F" };
		case civilian: { _guardClass = "C_man_1" }; //todo find classname of looters
		default { _guardClass = "I_Survivor_F" };
	};

	{
		
		//if number of pizzas is less than starting #:
			//check if no players within threshold
				//restock box, delete and respawn guards, update obj array?
		private _box = _x select 0;
		private _groups = _x select 1;
		private _marker = _x select 2;
		private _needToRespawn = false;
		private _objectiveGroupGuard = _groups select 0;
		private _objectiveGroupGuard = _groups select 1;
		private _objectiveGroupPatrol = _groups select 2;

		private _inventory = getItemCargo _box;
		private _path = [_inventory, "TAS_RationPizza"] call BIS_fnc_findNestedElement;
		private _numberPizzas = (_inventory select 1) select (_path select 1);
		if (_numberPizzas < TAS_scavStartingValuables) then {
			//some of the pizzas are missing, so there's definitely been players here.
			_needToRespawn = true;
		} else {
			//no pizzas are misisng, but let's check if we need to respawn some of the guards (i.e. wandering PMCs got them)
			private _iterations = 0;
			{
				_iterations = _iterations + 1;
				if (isNull _x) then { //if group doesnt exist (garbage collector), then respawn. i mean, prob wont get ran at all, so check elsewhere
					_needToRespawn = true;
				};
				if (units _x < 1) then { //if there's no units (aka garbage collector grabbed them) then need to respawn them
					_needToRespawn = true;
				};
				{
					if !(alive _x) then {
						_needToRespawn = true;
					};
				} forEach (units _x);
			} forEach _groups;

			if (iterations < 3) then { //we expect to check 3 groups. if we check less than that, then some are deleted and thus need to be respawned
				_needToRespawn = true;
			};
		};

		//don't need to restock pizzas, but do need to respawn groups
		if (_needToRespawn) then {
			if ({_x distance _box < TAS_scavPlayerDistanceThreshold} count allPlayers > 0) then {
				clearItemCargoGlobal _box;
				_box addItemCargoGlobal ["TAS_RationPizza", TAS_scavStartingValuables];

				//delete old groups 
				{
					[_group] call lambs_wp_fnc_taskReset;
					{
						deleteVehicle _x;
					} forEach (units _x);
					deleteGroup _x;
				} forEach _groups;

				//remake the groups
				private _objectiveGroupGuard = createGroup _guardSide;
				private _objectiveGroupCamp = createGroup _guardSide;
				private _objectiveGroupPatrol = createGroup _guardSide;
				private _newGroups = [_objectiveGroupGuard,_objectiveGroupCamp,_objectiveGroupPatrol];
				private _campLocation = [_objectiveBox, 5, 30, 3, 0, 0, 0, [], [getPos _objectiveBox, getPos _objectiveBox]] call BIS_fnc_findSafePos;
				for "_i" from 1 to 4 do {
					private _unit = _objectiveGroupGuard createUnit [_guardClass, getPos _objectiveBox,[],0,"NONE"];
					_unit allowDamage false;
					[_unit] call TAS_fnc_scavLoadout;
				};
				for "_i" from 1 to 3 do {
					private _unit = _objectiveGroupCamp createUnit [_guardClass, _campLocation,[],0,"NONE"];
					_unit allowDamage false;
					[_unit] call TAS_fnc_scavLoadout;
				};
				for "_i" from 1 to 3 do {
					private _unit = _objectiveGroupPatrol createUnit [_guardClass, _campLocation,[],0,"NONE"];
					_unit allowDamage false;
					[_unit] call TAS_fnc_scavLoadout;
				};
				[_objectiveGroupGuard, _objectiveBox, 10,[],true,false,2,false] call lambs_wp_fnc_taskGarrison;
				[_objectiveGroupCamp, _campLocation, 5, [], true, false] call lambs_wp_fnc_taskCamp;
				[_objectiveGroupPatrol, _objectiveBox, 50] call lambs_wp_fnc_taskPatrol;
				[_newGroups] spawn { //heal units in case lambs teleport hurts them
					params ["_groups"];
					sleep 5;
					{
						private _group = _x;
						{
							_x allowDamage true;
							[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
						} forEach (units _group);
						_x enableDynamicSimulation true;
					} forEach _groups;
				};

				_outdatedObjectives pushBack _x;
				_newObjectives pushBack [_box,_newGroups,_marker];
			};
		};

	} forEach _objectives;

	//update objectives. delete old and add new
	{
		_objectives = _objectives - [_x];
	} forEach _outdatedObjectives;
	{_objectives pushBack _x } forEach _newObjectives;
	missionNamespace setVariable ["TAS_scavObjectives",_objectives,true];

	sleep TAS_scavSleepInterval;
};