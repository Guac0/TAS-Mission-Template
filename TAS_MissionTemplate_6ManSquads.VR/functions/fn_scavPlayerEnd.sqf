

params [["_isFail",true]];

//todo fadeout?
[objNull, player] call ace_medical_treatment_fnc_fullHeal;

/*
private _taskId = player getVariable ["TAS_PersonalScavTaskName",""];

if (_isFail) then {
	[_taskId,"FAILED",true] call BIS_fnc_taskSetState;
	[_taskId,player,true] call BIS_fnc_deleteTask;
} else {
	[_taskId,"SUCCEEDED",true] call BIS_fnc_taskSetState;
	[_taskId,player,true] call BIS_fnc_deleteTask;
	//todo find number of pizzas and reward appropriately
};

private _actionsToRemove = player getVariable ["TAS_scavActions",[]]; //[[object,id,string for name]]
{
	[_x select 0,_x select 1] call BIS_fnc_holdActionRemove;
} forEach _actionsToRemove;


{
	_x setMarkerAlphaLocal 0;
} forEach (missionNamespace getVariable ["TAS_scavTaskMarkers",[]]);
{
	_x setMarkerAlphaLocal 1;
} forEach TAS_scavPmcMarkers;


//sleep 3;

//voiceline?

player setVariable ["TAS_playerIsScav",false,true];
*/

if (_isFail) then {
	[] call TAS_fnc_scavPlayerInit; //start whole scav thing over again if you want nonstop scaving
} else {
	private _numberPizzas = {TAS_scavValuableClassname == _x} count (items player);
	private _moneyChange = _numberPizzas * TAS_scavRewardPerItem;
	private _doChangeRelative = true;
	private _tasOldMoney = profileNamespace getVariable TAS_vassShopSystemVariable;
	private _tasNewMoney = 0;
	if (_doChangeRelative) then {
		_tasNewMoney = _tasOldMoney + _moneyChange;
		hint format ["You now have %1$ in cash due to extracting successfully!",_tasNewMoney];
	} else { //absolute change
		_tasNewMoney = _moneyChange;
		hint format ["You now have %1$ in cash due to a Zeus editing your previous balance by %2!",_tasNewMoney,_moneyChange];
	};
	profileNamespace setVariable [TAS_vassShopSystemVariable,_tasNewMoney];
	player removeItems TAS_scavValuableClassname;
	player setPosATL (getPosATL scavTpHelper);
};

/*
//restore old pmc loadout and position
private _loadout = player getVariable ["TAS_scavPmcLoadout",[]];
if (_loadout != []) then {
	[player, _loadout, false] call CBA_fnc_setLoadout;
} else {
	["Your old PMC loadout was not applied due to not being previously saved!",false] call TAS_fnc_error;
};
*/