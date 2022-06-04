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

	TAS_testOne = _unit;
	systemChat format ["2: %1",TAS_testOne];

	if (_unit == objNull) exitWith {
		hint "Place the module on a vehicle!";
		systemChat "Place the module on a vehicle!";
	};
	if !(_unit isKindOf "AllVehicles") exitWith { //TODO this allows men
		hint "Place the module on a vehicle!";
		systemChat "Place the module on a vehicle!";
	};
	//TODO cancel if already in respawn vic array and cancel duplicate names

	//_varUnit = missionNamespace getVariable [_unit,objNull];
	if (vehicleVarName _unit == "") then { //if vic doesn't have a var name, then give it one
		_unit setVehicleVarName format ["TAS_zeusRespawnVehicle%1",count TAS_respawnVehicles]; //TODO make better
		private _varName = format ["var_%1",_unit];
		_varName = _unit;
		publicVariable str _varName;
		systemChat format ["4: %1",_varName];
	};
	TAS_testOne = _unit;
	systemChat format ["3: %1",TAS_testOne];
	TAS_respawnVehicles pushBack [_unit,_name]; //["TAS_zeusRespawnVehicle1","test1"]
	publicVariable "TAS_respawnVehicles";
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