

while {true} do {
	private _objectives = missionNamespace getVariable ["TAS_scavObjectives",[]];
	
	{
		
		//if number of pizzas is less than starting #:
			//check if no players within threshold
				//restock box, delete and respawn guards, update obj array?
		private _box = _x select 0;
		private _groups = _x select 1;
		private _marker = _x select 2;
		private _needToRespawn = false;
		private _objectiveGroupGuard = _groups select 0;
		private _objectiveGroupPatrol = _groups select 1;

		private _inventory = getItemCargo _box;
		private _path = [_inventory, "TAS_RationPizza"] call BIS_fnc_findNestedElement;
		private _numberPizzas = (_inventory select 1) select (path select 1);
		if (_numberPizzas < TAS_scavStartingValuables) then {
			//some of the pizzas are missing, so there's definitely been players here.
			_needToRespawn = true;
		} else {
			//no pizzas are misisng, but let's check if we need to respawn some of the guards (i.e. wandering PMCs got them)
			{
				{
					if !(alive _x) then {
						_needToRespawn = true;
					};
				} forEach (units _x);
			} forEach _groups;
		};

		//don't need to restock pizzas, but do need to respawn groups
		if (_needToRespawn) then {
			if ({_x distance _box < TAS_scavPlayerDistanceThreshold} count allPlayers <= 0) then {
				clearItemCargoGlobal _box;
				_box addItemCargoGlobal ["TAS_RationPizza", TAS_scavStartingValuables];

				{
					[_group] call lambs_wp_fnc_taskReset;
					{
						deleteVehicle _x;
					} forEach (units _x);
				} forEach _groups;

				for "_i" from 1 to 6 do {
					private _unit = _objectiveGroupGuard createUnit ["O_Survivor_F", getPos _objectiveBox,[],0,"NONE"];
					[_unit] call TAS_fnc_scavLoadout;
				};
				for "_i" from 1 to 3 do {
					private _unit = _objectiveGroupPatrol createUnit ["O_Survivor_F", getPos _objectiveBox,[],0,"NONE"];
					[_unit] call TAS_fnc_scavLoadout;
				};

				[_objectiveGroupGuard, _box, 10,[],true,false,2,false] call lambs_wp_fnc_taskGarrison;
				[_objectiveGroupPatrol, _box, 50] call lambs_wp_fnc_taskPatrol;

				[_objectiveGroupGuard,_objectiveGroupPatrol] spawn { //heal units in case lambs teleport hurts them
					sleep 5;
					{
						private _group = _x;
						{
							[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
						} forEach (units _group);
					} forEach _this;
				};
			};
		};

	} forEach _objectives;

	sleep TAS_scavSleepInterval;
};