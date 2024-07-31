/*
	Author: Guac

	Requirements: none
	
	Description:
	Helper function creating a basic transition to another camera angle, optionally with text.
	Execute locally to each player.

	Return value: true

	Usage:
	[[] call TAS_fnc_cam_camDataGrabber] call TAS_fnc_cam_transition;
	[[] call TAS_fnc_cam_camDataGrabber,5] call TAS_fnc_cam_transition;
	[[] call TAS_fnc_cam_camDataGrabber,3,"My Basic Message"] call TAS_fnc_cam_transition;
	[[] call TAS_fnc_cam_camDataGrabber,3,"<t color='#ffffff' size='2' shadow='0' font='PuristaLight' align='left'>My Fancy Message</t>",true] call TAS_fnc_cam_transition;
	[[] call TAS_fnc_cam_camDataGrabber,3,"<t color='#ffffff' size='2' shadow='0' font='PuristaLight' align='left'>My Fancy Message lasting for 15 seconds</t>",true,15] call TAS_fnc_cam_transition;
	[[] call TAS_fnc_cam_camDataGrabber,5] remoteExec ["TAS_fnc_cam_transition",_remotePlayerUnit];
*/

params ["_newCamData",["_fadeTime",3],["_text",""],["_isStructuredText",false],["_textTime",7]];

cutText ["", "BLACK OUT", _fadeTime]; // begin fade out
sleep _fadeTime; //wait for fade to finish
private _result = _newCamdata call TAS_fnc_cam_modifyCam; //new camera angle
if (_result isNotEqualTo true) exitWith { ["fn_cam_transition: error when attempting to modify camera object!"] call TAS_fnc_error};

if (_text isNotEqualTo "") then { //if we have text, display it
	titleText [_text, "BLACK", _textTime / 10, true, _isStructuredText]; //time param is messed up and is actually 10x the specified time
	sleep _textTime; //wait for text to finish
};

cutText ["", "BLACK IN", _fadeTime]; //begin fade in
sleep _fadeTime; //wait for fade to complete

true