/*
	Original Author: Bassbeard [Bassbeard's Wonder Emporium, https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em]
	Additional Work: Guac

	Requirements: ACE Medical
	
	Description:
	Makes provided unit be invincible until they have suffered damage X times.
	By default, unit immediately dies once they have suffered damage X times,
		but optionally system can merely disable invincibility after taking
		damage X times instead of outright killing the unit.
		Note: disabling instadeath is recommended if using juggernaut for players.
	Includes visual feedback (in fancy hint form) upon startup and upon taking
		damage if the juggernaut is the local player.
	Execute locally on the machine owner of the juggernaut unit.

	Return: true

	Examples: (RemoteExec is preferred if you can't guarantee the locality of the affected unit)
	[_unit,10] call TAS_fnc_aceJuggernautAI;
	[_unit,10] remoteExec ["TAS_fnc_aceJuggernautAI",_unit];
	[_unit,10,false] call TAS_fnc_aceJuggernautAI;
	[_unit,10,false] remoteExec ["TAS_fnc_aceJuggernautAI",_unit];
*/

params ["_unit","_hitsBeforeDepletion",["_instaKillOnDepletion",true]];

private _isPlayer = false;
if (_unit == player) then {
	_isPlayer = true;
};

_unit allowDamage false;
_unit addEventHandler ["HandleDamage",{0}];
_unit removeAllEventHandlers "HitPart";
_unit setVariable ["TAS_fnc_juggernautHitsBeforeDepletion",_hitsBeforeDepletion]; 
_unit setVariable ["TAS_fnc_juggernautInstalKillOnDepletion",_instaKillOnDepletion];

if (_isPlayer) then {
	private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>Welcome to the Juggernaut Suit</t><br/><br/><t color='#ff0000' size='3' align='center'>The Juggernaut Suit will allow you to take %1 hits without any adverse affects.</t><br/><br/>",_hitsBeforeDepletion]; 
	if (_instaKillOnDepletion) then {
		_msg = _msg + (format ["<t color='#ff5050' size='2' align='center'>Once your suit is depleted, you will instantly die from the strain of being hit so many times!</t><br/><br/>"]);
	} else {
		_msg = _msg + (format ["<t color='#ff5050' size='2' align='center'>Once your suit is depleted, you will no longer have any benefits from it.</t><br/><br/>"]);
	};
	_msg = parseText (_msg);
	hint _msg;
};

_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"]; 
	
	private _isPlayer = false;
	if (_target == player) then {
		_isPlayer = true;
	};
	_hits = _target getVariable ["TAS_fnc_juggernautHits",0]; 
	_hits = _hits + 1; 
	_target setVariable ["TAS_fnc_juggernautHits",_hits];
	//hint format ["%1 has been hit %2 times",name _target,_hits];
	if (_hits > (_target getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",10]) ) then { 
		if (_target getVariable ["TAS_fnc_juggernautInstalKillOnDepletion",false]) then {
			_target setdamage 1;
		} else {
			_target allowDamage true;
			_target removeAllEventHandlers "HandleDamage";

			if (_isPlayer) then {
				private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>Your suit has been torn to shreds by enemy fire!</t><br/><br/><t color='#ff5050' size='2' align='center'>You will no longer receive any benefits from the Juggernaut Suit.</t><br/><br/>"]; 
				_msg = parseText (_msg);
				hint _msg;
			};
		};
	} else {
		_target call ACE_medical_treatment_fnc_fullHealLocal;

		if (_isPlayer) then {
			private _msg = format ["<br/><t color='#ff5050' size='2' align='center'>You've taken a hit!</t><br/><br/><t color='#cc6600' size='3' align='center'>Hits remaining: %1</t><br/><br/>",(_target getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",10]) - hits]; 
			_msg = parseText (_msg);
			hintSilent _msg;
		};
	};

}];

true