//inspiration taken from Crow's Zeus Additions

private _moduleList = [];

if (TAS_zeusResupply) then {
	_moduleList pushBack ["Spawn Resupply Crate", {_this call TAS_fnc_ammoCrateZeus}];
};
if (TAS_respawnInVehicle) then {
	_moduleList pushBack ["Assign As Respawn Vehicle", {_this call TAS_fnc_assignRespawnVic}];
};
if (TAS_zeusInfoText) then {
	_moduleList pushBack ["Play Info Text", {_this call TAS_fnc_zeusInfoText}];
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