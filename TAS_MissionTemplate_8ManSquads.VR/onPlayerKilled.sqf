//Save dead player's loadout. Vanilla code sometimes breaks things, like radios and current weapon, so use CBA.
private _loadout = [player] call CBA_fnc_getLoadout;
player setVariable ["TAS_deathLoadout",_loadout];

if (TAS_fixDeathColor) then {
	private _team = assignedTeam player;
	player setVariable ["TAS_deathFireteamColor",_team];
};

if (TAS_scavAfterDeath) then { //would this work better in onPlayerRespawn?
	if (player getVariable ["TAS_playerIsScav",false]) then {
		//was a scav when died
		[true] spawn TAS_fnc_scavPlayerEnd;
	} else {
		player setVariable ["TAS_scavPmcLoadout",_loadout];
		//turning player pmc into scav happens in onPlayerRespawn
	};
};