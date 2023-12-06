/*
Initializes the scav system on a (local) player.
[] call TAS_fnc_scavPlayerInit;
*/

params [["_firstTime",true]];
if (_firstTime) then {
	[player,5] call TAS_fnc_scavLoadout;
	[player] joinSilent (createGroup TAS_scavPlayerSide);
	(group player) setGroupIdGlobal [format ["%1's Scav Gang", name player]];

	//do markers. dont worry about markers created during scaving, would be immersion breaking anyways
	{
		_x setMarkerAlphaLocal 1;
	} forEach (missionNamespace getVariable ["TAS_scavTaskMarkers",[]]);
	{
		_x setMarkerAlphaLocal 0;
	} forEach TAS_scavPmcMarkers;
};

player setVariable ["TAS_playerIsScav",true,true];
player setVariable ["ace_medical_medicclass", 1, true]; //medic 
player setUnitTrait ["Medic", true];
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
		"(_caller distance _target < 5) && ({TAS_scavValuableClassname == _x} count (items player) >= TAS_scavNeededValuables)",						// Condition for the action to progress
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

[missionNamespace getVariable ["TAS_scavExtracts",[]]] spawn TAS_fnc_scavHandleExtractSmokes;

//[player] remoteExec ["TAS_fnc_scavInsertPlayer",2];
private _tpHelper = TAS_scavSafeZoneTpHelper;
_tpHelper = missionNamespace getVariable [_tpHelper, objNull]; //convert from string to object, otherwise we get errors
if (!isNull _tpHelper) then {
	player setPosATL (getPosATL _tpHelper);
} else {
	[format ["fn_scavPlayerInit: Critical error: TAS_scavSafeZoneTpHelper object with name %1 is null!",TAS_scavSafeZoneTpHelper],false] call TAS_fnc_error;
};

"Scav Intro" hintC [
	"You are now playing as a scavenger.",
	"One of the local power players has contracted you, they recently had a convoy get raided and its contents stolen.",
	"The raiders have spread out their gains to a number of caches throughout the region.",
	"Acquire at least 3 of the stolen Pizza items and get to an extraction point. Bonus pizzas will earn you a higher reward.",
	"You may cooperate with other player scavengers if you wish. They can be contacted on the default radio frequency of 44.",
	"You have been placed into the Shop safe zone. When ready, use the flagpole to enter the AO.",
	"Contact Zeus if you have questions, or if you wish to propose an alternative objective that you might get paid for."
];