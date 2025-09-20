/*
	Author: Guac

	Requirements: KS_fnc_ceaseFire, ACE Medical / Captives
	
	Description:
	Creates a basic ENDEX script.
	* Forces cease fire
	* Displays ENDEX hint
	* Disables damage for all units and ace heals them
	* Surrenders all AI

	Return: true

	Examples: 
	[] call TAS_fnc_endex; //ENDEX the local player
	[] remoteExec ["TAS_fnc_endex"];  //ENDEX all players
	["Good job."] remoteExec ["TAS_fnc_endex"];  //ENDEX all players with custom message
	["Weapons re-enabled",false] remoteExec ["TAS_fnc_endex"];  //Cancel ENDEX effects for all players with custom message
*/
params [["_customText",""],["_isEndex",true]];

if (_isEndex) then {

	[true] call KS_fnc_ceaseFire;

	private _msg = format ["<br/><t color='#5ae000' size='4' align='center'>ENDEX</t><br/><br/>All weapons have been set to Safe.<br/>Stand by for further instructions.<br/><br/>%1",_customText]; 
	_msg = parseText (_msg);
	hintSilent _msg;

	{
		if (local _x) then {
			if !(isPlayer _x) then {
				[_x, true] call ace_captives_fnc_setSurrendered;
			};
			[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
			_x allowDamage false;
		};
	} forEach allUnits;

} else {

	//Undo Endex

	[false] call KS_fnc_ceaseFire;

	private _msg = format ["<br/><t color='#ff0000ff' size='3' align='center'>ENDEX Effects Canceled</t><br/><br/>Happy killing.<br/><br/>%1",_customText]; 
	_msg = parseText (_msg);
	hintSilent _msg;

	{
		if (local _x) then {
			if !(isPlayer _x) then {
				[_x, false] call ace_captives_fnc_setSurrendered;
			};
			[objNull, _x] call ace_medical_treatment_fnc_fullHeal;
			_x allowDamage true;
		};
	} forEach allUnits;

};

true