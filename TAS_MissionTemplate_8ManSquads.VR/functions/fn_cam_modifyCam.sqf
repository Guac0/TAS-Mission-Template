/*
	Author: Guac
	Inspiration from Haleks and their Remnant mod's showcases.

	Requirements: none
	
	Description:
	Helper function to create/modify a camera with the specified settings.

	Return value:
	true once camera has finished commiting changes. Could take a long time if _commitTime was set high.

	Usage:
	[[] call TAS_fnc_cam_camDataGrabber] call TAS_fnc_cam_modifyCam;
*/

params ["_Island", "_camera", "_camPosition", "_camDirection", "_pitchBank",["_commitTime",0],["_FOV",0.75]];
// Note that "_island" does not have any effect, it's just for zeus organizational purposes.
// fov default is 0.75. commit is 0 unless moving the camera

//_camera = "camera" camcreate position player;
_camera cameraEffect ["internal", "back"];
_camera setDir _camDirection;
_camera camPreparePos _camPosition;
_camera camPrepareFOV _FOV;
_camera camPreload 0;
//preloadCamera _camPosition;
//waitUntil { camPreloaded _camera };
[_camera, _pitchBank#0, _pitchBank#1] call BIS_fnc_setPitchBank;
_camera camCommitPrepared _commitTime;
waitUntil { camCommitted _camera };

true