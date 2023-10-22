

params [["_isFail",true]];

//todo fadeout?
[objNull, player] call ace_medical_treatment_fnc_fullHeal;

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
	_x setMarkerAlpha 0;
} forEach (missionNamespace getVariable ["TAS_scavTaskMarkers",[]]);


//sleep 3;

//voiceline?

player setVariable ["TAS_playerIsScav",false,true];

//[] call TAS_fnc_scavPlayerInit; //start whole scav thing over again if you want nonstop scaving

//restore old pmc loadout and position