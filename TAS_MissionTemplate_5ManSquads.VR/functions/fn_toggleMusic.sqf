//TAS Music Hotkey Script
//Written by Guac
//Requirements: CBA

//setup TAS_musicEnabled, if player does not have TAS_musicEnabled already defined then default to false
private _unit = player;
private _musicEnabled = _unit getVariable ["TAS_musicEnabled", false];


if (_musicEnabled) then { //undoes effect if player already has music enabled 
	1 fadeMusic 1;
	systemChat "Unmuted music!";
	_unit setVariable ["TAS_musicEnabled",false];
} else { //Turns music off
	1 fadeMusic 0;
	systemChat "Muted music!";
	_unit setVariable ["TAS_musicEnabled",true];
};