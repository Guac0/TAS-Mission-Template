/*
	Author: Guac

	Requirements: None
	
	Generates various debug information (mostly related to performance) to the RPT log on the given machine.

	Examples:
	[true,300,2,true] call TAS_fnc_debugPerfRpt;		//loops forever, generates report every 5 minutes, sends report information to the server log and also saves a copy to the client log
*/

private _duration 		= _this select 0;	//accepts true for infinite time
private _delay 			= _this select 1;	//delay between logs
private _targetOutput	= _this select 2;	//machine to send output to
private _localOutput	= _this select 3;	//boolean, whether to save a copy to the client machine too

while {_duration} do {
	
	private _output = format ["%1 - FPS: %2 - Local groups: %3 - Local units: %4 - Active Scripts: [spawn: %5, execVM: %6, exec: %7, execFSM: %8]",
		name player,
		((round (diag_fps * 100.0)) / 100.0),
		{local _x} count allGroups,
		{local _x} count allUnits,
		diag_activeScripts select 0,
		diag_activeScripts select 1,
		diag_activeScripts select 2,
		diag_activeScripts select 3
	];

	_output remoteExec ["diag_log",_targetOutput];

	if (_localOutput) then {
		diag_log _output;
	};

	sleep _delay;
};