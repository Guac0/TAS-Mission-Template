/*
	Author: Guac

	Requirements: ACE3
	
	Description: Sets up the event handler to catch civilian kills and handles the checking and setting of player civ kill counts.

	Related files: fn_punishCivKillerLocal.sqf, which this file executes.

	Execution locality: local to _civ object (usually server)

	Examples:
	[_civ] remoteExec ["TAS_fnc_punishCivKiller",2];
	[_civ] spawn TAS_fnc_punishCivKiller;
*/
private _debug = false;
params ["_civ"];
if (_debug) then { systemChat format ["Starting fn_punishCivKillerServer with %1",_civ]; };

//if !(TAS_punishCivKills) exitWith { if (_debug) then { systemChat format ["Exitting fn_punishCivKillerServer as system is disabled!"]; }; };

if (_civ getVariable ["TAS_isProtectedUnit",false]) exitWith { if (_debug) then { systemChat format ["Exitting fn_punishCivKillerServer as unit %1 has already been protected!",_civ]; }; };

_civ setVariable ["TAS_isProtectedUnit",true,true]; //dunno if it should be public but may as well
_civ addEventHandler ["Killed", {
	private _debug = false;
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	if (_debug) then { systemChat format ["Starting fn_punishCivKillerLocal eventhandler with %1 and %2",_unit,_killer]; };
	//todo catch edge cases where killer is a vehicle and arma gives the vehicle instead of the effectiveCommander?
	if (isPlayer _killer) then {
		private _kills = _killer getVariable ["TAS_civsKilledByUnit",0];
		_kills = _kills + 1;
		_killer setVariable ["TAS_civsKilledByUnit",_kills,true];
		_msg = format ["You have killed a civilian! Current civilian kills: %1. Civilian kills allowed before punishment: %2",_kills,TAS_punishCivKillsThreshold];
		_msg remoteExec ["systemChat",_killer];
		if (_kills > TAS_punishCivKillsThreshold) then {
			[_killer,TAS_punishCivKillTimeout] remoteExec ["TAS_fnc_punishCivKillerLocal",_killer];
		};
		if (TAS_punishCivKillerHumiliate) then {
			(format ["%1 has killed a civilian/protected unit (%2)!",name _killer, name _unit]) remoteExec ["systemChat"];
		};
		(format ["%1 has killed a civilian/protected unit (%2)!",name _killer, name _unit]) remoteExec ["diag_log",2];
	} else {
		(format ["A protected unit (%1) has died, but the killer (%2) is not a player!",name _unit, name _killer]) remoteexec ["diag_log",2];
	};
	
}];

//systemChat "Unit has been added to protected list!"; //this runs on server so no one will see this