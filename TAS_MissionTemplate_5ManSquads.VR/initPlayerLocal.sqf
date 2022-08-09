
sleep 1; //wait for mission start (server init will happen in map screen)

if (TAS_ModLog) then {
	private _logMessage = "";

	if (isClass(configFile >> "CfgPatches" >> "Revo_NoWeaponSway")) then {
		_shameMessage = format ["%1 is running No Weapon Sway",player];
		_shameMessage remoteExec ["diag_log",2];
		if (TAS_ModLogShame) then {
			//"I am running No Weapon Sway!" remoteExec ["globalChat"];
		};
	};
	if (isClass(configFile >> "CfgPatches" >> "cTab")) then { 
		_shameMessage = format ["%1 is running cTab",player];
		_shameMessage remoteExec ["diag_log",2];
		if (TAS_ModLogShame) then {
			"I am running cTab!" remoteExec ["globalChat"];
		};
	};
	if (isClass(configFile >> "CfgPatches" >> "Ronon_gun_Pat")) then { 
		_shameMessage = format ["%1 is running Stargate",player];
		_shameMessage remoteExec ["diag_log",2];
		if (TAS_ModLogShame) then {
			"I am running Stargate!" remoteExec ["globalChat"];
		};
	};

	/*if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { 
		//"I am running AAA! Shame on me!" remoteExec ["globalChat"];
		_shameMessage = format ["%1 is running AAA",player];
		_shameMessage remoteExec ["diag_log"];
	};*/
};

//setup diary subject
player createDiarySubject ["tasMissionTemplate","Mission Template","media\logo256x256.paa"];
player createDiaryRecord ["tasMissionTemplate", ["Mission Template Version", TAS_templateVersion]];

//setup leadership trait for later usage
private _leadershipVariableNames = ["Z1","Z2","Z3","CMD_Actual","CMD_JTAC","RECON_Actual","AIR_1_Actual","AIR_2_Actual","GROUND_1_Actual","GROUND_2_Actual","ALPHA_Actual","BRAVO_Actual","CHARLIE_Actual","DELTA_Actual","ECHO_Actual","FOXTROT_Actual"];
private _leadershipRoleDescriptions = ["Zeus","Ground Command","Officer","JTAC","TACP","Pilot","Commander","Squad Leader","Recon Team Leader","Radioman","RTO"]; //Case sensitive (so don't worry about copilot showing up). Team leader is explicitly not on this due to it might be being used for fireteam stuff under the SL
private _leadershipRoleDescriptionSimple = "@";	//group leaders have an @ sign in their role description to name their squads in role select
private _playerClass = vehicleVarName player;
private _roleDescription = roleDescription player;

//leadership marking
if (_leadershipRoleDescriptionSimple in _roleDescription) then { //STRING in STRING
	player setVariable ["TAS_PlayerisLeadership",true];
};
//if (_playerClass in _leadershipVariableNames) then {
//	player setVariable ["TAS_PlayerisLeadership",true];
//};

//dynamic groups code
if (TAS_dynamicGroupsEnabled) then {
	["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group
	player createDiaryRecord ["tasMissionTemplate", ["Dynamic Groups", "Enabled. Press 'U' to open the Dynamic Groups menu."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Dynamic Groups", "Disabled."]]; };
};

//disableStamina, simple way since the more complicated way with addMPEventhandler bugged out recently. Must be here and in onPlayerRespawn
if (TAS_vanillaStaminaDisabled) then {
	player enableFatigue false;
	player createDiaryRecord ["tasMissionTemplate", ["Vanilla Stamina", "Vanilla Stamina is Disabled."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Vanilla Stamina", "Vanilla Stamina is Enabled."]];
};

//Sets custom aim coefficient (precision and/or weapon sway) and recoil coefficient. Must be here and in onPlayerRespawn
if (TAS_doCoefChanges) then {
	player setCustomAimCoef TAS_aimCoef;
	player setUnitRecoilCoefficient TAS_recoilCoef;
	player createDiaryRecord ["tasMissionTemplate", ["Sway/Recoil Coefficient Changes", format ["Sway coefficient: %1. Recoil Coefficient: %2",TAS_aimCoef,TAS_recoilCoef]]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Sway/Recoil Coefficient Changes", "Vanilla coefficients are enabled."]]; };
};

//Add TAS Afk Script
if (TAS_afkEnabled) then {
	// Register a simple keypress to an action
	//#include "\a3\ui_f\hpp\defineDIKCodes.inc" //these two lines can be removed if wanted, rn script uses the number codes instead
	//#define USER_19 0x10C
	//25 for P, 0x10C for User Action 19
	//[24, [false, true, true]] is "O + lctrl + lalt", can change in cba keybindings if wanted
	["TAS Keybindings","afk_script_key_v2","Run TAS Afk Script", {[] call TAS_fnc_AfkScript}, "", [24, [false, true, true]]] call CBA_fnc_addKeybind;

	//make a diary record tutorial
	player createDiaryRecord ["tasMissionTemplate", ["Afk Script", "Enabled. To start/stop the AFK script, input the keybinding you added under Controls\Addon Controls\TAS Keybindings\Run AFK Script. By default, it will be Left Control + Left Alt + O."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Afk Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add TAS Earplugs Script
if (TAS_earplugsEnabled) then {
	// Register a simple keypress to an action
	//#include "\a3\ui_f\hpp\defineDIKCodes.inc" //these two lines can be removed if wanted, rn script uses the number codes instead
	//#define USER_19 0x10C
	//25 for P, 0x10C for User Action 19
	//[18, [false, true, true]] is "E + lctrl + lalt", can change in cba keybindings if wanted
	["TAS Keybindings","earplugs_key","Toggle Earplugs", {[] call TAS_fnc_earplugs}, "", [18, [false, true, true]]] call CBA_fnc_addKeybind;

	//make a diary record tutorial
	player createDiaryRecord ["tasMissionTemplate", ["Earplugs Script", "Enabled. To enable/disable the earplugs, input the keybinding you added under Controls\Addon Controls\TAS Keybindings\Toggle Earplugs. By default, it will be Left Control + Left Alt + E."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Earplugs Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add TAS Music Hotkey Script
if (TAS_musicKeyEnabled) then {
	["TAS Keybindings","music_key","Toggle Music", {[] call TAS_fnc_toggleMusic}, "", [13, [false, true, true]]] call CBA_fnc_addKeybind; //13 is =

	//make a diary record tutorial
	player createDiaryRecord ["tasMissionTemplate", ["Music Hotkey Script", "Enabled. To enable/disable music audio, input the keybinding you added under Controls\Addon Controls\TAS Keybindings\Toggle Music. By default, it will be Left Control + Left Alt + =."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Music Hotkey Script", "Disabled."]]; };
	//systemChat "Afk System disabled.";
};

//Add FOB Script
if (TAS_fobEnabled) then {
	[] execVM "buildfob\initfob.sqf";
} else {
	//systemChat "FOB/Rallypoint building disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["FOB/Rallypoint System", "Disabled."]]; };
};

//global tfar diary entry
if (TAS_globalTfarEnabled) then { 
	//function handled in description.ext
	player createDiaryRecord ["tasMissionTemplate", ["Global TFAR Script", "Enabled. Sets all Short Range radios to a single channel for Zeus/Lore events. Restores radios to prior channel when run a second time. Can be executed from either debug console or via trigger by using remoteExecCall on TAS_fnc_globalTFAR."]];
} else {
	//systemChat "TAS Global TFAR System disabled."
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Global TFAR Script", "Disabled."]]; };
};

if (TAS_useConfigLoadout) then {
	[player,TAS_configFaction,TAS_defaultConfigUnit] call TAS_fnc_assignLoadoutFromConfig;
	player createDiaryRecord ["tasMissionTemplate", ["Loadout Assignment From Config", "Your loadout has been set accordingly to the given faction and your role description. See your chat messages for more information in the case of the script resorting to fallback loadouts or a notficiation that Zeus has chosen to skip your loadout assignment in particular."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Loadout Assignment From Config", "Disabled."]]; };
};

//radio setup
if (TAS_radiosEnabled) then {
	
	player linkItem TAS_radioPersonal;
	
	//LR radio possession marking
	if (TAS_NoSquadleadLr) then {

		//give radio if player is RTO
		if (("Radioman" in _roleDescription) || ("RTO" in _roleDescription)) then {
			player setVariable ["TAS_PlayerHasLr",true];
		};
		//give radio if player is a normal leadership guy (if they aren't an SL)
		if ((player getVariable ["TAS_PlayerisLeadership",false]) && !("Squad Leader" in _roleDescription)) then {
			player setVariable ["TAS_PlayerHasLr",true];
		};

	} else {

		//if player is leadership, then give radio
		if (player getVariable ["TAS_PlayerIsLeadership",false]) then {
			player setVariable ["TAS_PlayerHasLr",true];
		};

	};

	//give player LR radio if approved to do so
	if (player getVariable ["TAS_PlayerHasLr",false]) then {
		player addBackpack TAS_radioBackpack;
		[(call TFAR_fnc_activeLrRadio), 1, "50"] call TFAR_fnc_SetChannelFrequency; //set 50 as active radio channel on channel 1
		[(call TFAR_fnc_activeLrRadio), 2, "55"] call TFAR_fnc_SetChannelFrequency; //set 55 (fire support) as radio channel two (not active and not additional)
	};

	player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Enabled. It may take a second for Teamspeak to initialize your radios. If your radio freq shows up as blank, do not panic as this happens when it is set via script. All SRs are set on squad freq and LRs on 50 (channel 1) and 55 (channel 2)."]];
	//systemChat "Radio loadout init finished. It may take a second for Teamspeak to initialize your radio fully.";

} else {
	
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Radio Assignment", "Disabled."]]; };
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
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Radio Additional Channels Assignment", "Disabled."]]; };
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
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["cTab Assignment", "Disabled."]]; };
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
	if (primaryWeapon player != "") then {
		for "_i" from 1 to 8 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 0) }; //standard ammo
	};
	//for "_i" from 1 to 4 do { player addItem ([primaryWeapon player] call CBA_fnc_compatibleMagazines select 1) }; //special ammo, usually but not always tracers. Buggy so just double the amount of standard mags
	if (handgunWeapon player != "") then {
		for "_i" from 1 to 1 do { player addItem ([handgunWeapon player] call CBA_fnc_compatibleMagazines select 0) };
	};
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
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Inventory Population", "Disabled"]]; };
};

if (TAS_bftEnabled) then {
	[] execVM "functions\scripts\QS_icons.sqf";
	//systemChat "QS BFT initiated.";
	player createDiaryRecord ["tasMissionTemplate", ["Quicksilver BFT", "Enabled. Open your map or GPS to activate it."]];
} else {
	//systemChat "QS BFT disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Quicksilver BFT", "Disabled."]]; };
};

if (TAS_aceHealObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Ace Heal Object", "Enabled. Interact with the heal object in order to see and activate the heal action."]];
} else {
	//systemChat "Ace Heal Object disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Ace Heal Object", "Disabled."]]; };
};

if (TAS_aceSpectateObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Ace Spectate Object", "Enabled. Interact with the heal/spectate object in order to see and activate the spectate action. Press the 'Escape' key to exit spectator."]];
} else {
	//systemChat "Ace Spectate Object disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Ace Spectate Object", "Disabled."]]; };
};

//respawn with death gear
if (TAS_respawnDeathGear) then {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Enabled. You will respawn with the gear you had equipped when you died."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Disabled."]]; };
};

//respawn with saved gear
if (TAS_respawnArsenalGear) then {
	private _loadout = [player] call CBA_fnc_getLoadout;
	player setVariable ["TAS_arsenalLoadout",_loadout]; //setup initial loadout so doesnt use config loadout if not done by player. Use CBA method.

	//setup automatic saving of loadout when exitting the arsenal. Player can also set loadout at the heal box manually.
	["ace_arsenal_displayClosed", {
		private _loadout = [player] call CBA_fnc_getLoadout;
		player setVariable ["TAS_arsenalLoadout",_loadout];
	}] call CBA_fnc_addEventHandler;

	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Enabled. Interact with the heal/spectate object in order to save your loadout."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Disabled."]]; };
};

//respawn in vehicle
if (TAS_respawnInVehicle) then {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Enabled. After a waiting period specified by the mission maker, respawning players will be teleported into the logistics vehicle. During this waiting time, respawning players can spectate, edit their loadout, or hang out at base. Zeus has access to a module to add additional respawn vehicles. You can find it under 'TAS Mission Template' in the module list."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Disabled."]]; };
};

if (TAS_fpsDisplayEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["FPS Counter (by MildlyInterested)", "Enabled. In the bottom left of the map you will see markers for the server and any HCs with various debug information."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["FPS Counter (by MildlyInterested)", "Disabled."]]; };
};

if (TAS_resupplyObjectEnabled) then {
	player createDiaryRecord ["tasMissionTemplate", ["Resupply Object Spawner", "Enabled. At base, players will be able to spawn a supply crate with ammo and medical for all the players."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Resupply Object Spawner", "Disabled."]]; };
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

//diary record for repair zone. Figuring out the logic for detecting if repair zone exists hurts my mind, so don't bother with it.
player createDiaryRecord ["tasMissionTemplate", ["Automatic RRR Zone", "If placed in the mission by the Zeus, the repair zone(s) usually are located at a square helipad. Move your vehicle onto this helipad, reduce its speed to 0, and turn your engine off to begin the automatic repair, refuel, and rearm."]];

//window break setup
if (TAS_aceWindowBreak) then {
	[] execVM "functions\scripts\ifx_windowBreak.sqf";
	player createDiaryRecord ["tasMissionTemplate", ["Ace Window Break by IndigoFox", "Enabled. Walk up to any window and you will see an ace interaction somewhere near it in order to break it."]];
} else {
	if !(TAS_cleanBriefing) then { player createDiaryRecord ["tasMissionTemplate", ["Ace Window Break by IndigoFox", "Disabled."]]; };
};

if (TAS_respawnInVehicle) then {
	//module now handled in zeus register function
	["ace_arsenal_displayOpened", {player setVariable ["TAS_aceArsenalOpen",true]}] call CBA_fnc_addEventHandler;
	["ace_arsenal_displayClosed", {player setVariable ["TAS_aceArsenalOpen",false]}] call CBA_fnc_addEventHandler;
};

//TODO check if we need to delay until curator is registered? and/or just set it as postInit in description.ext and remove it from here
[] call TAS_fnc_zenCustomModulesRegister;

if (TAS_arsenalCurate) then {
	{
		//do some fancy stuff before removing items to account for arsenals that don't actually exist.
		private _arsenal = _x;
		_arsenal = missionNamespace getVariable [_arsenal, objNull]; //convert from string to object, otherwise we get errors
		if (!isNull _arsenal) then {
			//RHS USAF Doomsday
			if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { 
				[_arsenal, ["rhsusf_5Rnd_doomsday_Buck","rhsusf_8Rnd_doomsday_Buck"]] call ace_arsenal_fnc_removeVirtualItems;
			};
			//TAS Flashlights
			if (isClass(configFile >> "CfgPatches" >> "TAS_BrightLite")) then { 
				[_arsenal, ["tas_acc_brightlite_sniper","tas_acc_brightlite_high","tas_acc_brightlite_low","tas_acc_brightlite_static","tas_acc_nightlite_sniper","tas_acc_nightlite_high","tas_acc_nightlite_low","tas_acc_nightlite_static"]] call ace_arsenal_fnc_removeVirtualItems;
			};
			//TAS Doomsday
			if (isClass(configFile >> "CfgPatches" >> "TAS_Revolver")) then { 
				[_arsenal, ["TAS_6Rnd_doomsday_Buck"]] call ace_arsenal_fnc_removeVirtualItems;
			};
			//[_x, []] call ace_arsenal_fnc_removeVirtualItems;
		};
	} forEach ["arsenal_1","arsenal_2","arsenal_3","arsenal_4","arsenal_5","arsenal_6","arsenal_7","arsenal_8","arsenal_9","arsenal_10"]; //template only provides 3 arsenals, but more are provided in case mission maker copy pastes them (they'll automatically be named arsenal_X)
};

if (TAS_doTemplateBriefing) then {
	TAS_templateBriefing = [
		"1. Made earplugs (default keybind: left control + left alt + E) take effect immediantly instead of gradually fading audio in and out.",
		"2. Added a GUI to the Rallypoints respawn system similar to how it is implemented in the Respawn Vehicle system. Also fixed incompatiblities between the GUI and the Ace Arsenal for all Respawn GUI systems.",
		"3. Added an optional feature (enabled by default) to allow Rallypoints to be placed as long as friendlies outnumber enemies within the set radius, instead of the previous system where Rallypoint creation was canceled if there were ANY enemies within the radius.",
		"4. Added a new keybind for toggling your music volume between no music and max music volume (by default, the keybind is: left control + left alt + =).",
		"5. Changed the default enable/disable and other settings for various scripts. Now, earplugs reduce volume to 25% of normal instead of 40%, the incompatible sway and recoil edits have been disabled, and the RTO radio setup is now enabled by default.",
		"We encourage you to visit the 'Mission Template' section in the mission notes (in the top left of map screen) to be aware of the enabled toggleable features present in this mission.",
		"You will only receive this message once every time you join a mission with a new mission template version."
	];

	private _lastBriefed = profileNamespace getVariable ["TAS_lastTemplateBrief","never briefed"];
	if (_lastBriefed != TAS_templateVersion) then {
		(format ["TAS Mission Template %1 — What's New",TAS_templateVersion]) hintC TAS_templateBriefing;
		profileNamespace setVariable ["TAS_lastTemplateBrief",TAS_templateVersion];
		//note: if client does a non-graceful game exit, this variable will not be saved. Not going to bother forcing a save here as it's not worth the time it takes.
	};
};

if (TAS_trackPerformance) then {
	[true,300,2,true] spawn TAS_fnc_debugPerfRpt;
};

if (TAS_doDiscordUpdate) then {
	TAS_discordUpdateDelay spawn TAS_fnc_updateDiscordRichPresence;
};