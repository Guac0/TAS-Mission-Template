if !(isServer) exitWith {};

private _layersToSwawn = _this select 0; //provide as two dimensional array
private _delay = _this select 1;
private _clientToSpawnOn = _this select 2; //"2" (as number, not string) for server; "HC#" (as object, not string) to execute on HC

[format ["AI spawning in %1, be prepared for desync/lag for a short time!", [((_delay)/60)+.01,"HH:MM"] call BIS_fnc_timeToString] ] remoteExec ["hint"];
[format ["AI spawning in %1, be prepared for desync/lag for a short time!", [((_delay)/60)+.01,"HH:MM"] call BIS_fnc_timeToString] ] remoteExec ["systemChat"];
while { (_delay > 0)} do {
	_delay = _delay - 1;
	[format ["AI spawning in %1, be prepared for desync/lag for a short time!", [((_delay)/60)+.01,"HH:MM"] call BIS_fnc_timeToString] ] remoteExec ["hintSilent"];
	sleep 1;
};
[format ["AI now spawning, prepare for desync/lag for a short time!", [((_delay)/60)+.01,"HH:MM"] call BIS_fnc_timeToString] ] remoteExec ["hint"];
[format ["AI now spawning, prepare for desync/lag for a short time!", [((_delay)/60)+.01,"HH:MM"] call BIS_fnc_timeToString] ] remoteExec ["systemChat"];

[_layersToSwawn,"spawnUnits.sqf"] remoteExec ["execVM",_clientToSpawnOn];

//sleep 15;
//"" remoteExec ["hintSilent"];
//[[["northbase","officers","southcentraldump"]],10,2] remoteExec ["TAS_fnc_spawnAiWithWarning",2];