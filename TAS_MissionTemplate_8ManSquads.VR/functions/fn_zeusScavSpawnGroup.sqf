params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_numberUnits",
		"_side",
		"_magazines",
		"_grenades",
		"_changeSkill"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	if (count _side > 1) exitWith {["Error when executing Zeus Spawn Scav Group module: select only 1 side!",false] call TAS_fnc_error};
	_side = _side select 0;
	private _group = createGroup _side;
	private _unitClass = "dummy";
	switch {_side} do {
		case west: { _unitClass = "B_Survivor_F" };
		case independent: { _unitClass = "I_Survivor_F" };
		case east: { _unitClass = "O_Survivor_F" };
		case civilian: { _unitClass = "C_man_1" }; //nonhostile
		default { _unitClass = "I_Survivor_F" };
	};

	[format ["TAS_fnc_zeusSpawnScavGroup executing with side %1, group %2, unitClass %3, number of units %4, and position %5!",_side,_group,_unitClass,_numberUnits,_pos]] call TAS_fnc_error;

	for "_i" from 1 to _numberUnits do {
		//private _safeSpawnpoint = [_pos, 0, 10, 1] call BIS_fnc_findSafePos; //spawn units around building
		private _unit = _group createUnit [_unitClass, _pos,[],0,"NONE"]; //they'll spawn on top of each other but oh well. assume that zeus will choose a good position.
		//_unit allowDamage false;
		[_unit,_magazines,_radio,_grenades,_changeSkill] call TAS_fnc_scavLoadout;
	};

	_group setFormation "DIAMOND";
	
	private _groupID = groupID _group;
	_group setGroupIdGlobal [format ["%1 [Scavs]",_groupID]];

};

[
	"Spawn Scav Group", 
	[
		["SLIDER", ["Number of units", ""], [1,20,5,0]],	//min 1 mag, max 20 mags, default 5 mags, 0 decimal places
		["SIDES", ["Select 1", "Only the first selected side will be taken into account."], [east]],
		["SLIDER", ["Primary weapon magazines", ""], [1,20,8,0]],	//min 1 mag, max 20 mags, default 5 mags, 0 decimal places
		["TOOLBOX:YESNO", ["Give grenades?", "2x V40s, 2x white smoke, 2x chemlights"], false],
		["TOOLBOX:YESNO", ["Apply TAS_scavSkill?", "Does not apply to players."], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;