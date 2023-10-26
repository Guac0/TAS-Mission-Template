/*
Initializes the scav system on a (local) player.
[] call TAS_fnc_scavPlayerInit;
*/

player setVariable ["TAS_playerIsScav",true,true];
[player] call TAS_fnc_scavLoadout;
[player] joinSilent (createGroup TAS_scavPlayerSide);
(group player) setGroupId [format ["%1's Scav Gang", name player]];

//play audio briefing, give text diary entries, and assign task
//playSound ["scavBriefing",1,0];
//_path spawn TAS_fnc_playCornerVideo;

private _taskId = format ["TAS_PersonalScavTask%1",name player];
player setVariable ["TAS_PersonalScavTaskName",_taskId];

[player,_taskId,[
	format ["Your contact has marked several locations containing items that will satisfy the contract. Locate at least the minimum number of items and move to an extraction point with them in your inventory to complete your contract.<br/><br/><br/><br/>Accepted Items: Pizza Rations.<br/>Quantity Needed: %1",TAS_scavNeededValuables],
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
private _availableExtracts = missionNamespace getVariable ["TAS_scavExtracts",[]];
{
	_actionID = [
		_x,											// Object the action is attached to
		"Extract",										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 5",						// Condition for the action to be shown
		"(_caller distance _target < 5) && ({'TAS_RationPizza' == _x} count (items player) >= TAS_scavNeededValuables)",						// Condition for the action to progress
		{ [_target,3] call BIS_fnc_dataTerminalAnimate; },													// Code executed when action starts
		{},													// Code executed on every progress tick
		{
			[false] call TAS_fnc_scavPlayerEnd; [_target,0] call BIS_fnc_dataTerminalAnimate;
		},												// Code executed on completion
		{ [_target,0] call BIS_fnc_dataTerminalAnimate; hint "You don't have the required items to successfully extract and complete your contract yet!"; systemChat "You don't have the required items to successfully extract and complete your contract yet!" },													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		10,													// Action duration [s]
		4,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] call BIS_fnc_holdActionAdd;
	_scavActions pushBack [_x,_actionID,"scav_extract"];
} forEach _availableExtracts;
player setVariable ["TAS_extractActions",_scavActions];

//spawn in building near extract? or anywhere in AO thats not next to players/obj?
private _spawnPointExtract = selectRandom _availableExtracts;
private _spawnPoint = [_spawnPointExtract,3,20,1] call BIS_fnc_findSafePos;
player setPosATL [_spawnPoint select 0, _spawnPoint select 1, 0.25];