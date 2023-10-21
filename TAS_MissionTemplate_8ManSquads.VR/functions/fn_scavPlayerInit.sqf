/*
Initializes the scav system on a (local) player.
[] call TAS_fnc_scavPlayerInit;
*/

[player] call TAS_fnc_scavLoadout;
[player] joinSilent (createGroup independent);
(group player) setGroupId [format ["%1's Scav Gang", name player]];

//play audio briefing, give text diary entries, and assign task
//playSound ["scavBriefing",1,0];
//_path spawn TAS_fnc_playCornerVideo;

private _taskId = format ["TAS_PersonalScavTask%1",name player];
player setVariable ["TAS_PersonalScavTaskName",_taskId];

[player,_taskId,[
	"Your contact has marked several locations containing items that will satisfy the contract. Locate at least the minimum number of items and move to an extraction point with them in your inventory to complete your contract.<br/><br/><br/><br/>Accepted Items: Pizza Rations.<br/>Quantity Needed: 3",
	"Fulfill Scavenger Contract",
	""
],objNull,"ASSIGNED"] call BIS_fnc_taskCreate;

//do markers. dont worry about markers created during scaving, would be immersion breaking anyways
{
	_x setMarkerAlpha 1;
} forEach (missionNamespace getVariable ["TAS_scavTaskMarkers",[]]);

/*
class CfgSounds
{
	sounds[] = {};
	class thisiswhattheysay
	{
		name = "w/e";
		sound[] = {pathtotheactyualsoundfileinyourmissionfolder}; IE: /sounds/sound1.ogg
		titles[] = {1,"this is what the subtitles will say when the sound is triggered"};
	};
};
*/

//add extraction areas
private _scavActions = [];
private _availableExtracts = [];
{
	private _object = _x;
	_object = missionNamespace getVariable [_object, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _object) then {
		_availableExtracts pushBack _object;
		//add save loadout option
		_actionID = [
			_object,											// Object the action is attached to
			"Extract",										// Title of the action
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
			"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
			"_this distance _target < 5",						// Condition for the action to be shown
			"(_caller distance _target < 5) && ({'TAS_RationPizza' == _x} count (items player) > 2)",						// Condition for the action to progress
			{ [_target,3] call BIS_fnc_dataTerminalAnimate; },													// Code executed when action starts
			{},													// Code executed on every progress tick
			{
				[] call TAS_fnc_scavPlayerEnd; [_target,0] call BIS_fnc_dataTerminalAnimate;
			},												// Code executed on completion
			{ [_target,0] call BIS_fnc_dataTerminalAnimate; hint "You don't have the required items to successfully extract and complete your contract yet!"; systemChat "You don't have the required items to successfully extract and complete your contract yet!" },													// Code executed on interrupted
			[],													// Arguments passed to the scripts as _this select 3
			10,													// Action duration [s]
			4,													// Priority
			false,												// Remove on completion
			false												// Show in unconscious state 
		] call BIS_fnc_holdActionAdd;
		_scavActions pushBack [_object,_actionID,"scav_extract"];

	} else {
		//["fn_scavPlayerInit: missing at least one extraction point!",true] call TAS_fnc_error;
	};
} forEach ["TAS_extract_1","TAS_extract_2","TAS_extract_3","TAS_extract_4","TAS_extract_5","TAS_extract_6","TAS_extract_7","TAS_extract_8","TAS_extract_9","TAS_extract_10"];
player setVariable ["TAS_extractActions",_scavActions];

private _spawnPointExtract = selectRandom _availableExtracts;
private _spawnPoint = [_spawnPointExtract,3,20,1] call BIS_fnc_findSafePos;
player setPosATL [_spawnPoint select 0, _spawnPoint select 1, 0.25];