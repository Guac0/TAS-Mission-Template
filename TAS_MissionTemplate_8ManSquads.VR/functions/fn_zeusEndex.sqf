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
		"_msg",
		"_endexStatus"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[_msg,_endexStatus] remoteExec ["TAS_fnc_endex"];

};

[
	"ENDEX", 
	[
		["EDIT","Custom Message",["Good work."]], //all defaults, no sanitizing function as we shouldn't need it
		["TOOLBOX:YESNO", ["Is Endex?", "TRUE enables endex effects, FALSE disables them (i.e. if you accidentally enabled endex earlier)"], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;