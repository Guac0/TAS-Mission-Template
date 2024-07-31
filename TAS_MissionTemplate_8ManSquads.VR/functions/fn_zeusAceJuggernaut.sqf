params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the ace juggernaut zeus module on the unit that you wish to make into a juggernaut!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusAceJuggernaut was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_hits",
		"_instaKill"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	[_unit,_hits,_instaKill] remoteExec ["TAS_fnc_aceJuggernaut",_unit];

};

[
	"Make Unit into Juggernaut", 
	[
		["SLIDER", ["Hits Before Death", "Note: fragmentation and etc will all count as separate hits"], [1,500,10,0]],	//min 1 hit, max 100 hits, default 10 hits, 0 decimal places
		["TOOLBOX:YESNO", ["Insta Kill Unit Upon Depletion?", "If enabled, unit dies immediately when hit X times. Not recommended when using on players."], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;