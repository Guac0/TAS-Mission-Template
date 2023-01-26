private _sourcestr = "Server";
private _position = 0;

if (!isServer) then {
    if (!isNil "HC1") then {
        if (!isNull HC1) then {
            if (local HC1) then {
                _sourcestr = "HC1";
                _position = 1;
            };
        };
    };

    if (!isNil "HC2") then {
        if (!isNull HC2) then {
            if (local HC2) then {
                _sourcestr = "HC2";
                _position = 2;
            };
        };
    };

    if (!isNil "HC3") then {
        if (!isNull HC3) then {
            if (local HC3) then {
                _sourcestr = "HC3";
                _position = 3;
            };
        };
    };
};

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

    private _output = format ["%1 - FPS: %2 - Local groups: %3 - Local units: %4 - Active Scripts: [spawn: %5, execVM: %6, exec: %7, execFSM: %8] - Last Updated: %9 (server time)",
		_sourcestr,
		_myfps,
		_localgroups,
		_localunits,
		diag_activeScripts select 0,
		diag_activeScripts select 1,
		diag_activeScripts select 2,
		diag_activeScripts select 3,
        serverTime 
    ];

    _myfpsmarker setMarkerText _output;
    diag_log _output;
    
    sleep 15; //updates FPS and markers every 15 secounds
};