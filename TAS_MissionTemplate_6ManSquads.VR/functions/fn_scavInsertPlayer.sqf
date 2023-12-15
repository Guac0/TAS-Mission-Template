//helper function that performs the insert location calculations for _unit
//needed because the AO buildings variable is only held on the server machine
params ["_unit"];

if !(isServer) then {
	[format ["fn_scavInsertPlayer is being executed on %1 instead of on the server, errors will likely occur!!",name player],false] call TAS_fnc_error;
};

private _availableExtracts = missionNamespace getVariable ["TAS_scavExtracts",[0,0,0]];
private _spawnHouse = [] call TAS_fnc_scavFindSuitableBuilding;
private _houseTpPosAGL = _spawnHouse buildingPos 1;
if (_houseTpPosAGL isEqualTo [0,0,0]) then { //fallback, spawn near extract
	private _spawnPointExtract = selectRandom _availableExtracts;
	private _spawnPoint = [_spawnPointExtract,3,20,1] call BIS_fnc_findSafePos;
	player setPosATL [_spawnPoint select 0, _spawnPoint select 1, 0.25];
	["fn_scavInsertPlayer houseTpPosAGL is invalid, performing backup spawn"] call TAS_fnc_error;
} else {
	_unit setPosASL (AGLToASL _houseTpPosAGL);
};