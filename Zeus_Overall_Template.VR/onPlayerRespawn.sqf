//respawn with death gear
if (TAS_respawnWithDeathGear) then {
	player setUnitLoadout (player getVariable ["deathLoadout",[]]); //Load dead player's loadout
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Enabled. You will respawn with the gear you had equipped when you died."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Death Loadout", "Disabled."]];
};

//respawn with saved gear
if (TAS_respawnWithArsenalGear) then {
	player setUnitLoadout (player getVariable ["arsenalLoadout",[]]); //Load player's saved loadout
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Enabled. Interact with the heal/spectate object in order to save your loadout."]];
} else {
	//systemChat "Respawn with Arsenal Loadout disabled.";
	player createDiaryRecord ["tasMissionTemplate", ["Respawn With Saved Loadout", "Disabled."]];
};

//respawn in vehicle
if (TAS_respawnInVehicle) then {
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
	player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Enabled. After a waiting period specified by the mission maker, respawning players will be teleported into the logistics vehicle. During this waiting time, respawning players can spectate, edit their loadout, or hang out at base."]];
} else {
	player createDiaryRecord ["tasMissionTemplate", ["Respawn in Vehicle (Custom)", "Disabled."]];
};

//stamina on respawn is covered in initPlayerLocal