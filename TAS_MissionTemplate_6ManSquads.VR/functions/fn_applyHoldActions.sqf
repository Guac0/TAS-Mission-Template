//if you want to add your own hold actions, then add them at the end (not at the very end, do it before the last debug message. just scroll down and you'll see)
//systemChat "a";

//if client already has actions made, then remove them. If client does not have actions made, then setup appropriate vars.
private ["_actionID"];
if (isNil "TAS_holdActionIDs") then {
	private _debugMessage = format ["%1 is applying their hold actions for the first time!", name player];
	diag_log _debugMessage;
	_debugMessage remoteExec ["diag_log",2];
	
	TAS_holdActionIDs = [];
} else {
	private _debugMessage = format ["%1 is reapplying their hold actions! Old actions: %2", name player, TAS_holdActionIDs];
	diag_log _debugMessage;
	_debugMessage remoteExec ["diag_log",2];

	{
		_x call BIS_fnc_holdActionRemove;
	} forEach TAS_holdActionIDs;
	TAS_holdActionIDs = [];
};

//apply the various actions

//actions on the AceHealObject
if (!isNil "AceHealObject") then { //check if the ace heal object actually exists so we dont get errors
	if (TAS_aceHealObjectEnabled) then {
		_actionID = [
			AceHealObject,											// Object the action is attached to
			"Heal All Entities in 100m",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{_nearPlayers = AceHealObject nearEntities ["Man", 100]; {[objNull, _x] call ace_medical_treatment_fnc_fullHeal} forEach _nearPlayers},													// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			1,													// Action duration [s]
			5,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [AceHealObject,_actionID,"heal"];	//add action info to var for later removal if requested
	} else {
		//systemChat "Ace Heal Object disabled.";
	};
	if (TAS_aceSpectateObjectEnabled) then {
		//enter spectator action
		_actionID = [
			AceHealObject,											// Object the action is attached to
			"Enter Spectator",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ [true, false, false] call ace_spectator_fnc_setSpectator },													// Code executed on completion,* 0: Spectator state of local client <BOOL> (default: true) * 1: Force interface <BOOL> (default: false)* 2: Hide player (if alive) <BOOL> (default: false)
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			2,													// Action duration [s]
			4,													// Priority, 0-6
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [AceHealObject,_actionID,"spectator"];
	} else {
		//systemChat "Ace Spectate Object disabled.";
	};
	if (TAS_respawnArsenalGear) then {
		_actionID = [
			AceHealObject,											// Object the action is attached to
			"Manually Save Loadout",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ private _loadout = [player] call CBA_fnc_getLoadout; player setVariable ["TAS_arsenalLoadout",_loadout]; },												// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			2,													// Action duration [s]
			3,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [AceHealObject,_actionID,"save_loadout"];
	} else {
		//systemChat "Respawn with Arsenal Loadout disabled.";
		//diag_log text "Respawn with Arsenal Loadout disabled.";
	};
	if (TAS_respawnInVehicle || TAS_fobEnabled || TAS_rallypointsEnabled || TAS_flagpoleRespawn) then {
		_actionID = [
			AceHealObject,											// Object the action is attached to
			"Open Respawn GUI",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"(_this distance _target < 15) && !(player getVariable ['TAS_waitingForReinsert',false]) && (TAS_respawnInVehicle || TAS_fobEnabled || TAS_rallypointsEnabled || TAS_flagpoleRespawn)",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ [] spawn TAS_fnc_openRespawnGui; },												// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			1,													// Action duration [s]
			3,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [AceHealObject,_actionID,"respawn_gui"];
	} else {
		//systemChat "Respawn with Arsenal Loadout disabled.";
		//diag_log text "Respawn with Arsenal Loadout disabled.";
	};
};

//resupply object
if (TAS_resupplyObjectEnabled) then { //check if the resupply object actually exists so we dont get errors
	if ((!isNil "CreateResupplyObject") && (!isNil "ResupplySpawnHelper")) then {
		_actionID = [
			CreateResupplyObject,											// Object the action is attached to
			"Spawn Resupply Box",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 15",						// Condition for the action to be shown
			"_caller distance _target < 15",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{[ResupplySpawnHelper,false,true,false,true,true,true,250,"B_CargoNet_01_ammo_F"] call TAS_fnc_AmmoCrate;},													// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			1,													// Action duration [s]
			5,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [CreateResupplyObject,_actionID,"create_resupply"];
	} else { //if resupply object stuff is turned on but missing the objects needed for it to work, then display a warning that the resupply system will be disabled.
		if (isServer) then {
			systemChat "WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
			diag_log text "TAS-Mission-Template WARNING: Resupply Creator enabled, but missing the relevant spawner object(s) in mission! Disabling resupply creator...";
		};
	};
};

if (TAS_vassEnabled) then {
	{
		private _object = _x;
		_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
		
		if (!isNull _object) then {
			//add save loadout option
			_actionID = [
				_object,											// Object the action is attached to
				"Save Loadout",										// Title of the action
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
				"_this distance _target < 5",						// Condition for the action to be shown
				"_caller distance _target < 5",						// Condition for the action to progress
				{},													// Code executed when action starts
				{},													// Code executed on every progress tick
				{
					TAS_rebuyCost = 0; //setup rebuy variables, not private because need to escape the if statements
					if !(primaryWeapon player == "") then { //if player has a primary weapon, add cost
						TAS_rebuyCost = TAS_rebuyCost + TAS_rebuyCostPrimary;
					};
					if !(secondaryWeapon player == "") then { //if player has a secondary (launcher) weapon, add cost
						TAS_rebuyCost = TAS_rebuyCost + TAS_rebuyCostSecondary;
					};
					if !(handgunWeapon player == "") then { //if player has a handgun weapon, add cost
						TAS_rebuyCost = TAS_rebuyCost + TAS_rebuyCostHandgun;
					};
					player setVariable ["rebuyCost",TAS_rebuyCost];
					player setVariable ["arsenalLoadout",getUnitLoadout player];
					hint format ["Note: it will cost %1$ to rebuy your saved loadout.",TAS_rebuyCost];
				},												// Code executed on completion
				{},													// Code executed on interrupted
				[],													// Arguments passed to the scripts as _this select 3
				2,													// Action duration [s]
				4,													// Priority
				false,												// Remove on completion
				false												// Show in unconscious state 
			] call BIS_fnc_holdActionAdd;
			TAS_holdActionIDs pushBack [_object,_actionID,"vass_save_loadout"];

			//add rebuy option, TODO: cost money depending on weapons selected
			_actionID = [
				_object,											// Object the action is attached to
				"Rebuy Loadout",										// Title of the action
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
				"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
				"_this distance _target < 5",						// Condition for the action to be shown
				"_caller distance _target < 5",						// Condition for the action to progress
				{},													// Code executed when action starts
				{},													// Code executed on every progress tick
				{ 
					_currentMoney = profileNamespace getVariable [TAS_vassShopSystemVariable,0]; //remove test and set to profileNamespace in future
					_rebuyCost = player getVariable ["rebuyCost",0];
					if (_currentMoney >= _rebuyCost) then {
						_newMoney = _currentMoney - _rebuyCost;
						profileNamespace setVariable [TAS_vassShopSystemVariable,_newMoney];
						hint format ["You now have %1$ in cash after rebuying your loadout.",_newMoney];
						player setUnitLoadout (player getVariable ["arsenalLoadout",[]]);
					} else {
						hint format ["You only have %1$ of the %2$ needed to rebuy your saved loadout!",_currentMoney,_rebuyCost];
					};
				},												// Code executed on completion
				{},													// Code executed on interrupted
				[],													// Arguments passed to the scripts as _this select 3
				2,													// Action duration [s]
				3,													// Priority
				false,												// Remove on completion
				false												// Show in unconscious state 
			] call BIS_fnc_holdActionAdd;
			TAS_holdActionIDs pushBack [_object,_actionID,"vass_rebuy_loadout"];
		} else {
			if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorLogic player))) then { //only do visual error if server (singleplayer testing) or admin or zeus
				systemchat format ["WARNING: One or more objects (%1) in TAS_vassSigns does not exist!",_x];
			};
			diag_log text format ["TAS-MISSION-TEMPLATE WARNING: One or more objects (%1) in TAS_vassSigns does not exist!",_x];
		};
	} forEach TAS_vassSigns;
};

if (TAS_scavSystemEnabled) then {
	private _object = missionNamespace getVariable [TAS_scavInsertActionObject, objNull]; //convert from string to object, otherwise we get errors
	if (!isNull _object) then {
		_actionID = [
			_object,											// Object the action is attached to
			"Insert as Scav",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 5",						// Condition for the action to be shown
			"_caller distance _target < 5",						// Condition for the action to progress
			{},													// Code executed when action starts
			{},													// Code executed on every progress tick
			{ 
				[player] remoteExec ["TAS_fnc_scavInsertPlayer",2];
			},												// Code executed on completion
			{},													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			5,													// Action duration [s]
			3,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		TAS_holdActionIDs pushBack [scavAction,_actionID,"scavReenterAction"];
	} else {
		["Scav system enabled, but mission is missing the TAS_scavInsertActionObject to attach the insert action to for scavs to enter the AO!"] call TAS_fnc_error;
	};
};


/////////////////////////////////
////place custom actions here////
/////////////////////////////////
//Make sure that your actions are local only for effects! (i.e. don't have remoteExec or other commands that make them global)
	//the last line of your command for a hold action should be something like "] call BIS_fnc_holdActionAdd;" (without the quotes)
//add this at the end of your action: "TAS_holdActionIDs pushBack [AceHealObject,_actionID];" (without the quotes)
	//and at the start, add "_actionID = " (with right after that being your "[blahblahblah] call BIS_fnc_holdActionAdd")







//////////////////////
////Debug (at end)////
//////////////////////
private _debugMessage = format ["%1 has applied their hold actions! Actions applied: %2", name player, TAS_holdActionIDs];
diag_log _debugMessage;
_debugMessage remoteExec ["diag_log",2];