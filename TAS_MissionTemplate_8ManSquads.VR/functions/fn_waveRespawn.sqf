if !(isServer) exitWith {};

//setup
TAS_waveRemainingTime	= TAS_waveTime;
publicVariable "TAS_waveRemainingTime";
private _playersWaiting = [];

while {TAS_waveRespawn} do {

	//countdown, server side with broadcasting to clients every so often
	private _time = TAS_waveTime;
	diag_log format ["TAS MISSION TEMPLATE: WAVE RESPAWN beginning new cycle, %1 remaining",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
	while { _time > 0 } do {
		_time = _time - 1;  
		if (_time % 20 == 0) then { //debug message and timer broadcast every 20 seconds
			_playersWaiting = [];	//reset array
			{
				if (_x getVariable ["TAS_waitingForReinsert",false]) then {
					_playersWaiting pushBack _x;
				};
			} forEach allPlayers;
			TAS_waveRemainingTime = _time;
			publicVariable "TAS_waveRemainingTime";
			diag_log format ["TAS MISSION TEMPLATE: WAVE RESPAWN waiting, %1 remaining in cycle, %2 players waiting.",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring, count _playersWaiting];
		};
		sleep 1;
	};

	//do the reinsert
	_playersWaiting = [];	//reset array
	{
		if (_x getVariable ["TAS_waitingForReinsert",false]) then {
			_playersWaiting pushBack _x;
		};
	} forEach allPlayers;
	diag_log format ["TAS MISSION TEMPLATE: WAVE RESPAWN occuring, %1 players %2 being reinserted.", count _playersWaiting, _playersWaiting];
	/*{
		[false,false,false] call ace_spectator_fnc_setSpectator; 
		switch (TAS_waveReinsertType) do {
			case "base": 		{
				//nothing, they're already at the reinsert point
			};
			case "rallypoint": 	{
				"rallypoint" remoteExec ["TAS_fnc_respawnGui",_x];
			};
			case "vehicle":		{
				"vehicle" remoteExec ["TAS_fnc_respawnGui",_x];
			};
			case "custom":		{
				//add whatever code you want here. The current player iterated is referred to as "_x".



			};
			default 			{
				//nothing, same as "base"
				diag_log "TAS MISSION TEMPLATE: WAVE RESPAWN using default case for reinserts!";
			};
		};
		_x setVariable ["TAS_waitingForReinsert",false];
	} forEach _playersWaiting;*/
	_playersWaiting 		= [];	//reset array
	TAS_waveRemainingTime	= 0;
	publicVariable "TAS_waveRemainingTime";

	sleep 30;	//grace period for respawns

	//back to top
};