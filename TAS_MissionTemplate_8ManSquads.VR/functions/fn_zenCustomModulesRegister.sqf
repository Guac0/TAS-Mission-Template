//inspiration taken from Crow's Zeus Additions

private _moduleList = [];

if (TAS_zeusResupply) then {
	_moduleList pushBack ["Spawn Resupply Crate", {_this call TAS_fnc_ammoCrateZeus}];
	player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Enabled. Adds two custom resupply modules to Zeus. One spawns the crate at the cursor location, while the other paradrops it. Each spawns a large crate with medical and 6 mags for each player's weapon. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Disabled."]]; };
};

if (TAS_respawnInVehicle) then {
	_moduleList pushBack ["Assign As Respawn Vehicle", {_this call TAS_fnc_assignRespawnVic}];
	//diary handled in initPlayerLocal
};

if (TAS_zeusInfoText) then {
	_moduleList pushBack ["Play Info Text", {_this call TAS_fnc_zeusInfoText}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Info Text", "Enabled. Adds a Zeus module to play info text to all players. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Info Text", "Disabled."]]; };
};

if (TAS_zeusHcTransfer) then {
	_moduleList pushBack ["Transfer Group Ownership", {_this call TAS_fnc_zeusTransferGroupOwnership}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Enabled. Adds a zeus module to manually transfer ownership of AI groups. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Headless Client Group Trasnfer", "Disabled."]]; };
};

if (TAS_3dGroupIcons) then {
	_moduleList pushBack ["Manage 3d Group Icons", {_this call TAS_fnc_zeus3dGroupIcons}];
	player createDiaryRecord ["tasMissionTemplate", ["3d Group Icons", "Enabled. Adds 3d icons over group leaders' heads (enable/disable is managable through a zeus module). You can find the management zeus module under 'TAS Mission Template' in the module list."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["3d Group Icons", "Disabled."]]; };
};

if (TAS_zeusActionDebug) then {
	_moduleList pushBack ["Reapply Hold Actions", {_this remoteExec ["TAS_fnc_applyHoldActions",0]}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Hold Action Debug", "Enabled. Adds a module to Zeus to allow them to trigger automatic debugging of the various hold actions present in a mission (i.e. medical box heal and stuff)."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Hold Action Debug", "Disabled."]]; };
};

if (TAS_zeusSpectateManager) then {
	_moduleList pushBack ["Manage ACE Spectator Settings", {_this call TAS_fnc_zeusSpectatorOptions}];
	_moduleList pushBack ["Apply ACE Spectator", {_this call TAS_fnc_zeusApplySpectator}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Enabled. Adds a module to Zeus to allow them to edit available sides and camera modes for spectator, as well as adding a module to let them manage the spectator status of individual units."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Manage ACE Spectator Settings", "Disabled."]]; };
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
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Empty Group Deletion", "Enabled. Adds a module to Zeus that deletes currently empty groups and tags occupied groups for deletion once they are empty."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Empty Group Deletion", "Disabled."]]; };
};

if (TAS_zeusFollowMarker) then {
	_moduleList pushBack ["Attach Marker to Object", {_this call TAS_fnc_zeusMarkerFollow}];
	player createDiaryRecord ["tasMissionTemplate", ["Zeus Attach Marker to Object", "Enabled. Adds a module to Zeus to allow them to attach markers on objects that follow them at the set interval."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Zeus Attach Marker to Object", "Disabled."]]; };
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