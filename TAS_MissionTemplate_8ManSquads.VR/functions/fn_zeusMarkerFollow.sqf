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
		"_markerType",
		"_markerColor",
		"_markerName",
		"_deleteOnDeath",
		"_interval"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[_unit,_markerType,_markerColor,_markerName,_deleteOnDeath,_interval] remoteExec ["TAS_fnc_markerFollow",2];

};

[
	"Spawn Info Text", 
	[
		["EDIT","Marker Type",["hd_flag"]],
		["EDIT","Marker Color",["ColorUNKNOWN"]],
		["EDIT","Marker Display Name",["Follow Marker"]], //all defaults, no sanitizing function as we shouldn't need it
		["TOOLBOX:YESNO", ["Delete marker when object dies?", "Even if marker is not deleted, its position will not update after the attached object dies."], false],
		["SLIDER", ["Interval between position updates", ""], [1,600,60,0]]	//min 1 second, max 600 seconds, default 60 seconds, 0 decimal places
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;