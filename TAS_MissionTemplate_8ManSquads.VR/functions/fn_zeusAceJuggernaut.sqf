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
		"_instaKill",
		"_sound",
		"_changeLoadout",
		"_playerEffects",
		"_wbkDisableHitReactions"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	if (_playerEffects) then {
		[_unit,_hits,_instaKill,_sound,_changeLoadout,_wbkDisableHitReactions] remoteExec ["TAS_fnc_aceJuggernautEffects",_unit];
	} else {
		[_unit,_hits,_instaKill,_sound,_changeLoadout,_wbkDisableHitReactions] remoteExec ["TAS_fnc_aceJuggernaut",_unit];
	};

};

[
	"Make Unit into Juggernaut", 
	[
		["SLIDER", ["Hits Before Death", "Note: fragmentation and over-penetration to multiple body parts will all count as separate hits"], [1,500,10,0]],	//min 1 hit, max 100 hits, default 10 hits, 0 decimal places
		["TOOLBOX:YESNO", ["Insta Kill Unit Upon Depletion?", "If enabled, unit dies immediately when hit X times. Not recommended when using on players."], true],
		["TOOLBOX:YESNO", ["Play Sound?", "Plays sound like COD-style juggernauts"], true],
		["TOOLBOX:YESNO", ["Change Loadout?", "Adds all-black OP loadout"], true],
		["TOOLBOX:YESNO", ["Add Player Effects?", "Adds additional effects if you are using this script on a player."], false],
		["TOOLBOX:YESNO", ["Enable WBK Hit Reactions?", "Disables WBK hit reactions if mod is loaded and value of this is set to false"], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;