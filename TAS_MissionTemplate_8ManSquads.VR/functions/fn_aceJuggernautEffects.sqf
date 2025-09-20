/*
	Author: Guac

	Requirements: ACE Goggles, plus fn_aceJuggernaut dependencies
	
	Description:
	Various effects for immersive juggernaut script
	Execute locally

	Return: true

	Examples: (RemoteExec is preferred if you can't guarantee the locality of the affected unit)
	
*/
params ["_unit",["_hits",100],["_instaKillOnDepletion",true],["_playMusic",false],["_changeLoadout",true],["_wbkDisableHitReactions",false]];

if !(local _unit) exitWith { 
	[format ["fn_playerJuggernautEffects: unit %1 is not local, exiting script! (Use remotexec!)",_unit]] call TAS_fnc_error;
};

if !(isPlayer _unit) exitWith {
	[format ["fn_playerJuggernautEffects: unit %1 is not a player, exiting script!",_unit]] call TAS_fnc_error;
};

_unit setVariable ["TAS_isPlayerJuggernaut",true];

// stamina and speed
_unit allowSprint false;
//_unit forceWalk true;
//_unit setAnimSpeedCoef 0.50;
//setStaminaScheme "FastDrain";

//visual effect using APR overlay
[_unit] spawn {
	sleep 1;
	[_this select 0, "G_AirPurifyingRespirator_01_F"] call ace_goggles_fnc_applyGlassesEffect;
	//[_unit, "G_AirPurifyingRespirator_01_F"] call ace_goggles_fnc_applyGlassesEffect;
};

//aim
_unit setCustomAimCoef 0.2;
_unit setUnitRecoilCoefficient 0.1;

//sound
0 fadeSound 0.5;
0 fadeSpeech 0.5;
0 fadeEnvironment 0.5;

//force first person unless mounted in vehicle
[_unit] spawn {
	params ["_unit"];
	while {_unit getVariable ["TAS_isPlayerJuggernaut",false]} do {
		private _vehUnit = vehicle _unit;
		if (_vehUnit == _unit) then {
			if (cameraView == "External") then {
				_vehUnit switchCamera "Internal";
				private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>Attempting to escape your suit of armor is blasphemy!</t><br/><br/><t color='#ff0000' size='2' align='center'>The Juggernaut Suit will not allow you to enter Third Person View while it is operational.</t><br/><br/>"]; 
				_msg = parseText (_msg);
				hint _msg;
				sleep 1;
				[_unit, "G_AirPurifyingRespirator_01_F"] call ace_goggles_fnc_applyGlassesEffect;
			};
		};
		sleep 0.25;
	};
};

//intentionally no semicolon for return!!!
[_unit,_hits,_instaKillOnDepletion,_playMusic,_changeLoadout,_wbkDisableHitReactions] call TAS_fnc_aceJuggernaut