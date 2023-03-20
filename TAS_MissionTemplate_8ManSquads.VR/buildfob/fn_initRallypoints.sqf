//called by each client locally to setup rallypoint stuff.

//variable setup
private _playerClass = vehicleVarName player;
private _playerRoleDescription = roleDescription player;

//error detection for missing markers. cancels script if missing
{
	if (getMarkerColor _x == "") exitWith { //should be colorCiv. if missing, will be ""
		//systemChat str _x;
		if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorLogic player))) then { //only do visual error if server (singleplayer testing) or admin or zeus
			systemchat "WARNING: You have enabled the Rallypoint system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoints system...";
		};
		diag_log text "TAS-Mission-Template WARNING: You have enabled the Rallypoint system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoints system...";
	};
} forEach ["rallypointAlphaMarker","rallypointBravoMarker","rallypointCharlieMarker","rallypointDeltaMarker","rallypointEchoMarker","rallypointFoxtrotMarker","rallypointReconMarker","rallypointCmdMarker"];

//add a tutorial diary entry
	//TODO make this more customized depending on mission settings
player createDiaryRecord ["Diary", ["Rallypoints", format [
	"Allows all Squad Leaders to place down a rallypoint via a self ace interaction that contains a tent and a respawn position.<br/>Rallypoints cannot be placed within %1m of enemies.<br/>Depending on mission settings, a small emergency resupply crate will also be included at the rallypoint.<br/>Rallypoints have no limit on their number of uses (although each new use will delete the squad's previous rallypoint)."
,TAS_rallyDistance]]];

player createDiaryRecord ["tasMissionTemplate", ["Rallypoints", "Enabled.<br><br>See briefing section for tutorial on the Rallypoint system."]];

//adds place rallypoint action to each squad leader (or equivalent for GC and Recon) using their variable name or role description
	//checking for leader of group doesnt make sense as SL is not always leader of group due to arma being bad/misordered slotting

//5 names to replace
if (
		("CMD_Actual" in _playerClass) || 
		(
			("Leader" in _playerRoleDescription || "Commander" in _playerRoleDescription || "Officer" in _playerRoleDescription)
			&& ("GC" in _playerRoleDescription || "Command Element" in _playerRoleDescription || "Ground Command" in _playerRoleDescription)
		)
	) then {
	private _Rally_CMD_Action = ["rallyCMD","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_cmdRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_CMD_Action] call ace_interact_menu_fnc_addActionToObject;
};

//old action without progressbar
/*if (_playerClass == "ALPHA_Actual") then {
	_Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[] call TAS_fnc_alphaRallypoint;},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};*/
if (_playerClass == "ALPHA_Actual" || ("Squad Leader" in _playerRoleDescription && "Alpha" in _playerRoleDescription)) then { //doesn't handle nearly enough edge cases in role description names
	private _Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_alphaRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "BRAVO_Actual" || ("Squad Leader" in _playerRoleDescription && "Bravo" in _playerRoleDescription)) then {
	private _Rally_Bravo_Action = ["rallyBravo","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_bravoRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Bravo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "CHARLIE_Actual" || ("Squad Leader" in _playerRoleDescription && "Charlie" in _playerRoleDescription)) then {
	private _Rally_Charlie_Action = ["rallyCharlie","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_charlieRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Charlie_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "DELTA_Actual" || ("Squad Leader" in _playerRoleDescription && "Delta" in _playerRoleDescription)) then {
	private _Rally_Delta_Action = ["rallyDelta","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_deltaRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Delta_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "ECHO_Actual" || ("Squad Leader" in _playerRoleDescription && "Echo" in _playerRoleDescription)) then {
	private _Rally_Echo_Action = ["rallyEcho","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_echoRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Echo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "FOXTROT_Actual" || ("Squad Leader" in _playerRoleDescription && "Foxtrot" in _playerRoleDescription)) then {
	private _Rally_Foxtrot_Action = ["rallyFoxtrot","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_foxtrotRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Foxtrot_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "GOLF_Actual" || ("Squad Leader" in _playerRoleDescription && "Golf" in _playerRoleDescription)) then {
	private _Rally_Golf_Action = ["rallyGolf","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_golfRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Golf_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "HOTEL_Actual" || ("Squad Leader" in _playerRoleDescription && "Hotel" in _playerRoleDescription)) then {
	private _Rally_Hotel_Action = ["rallyHotel","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_hotelRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Hotel_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (_playerClass == "Recon_Actual" || ("Leader" in _playerRoleDescription && "Recon" in _playerRoleDescription)) then { //assumes that recon is a smaller team without two leaders
	private _Rally_Recon_Action = ["rallyRecon","Place Squad Rallypoint","",{[3,[],{[] call TAS_fnc_reconRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _Rally_Recon_Action] call ace_interact_menu_fnc_addActionToObject;
};