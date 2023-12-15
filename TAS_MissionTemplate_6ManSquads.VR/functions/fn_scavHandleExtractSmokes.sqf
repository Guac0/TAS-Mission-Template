params [["_emitters",missionNamespace getVariable ["TAS_scavExtracts",[]]]];
private _debug = false;

if (_debug) then {[format ["TAS_fnc_scavHandleExtractSmokes starting with _emitters %1",_emitters]] call TAS_fnc_error};

while { player getVariable ["TAS_playerIsScav",false] } do {
	if (_debug) then {[format ["TAS_fnc_scavHandleExtractSmokes running loop!"]] call TAS_fnc_error};
	{
		private _smoke = "SmokeShellGreen" createVehicleLocal [0,0,0];
		_smoke attachTo [_x, [0, 0, 0]];
		if (_debug) then {[format ["TAS_fnc_scavHandleExtractSmokes adding smoke %1 to emitter %2!",_smoke,_x]] call TAS_fnc_error};
	} forEach _emitters;
	sleep 60;
};