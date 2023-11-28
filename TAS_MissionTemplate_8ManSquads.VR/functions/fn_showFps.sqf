//show fps script by Mildly Interested/Bassbeard, modified by Guac

//are we going to run into issues with multiple clients executing this at game start and thus all having position 0?
    //if so, we should wait a random number of seconds (5-30) before we start
params [["_timeout",floor (random 30)],["_unit",player]];

if (_timeout > 0) then {
    sleep _timeout;
};

private _position = missionNamespace getVariable ["TAS_numberFpsDisplaysActive",0];
missionNamespace setVariable ["TAS_numberFpsDisplaysActive",_position + 1,true];

if (_position > 5) then {
    [format ["TAS_showFps: selected position (%1) is > 5, map marker may not be visible due to excessive distance from map!",_position]] call TAS_fnc_error;
};

private ["_sourcestr"];
if (isServer) then {
    _sourcestr = "Server";
} else {
    _sourcestr = name _unit;
};

[format ["TAS_showFps: Executing on %1 with timeout of %2 and position of %3.",_sourcestr,_timeout,_position]] call TAS_fnc_error;

private _myfpsmarker = createMarker [format ["fpsmarker%1", _sourcestr], [0, -500 - (500 * _position)]];
_myfpsmarker setMarkerType "mil_start";
_myfpsmarker setMarkerSize [0.7, 0.7];

while {true} do {

    private _myfps = (round (diag_fps * 100.0)) / 100.0;
    private _localgroups = {local _x} count allGroups;
    private _localunits = {local _x} count allUnits;

    _myfpsmarker setMarkerColor "ColorGREEN";
    if (_myfps < 30) then {_myfpsmarker setMarkerColor "ColorYELLOW";};
    if (_myfps < 20) then {_myfpsmarker setMarkerColor "ColorORANGE";};
    if (_myfps < 10) then {_myfpsmarker setMarkerColor "ColorRED";};

    private _output = format ["%1 - FPS: %2 - Local groups: %3 - Local units: %4 - Active Scripts: [spawn: %5, execVM: %6, exec: %7, execFSM: %8] - Last Updated: %9",
		_sourcestr,
		_myfps,
		_localgroups,
		_localunits,
		diag_activeScripts select 0,
		diag_activeScripts select 1,
		diag_activeScripts select 2,
		diag_activeScripts select 3,
        [dayTime] call BIS_fnc_timeToString 
    ];

    _myfpsmarker setMarkerText _output;
    diag_log _output;
    
    sleep 15; //updates FPS and markers every 15 secounds
};