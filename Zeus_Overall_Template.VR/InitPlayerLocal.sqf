//short sleep for server to read init file, probably bad
sleep 1;

//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group

//disableStamina
if (local player) then { 
  player enableFatigue false; 
  player addMPEventhandler ["MPRespawn", {player enableFatigue false}]; 
};

//Add TAS Afk Script
[] execVM "Scripts\afkScript.sqf";

//Add FOB Script
[] execVM "buildfob\initfob.sqf";

//Register TAS_globalTFAR as a function if enabled in initServer, also add tutorial diary entry
if (TAS_globalTFAREnabled) then { 
	TAS_fnc_globalTFAR = compile preprocessFile "Scripts\TAS_globalTFAR.sqf";
	player createDiaryRecord ["Diary", ["TAS Global TFAR Script", "Sets all Short Range radios to a single channel for Zeus/Lore events. Restores radios to prior channel when run a second time. Can be executed from either debug console or via trigger by using remoteExecCall on TAS_fnc_globalTFAR."]];
	systemChat "TAS Global TFAR System enabled."
} else {
	systemChat "TAS Global TFAR System disabled."
};

//radio setup
if (autoRadioLoadoutsEnabled) then {
	player linkItem radioPersonal;
	if (leader group player == player) then {player addBackpack radioBackpack;};
	systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";
} else {
	systemChat "TFAR automatic radio assignment disabled."
};

//ctab setup
if (ctabEnabled) then {
	player addItem "ItemcTabHCam"; //give all players a helmetcam
	if (leader group player != player) then {player linkItem "itemAndroid";}; //give riflemen an android in their gps slot
	if (leader group player == player) then {player linkItem "itemcTab"; player addItem "itemAndroid";}; //give leadership an android in their inventories and a tablet in their gps slot
	systemChat "cTab loadout init finished.";
} else {
	systemChat "cTab automatic item assignment disabled."
};
