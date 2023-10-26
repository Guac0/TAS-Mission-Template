params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the scav loadout zeus module on the object that you wish to attach the marker to!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusScavLoadout was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_mags",
		"_radio"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[_unit,_mags,_radio] remoteExec ["TAS_fnc_scavLoadout",_unit];

};

[
	"Spawn Info Text", 
	[
		["SLIDER", ["Interval between position updates", ""], [1,20,5,0]],	//min 1 second, max 600 seconds, default 60 seconds, 0 decimal places
		["TOOLBOX:YESNO", ["Give radio?", "Players will have their radio set to TAS_scavRadioFreq"], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;