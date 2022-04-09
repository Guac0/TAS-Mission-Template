//disable vanilla stamina on respawn
if (TAS_vanillaStaminaDisabled) then {
	player enableFatigue false;
};

//respawn with death gear
if (TAS_respawnDeathGear) then {
	player setUnitLoadout (player getVariable ["deathLoadout",[]]); //Load dead player's loadout} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
};

//respawn with saved gear
if (TAS_respawnArsenalGear) then {
	player setUnitLoadout (player getVariable ["arsenalLoadout",[]]); //Load player's saved loadout
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
};

//respawn in vehicle
if (TAS_respawnInVehicle) then {
	if (isNil logistics_vehicle) exitWith { 
		hint "Respawn vehicle is dead or does not exist! Contact GC, Zeus, or other designated logistics coordinator for reinsert information!";
	}; //if logistics_vehicle is dead, then exit
	[true,false,true] call ace_spectator_fnc_setSpectator; //start spectator but player can exit
	private _time = TAS_respawnInVehicleTime;
	hint format ["You must wait for %1 seconds before respawning, either spectate or customize your loadout while you wait! Press escape to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
	while { _time > 0 } do {
		_time = _time - 1;  
		hintSilent format ["You must wait for %1 seconds before respawning, either spectate or customize your loadout while you wait! Press escape to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
	hintSilent "";
	[false,false,false] call ace_spectator_fnc_setSpectator; //end spectator if applicable
	player moveInCargo logistics_vehicle; //get in respawn vic in passenger seat
} else {
	//systemChat "respawn in vehicle disabled";
};
