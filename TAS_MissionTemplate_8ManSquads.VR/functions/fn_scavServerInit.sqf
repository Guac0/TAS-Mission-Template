private _markers = [];
{
	private _object = _x;
	_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _object) then {
		_marker = createMarkerLocal [format ["%1_Marker",_x],getPos _object];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTextLocal "Extraction Point";
		_marker SetMarkerTypeLocal "mil_start";
		_marker setMarkerAlpha 0; //broadcast
		_markers pushback marker;
		
	} else {
		["fn_scavServerInit: missing at least one extraction point!",true] call TAS_fnc_error;
	};
} forEach ["TAS_extract_1","TAS_extract_2","TAS_extract_3","TAS_extract_4","TAS_extract_5","TAS_extract_6","TAS_extract_7","TAS_extract_8","TAS_extract_9","TAS_extract_10"];

//spawn objectives and make markers
//private _scavZone = triggerArea TAS_ScavZone_Marker;
private _centerZone = getMarkerPos TAS_ScavZone_Marker;
private _buildings = _centerZone nearObjects ["Building",(getMarkerSize TAS_ScavZone_Marker) select 0];
private _enterableBuildings = _buildings select (count (_x buildingPos -1) > 6);
private _objectivesToMake = 10;
private _distanceThreshold = 500;
while {_objectivesToMake > 0} do {
	private _potentialObjective = selectRandom _enterableBuildings;
	if ({_x distance _potentialObjective < _distanceThreshold} count allPlayers <= 0) then { //don't create an objective if players are nearby 
		private _objectiveBox = createVehicle ["VirtualReammoBox_camonet_F",(_potentialObjective buildingPos 0),[],0,"CAN_COLLIDE"]; //empty cache
		_objectivesToMake = _objectivesToMake - 1;
	};	
};
//I_Survivor_F
//mil_destroy
//ColorPink

missionNamespace setVariable ["TAS_scavTaskMarkers",_markers,true];

//spawn new objs as needed and create more markers