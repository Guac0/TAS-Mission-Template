/*
	Author: Guac

	Requirements: none
	
	Description:
	Tool to grab Eden camera information used in fn_cam_makeCam.

	Return value:
	Basic camera data in array [world name, camera object (hardcoded to '_camera'),
		camera position, camera direction, camera pitch and bank]
	See fn_camModify for full list of parameters that can be added.
		Some are ommited due to not being capturable by this function (like commit time).

	Usage:
	Position camera in Eden how you want the camera angle to look in your cinematic
	Open debug console with "Alt + D" keyboard combo
	Type in the following: "[] call TAS_fnc_cam_camDataGrabber" (without quotes) and execute
	Copy and paste result (without begining/end quotes) into fnc_cam_main
		(or other cinematic main file if doing custom)
*/

// Note that "_island" does not have any effect, it's just for zeus organizational purposes.
format [
	"['%1',_camera,%2,%3,%4]",
	worldName,
	getPos get3DENCamera,
	getDir get3DENCamera,
	get3DENCamera call BIS_fnc_getPitchBank
]