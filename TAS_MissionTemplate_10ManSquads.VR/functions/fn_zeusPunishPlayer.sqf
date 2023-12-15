params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

private _debug = false;
if (_debug) then { systemChat format ["Starting fn_zeusPunishPlayer with %1 and %2",_pos,_unit]; };

if (isNull _unit) exitWith {
	systemChat "Error: place the zeus module on the object that you wish to attach the marker to!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusPunishPlayer was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_timeout"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	if (_debug) then { systemChat format ["Starting fn_zeusPunishPlayer onConfirm with %1 and %2",_unit,_timeout]; };
	if ((_unit getVariable ["TAS_civsKilledByUnit",0]) < 1) then {
		_unit setVariable ["TAS_civsKilledByUnit",1];
	};
	[_unit,_timeout] remoteExec ["TAS_fnc_punishCivKillerLocal",_unit,true];

	systemChat format ["Sending %1 to timeout for %2 seconds!",name _unit,_timeout];
};

[
	"Punishment Duration", 
	[
		["SLIDER", ["Timeout duration", ""], [1,600,60,0]]	//min 1 second, max 600 seconds, default 60 seconds, 0 decimal places
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;