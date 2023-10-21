//todo fadeout?
private _actionsToRemove = player getVariable ["TAS_scavActions",[]]; //[[object,id,string for name]]
{
	[_x select 0,_x select 1] call BIS_fnc_holdActionRemove;
} forEach _actionsToRemove;

{
	_x setMarkerAlpha 0;
} forEach (missionNamespace getVariable ["TAS_scavTaskMarkers",[]]);

private _taskId = player getVariable ["TAS_PersonalScavTaskName",""];
[_taskId,"SUCCEEDED",true] call BIS_fnc_taskSetState;

//sleep 3;

[_taskId,player,true] call BIS_fnc_deleteTask;

//[] call TAS_fnc_scavPlayerInit; //start whole scav thing over again if you want nonstop scaving

//restore old pmc loadout and position