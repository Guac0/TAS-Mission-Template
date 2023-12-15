/*
	Author: Guac

	Requirements: ACE3
	
	Description: Puts offending player into timeout and then restores him after a time.

	Related files: fn_punishCivKiller.sqf, where this is ordinally executed from.

	Execution locality: local to _killer object

	Examples:
	[_killer,TAS_punishCivKillTimeout] remoteExec ["TAS_fnc_punishCivKillerLocal",_killer];
*/

//various setup
private _debug = false;
params ["_killer","_timeout",["_forced",false]];
if (_debug) then { systemChat format ["Starting fn_punishCivKillerLocal with %1 and %2",_killer,_timeout]; };
private _oldPos = getPosATL _killer;
private _oldVehicle = objNull;
if (vehicle _killer != _killer) then {
	_oldVehicle = vehicle _killer;
	doGetOut _killer;
	waitUntil {vehicle _killer == _killer}
};

//Put the offender into spectator and freeze them at the map origin. Heal him so he doesn't bleed out too.
if (TAS_punishCivKillsSpectator) then {
	[true, true, true] call ace_spectator_fnc_setSpectator;
};
[_killer] call ace_medical_treatment_fnc_fullHealLocal;
_killer allowDamage false;
_killer setPosATL [0,0,0];
_killer enableSimulationGlobal false;

if (TAS_punishCivKillerHumiliate) then {
	(format ["%1 has been put into timeout for %2 seconds!",name _killer, _timeout]) remoteExec ["systemChat"];
};

//wait out his punishment
private _time = _timeout;
systemChat format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
hint format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
if (_forced) then {
	while { _time > 0 } do { //second condition is to allow for early out by zeus
		_time = _time - 1;
		//systemChat format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		hintSilent format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
} else {
	while { (_time > 0) && ((_killer getVariable ["TAS_civsKilledByUnit",0]) > TAS_punishCivKillsThreshold) } do { //second condition is to allow for early out by zeus
		_time = _time - 1;
		//systemChat format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		hintSilent format ["You have killed too many civilians and must wait %1 before being reinserted!",[((_time)/60)+.01,"HH:MM"] call BIS_fnc_timetostring];
		sleep 1;
	};
};

//unfreeze the player
if (TAS_punishCivKillsSpectator) then {
	[false, false, false] call ace_spectator_fnc_setSpectator;
};
_killer enableSimulationGlobal true;
_killer allowDamage true;

//reset civ kills counter
(format ["%1 has killed %2 civs and has been punished for it, their record has now been wiped clean!",name _killer,_killer getVariable ["TAS_civsKilledByUnit",0]]) remoteexec ["diag_log",2];
_killer setVariable ["TAS_civsKilledByUnit",0,true];

//Restore the player's location depending on the mission settings, group leader status, and vehicle status
if (leader _killer == _killer) then {
	if (TAS_punishCivKillerTpToLeader) then {
		"You're your own group leader, so your position has been restored to your previous location instead of teleporting you to your group leader!"
	};
	if !(isNull _oldVehicle) then {
		private _success = _killer moveInAny _oldVehicle;
		if !(_success) then {
			_killer setPosATL _oldPos;
			systemChat "Your previous vehicle was full, so you've been teleported to your previous location!";
		};
		systemChat "You've been teleported into your previous vehicle!";
	} else {
		_killer setPosATL _oldPos;
		systemChat "You've been teleported to your previous location!";
	};
} else {
	if (TAS_punishCivKillerTpToLeader) then {
		private _leader = leader _killer;
		if (vehicle _leader != _leader) then {
			private _success = _killer moveInAny (vehicle _leader);
			if !(_success) then {
				_killer setPosATL _oldPos;
				systemChat "Your group leader's vehicle was full, so you've been teleported to your previous location!";
			};
			systemChat "You've been teleported into your group leader's vehicle!";
		} else {
			_killer setPosATL (getPosATL (leader _killer));
			systemChat "You've been teleported to your group leader's location!";
		};
	} else {
		if !(isNull _oldVehicle) then {
			private _success = _killer moveInAny _oldVehicle;
			if !(_success) then {
				_killer setPosATL _oldPos;
				systemChat "Your previous vehicle was full, so you've been teleported to your previous location!";
			};
			systemChat "You've been teleported into your previous vehicle!";
		} else {
			_killer setPosATL _oldPos;
			systemChat "You've been teleported to your previous location!";
		};
	};
};