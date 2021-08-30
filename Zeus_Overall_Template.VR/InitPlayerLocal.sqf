
sleep 1; //wait for mission start (server init will happen in map screen)

//setup variable names of leadership positions for loadout assignment
private _leadership = ["CMD_Actual","CMD_JTAC","AIR_1_Actual","AIR_2_Actual","GROUND_1_Actual","GROUND_2_Actual","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _playerClass = vehicleVarName player;

//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group

//disableStamina
if (local player) then {
  player enableFatigue false;
  player addMPEventhandler ["MPRespawn", {player enableFatigue false}]; 
};

//Add TAS Afk Script
if (TAS_afkEnabled) then {
	[] execVM "Scripts\TAS_afkScript.sqf";
} else {
	systemChat "Afk System disabled.";
};

//Add FOB Script
if (TAS_fobEnabled) then {
	[] execVM "buildfob\initfob.sqf";
} else {
	systemChat "FOB/Rallypoint building disabled.";
};

//Register TAS_globalTFAR as a function if enabled in initServer, also add tutorial diary entry
if (TAS_globalTFAREnabled) then { 
	TAS_fnc_globalTFAR = compile preprocessFile "Scripts\TAS_globalTFAR.sqf";
	player createDiaryRecord ["Diary", ["TAS Global TFAR Script", "Sets all Short Range radios to a single channel for Zeus/Lore events. Restores radios to prior channel when run a second time. Can be executed from either debug console or via trigger by using remoteExecCall on TAS_fnc_globalTFAR."]];
	systemChat "TAS Global TFAR System enabled."
} else {
	systemChat "TAS Global TFAR System disabled."
};

//radio setup
if (TAS_autoRadioLoadoutsEnabled) then {
	player linkItem TAS_radioPersonal;
	if (_playerClass in _leadership) then {player addBackpack TAS_radioBackpack;};
	systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";
} else {
	systemChat "TFAR automatic radio assignment disabled."
};

//ctab setup
if (TAS_ctabEnabled) then {
	player addItem "ItemcTabHCam"; //give all players a helmetcam, will auto delete hcam if inventory is full
	player linkItem "itemAndroid"; //give everyone an android in their gps slot, will be overwriten if they are leadership
	if (_playerClass in _leadership) then {player linkItem "itemcTab"; player addItem "itemAndroid";}; //give leadership an android in their inventories and a tablet in their gps slot (will delete existing item), will auto delete android if inventory is full
	systemChat "cTab loadout init finished.";
} else {
	systemChat "cTab automatic item assignment disabled."
};

if (TAS_bftEnabled) then {
	[] execVM "scripts\QS_icons.sqf";
	systemChat "QS BFT initiated.";
} else {
	systemChat "QS BFT disabled.";
};