//TAS Earplugs Script
//Written by Guac
//Requirements: CBA

//function to use in making/unmaking afk

//setup TAS_earplugsEnabled, if player does not have TAS_earplugsEnabled already defined then default to false
private _unit = player;
private _earplugsEnabled = _unit getVariable ["TAS_earplugsIn", false];
private _reducedVolume = TAS_earplugVolume; //private var to reduce strain from querying global


if (_earplugsEnabled == true) then { //undoes effect if player already has earplugs in (toggles to off)
	/*{
		1 _x 1;
	} forEach [fadeSound,fadeRadio,fadeSpeech,fadeMusic,fadeEnvironment];*/ //errors if we do it this way for some reason
	0 fadeSound 1;
	0 fadeRadio 1;
	0 fadeSpeech 1;
	if (_unit getVariable ["TAS_musicDisabled",false]) then { //don't change music volume if music is toggled off
		0 fadeMusic 1;
	};
	0 fadeEnvironment 1;
	systemChat "Took earplugs out!";
	_unit setVariable ["TAS_earplugsIn",false];
} else { //applies effect if player doesn't have earplugs in (toggles to on)
	/*{
		1 _x _reducedVolume; //change to _reducedVolume over 1 seconds
	} forEach [fadeSound,fadeRadio,fadeSpeech,fadeMusic,fadeEnvironment];*/
	0 fadeSound _reducedVolume;
	0 fadeRadio _reducedVolume;
	0 fadeSpeech _reducedVolume;
	if (_unit getVariable ["TAS_musicDisabled",false]) then { //don't change music volume if music is toggled off
		0 fadeMusic _reducedVolume;
	};
	0 fadeEnvironment _reducedVolume;
	systemChat "Put earplugs in!";
	_unit setVariable ["TAS_earplugsIn",true];
};