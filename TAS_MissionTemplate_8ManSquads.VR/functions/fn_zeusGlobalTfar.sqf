params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_input"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	remoteExecCall ["TAS_fnc_globalTfar", 2];

};

[
	"Toggle Global TFAR", 
	[
		["EDIT","Place module to toggle global TFAR",[format ["Currently activated: %1",missionNamespace getVariable ["playersRadioGlobal", false]]]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;