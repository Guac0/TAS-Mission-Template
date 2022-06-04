//disable vanilla stamina on respawn
if (TAS_vanillaStaminaDisabled) then {
	player enableFatigue false;
};

if (TAS_doCoefChanges) then {
	player setCustomAimCoef TAS_aimCoef;
	player setUnitRecoilCoefficient TAS_recoilCoef;
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
	private _respawnVehicle = missionNamespace getVariable ["TAS_respawnVehicle",objNull];

	/*if (isNull _respawnVehicle) exitWith { //if logistics_vehicle is dead, then exit
		hint "Respawn vehicle is dead and/or does not exist! Contact GC, Zeus, or other designated logistics coordinator for reinsert information!";
	};
	if !(alive _respawnVehicle) exitWith {
		hint "Respawn vehicle is dead! Contact GC, Zeus, or other designated logistics coordinator for reinsert information!"
	};*/

	[true,false,true] call ace_spectator_fnc_setSpectator; //start spectator but player can exit
	private _time = TAS_respawnInVehicleTime;
	hint format ["You must wait for %1 seconds before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring]; //have sound for the first hint
	while { _time > 0 } do {
		_time = _time - 1;  
		hintSilent format ["You must wait for %1 seconds before reinserting, either spectate or customize your loadout while you wait!\n\nPress the ESCAPE key to exit spectator and go to the arsenal box if desired.", [((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
	hintSilent "";
	[false,false,false] call ace_spectator_fnc_setSpectator; //end spectator if applicable
	"vehicle" execVM "scripts\respawnGui.sqf";
	//player moveInCargo _respawnVehicle; //get in respawn vic in passenger seat
} else {
	//systemChat "respawn in vehicle disabled";
};
