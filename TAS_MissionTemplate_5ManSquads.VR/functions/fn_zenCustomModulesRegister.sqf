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
	_moduleList pushBack ["Transfer Group Ownership", {_this call TAS_fnc_transferGroupOwnership}];
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