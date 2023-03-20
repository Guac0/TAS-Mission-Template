//FOB Script. Called by each client locally to set up the FOB script.

if ( {getMarkerColor _x == ""} forEach ["fobMarker"] ) exitWith {
	if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorLogic player))) then { //only do visual error if server (singleplayer testing) or admin or zeus
		systemchat "WARNING: You have enabled the FOB system in the mission template options, but the mission.sqm does not contain the needed FOB markers! Disabling FOB system...";
	};
	diag_log text "TAS-Mission-Template WARNING: You have enabled the FOB system in the mission template options, but the mission.sqm does not contain the needed FOB markers! Disabling FOB system...";
};

if (isNil "logistics_vehicle") then {
	if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorLogic player))) then { //only do visual error if server (singleplayer testing) or admin or zeus
		systemchat "WARNING: You have enabled the FOB system in the mission template options, but the mission.sqm does not contain the needed vehicle to build the FOB! Disabling FOB system!";
	};
	diag_log text "TAS-Mission-Template WARNING: You have enabled the FOB system in the mission template options, but the mission.sqm does not contain the needed vehicle to build the FOB! Disabling FOB system!";
};

//add a tutorial diary entry
	//TODO make this more customized depending on mission settings
player createDiaryRecord ["Diary", ["Forward Operating Base", format [
	"Members of the Command team and the Squad Leaders will be able to place down a medium-sized FOB via an ace interaction on the HEMTT (BOX) truck, and the FOB will include minor defensive structures, vehicle RRR boxes, and arsenals for players. The FOB can usually only be placed once and cannot be placed if enemies are within %1m."
,TAS_fobDistance]]];

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
		//FOB_Action = ["FOBAction","Place FOB (Can only be used once!!!)","",{[] spawn TAS_fnc_fobBuild},{true}] call ace_interact_menu_fnc_createAction; //old action without progressbar */
		private _fobPlaceAction = [
			"FOBAction",
			"Place FOB",
			"",
			{
				[
					15,
					[],
					{
						[] spawn TAS_fnc_fobBuild;
					},
					{},
					"Establishing FOB..."
				] call ace_common_fnc_progressBar
			},
			{!TAS_fobBuilt && !TAS_fobDestroyed} //not available if fob has been placed or previously overrun
		] call ace_interact_menu_fnc_createAction; //maybe make this a private var
		[logistics_vehicle, 0, ["ACE_MainActions"], _fobPlaceAction] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when outside the vehicle
		//[logistics_vehicle, 1, ["ACE_SelfActions"], FOB_Action] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when inside the vehicle, doesnt work with progressbar
		private _fobPackupAction = [
			"FOB_PackupAction",
			"Disassemble FOB",
			"",
			{
				[
					15,
					[],
					{
						[] call TAS_fnc_fobPackup;
					},
					{},
					"Disassembling FOB..."
				] call ace_common_fnc_progressBar
			},
			{TAS_fobBuilt && TAS_fobPackup && !TAS_fobDestroyed} //not available if fob hasn't been placed
		] call ace_interact_menu_fnc_createAction; //maybe make this a private var
		[logistics_vehicle, 0, ["ACE_MainActions"], _fobPackupAction] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when outside the vehicle
	};
};

//debug init finished
//systemChat "FOB/Rallypoint system init finished.";
	//TODO redundant?
player createDiaryRecord ["tasMissionTemplate", ["FOB System", "Enabled.<br><br>See Briefing section for tutorial on the FOB system."]];