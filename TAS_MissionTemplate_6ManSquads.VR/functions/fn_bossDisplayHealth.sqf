//run locally on each client
//[] spawn TAS_fnc_displayHealth;
private _debug = false;

if !(TAS_bossEnabled) exitWith {
	diag_log "TAS MISSION TEMPLATE: attempted to display boss health system without the boss system being enabled!";
	if (_debug) then {
		systemChat format ["attempted to display boss health system without the boss system being enabled!"];
	};
};

if (_debug) then {
	systemChat format ["Handle damage waiting for variable setup!"];
};

waitUntil {sleep TAS_bossInterval; !(isNil "TAS_bossComponents")};

if (_debug) then {
	systemChat format ["Handle damage starting loop!"];
};

while {true} do { //TODO not true
	private _imag  = format ["<img size='8' image='%1' align='center'/>",TAS_bossImagePath];
	private _output = "<br/><t color='#cc6600' size='3' align='center'>MECH HEALTH DISPLAY</t><br/><br/>";
	
	{
		private _varName = format ["TAS_%1",_x];
		private _health = missionNamespace getVariable [_varName, [0,1]]; //2 decimals
		private _currentHealth = _health select 0;
		private _defaultHealth = _health select 1;
		switch true do { //compare %
			case ((_currentHealth / _defaultHealth) >= .75): { _health = format ["<t color='#00ff00'>ONLINE</t><br/>"] };
			case (((_currentHealth / _defaultHealth) < .75) && ((_currentHealth / _defaultHealth) >= .35)): { _health = format ["<t color='#ffff00'>DAMAGED</t><br/>"] };
			case (((_currentHealth / _defaultHealth) < .35) && ((_currentHealth / _defaultHealth) > 0)): { _health = format ["<t color='#ff0000'>CRITICAL</t><br/>"] };
			case (_currentHealth <= 0): { _health = format ["<t color='#800000'>DESTROYED</t><br/>"] };
			default { _health = "error: no health value found" };
		};

		_output = _output + (format ["<br/>%1: %2", _x, _health]);

		if (_debug) then {
			systemChat format ["Displaying %1 with varname of %2 and currentHealth of %3 with defaultHealth of %4",_x,_varName,_currentHealth,_defaultHealth];
		};
	} forEach TAS_bossComponents;

	hint parseText (_output + "<br/><br/>" + _imag + "<br/><br/>");

	sleep TAS_bossInterval;

	/*
	private _imag  = "<img color='#ff0000' size='2' image='logo256x256.paa' align='center'/>";
	private _text = "<t color='#ff0000' size='1.2' align='center'>Welcome</t><br/><br/>";
	hint parseText (_imag + _text);
	*/
};