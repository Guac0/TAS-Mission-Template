params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the scav loadout zeus module on the object that you wish to equip with a scav loadout!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusScavLoadout was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_numberUnits",
		"_side"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	private _group = createGroup _side;
	private _unitClass = "dummy";
	switch {_side} do {
		case west: { _unitClass = "B_Survivor_F" };
		case independent: { _unitClass = "I_Survivor_F" };
		case east: { _unitClass = "O_Survivor_F" };
		case civilian: { _unitClass = "C_man_1" }; //nonhostile
		default { _unitClass = "I_Survivor_F" };
	};

	for "_i" from 1 to _numberUnits do {
		private _safeSpawnpoint = [_pos, 0, 10, 1] call BIS_fnc_findSafePos; //spawn units around building
		private _unit = _group createUnit [_unitClass, _safeSpawnpoint,[],0,"NONE"];
		//_unit allowDamage false;
		[_unit] call TAS_fnc_scavLoadout;
	};

	_group setFormation "DIAMOND";
	
	private _groupID = groupID _group;
	_group setGroupIdGlobal [format ["%1 [Scavs]",_groupID]];

};

[
	"Spawn Scav Group", 
	[
		["SLIDER", ["Number of units", ""], [1,20,5,0]],	//min 1 mag, max 20 mags, default 5 mags, 0 decimal places
		["SIDES", ["Select 1", "Only the first selected side will be taken into account."], [east]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;