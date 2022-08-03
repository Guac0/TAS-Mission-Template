//TAS Music Hotkey Script
//Written by Guac
//Requirements: CBA

//setup TAS_musicEnabled, if player does not have TAS_musicEnabled already defined then default to false
private _unit = player;
private _musicEnabled = _unit getVariable ["TAS_musicDisabled", false];


if (_musicEnabled) then { //undoes effect if player already has music enabled 
	2 fadeMusic 1; //fades in over 2 seconds
	systemChat "Smoothly unmuting music over two seconds!";
	_unit setVariable ["TAS_musicDisabled",false];
} else { //Turns music off
	0 fadeMusic 0;
	systemChat "Muted music!";
	_unit setVariable ["TAS_musicDisabled",true];
};