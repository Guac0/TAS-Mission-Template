params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the rallypoint place module on the unit it should be created for!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusRallypointPlace was executed without being placed on an object!";
};

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

	[_unit,_rallypointInternalName,_rallyMarkerName,_customName,_pos] call TAS_fnc_genericRallypoint;

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