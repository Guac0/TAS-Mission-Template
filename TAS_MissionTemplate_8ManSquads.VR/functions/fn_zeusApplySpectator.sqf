params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_spectate",
        "_forceInterface",
        "_hidePlayer"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	[_spectate,_forceInterface,_hidePlayer] remoteExec ["ace_spectator_fnc_setSpectator",_unit];
};

[
	"Update Sides available in Spectator (for all players)", 
	[
		["TOOLBOX:YESNO", ["Enable spectator?", ""], false],
		["TOOLBOX:YESNO", ["Force spectator interface?", "If enabled, player cannot exit spectator by pressing ESC"], false],
		["TOOLBOX:YESNO", ["Hide player in world?", ""], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;