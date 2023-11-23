params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rallypointInternalName",
		"_rallyMarkerName",
		"_customName"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[player,_rallypointInternalName,_rallyMarkerName,_customName,_pos] call TAS_fnc_genericRallypoint;

};

[
	"Rallypoint Options",
	[
		["EDIT","Rallypoint internal name (not visible)",["TAS_alphaRallypoint"]],
		["EDIT","Rallypoint marker variable name",["rallypointAlphaMarker"]],
		["EDIT","Rallypoint marker visible name",["Alpha Rallypoint"]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;