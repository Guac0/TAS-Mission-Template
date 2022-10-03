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

if (TAS_waveRespawns) then {
	player setVariable ["TAS_waitingForReinsert",true];
};

//respawn in vehicle
if (TAS_respawnInVehicle || TAS_fobEnabled) then {
	private _respawnVehicle = missionNamespace getVariable ["TAS_respawnVehicle",objNull];

	/*if (isNull _respawnVehicle) exitWith { //if logistics_vehicle is dead, then exit
		hint "Respawn vehicle is dead and/or does not exist! Contact GC, Zeus, or other designated logistics coordinator for reinsert information!";
	};
	if !(alive _respawnVehicle) exitWith {
		hint "Respawn vehicle is dead! Contact GC, Zeus, or other designated logistics coordinator for reinsert information!"
	};*/

	[true,false,true] call ace_spectator_fnc_setSpectator; //start spectator but player can exit
	private _time = 30; //backup
	if (TAS_respawnInVehicle) then {
		_time = TAS_respawnInVehicleTime;
	};
	if (TAS_fobEnabled) then {
		_time = TAS_rallyRespawnTime;
	};
	hint format ["You must wait for %1 seconds before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
	while { _time > 0 } do {
		_time = _time - 1;  
		hintSilent format ["You must wait for %1 seconds before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
	hintSilent "";
	[false,false,false] call ace_spectator_fnc_setSpectator; //end spectator if applicable
	if (TAS_respawnInVehicle) then { "vehicle" call TAS_fnc_respawnGui };
	if (TAS_fobEnabled) then { "rallypoint" call TAS_fnc_respawnGui };
} else {
	//systemChat "respawn in vehicle disabled";
};

if (TAS_respawnAsSpectator) then {
	private _time = TAS_respawnSpectatorTime;
	[true,TAS_respawnSpectatorForceInterface,TAS_respawnSpectatorHideBody] call ace_spectator_fnc_setSpectator;
	if (_time = 0) then {
		hint "You have died and (unless otherwise stated by Zeus) there is currently no plans for respawns to occur.\n\nThank you for playing!";
	} else {
		if (TAS_respawnSpectatorForceInterface) then {
			hint format ["You must wait for %1 seconds before exiting spectator.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
			while { _time > 0 } do {
				_time = _time - 1;  
				hintSilent format ["You must wait for %1 seconds before exiting spectator.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
				sleep 1;
			};
			hintSilent "";
		} else {
			hint format ["You must wait for %1 seconds before reinserting.\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired."", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
			while { _time > 0 } do {
				_time = _time - 1;  
				hintSilent format ["You must wait for %1 seconds before exiting spectator.\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired."", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
				sleep 1;
			};
			hintSilent "";
		};
		[false,false,false] call ace_spectator_fnc_setSpectator;
	};
};