//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_name"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_object",objNull,[objNull]]];

	//systemChat format ["2: %1",_object];

	//validate input object
	if (_object == objNull) exitWith {
		hint "Place the module on an object!";
		systemChat "Place the module on an object!";
	};
	if (_object isKindOf "AllVehicles") exitWith { //TODO this allows men and sometimes allows vehicles
		hint "Place the module on an object, not a vehicle!";
		systemChat "Place the module on an object, not a vehicle!";
	};

	[_object,_name] remoteExec ["TAS_fnc_assignRespawnFlagpoleInit",2]; //exec on server
};
[
	"Set Respawn Position Name", 
	[
		["EDIT","Text"] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;

/*[_object,_name] spawn { //create marker and update it on vehicle every minute while it's alive
	private _marker = createMarkerLocal [format ["TAS_respawnVehicleMarker_%1",_name], position gangFourLeader]; //change for correct gang
	_marker setMarkerType "mil_flag_noShadow";
	_marker setMarkerColor "ColorUNKNOWN"; //TODO change based on player side?
	_marker setMarkerText _name; //change for correct gang

	while {alive _this} do { //returns false if null
		_marker setMarkerPos getPos _this;
		sleep 60;
	};
};*/