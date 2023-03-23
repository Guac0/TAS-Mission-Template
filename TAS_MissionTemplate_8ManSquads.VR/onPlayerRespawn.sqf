private _debug = false;

if (_debug) then {
	systemChat "onPlayerRespawn a";
};

//disable vanilla stamina on respawn
if (TAS_vanillaStaminaDisabled) then {
	player enableFatigue false;
};

if (TAS_doAimCoefChange) then {
	player setCustomAimCoef TAS_aimCoef;
	player setUnitRecoilCoefficient TAS_recoilCoef;
};

//respawn with death gear
if (TAS_respawnDeathGear) then {
	private _loadout = player getVariable ["TAS_deathLoadout",[]]; //Load dead player's loadout. Use CBA instead of vanilla. BOOL is for refilling mags.
	if (count _loadout == 0) then {
		systemChat "Your saved loadout is empty and thus will not be applied!";
	} else {
		[player, _loadout, false] call CBA_fnc_setLoadout;
	};
};

//fix death color
if (TAS_fixDeathColor) then {
	private _color = player getVariable ["TAS_deathFireteamColor",""];
	if ((_color != "") && (_color != "MAIN")) then {	//dont bother doing it if its invalid or default
		player assignTeam _color;
	};
};

//respawn with saved gear
if (TAS_respawnArsenalGear) then {
	private _loadout = player getVariable ["TAS_arsenalLoadout",[]]; //Load dead player's loadout. Use CBA instead of vanilla. BOOL is for refilling mags.
	if (count _loadout == 0) then {
		systemChat "Your saved loadout is empty and thus will not be applied!";
	} else {
		[player, _loadout, false] call CBA_fnc_setLoadout;
	};
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
};

if (TAS_vassEnabled) then {
	//VASS
	//load editor loadout (player can choose to rebuy old loadout elsewhere)
	player setUnitLoadout (player getVariable ["editorLoadout",[]]);
};

player setVariable ["TAS_waitingForReinsert",true];
private _automaticExitSpectator = true;
private _allowReinsert = true;

if (_debug) then {
	systemChat "onPlayerRespawn b";
};

if (TAS_respawnSpectator) then {


	if (_debug) then {
		systemChat "onPlayerRespawn c";
	};

	//setup and initial spectator
	private _time = TAS_respawnSpectatorTime;
	[TAS_respawnSpectator,TAS_respawnSpectatorForceInterface,TAS_respawnSpectatorHideBody] call ace_spectator_fnc_setSpectator;

	if (TAS_waveRespawn) then {
		//wave respawns (timer is server side and is broadcast every 30 seconds)
		if (TAS_respawnSpectatorForceInterface) then {
			while { TAS_waveRemainingTime != 0 } do { //forced interface
				hintSilent format ["You must wait for a wave respawn to occur before exiting spectator and reinserting.\n\nApproximate Time Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
				sleep 5;
			};
			hintSilent "";
		} else {
			while { TAS_waveRemainingTime != 0 } do { //can exit spectator
				hintSilent format ["You must wait for a wave respawn to occur before exiting spectator and reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.\n\nApproximate Time Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
				sleep 5;
			};
			hintSilent "";
		};
	} else {
		if (_time == 0) then {
			if (TAS_respawnSpectatorForceInterface) then {
				//stuck in spectator
				hint "You have died and there is currently no plans for respawns to occur.\n\nThank you for playing!";
				_automaticExitSpectator = false;
				_allowReinsert = false;
			} else {
				//no timer before exiting is possible
				hint "When you are ready to reinsert or to access the arsenal, press the ESCAPE key!";
				_automaticExitSpectator = false;
			};
		} else {
			//waiting timers
			//non-wave respawns (timer operates locally)
			if (TAS_respawnSpectatorForceInterface) then {
				hint format ["You must wait before exiting spectator and reinserting.\n\nTime Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
				while { _time > 0 } do {
					_time = _time - 1;  
					hintSilent format ["You must wait before exiting spectator and reinserting.\n\nTime Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
					sleep 1;
				};
				hintSilent "";
			} else {
				hint format ["You must wait before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.\n\nTime Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
				while { _time > 0 } do {
					_time = _time - 1;  
					hintSilent format ["You must wait before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.\n\nTime Remaining: %1", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
					sleep 1;
				};
				hintSilent "";
			};
		};
	};
	
	if (_debug) then {
		systemChat "onPlayerRespawn d";
	};

	//reinsert time
	if (_automaticExitSpectator) then {
		[false,false,false] call ace_spectator_fnc_setSpectator;
	};
};

if (_allowReinsert) then {
	if (player getVariable ["TAS_aceArsenalOpen",false]) then {
		hint "Please close any displays (such as Arsenal) before being shown the respawn GUI!";
		systemChat "Please close any displays (such as Arsenal) before being shown the respawn GUI!"; //this too because while in arsenal, hints are hidden
		waitUntil {sleep 0.25; !(player getVariable ["TAS_aceArsenalOpen",false])}; //wait until ace arsenal is exited to avoid gui errors
	};
	if (vehicle player != player) then {
		hint "Exit the vehicle before being shown the respawn GUI!";
		systemChat "Exit the vehicle before being shown the respawn GUI!"; //this too because while in arsenal, hints are hidden
		waitUntil {sleep 0.25; vehicle player == player}; //wait until ace arsenal is exited to avoid gui errors
	};

	player setVariable ["TAS_waitingForReinsert",false];
	if (TAS_respawnInVehicle || TAS_fobEnabled || TAS_rallypointsEnabled || TAS_flagpoleRespawn) then { [] spawn TAS_fnc_openRespawnGui; };
	//if respawn vehicle and fob aren't enabled, then nothing will happen (player will be left at the base they selected to respawn at)
	//if you have a custom respawn method, add it below (make sure respawn vehicle and fob are disabled)
		//change "spawn" to "call" above if you want the code below to run AFTER player is TPed to rally/fob/wherever



};


if (_debug) then {
	systemChat "onPlayerRespawn f";
};