params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the follow marker zeus module on the object that you wish to attach the marker to!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusMarkerFollow was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rallypointInternalName",
		"_rallyMarkerName"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[player,_rallypointInternalName,_rallyMarkerName] call TAS_fnc_genericRallypoint;

};

[
	"Spawn Info Text", 
	[
		["EDIT","Rallypoint internal name (not visible)",["TAS_alphaRallypoint"]],
		["EDIT","Rallypoint marker variable name",["rallypointAlphaMarker"]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;