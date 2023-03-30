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

	[_unit,_name] remoteExec ["TAS_fnc_assignRespawnVicInit",2]; //exec on server
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