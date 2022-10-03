params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_blufor",
		"_independent",
		"_opfor",
		"_civ",
		"_first",
		"_third",
		"_free",
		"_spectateOnRespawn",
		"_respawnForceSpectate",
		"_respawnHidePlayer",
		"_respawnSpectateTime"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	_sidesToAdd = [];
	_sidesToRemove = [];

	if (_blufor) then {
		_sidesToAdd pushBack west;
	} else {
		_sidesToRemove pushBack west;
	};
	if (_independent) then {
		_sidesToAdd pushBack resistance;
	} else {
		_sidesToRemove pushBack resistance;
	};
	if (_opfor) then {
		_sidesToAdd pushBack east;
	} else {
		_sidesToRemove pushBack east;
	};
	if (_civ) then {
		_sidesToAdd pushBack civilian;
	} else {
		_sidesToRemove pushBack civilian;
	};

	[
		_sidesToAdd, _sidesToRemove
	] remoteExec ["ace_spectator_fnc_updateSides",0,true];

	_visionModesToAdd = [];
	_visionModeRemove = [];

	if (_first) then {
		_visionModesToAdd pushBack 1;
	} else {
		_visionModeRemove pushBack 1;
	};
	if (_third) then {
		_visionModesToAdd pushBack 2;
	} else {
		_visionModeRemove pushBack 2;
	};
	if (_free) then {
		_visionModesToAdd pushBack 0;
	} else {
		_visionModeRemove pushBack 0;
	};

	[
		_visionModesToAdd, _visionModeRemove
	] remoteExec ["ace_spectator_fnc_updateCameraModes",0,true];

	if (_spectateOnRespawn) then {
		TAS_respawnSpectator = true;
	} else {
		TAS_respawnSpectator = false;
	};
	if (_respawnForceSpectate) then {
		TAS_respawnSpectatorForceInterface = true;
	} else {
		TAS_respawnSpectatorForceInterface = false;
	};
	if (_respawnHidePlayer) then {
		TAS_respawnSpectatorHideBody = true;
	} else {
		TAS_respawnSpectatorHideBody = false;
	};
	if (_respawnSpectateTime != 0) then {
		TAS_respawnSpectatorTime = _respawnSpectateTime;
	} else {
		TAS_respawnSpectatorTime = 0;
	};
	publicVariable "TAS_respawnSpectator";
	publicVariable "TAS_respawnSpectatorForceInterface";
	publicVariable "TAS_respawnSpectatorHideBody";
	publicVariable "TAS_respawnSpectatorTime";
};

[
	"Update Sides available in Spectator (for all players)", 
	[
		["TOOLBOX:YESNO", ["BLUFOR visible?", ""], false],
		["TOOLBOX:YESNO", ["INDEPENDENT visible?", ""], false],
		["TOOLBOX:YESNO", ["OPFOR visible?", ""], false],
		["TOOLBOX:YESNO", ["CIV visible?", ""], false],
		["TOOLBOX:YESNO", ["1st person camera available?", ""], false],
		["TOOLBOX:YESNO", ["3rd person camera available?", ""], false],
		["TOOLBOX:YESNO", ["Free camera available?", ""], false],
		["TOOLBOX:YESNO", ["Apply spectator on respawn?", ""], false],
		["TOOLBOX:YESNO", ["Respawn — allow spectator exit?", "If enabled, allows player to exit spectator by pressing the ESC key."], false],
		["TOOLBOX:YESNO", ["Respawn — hide player's body?", ""], false],
		["TOOLBOX:YESNO", ["Respawn — end spectator after time?", "Leave at 0 for spectator to not be removed."], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;