//basically just a space saver for assigning respawn vic through init field or through zeus function
//see fn_assignRespawnVic.sqf for zeus version
//should probably be only called from server but should work if called locally as long as it's not executed globally
//[this,"Respawn Vehicle 1"] spawn TAS_fnc_assignRespawnVicInit;	//and/or an ifServer check and/or a remoteExec on server

params ["_vehicle","_name"];

//waitUntil {!isNil "TAS_respawnInVehicle"}; //shouldnt be needed now that we have preinit for config.sqf
if (TAS_respawnInVehicle) then {
	waitUntil {!isNil "TAS_respawnLocations"};
	TAS_respawnLocations pushBack [_vehicle,_name];
	[_vehicle,"hd_flag","ColorUNKNOWN",_name,true,5] call TAS_fnc_markerFollow;
	publicVariable "TAS_respawnLocations";
	_vehicle addMPEventHandler ["MPKilled", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		private _path = [TAS_respawnLocations, _unit] call BIS_fnc_findNestedElement;
		if (_path isNotEqualTo []) then {
			diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic removing respawn vic from list!";
			private _indexOfOldVehiclePair = _path select 0;
			TAS_respawnLocations deleteAt _indexOfOldVehiclePair;
			publicVariable "TAS_respawnLocations";
		} else {
			diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic cannot find vehicle to remove!";
		};
	}];
};