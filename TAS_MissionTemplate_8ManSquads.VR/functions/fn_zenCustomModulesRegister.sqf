//inspiration taken from Crow's Zeus Additions

private _moduleList = [];

if (TAS_zeusResupply) then {
	_moduleList pushBack ["Spawn Resupply Crate", {_this call TAS_fnc_ammoCrateZeus}];
	player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Enabled.<br/><br/>Adds two custom resupply modules to Zeus. One spawns the crate at the cursor location, while the other paradrops it. Each spawns a large crate with medical and 6 mags for each player's weapon. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Disabled."]]; };
};

if (TAS_respawnInVehicle) then {
	_moduleList pushBack ["Assign As Respawn Vehicle", {_this call TAS_fnc_assignRespawnVic}];
	//diary handled in initPlayerLocal
};

if (TAS_flagpoleRespawn) then {
	_moduleList pushBack ["Add Flagpole as Respawn Position", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on an object like a flagpole!"};
		_this call TAS_fnc_assignRespawnFlagpole;
	}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Flagpole Respawn", "Enabled.<br/><br/>Adds a module to Zeus to allow them to add flagpoles as respawn positions."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Flagpole Respawn", "Disabled."]]; };
};

if (TAS_zeusInfoText) then {
	_moduleList pushBack ["Play Info Text", {_this call TAS_fnc_zeusInfoText}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Info Text", "Enabled.<br/><br/>Adds a Zeus module to play info text to all players. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Info Text", "Disabled."]]; };
};

if (TAS_zeusHcTransfer) then {
	_moduleList pushBack ["Transfer Group Ownership", {_this call TAS_fnc_zeusTransferGroupOwnership}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Enabled.<br/><br/>Adds a zeus module to manually transfer ownership of AI groups. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Disabled."]]; };
};

if (TAS_3dGroupIcons) then {
	_moduleList pushBack ["Manage 3d Group Icons", {_this call TAS_fnc_zeus3dGroupIcons}];
	player createDiaryRecord ["tasMissionTemplate", ["3d Group Icons", "Enabled.<br/><br/>Adds 3d icons over group leaders' heads (enable/disable is managable through a zeus module). You can find the management zeus module under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["3d Group Icons", "Disabled."]]; };
};

if (TAS_zeusActionDebug) then {
	_moduleList pushBack ["Reapply Hold Actions", {_this remoteExec ["TAS_fnc_applyHoldActions",0]; systemChat "Reapplied hold actions for all players."}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Hold Action Debug", "Enabled.<br/><br/>Adds a module to Zeus to allow them to trigger automatic debugging of the various hold actions present in a mission (i.e. medical box heal and stuff)."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Hold Action Debug", "Disabled."]]; };
};

if (TAS_zeusSpectateManager) then {
	_moduleList pushBack ["Manage ACE Spectator Settings", {_this call TAS_fnc_zeusSpectatorOptions}];
	_moduleList pushBack ["Apply ACE Spectator", {_this call TAS_fnc_zeusApplySpectator}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Enabled.<br/><br/>Adds a module to Zeus to allow them to edit available sides and camera modes for spectator, as well as adding a module to let them manage the spectator status of individual units."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Disabled."]]; };
};

if (TAS_respawnInVehicle || TAS_fobEnabled || TAS_rallypointsEnabled || TAS_flagpoleRespawn) then {
	_moduleList pushBack ["Open Respawn GUI on Unit", {
		private _unit = _this select 1;
		if (isNull _unit) exitWith { systemChat "Place the module on a unit!"};
		[] remoteExec ["TAS_fnc_openRespawnGui",_unit];
		systemChat format ["Opened respawn GUI for unit %1",_unit];
	}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Open Respawn GUI on Unit", "Enabled.<br/><br/>Adds a module to Zeus to allow them to activate the respawn GUI on a unit."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Open Respawn GUI on Unit", "Disabled."]]; };
};

if (TAS_zeusGroupDeletion) then {
	_moduleList pushBack ["Enable Empty Group Deletion", {
		private _groupNumber = count allGroups;
		diag_log format ["TAS-MISSION-TEMPLATE Empty group deletion starting, old groups: %1", _groupNumber];
		[{
			if (local _x) then
			{
				if (count units _x != 0) then {
					_x deleteGroupWhenEmpty true;
				} else {
					deleteGroup _x;
				};
			}
			else
			{
				if (count units _x != 0) then {
					[_x, true] remoteExec ["deleteGroupWhenEmpty", groupOwner _x];
				} else {
					_x remoteExec ["deleteGroup", groupOwner _x];
				};
			};
		}, allGroups] remoteExec ["forEach",2];
		private _newGroupNumber = count allGroups;
		diag_log format ["TAS-MISSION-TEMPLATE Empty group deletion ending, deleted groups: %1", _groupNumber - _newGroupNumber];
		systemChat format ["Deleted %1 empty groups and queued all others for deletion after being empty! Remaining groups: %2", _groupNumber - _newGroupNumber, _newGroupNumber];
	}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Empty Group Deletion", "Enabled.<br/><br/>Adds a module to Zeus that deletes currently empty groups and tags occupied groups for deletion once they are empty."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Empty Group Deletion", "Disabled."]]; };
};

if (TAS_zeusFollowMarker) then {
	_moduleList pushBack ["Attach Marker to Object", {_this call TAS_fnc_zeusMarkerFollow}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Attach Marker to Object", "Enabled.<br/><br/>Adds a module to Zeus to allow them to attach markers on objects that follow them at the set interval."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Attach Marker to Object", "Disabled."]]; };
};

if (TAS_globalTfarEnabled) then {
	_moduleList pushBack ["Configure Global TFAR", {_this call TAS_fnc_zeusGlobalTfar}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Global TFAR", "Enabled.<br/><br/>Adds a module to Zeus to allow them to activate or disable the Global TFAR script."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Global TFAR", "Disabled."]]; };
};

if (TAS_zeusServiceVehicle) then {
	_moduleList pushBack ["Service Vehicle", {if (isNull (_this select 1)) exitWith {systemChat "Place the module on a vehicle!"}; [(_this select 1)] remoteExec ["TAS_fnc_serviceHeli",_this]}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Service Vehicle", "Enabled.<br/><br/>Adds a module to Zeus to allow them to RRR a vehicle with chat messages to its crew."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Service Vehicle", "Disabled."]]; };
};

if (TAS_vassEnabled) then {
	_moduleList pushBack ["[Shop System] Edit Balance", {
		if (isNull (_this select 1)) exitWith {systemChat "Place the module on a unit!"};
		_this call TAS_fnc_vassZeusEditMoney
	}];
	_moduleList pushBack ["[Shop System] View balance of player", {
		if (isNull (_this select 1)) exitWith {systemChat "Place the module on a unit!"}; 
		[[], {
			private _currentMoney = profileNamespace getVariable [TAS_vassShopSystemVariable,0];
			[[name player, _currentMoney], {
				private _message = format ["%1 has a balance of %2.",_this select 0, _this select 1];
				systemChat _message;
				hint _message;
			}] remoteExec ["spawn",remoteExecutedOwner];
		}] remoteExec ["spawn",_this select 1];
	}];
};



//registering ZEN custom modules, code modified from Crow
{
	private _successfullyRegistered = 
	[
		"TAS Mission Template", 
		(_x select 0), 
		(_x select 1)/*,
		(_x select 2)*/ 						//none of the template modules have icons
	] call zen_custom_modules_fnc_register;
	if (!_successfullyRegistered) then {
		systemChat format ["TAS-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
		diag_log format ["TAS-MISSION-TEMPLATE WARNING: Failed to register custom zeus module! Name of failed module: %1.",_x select 0];
	};
} forEach _moduleList;
