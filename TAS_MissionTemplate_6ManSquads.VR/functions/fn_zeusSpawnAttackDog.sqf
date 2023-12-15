//Attack dog script by BenfromTTG found via Bassbeard's Wonder Emporium with minimal edits
	//https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em
params ["_pos","_unit"];

["Side Selector",[
	["SIDES", ["", "Only the first selected side will be taken into account."], [east]],
	["SLIDER", ["Search Radius", "The dogs will search within given radius for targets."], [0, 1000, 100, 0]],
	["SLIDER", ["Dog Damage", "How much damage should give."], [0, 25, 3, 2]],
	["CHECKBOX", ["Attack all sides", "Allows the dog to attack all sides."], false],
	["CHECKBOX", ["Spawn with Lightning", "Spawns lightning at the dog's spawn location."], false]
],
{
	params ["_results","_pos"];
	_results params ["_sides", "_radius", "_damage", "_allowAttackSides","_doLightning"];

	if (_sides isEqualTo []) exitWith {
		["You must select a side!"] call zen_common_fnc_showMessage;
	};

	private _grp = createGroup (_sides select 0);
	private _dog = _grp createUnit ["Fin_random_F", _pos, [], 0, "CAN_COLLIDE"];
	_dog setPosATL [_pos select 0, _pos select 1, 0.3];
	[_grp] joinSilent _dog;
	[_dog, ["dog_spawn_in", 50]] remoteExec ["say3D", 0, true];
	if (_doLightning) then {
		private _lightning = createVehicle ["Lightning1_F", position _dog, [], 0, "CAN_COLLIDE"];

		[{deleteVehicle _this;}, _lightning, 1] call CBA_fnc_waitAndExecute;
	};

	_dog setVariable ["BIS_fnc_animalBehaviour_disable", false];

	{
		_x addCuratorEditableObjects [[_dog], true];
	} forEach allCurators;

	_dog playMove "Dog_Run";
	_dog setName selectRandom ["Fluffy","Susian","Cuddles","Santa's Little Helper","Biter","Foxer","Boxy","Death","TopKek","Rabit","Cuddles","SirKillALot","Dogga","Digga"];
	
	[{
		params ["_args", "_handleID"];
		_args params ["_dog", "_radius", "_damage", "_allowAttackSides"];

		if (!alive _dog) exitWith {
			[_handleID] call CBA_fnc_removePerFrameHandler;
		};
		private _manList = (getPos _dog) nearEntities ["Man", _radius];
		private _dogNearestEnemyList = if (_allowAttackSides) then {_manList select {(side _x != sideLogic) && (side _x != sideAmbientLife) && (side _x != sideEmpty)};} else {_manList select {(side _x != side _dog) && (side _x != civilian) && (side _x != sideLogic) && (side _x != sideAmbientLife) && (side _x != sideEmpty)};};
		private _dogNearestEnemy = _dogNearestEnemyList select 0;

		if (!isNull _dogNearestEnemy) then {
			_dog setDir (_dog getDir _dogNearestEnemy);

			private _distance = _dog distance _dogNearestEnemy;

			if (_distance < 3) then {
				private _enemyPos = getPos _dogNearestEnemy;
				private _newPos = _enemyPos set [1, ((_enemyPos select 1) + 1)];
				_dog setPos (_newPos);
				_dog playMove "Dog_Sit";
				playSound3D ["A3\Sounds_F\ambient\animals\dog3.wss", _dog, false, getPosASL _dog, 15, 0.5, 100];
				private _bodyPart = selectRandom ["LeftArm", "RightArm", "LeftLeg", "RightLeg"];
				[_dogNearestEnemy, _damage, _bodyPart, "stab"] remoteExec ["ace_medical_fnc_addDamageToUnit", _dogNearestEnemy, true];
			};

			if (_distance >= 15) then {
				_dog playMove "Dog_Sprint";
			};

			if (_distance > 5 && {_distance < 15}) then {
				_dog playMove "Dog_Run";
			};

			if (_distance > 3 && {_distance < 5}) then {
				_dog playMove "Dog_Walk";
			};

			_dog move (getPos _dogNearestEnemy);
		};
	}, 3, [_dog, _radius, _damage, _allowAttackSides]] call CBA_fnc_addPerFrameHandler;
},
{
	["Aborted"] call zen_common_fnc_showMessage;
	playSound "FD_Start_F";
}, _pos] call zen_dialog_fnc_create;
