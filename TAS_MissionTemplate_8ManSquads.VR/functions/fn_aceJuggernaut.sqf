//Script by Bassbeard found via Bassbeard's Wonder Emporium with some edits
	//https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em

/*
Makes provided unit be invincible until they have suffered damage X times.
Execute locally on the machine owner of the juggernaut unit.
[_unit,10] call TAS_fnc_aceJuggernaut;
[_unit,10] remoteExec ["TAS_fnc_aceJuggernaut",_unit];
*/

params ["_unit","_hitsBeforeDeath"];

_unit allowDamage false;
_unit addEventHandler ["HandleDamage",{0}];
_unit removeAllEventHandlers "HitPart";
_unit setVariable ["TAS_fnc_juggernautHitsBeforeDeath",_hitsBeforeDeath]; 
  
_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"]; 
	_hits = _target getVariable ["TAS_fnc_juggernautHits",0]; 
	_hits = _hits + 1; 
	_target setVariable ["TAS_fnc_juggernautHits",_hits]; 
	//hint format ["%1 has been hit %2 times",name _target,_hits];
	if (_hits > (_target getVariable ["TAS_fnc_juggernautHitsBeforeDeath",10]) ) then { _target setdamage 1} else {
		_target call ACE_medical_treatment_fnc_fullHealLocal; 
	};
}];