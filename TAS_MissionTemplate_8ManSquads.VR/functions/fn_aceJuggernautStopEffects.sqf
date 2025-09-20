/*
	Author: Guac

	Requirements: ACE Goggles, plus fn_aceJuggernaut dependencies
	
	Description:
	Various effects for immersive juggernaut script
	Execute locally

	Return: true

	Examples: (RemoteExec is preferred if you can't guarantee the locality of the affected unit)
	
*/

params ["_unit",["_showGenericText",false]];

if !(local _unit) exitWith { 
	[format ["fn_playerJuggernautStopEffects: unit %1 is not local, exitting script! (Use remotexec!)",_unit]] call TAS_fnc_error;
};

if !(_unit getVariable ["TAS_isPlayerJuggernaut",false]) exitWith {
	[format ["fn_playerJuggernautStopEffects: unit %1 is not already a juggernaut!",_unit]] call TAS_fnc_error;
};

_unit setVariable ["TAS_isPlayerJuggernaut",false];

_unit allowSprint true;

deleteVehicle (_unit getVariable ["TAS_juggernautSoundObject",objNull]);

[ace_player, ""] call ace_goggles_fnc_applyGlassesEffect;

//aim
_unit setCustomAimCoef 1;
_unit setUnitRecoilCoefficient 1;

//sound
0 fadeSound 1;
0 fadeSpeech 1;
0 fadeEnvironment 1;

_unit allowDamage true;
_unit removeAllEventHandlers "HandleDamage";
_unit setVariable ["TAS_isPlayerJuggernaut",false];

if (_showGenericText) then {
	private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>The universe has revoked your right to the Juggernaut Suit!</t><br/><br/>"]; 
	_msg = parseText (_msg);
	hint _msg;
} else {
	private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>Your suit has been torn to shreds by enemy fire!</t><br/><br/><t color='#ff0000' size='2' align='center'>You will no longer receive any benefits from the Juggernaut Suit.</t><br/><br/>"]; 
	_msg = parseText (_msg);
	hint _msg;
};

_unit call ACE_medical_treatment_fnc_fullHealLocal;

true