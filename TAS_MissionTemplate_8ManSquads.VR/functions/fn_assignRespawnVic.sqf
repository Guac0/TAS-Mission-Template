//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_name"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	//systemChat format ["2: %1",_unit];

	//validate input object
	if (_unit == objNull) exitWith {
		hint "Place the module on a vehicle!";
		systemChat "Place the module on a vehicle!";
	};
	if !(_unit isKindOf "AllVehicles") exitWith { //TODO this allows men
		hint "Place the module on a vehicle!";
		systemChat "Place the module on a vehicle!";
	};
	
	//validate if object is already respawn vic, or is name is already used
	/*systemChat str TAS_respawnLocations;
	private _foundOccurance = [TAS_respawnLocations, _name] call BIS_fnc_findNestedElement; //returns "[]" if not found 
	systemChat str _foundOccurence;
	if (_foundOccurence != []) exitWith {
		hint "The same name is already set for another respawn vehicle!";
		systemChat "The same name is already set for another respawn vehicle!";
	};
	_foundOccurance = [TAS_respawnLocations, _unit] call BIS_fnc_findNestedElement; //returns "[]" if not found
	systemChat str _foundOccurence;
	if (_foundOccurence != []) exitWith {
		hint "The given vehicle is already a respawn vehicle!";
		systemChat "The given vehicle is already a respawn vehicle!";
	};*/

	if (vehicleVarName _unit == "") then { //if vic doesn't have a var name, then give it one
		_unit setVehicleVarName format ["TAS_zeusRespawnVehicle%1",count TAS_respawnLocations]; //TODO make better
		//systemChat format ["3: %1",_unit];
	};
	private _vehicleName = vehicleVarName _unit;
	//systemChat format ["4: %1",_vehicleName];
	missionNamespace setVariable [_vehicleName, _unit];
	publicVariable _vehicleName;

	//systemChat format ["5: %1",_unit];
	[_unit,"hd_flag","ColorUNKNOWN",_name,true,5] call TAS_fnc_markerFollow;
	TAS_respawnLocations pushBack [_unit,_name]; //["TAS_zeusRespawnVehicle1","test1"]
	publicVariable "TAS_respawnLocations";

	//systemChat format ["assignRespawnVic a"];
	_unit addMPEventHandler ["MPKilled", {	//removes respawn vehicle from list. global effect, but unknown effect on JIP.
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		//systemChat format ["assignRespawnVic b %1",TAS_respawnLocations];
		private _path = [TAS_respawnLocations, _unit] call BIS_fnc_findNestedElement;
		if (_path isNotEqualTo []) then {	//only execute if it exists
			diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic removing repsawn vic from list!";
			private _indexOfOldVehiclePair = _path select 0;
			TAS_respawnLocations deleteAt _indexOfOldVehiclePair;
			publicVariable "TAS_respawnLocations";	// not needed due to global effect but better safe than sorry
		} else {
			diag_log "TAS-MISSION-TEMPLATE fn_assignRespawnVic cannot find vehicle to remove!";
		};
		//systemChat format ["assignRespawnVic c %1 %2 %3 %4",_unit,_path,_indexOfOldRallyPair];
		//systemChat format ["assignRespawnVic d %1",TAS_respawnLocations];
	}];
	//systemChat format ["assignRespawnVic e"];
};
[
	"Set Respawn Vehicle Name", 
	[
		["EDIT","Text"] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

/*[_unit,_name] spawn { //create marker and update it on vehicle every minute while it's alive
	private _marker = createMarkerLocal [format ["TAS_respawnVehicleMarker_%1",_name], position gangFourLeader]; //change for correct gang
	_marker setMarkerType "mil_flag_noShadow";
	_marker setMarkerColor "ColorUNKNOWN"; //TODO change based on player side?
	_marker setMarkerText _name; //change for correct gang

	while {alive _this} do { //returns false if null
		_marker setMarkerPos getPos _this;
		sleep 60;
	};
};*/