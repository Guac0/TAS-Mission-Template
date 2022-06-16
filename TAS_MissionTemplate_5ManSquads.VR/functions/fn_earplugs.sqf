//TAS Earplugs Script
//Written by Guac
//Requirements: CBA

//function to use in making/unmaking afk

//setup TAS_earplugsEnabled, if player does not have TAS_earplugsEnabled already defined then default to false
private _AfkPlayer = player;
private _earplugsEnabled = _AfkPlayer getVariable ["TAS_earplugsIn", false];
private _reducedVolume = TAS_earplugVolume; //private var to reduce strain from querying global


if (_earplugsEnabled == true) then { //undoes effect if player already has earplugs in (toggles to off)
	{
		3 _x 1;
	} forEach [fadeSound,fadeRadio,fadeSpeech,fadeMusic,fadeEnvironment];
	_AfkPlayer setVariable ["TAS_earplugsIn",false];
} else { //applies effect if player doesn't have earplugs in (toggles to on)
	{
		3 _x _reducedVolume; //change to _reducedVolume over 3 seconds
	} forEach [fadeSound,fadeRadio,fadeSpeech,fadeMusic,fadeEnvironment];
	_AfkPlayer setVariable ["TAS_earplugsIn",true];
};