//FOB Script

if ( {getMarkerColor _x == ""} forEach ["rallypointAlphaMarker","rallypointBravoMarker","rallypointCharlieMarker","rallypointDeltaMarker","rallypointEchoMarker","rallypointFoxtrotMarker","rallypointCmdMarker","fobMarker"] ) exitWith {
	systemchat "WARNING: You have enabled the Rallypoint/FOB system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoint/FOB system...";
	diag_log text "TAS-Mission-Template WARNING: You have enabled the FOB system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoint/FOB system...";
};

if (isNil "logistics_vehicle") then {
	systemchat "WARNING: You have enabled the Rallypoint/FOB system in the mission template options, but the mission.sqm does not contain the needed vehicle to build the FOB! Disabling FOB system, but Rallypoints will still function...";
	diag_log text "TAS-Mission-Template WARNING: You have enabled the Rallypoint/FOB system in the mission template options, but the mission.sqm does not contain the needed vehicle to build the FOB! Disabling FOB system, but Rallypoints will still function...";
};

//add a tutorial diary entry
player createDiaryRecord ["Diary", ["Rallypoint/FOB Script", "Allows all Squad Leaders to place down a rallypoint via a self ace interaction that contains a tent and a respawn position. Rallypoints cannot be placed within 150m of enemies. Depending on mission settings, a small emergency resupply crate will also be included at the rallypoint. Members of the Command team (plus the Alpha squad leader as a fallback) will be able to place down a fairly-sized FOB via an ace interaction on the HEMTT (BOX) truck, and the FOB will include minor defensive structures, vehicle RRR boxes, and arsenals for players. The FOB can only be placed once and cannot be placed if enemies are within 300m, while rallypoints have no limit on their number of uses (although each new use will delete the squad's previous rallypoint)."]];

// Vars/role descriptions for picking those who can place the fob
// Depending on mission, add more/less, such as the other members of the command element, a dedicated logi crew, or the alpha SL (if GC not used), or all SLs
private _fobBuildersRoleDescriptions = ["Zeus","Ground Command","Officer","JTAC","TACP","Engineer","Commander","Squad Leader","FOB","Logistics","Logi"];
private _fobBuildersVarNames = ["Z1","Z2","Z3","CMD_Actual","CMD_Engineer","CMD_JTAC","CMD_Medic","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _playerClass = vehicleVarName player;
private _playerRoleDescription = roleDescription player;
if (!isNil "logistics_vehicle") then { //check if the logistics_vehicle actually exists so we dont get errors
	{
		if (_x in _playerRoleDescription) then {
			player setVariable ["TAS_FobBuilder",true];
		};
	} forEach _fobBuildersRoleDescriptions;
	{
		if (_x in _playerClass) then {
			player setVariable ["TAS_FobBuilder",true];
		};
	} forEach _fobBuildersVarNames;
	
	if (player getVariable ["TAS_FobBuilder",false]) then {
		//FOB_Action = ["FOBAction","Place FOB (Can only be used once!!!)","",{[] execVM "buildfob\fobBuild.sqf";},{true}] call ace_interact_menu_fnc_createAction; //old action without progressbar */
		FOB_Action = ["FOBAction","Place FOB (Can only be used once!!!)","",{[15,[],{[] execVM "buildfob\fobBuild.sqf";},{},"Establishing FOB..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction; //maybe make this a private var
		[logistics_vehicle, 0, ["ACE_MainActions"], FOB_Action] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when outside the vehicle
		//[logistics_vehicle, 1, ["ACE_SelfActions"], FOB_Action] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when inside the vehicle, doesnt work with progressbar
	};
};

//5 names to replace
//all these "Rally_CMD_Action might be better as private variables
if (vehicleVarName player == "CMD_Actual" || "Commander" in _playerRoleDescription || "Officer" in _playerRoleDescription || "GC" in _playerRoleDescription) then {
	Rally_CMD_Action = ["rallyCMD","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\cmdRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_CMD_Action] call ace_interact_menu_fnc_addActionToObject;
};

//old action without progressbar
/*if (vehicleVarName player == "ALPHA_Actual") then {
	Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[] execVM "buildfob\alphaRallypoint.sqf";},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};*/
if (vehicleVarName player == "ALPHA_Actual" || ("Squad Leader" in _playerRoleDescription && "Alpha" in _playerRoleDescription)) then { //doesn't handle nearly enough edge cases in role description names
	Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\alphaRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "BRAVO_Actual" || ("Squad Leader" in _playerRoleDescription && "Bravo" in _playerRoleDescription)) then {
	Rally_Bravo_Action = ["rallyBravo","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\bravoRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Bravo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "CHARLIE_Actual" || ("Squad Leader" in _playerRoleDescription && "Charlie" in _playerRoleDescription)) then {
	Rally_Charlie_Action = ["rallyCharlie","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\charlieRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Charlie_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "DELTA_Actual" || ("Squad Leader" in _playerRoleDescription && "Delta" in _playerRoleDescription)) then {
	Rally_Delta_Action = ["rallyDelta","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\deltaRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Delta_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "ECHO_Actual" || ("Squad Leader" in _playerRoleDescription && "Echo" in _playerRoleDescription)) then {
	Rally_Echo_Action = ["rallyEcho","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\echoRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Echo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "FOXTROT_Actual" || ("Squad Leader" in _playerRoleDescription && "Foxtrot" in _playerRoleDescription)) then {
	Rally_Foxtrot_Action = ["rallyFoxtrot","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\foxtrotRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Foxtrot_Action] call ace_interact_menu_fnc_addActionToObject;
};

//debug init finished
//systemChat "FOB/Rallypoint system init finished.";
player createDiaryRecord ["tasMissionTemplate", ["FOB/Rallypoints", "Enabled. Squad Leads can self-ace-interact to place a rallypoint assuming no enemies are within a certain distance. To place the FOB, ace interact with the logistics vehicle."]];