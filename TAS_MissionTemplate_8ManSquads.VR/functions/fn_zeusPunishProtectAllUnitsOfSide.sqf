params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _debug = false;
if (_debug) then { systemChat format ["Starting fn_zeusPunishProtectAllUnitsOfSide with %1 and %2",_pos,_unit]; };

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_sides"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	if (_debug) then { systemChat format ["Starting fn_zeusPunishPlayer onConfirm with %1 and %2",_sides]; };
	
	{
		private _side = _x;
		{ if (side _x == _side) then { [_x] remoteExec ["TAS_fnc_punishCivKillerServer",_x] } } forEach allUnits;
	} forEach _sides;

	systemChat "Units have been added to protected list!";

};

[
	"Note: new units will not be protected, only existing ones.", 
	[
		["SIDES",["Choose sides to protect:"]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;