//FOB Script
sleep 2; //wait for init
if !(FOBEnabled) exitWith {systemChat "FOB/Rallypoint building disabled"};

// Vars for picking those who can place the fob
private _FOB_builders = ["CMD_Actual","CMD_Engineer","CMD_JTAC","CMD_Medic","ALPHA_Actual"]; //var names of roles with access to fob building
									//Depending on mission, add more/less, such as the other members of the command element, a dedicated logi crew, or the alpha SL (if GC not used), or all SLs
private _playerClass = vehicleVarName player;
if (_playerClass in _FOB_builders) then {
	//FOB_Action = ["FOBAction","Place FOB (Can only be used once!!!)","",{[] execVM "buildfob\FobBuild.sqf";},{true}] call ace_interact_menu_fnc_createAction; //old action without progressbar */
	FOB_Action = ["FOBAction","Place FOB (Can only be used once!!!)","",{[15,[],{[] execVM "buildfob\FobBuild.sqf";},{},"Establishing FOB..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[logistics_vehicle, 0, ["ACE_MainActions"], FOB_Action] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when outside the vehicle
	//[logistics_vehicle, 1, ["ACE_SelfActions"], FOB_Action] call ace_interact_menu_fnc_addActionToObject; //note that action will only be accessible when inside the vehicle, doesnt work with progressbar
};

//5 names to replace
if (vehicleVarName player == "CMD_Actual") then {
	Rally_CMD_Action = ["rallyCMD","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\cmdRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_CMD_Action] call ace_interact_menu_fnc_addActionToObject;
};

//old action without progressbar
/*if (vehicleVarName player == "ALPHA_Actual") then {
	Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[] execVM "buildfob\alphaRallypoint.sqf";},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};*/
if (vehicleVarName player == "ALPHA_Actual") then {
	Rally_Alpha_Action = ["rallyAlpha","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\alphaRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Alpha_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "BRAVO_Actual") then {
	Rally_Bravo_Action = ["rallyBravo","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\bravoRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Bravo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "CHARLIE_Actual") then {
	Rally_Charlie_Action = ["rallyCharlie","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\charlieRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Charlie_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "DELTA_Actual") then {
	Rally_Delta_Action = ["rallyDelta","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\deltaRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Delta_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "ECHO_Actual") then {
	Rally_Echo_Action = ["rallyEcho","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\echoRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Echo_Action] call ace_interact_menu_fnc_addActionToObject;
};

if (vehicleVarName player == "FOXTROT_Actual") then {
	Rally_Foxtrot_Action = ["rallyFoxtrot","Place Squad Rallypoint","",{[3,[],{[] execVM "buildfob\foxtrotRallypoint.sqf";},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], Rally_Foxtrot_Action] call ace_interact_menu_fnc_addActionToObject;
};