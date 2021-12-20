
sleep 1; //wait for mission start (server init will happen in map screen)

//setup diary subject
player createDiarySubject ["tasMissionTemplate","Mission Template","media\logo256x256.paa"];

//setup variable names of leadership positions for loadout assignment
private _leadership = ["Z1","Z2","Z3","CMD_Actual","CMD_JTAC","AIR_1_Actual","AIR_2_Actual","GROUND_1_Actual","GROUND_2_Actual","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _playerClass = vehicleVarName player;

//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group

//disableStamina, simple way since the more complicated way with addMPEventhandler bugged out recently. Must be here and in onPlayerRespawn
player enableFatigue false;

//Add TAS Afk Script
if (TAS_afkEnabled) then {
	[] execVM "scripts\TAS_afkScript.sqf";
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Afk Script", "Disabled."]];
	//systemChat "Afk System disabled.";
};

//Add FOB Script
if (TAS_fobEnabled) then {
	[] execVM "buildfob\initfob.sqf";
} else {
	//systemChat "FOB/Rallypoint building disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["FOB/Rallypoint System", "Disabled."]];
};

//Register TAS_globalTFAR as a function if enabled in initServer, also add tutorial diary entry
if (TAS_globalTfarEnabled) then { 
	TAS_fnc_globalTfar = compile preprocessFile "scripts\TAS_globalTfar.sqf";
	player createDiaryRecord ["tasMissionTemplate", ["Global TFAR Script", "Enabled. Sets all Short Range radios to a single channel for Zeus/Lore events. Restores radios to prior channel when run a second time. Can be executed from either debug console or via trigger by using remoteExecCall on TAS_fnc_globalTFAR."]];
} else {
	//systemChat "TAS Global TFAR System disabled."
	player createDiaryRecord ["tasMissionTemplate", ["Global TFAR Script", "Disabled."]];
};

//radio setup
if (TAS_radiosEnabled) then {
	player linkItem TAS_radioPersonal;
	if (_playerClass in _leadership) then {player addBackpack TAS_radioBackpack;};
	player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Enabled. It may take a second for Teamspeak to initialize your radios. If your radio freq shows up as blank, do not panic as this happens when it is set via script. All SRs are set on squad freq and LRs on 50."]];
	//systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Disabled."]];
	//systemChat "TFAR automatic radio assignment disabled."
};

//ctab setup
if (TAS_ctabEnabled) then {
	player addItem "ItemcTabHCam"; //give all players a helmetcam, will auto delete hcam if inventory is full
	player linkItem "itemAndroid"; //give everyone an android in their gps slot, will be overwriten if they are leadership
	if (_playerClass in _leadership) then {player linkItem "itemcTab"; player addItem "itemAndroid";}; //give leadership an android in their inventories and a tablet in their gps slot (will delete existing item), will auto delete android if inventory is full
	//systemChat "cTab loadout init finished.";
	player createDiaryRecord ["tasMissionTemplate", ["cTab Assignment", "Enabled. All units have recieved an Android and helmet cam, while leadership have also recieved a rugged tablet."]];
} else {
	//systemChat "cTab automatic item assignment disabled."
	player createDiaryRecord ["tasMissionTemplate", ["cTab Assignment", "Disabled."]];
};

if (TAS_bftEnabled) then {
	[] execVM "scripts\QS_icons.sqf";
	//systemChat "QS BFT initiated.";
	player createDiaryRecord ["tasMissionTemplate", ["Quicksilver BFT", "Enabled. Open your map or GPS to activate it."]];
} else {
	//systemChat "QS BFT disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Quicksilver BFT", "Disabled."]];
};

if (TAS_aceHealObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Ace Heal Object", "Enabled. Interact with the heal object in order to see and activate the heal action."]];
} else {
	//systemChat "Ace Heal Object disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Ace Heal Object", "Disabled."]];
};

if (TAS_aceSpectateObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Ace Spectate Object", "Enabled. Interact with the heal/spectate object in order to see and activate the spectate action. Press the 'Escape' key to exit spectator."]];
} else {
	//systemChat "Ace Spectate Object disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Ace Spectate Object", "Disabled."]];
};

//adds two resupply options to ZEN under the "Resupply" catagory
//each spawns a large crate with medical and 6 mags for each player's weapon
//to customize contents of resupply, edit the files in scripts\ammocrate.sqf and ammocratepara.sqf
//REQUIRES ZEN TO BE LOADED (on all clients! although maybe just the zeus if you adjusted the code [i.e. not init.sqf] https://zen-mod.github.io/ZEN/#/frameworks/custom_modules)
if (TAS_zeusResupply) then {
	["Resupply", "Spawn Resupply Crate", {[_this select 0] execVM "scripts\AmmoCrate.sqf"}] call zen_custom_modules_fnc_register;
	["Resupply", "Paradrop Resupply Crate", {[_this select 0] execVM "scripts\AmmoCratePara.sqf"}] call zen_custom_modules_fnc_register;
	//systemChat "Custom Zeus resupply modules enabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Enabled. Adds two custom resupply modules to Zeus. One spawns the crate at the cursor location, while the other paradrops it. Each spawns a large crate with medical and 6 mags for each player's weapon."]];
} else {
	//systemChat "Custom Zeus resupply modules disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Custom Zeus Resupply Modules", "Disabled."]];
};

//respawn with death gear
if (TAS_respawnDeathGear) then {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Enabled. You will respawn with the gear you had equipped when you died."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Disabled."]];
};

//respawn with saved gear
if (TAS_respawnArsenalGear) then {
	player setVariable ["arsenalLoadout",getUnitLoadout player]; //setup initial loadout so doesnt use config loadout if not done by player
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Enabled. Interact with the heal/spectate object in order to save your loadout."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Disabled."]];
};

//respawn in vehicle
if (TAS_respawnInVehicle) then {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Enabled. After a waiting period specified by the mission maker, respawning players will be teleported into the logistics vehicle. During this waiting time, respawning players can spectate, edit their loadout, or hang out at base."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Disabled."]];
};

if (TAS_fpsDisplayEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["FPS Counter (by MildlyInterested)", "Enabled. In the bottom left of the map you will see markers for the server and any HCs with various debug information."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["FPS Counter (by MildlyInterested)", "Disabled."]];
};

if (TAS_resupplyObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Resupply Object Spawner", "Enabled. At base, players will be able to spawn a supply crate with ammo and medical for all the players."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Resupply Object Spawner", "Disabled."]];
};