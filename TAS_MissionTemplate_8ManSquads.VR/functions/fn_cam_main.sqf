/*
	Author: Guac

	Requirements: none
	
	Description:
	Provides a framework and examples for using the camera modules.
	Execute locally to each player.

	Return value: true

	Usage:
	Set "_viewDistance" in the View Distance section to your desired forced view distance.
	Collect your desired camera angles using "fn_cam_camDataGrabber.sqf". See the "usage" section in that file for details.
	Edit the "Main Cinematic" section to have your camera angles and timings. See the tutorials below for info.
	Execute the function by using one of the commands in the "Examples" section below once you are ingame.

	Examples:
	[] spawn TAS_fnc_cam_main;
	[] remoteExec ["TAS_fnc_cam_main",_specificPlayerObject];
	[] remoteExec ["TAS_fnc_cam_main"]; //all players
*/

/////////////////////////
///// VIEW DISTANCE /////
/////////////////////////

private _viewDistance = 2000; //change this to whatever view distance you want to set
private _oldViewDistance = viewDistance;
private _oldObjViewDistance = getObjectViewDistance select 0; //second arg is shadow
setViewDistance _viewDistance;
setObjectViewDistance _viewDistance;
private ["_oldCHVD_foot","_oldCHVD_car","_oldCHVD_air","_oldCHVD_footObj""_oldCHVD_carObj""_oldCHVD_airObj"];
if (isClass(configFile >> "CfgPatches" >> "CHVD")) then { //if CH View Distance is loaded, set that too
	//CHVD_footObj CHVD_carObj CHVD_airObj
	//CHVD_allowNoGrass = false; //false for disabling client's ability to set 'low' terrain detail (which doesn't render grass)
	//CHVD_maxView = _viewDistance; //max terrain view distance client can set
	//CHVD_maxObj = _viewDistance; //max object view distance client can set
	_oldCHVD_foot = CHVD_foot;
	_oldCHVD_car = CHVD_car;
	_oldCHVD_air = CHVD_air;
	_oldCHVD_footObj = CHVD_footObj;
	_oldCHVD_carObj = CHVD_carObj;
	_oldCHVD_airObj = CHVD_airObj;
	CHVD_foot = _viewDistance;
	CHVD_car = _viewDistance;
	CHVD_air = _viewDistance;
	CHVD_footObj = _viewDistance;
	CHVD_carObj = _viewDistance;
	CHVD_airObj = _viewDistance;
};

/////////////////////////
/////// MISC PREP ///////
/////////////////////////

//hide dui hud
["diwako_dui_main_hide_ui_by_default", true, 999, "server", false] call CBA_settings_fnc_set;

//prep camera
private _camera = "camera" camCreate position player; 
showCinemaBorder true;

/////////////////////////
///// MAIN CINEMATIC ////
/////////////////////////
// You edit everything in this section.

// Prep your opening camera angle using data from fn_cam_camDataGrabber
['VR',_camera,[105.84,219.504,16.8556],138.152,[-19.3174,-3.07606e-005]] call TAS_fnc_cam_modifyCam;

// If you are beginning the cinematic immediately at mission start,
// 	you may wish to incorporate a ~10 second pause to allow people to
// 	fully load in before the cinematic starts. Note that this is a
// 	CLIENT SIDE timer (not synced to all players due to network issues),
// 	but players should remain roughly in sync as long as you wait for all
// 	to load in on map screen before pressing play on the main mission.
// You may safely comment this out except for the final two "fade in" lines
// 	which are recommended.
cutText ["","BLACK FADED",999]; //immediate black screen for 999 seconds
titleText ["<t color='#f59b00' size='4' shadow='0' font='PuristaLight' align='left'>Waiting for all players to load...</t>", "BLACK", 999, true, true]; //create fake "waiting for players" text. note: its just a basic timer, not an actual waiting for loading
sleep 10; //delay time
titleText ["", "PLAIN", 0, true, true]; //remove waiting text immediately
cutText ["", "BLACK IN", 5]; //fade in over 5 seconds
sleep 5; //wait for fade to complete

// At this point, your first camera angle is fully visible.
// Let's start some music and give the player 10 seconds to appreciate the view...
playMusic "LeadTrack01_F"; //"This Is War", vanilla music, 2:43 duration
sleep 10;

// Now, let's do a basic fade to another angle, taking 3 seconds to fade out and another 3 to fade in.
// Note that using "call" pauses execution of "fn_cam_main" until the sub function ("fn_cam_transition")
// 	is done, which is when the transition is fully complete and the player sees the new camera angle.
// If you wish to not pause this script (i.e. doing something custom with text or music in the middle
//	of the transition), you can change "call" to "spawn".
// Make sure to account for the time the transition takes if you choose to use spawn (fade out time + 
// 	fade in time + text time [if applicable])
[['VR',_camera,[143.491,170.049,7.75402],33.8745,[-22.3405,-4.70769e-005]],3] call TAS_fnc_cam_transition;

// The second camera angle is fully visible now.
// We'll give the player another ten seconds to look at things in this camera angle.
sleep 10;

// Let's do another transition, but this time we'll display some basic text for the player during 
// 	the transition. By default, it will fade out over 3 seconds, the text will be shown for 7 seconds, 
// 	and then the new camera angle will fade in over 3 seconds.
// TODO: basic text appears to break some/most transitions. Recommend using fancy text as shown in the
//	next example instead.
[['VR',_camera,[170.739,175.467,1.93443],317.906,[0.610717,-5.61922e-005]],3,"My Basic Example Text Explaining Scenario Lore Over Black Screen",false,5] call TAS_fnc_cam_transition;

// The third camera angle is fully visible now and the text is gone.
// We'll give the player another ten seconds to look at things in this camera angle.
sleep 10;

// Let's get a little fancier. We'll do another transition with text, but let's make it look really nice.
// Again, let's have a fade time of 3 seconds, but we need to use the special structured text format, pass
// 	in a fourth argument of "true" to indicate that its structured text, and then specify that we want it shown
// 	for exactly 10 seconds.
// TODO: slight mistimings in text appear to be causing removal of the gradual fade in
[['VR',_camera,[150.141,207.255,1.8932],190.518,[-2.71599,-5.56649e-005]],3,"<t color='#ffffff' size='2' shadow='0' font='PuristaLight' align='left'>My Super Duper Fancy Example Text Explaining Scenario Lore Over Black Screen</t>",true,10] call TAS_fnc_cam_transition;

// The fourth camera angle is fully visible now and the text from the transition is gone.
// Let's show the player some fancy text over the current camera angle.
// Note how the color and some other settings are different, as we need to make it contrast better with the scene.
// Also note the "1": this is the time parameter for how long to show the text before fading, but for some reason
// 	it will actually show for 10x the specified value. Therefore, this text will be shown for 10 seconds.
titleText ["<t color='#f59b00' size='4' shadow='0' font='PuristaLight' valign='top'>What a nice example view!</t>", "PLAIN", 1, true, true];

// We'll give the player another ten seconds to look at things (and the text!) in this camera angle before moving on.
sleep 10;

// Okay, we've done a lot with text. Let's do a final cool thing with camera perspectives: a moving camera.
// We'll start with a basic transition to our new starting position for our camera:
[['VR',_camera,[156.031,216.696,0.250831],179.414,[1.38844,-5.37487e-005]]] call TAS_fnc_cam_transition;

// And now that we're in the new camera angle, let's call the modifyCam function directly to alter the camera
// 	without transitioning through a black screen. We won't bother with a sleep because we want to start moving immediately.
// Notice how the camera data is the same as the previous transition except for two things:
// 1. The third argument (camera position) is the same except for being 100 meters higher than before
// 2. There is now a sixth argument that controls the "commit time", or the time in seconds that it takes for
//	  	the camera to move from its original position to its new position. If there is no sixth argument set, it
//	  	defaults to 0 (aka instant teleport to new position). Here, it's set to 20 seconds.
// Note that, similar to the earlier note about call vs spawn for fnc_cam_transition, using call for
//	fnc_cam_modifyCam will pause execute of this main script until the camera has been fully changed to its
//	new position (i.e. it will resume after the 20 second camera movement provided here)
['VR',_camera,[156.031,216.696,100.250831],179.414,[1.38844,-5.37487e-005],20] call TAS_fnc_cam_modifyCam;

// Alright, that was a pretty cool series of shots. Don't put anything beneath this line and this function
// 	will automatically fade out over 5 seconds, return the player to first person view with character control
// 	(while covered in a black screen), and fade their perspective back into their first person camera over five seconds.

/////////////////////////
///// End + Cleanup /////
/////////////////////////

cutText ["", "BLACK OUT", 3]; //fade to black in 3 seconds
sleep 5;
showCinemaBorder false;
_camera cameraEffect ["terminate", "back"]; //destroy camera safely
camDestroy _camera; //destroy camera safely
cutText ["", "BLACK IN", 5]; //fade into first person camera in 3 seconds

//re-enable DUI if loaded
if (isClass(configFile >> "CfgPatches" >> "diwako_dui_main")) then {
	["diwako_dui_main_hide_ui_by_default", false, 999, "server", false] call CBA_settings_fnc_set;
};

//reset view distance to defaults
setViewDistance _oldViewDistance;
setObjectViewDistance _oldObjViewDistance;
if (isClass(configFile >> "CfgPatches" >> "CHVD")) then { //if CH View Distance is loaded, set that too
	//CHVD_allowNoGrass = false; //false for disabling client's ability to set 'low' terrain detail (which doesn't render grass)
	//CHVD_maxView = 12000; //max terrain view distance client can set
	//CHVD_maxObj = 12000; //max object view distance client can set
	CHVD_foot = _oldCHVD_foot;
	CHVD_car = _oldCHVD_car;
	CHVD_air = _oldCHVD_air;
	//TODO fix obj
	//CHVD_footObj = _oldCHVD_footObj;
	//CHVD_carObj = _oldCHVD_carObj;
	//CHVD_airObj = _oldCHVD_airObj;
};

true