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
		"_mags",
		"_radio"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[_unit,_mags,_radio] remoteExec ["TAS_fnc_scavLoadout",_unit];

};

[
	"Give Scav Loadout to Unit", 
	[
		["SLIDER", ["Primary weapon magazines", ""], [1,20,5,0]],	//min 1 mag, max 20 mags, default 5 mags, 0 decimal places
		["TOOLBOX:YESNO", ["Give radio?", "Players will have their radio set to TAS_scavRadioFreq"], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;