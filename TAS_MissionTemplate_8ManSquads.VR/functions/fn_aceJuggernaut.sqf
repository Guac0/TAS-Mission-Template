/*
	Original Author: Bassbeard [Bassbeard's Wonder Emporium, https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em]
	Additional Work: Guac

	Requirements: ACE Medical
	
	Description:
	Makes provided unit be invincible until they have suffered damage X times.
	By default, unit immediately dies once they have suffered damage X times,
		but optionally system can merely disable invincibility after taking
		damage X times instead of outright killing the unit.
	Execute locally on the machine owner of the juggernaut unit.

	Examples:
	[_unit,10] call TAS_fnc_aceJuggernaut;
	[_unit,10] remoteExec ["TAS_fnc_aceJuggernaut",_unit];
	[_unit,10,false] call TAS_fnc_aceJuggernaut;
	[_unit,10,false] remoteExec ["TAS_fnc_aceJuggernaut",_unit];
*/

params ["_unit","_hitsBeforeDeath",["_instaKillOnDepletion",true]];

_unit allowDamage false;
_unit addEventHandler ["HandleDamage",{0}];
_unit removeAllEventHandlers "HitPart";
_unit setVariable ["TAS_fnc_juggernautHitsBeforeDeath",_hitsBeforeDeath]; 
_unit setVariable ["TAS_fnc_juggernautInstalKillOnDepletion",_instaKillOnDepletion];

_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"]; 
	_hits = _target getVariable ["TAS_fnc_juggernautHits",0]; 
	_hits = _hits + 1; 
	_target setVariable ["TAS_fnc_juggernautHits",_hits]; 
	//hint format ["%1 has been hit %2 times",name _target,_hits];
	if (_hits > (_target getVariable ["TAS_fnc_juggernautHitsBeforeDeath",10]) ) then { 
		if (_target getVariable ["TAS_fnc_juggernautInstalKillOnDepletion",false]) then {
			_target setdamage 1
		} else {
			_target allowDamage true;
			_target removeAllEventHandlers "HandleDamage";
		};
	} else {
		_target call ACE_medical_treatment_fnc_fullHealLocal; 
	};
}];