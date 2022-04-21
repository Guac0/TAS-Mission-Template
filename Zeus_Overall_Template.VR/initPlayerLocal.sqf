
sleep 1; //wait for mission start (server init will happen in map screen)

//setup diary subject
player createDiarySubject ["tasMissionTemplate","Mission Template","media\logo256x256.paa"];

//setup leadership trait for later usage
private _leadershipVariableNames = ["Z1","Z2","Z3","CMD_Actual","CMD_JTAC","AIR_1_Actual","AIR_2_Actual","GROUND_1_Actual","GROUND_2_Actual","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _leadershipRoleDescriptions = ["Zeus","Ground Command","Officer","JTAC","TACP","Pilot","Commander","Squad Leader","Radioman","RTO"]; //Case sensitive (so don't worry about copilot showing up). Team leader is explicitly not on this due to it might be being used for fireteam stuff under the SL
private _playerClass = vehicleVarName player;
private _roleDescription = roleDescription player;

//leadership marking
if (_roleDescription in _leadershipRoleDescriptions) then {
	player setVariable ["TAS_PlayerisLeadership",true];
};
if (_playerClass in _leadershipVariableNames) then {
	player setVariable ["TAS_PlayerisLeadership",true];
};

//radios marking
if (TAS_NoSquadleadLr) then {
	//remove SL things from the arrays in case zeus wants to use RTOs instead
	_leadershipVariableNames = _leadershipVariableNames - ["ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
	_leadershipRoleDescriptions = _leadershipRoleDescriptions - ["Squad Leader"];

	//mark unit as LR carrier for later assignment
	if (playerClass in _leadershipVariableNames) then {
		player setVariable ["TAS_PlayerHasLr",true];
	};
	{
		if (_x in _roleDescription) then {
			player setVariable ["TAS_PlayerHasLr",true];
		};
	} forEach _leadershipRoleDescriptions;

} else {

	if (player getVariable ["TAS_PlayerIsLeadership",false]) then {
		player setVariable ["TAS_PlayerHasLr",true];
	};

};


//dynamic groups code
if (TAS_dynamicGroupsEnabled) then {
	["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group
	player createDiaryRecord ["tasMissionTemplate", ["Dynamic Groups", "Enabled."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Dynamic Groups", "Disabled."]];
};

//disableStamina, simple way since the more complicated way with addMPEventhandler bugged out recently. Must be here and in onPlayerRespawn
if (TAS_vanillaStaminaDisabled) then {
	player enableFatigue false;
	player createDiaryRecord ["tasMissionTemplate", ["Vanilla Stamina", "Vanilla Stamina is Disabled."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Vanilla Stamina", "Vanilla Stamina is Enabled."]];
};

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
	if (player getVariable ["TAS_PlayerHasLr",false]) then {
		player addBackpack TAS_radioBackpack;
		//[(call TFAR_fnc_activeLrRadio), 1, "50"] call TFAR_fnc_SetChannelFrequency; //set 50 as active radio channel on channel 1
		//[(call TFAR_fnc_activeLrRadio), 2, "55"] call TFAR_fnc_SetChannelFrequency; //set 55 (fire support) as radio channel two (not active and not additional)
	};
	player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Enabled. It may take a second for Teamspeak to initialize your radios. If your radio freq shows up as blank, do not panic as this happens when it is set via script. All SRs are set on squad freq and LRs on 50."]];
	//systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Disabled."]];
	//systemChat "TFAR automatic radio assignment disabled."
};
if (TAS_radioAdditionals) then {
	private _standardRadioAssignment = [] spawn {
		waitUntil {(call TFAR_fnc_haveSWRadio)}; //wait until have radio
		[(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_setAdditionalSwChannel; //set Channel 2 to additional (0-based index)
		[(call TFAR_fnc_ActiveSWRadio), 2] call TFAR_fnc_setAdditionalSwStereo; //set additional channel to right ear only
		[(call TFAR_fnc_ActiveSWRadio), 1] call TFAR_fnc_setSwStereo; //set main channel to left ear
	};
	player createDiaryRecord ["tasMissionTemplate", ["Radio Additional Channels Assignment", "Enabled. Your left ear is your main channel (capslock to transmit and by default is the squad-wide net), while your right ear is your additional channel (T to transmit, usually the fireteam net). Your Long Range radio remains unchanged."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Radio Additional Channels Assignment", "Disabled."]];
};

//ctab setup
if (TAS_ctabEnabled) then {
	player addItem "ItemcTabHCam"; //give all players a helmetcam, will auto delete hcam if inventory is full
	player linkItem "itemAndroid"; //give everyone an android in their gps slot, will be overwriten if they are leadership
	if (player getVariable ["TAS_PlayerIsLeadership",false]) then {player linkItem "itemcTab"; player addItem "itemAndroid";}; //give leadership an android in their inventories and a tablet in their gps slot (will delete existing item), will auto delete android if inventory is full
	//systemChat "cTab loadout init finished.";
	player createDiaryRecord ["tasMissionTemplate", ["cTab Assignment", "Enabled. All units have recieved an Android and helmet cam, while leadership have also recieved a rugged tablet."]];
} else {
	//systemChat "cTab automatic item assignment disabled."
	player createDiaryRecord ["tasMissionTemplate", ["cTab Assignment", "Disabled."]];
};

if (TAS_populateInventory) then {
	//clear items (should remove everything in cargo of uniform/vest/backpack, wont remove radios and gps and etc)
	removeAllItems player;
	{player removeMagazine _x} forEach magazines player;
	//for "_i" from 1 to 10 do { player addItem " " };

	//basic medical
	for "_i" from 1 to 16 do { player addItem "ACE_fieldDressing" };
	for "_i" from 1 to 8 do { player addItem "ACE_morphine" };
	for "_i" from 1 to 2 do { player addItem "ACE_epinephrine" };
	for "_i" from 1 to 3 do { player addItem "ACE_tourniquet"};
	for "_i" from 1 to 2 do { player addItem "ACE_bloodIV_500" };

	//misc
	for "_i" from 1 to 2 do { player addItem "ACE_CableTie" };
	player addItem "ACE_Earplugs";
	player addItem "ACE_EntrenchingTool";
	//player linkItem "ItemGPS";
	//player linkItem "ItemMap";
	//player linkItem "ItemWatch";
	//player linkItem "ItemCompass";
	//player linkItem "TFAR_anprc152";
	
	//grenades
	for "_i" from 1 to 2 do { player addItem "HandGrenade" }; //vanilla m67, v40 is MiniGrenade
	for "_i" from 1 to 2 do { player addItem "SmokeShell" }; //white smoke
	for "_i" from 1 to 1 do { player addItem "SmokeShellPurple" }; //purple smoke

	//ammo
	for "_i" from 1 to 8 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
	//for "_i" from 1 to 4 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 1) }; //special ammo, usually but not always tracers. Buggy so just double the amount of standard mags
	for "_i" from 1 to 1 do { player addItem ([handgunWeapon player] call CBA_fnc_compatibleMagazines select 0) };
	if (secondaryWeapon player != "") then {
		for "_i" from 1 to 2 do { player addItem ([secondaryWeapon player] call CBA_fnc_compatibleMagazines select 0) }; //add launcher ammo if player has launcher
	};

	//medic special stuff
	//https://github.com/acemod/ACE3/blob/master/addons/medical_treatment/functions/fnc_isMedic.sqf
	private _bisMedic = player getUnitTrait "Medic";
	private _aceMedic = [player,1] call ace_medical_treatment_fnc_isMedic;
	private _aceDoctor = [player,2] call ace_medical_treatment_fnc_isMedic;
	if ( _bisMedic == true || _aceMedic == true || _aceDoctor == true ) then {
		for "_i" from 1 to 40 do { player addItem "ACE_fieldDressing" };
		for "_i" from 1 to 20 do { player addItem "ACE_morphine" };
		for "_i" from 1 to 15 do { player addItem "ACE_epinephrine" };
		for "_i" from 1 to 6 do { player addItem "ACE_tourniquet"};
		for "_i" from 1 to 10 do { player addItem "ACE_bloodIV_500" };
		for "_i" from 1 to 6 do { player addItem "ACE_bloodIV" };
		player addItem "ACE_personalAidKit";
		//player addItem "ACE_surgicalKit";
	};

	//https://github.com/acemod/ACE3/blob/e4be783f80db5730ad5c351d611206a245b35a0f/addons/repair/functions/fnc_isEngineer.sqf
	//engineer gaming
	private _bisEngineer = player getUnitTrait "engineer";
	private _bisEOD = player getUnitTrait "explosiveSpecialist";
	private _aceEngineer = [player, 1] call ace_repair_fnc_isEngineer;
	if ( _bisEngineer == true || _bisEOD == true || _aceEngineer == true ) then {
		player addItem "ToolKit";
		player addItem "MineDetector";
		player addItem "ACE_DefusalKit";
	};

	player createDiaryRecord ["tasMissionTemplate", ["Inventory Population", "Enabled. You have been given basic medical, grenade, ammo, and loadout-specific supplies."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Inventory Population", "Disabled"]];
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

//JIP compat for globalTFAR
//if player has not had radio set to global most recently then cache current additional data and set additional to global
private _playerRadiosAreGlobal = missionNamespace getVariable ["playersRadioGlobal", false];
if (_playerRadiosAreGlobal == true) then {
	private _activeSwRadio = call TFAR_fnc_ActiveSwRadio;
	private _originalAdditionalChannel = _activeSwRadio call TFAR_fnc_getAdditionalSwChannel;
	private _originalAdditionalStereo = _activeSwRadio call TFAR_fnc_getAdditionalSwStereo;
	player setVariable ["originalAdditionalChannel", _originalAdditionalChannel];
	player setVariable ["originalAdditionalStereo", _originalAdditionalStereo];
	[_activeSwRadio, 8, "87"] call TFAR_fnc_SetChannelFrequency; //these two lines determine global channel and frequency, freq is the max freq LRs can go to
	[_activeSwRadio, 7] call TFAR_fnc_setAdditionalSwChannel; //lower by 1 cause internally this fnc is zero-based
	[_activeSwRadio, 0] call TFAR_fnc_setAdditionalSwStereo;
	player setVariable ["playersRadioGlobal", true];
	
	diag_log format ["TAS_fnc_globalTFAR applied successfully during JIP."];
};


//window break setup
if (TAS_aceWindowBreak) then {
	[] execVM "scripts\ifx_windowBreak.sqf";
	player createDiaryRecord ["tasMissionTemplate", ["Ace Window Break by IndigoFox", "Enabled. Walk up to any window and you will see an ace interaction somewhere near it in order to break it."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Ace Window Break by IndigoFox", "Disabled."]];
};