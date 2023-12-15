//Play video in corner script by Freddo found via Bassbeard's Wonder Emporium with minimal edits
	//https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em

/*
Plays the given video file in the corner (top right?) of the player's screen. Tested for 16:9 aspect resolution.
Execute locally on each client.
if (isServer) then { ["path\to\video.ogv"] remoteExec ["TAS_fnc_playCornerVideo"] };
*/

#include "\a3\ui_f\hpp\definecommongrids.inc"

params ["_videoPath"]; //"path\to\video.ogv"
[
  _videoPath,
  [
    GUI_GRID_X + safeZoneW - 2.1 * GUI_GRID_W, // X coordinate for top left of video
    safeZoneY + GUI_GRID_H * 0.1, // Y coordinate for top left of screen, with a slight gutter
    GUI_GRID_W * 2, // Width, leaving a slight gutter
    GUI_GRID_H * 2 // Height
  ],
  [1,1,1,1], // Colour filter
  "BIS_fnc_playVideo_skipVideo", // Mission namespace variable to skip
  [0,0,0,1], // Background colour
  true // Keep aspect, fill rest with background colour
] spawn BIS_fnc_playVideo;
