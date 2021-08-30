if (TAS_respawnWithDeathGear) then {
	player setUnitLoadout (player getVariable ["deathLoadout",[]]); //Load dead player's loadout
};
if (TAS_respawnWithArsenalGear) then {
	player setUnitLoadout (player getVariable ["arsenalLoadout",[]]); //Load player's saved loadout
};
//stamina on respawn is covered in initPlayerLocal
if (TAS_respawnInVehicle) then {
	//might be also possible to get around buggyness in respawns on old body if you have a setPos here
	[true,false,true] call ace_spectator_fnc_setSpectator; //start spectator but player can exit
	_time = TAS_respawnInVehicleTime;
	while { _time > 0 } do {
		_time = _time - 1;  
		hintSilent format ["You must wait for %1 seconds before respawning, either spectate or customize your loadout while you wait! Press escape to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
	hintSilent "";
	[false,false,false] call ace_spectator_fnc_setSpectator; //end spectator if applicable
	player moveInCargo logistics_vehicle; //get in respawn vic in passenger seat
};
