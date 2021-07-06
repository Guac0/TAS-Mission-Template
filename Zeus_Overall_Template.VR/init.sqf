//automated (non-zeus) ace heal by Guac
//Ace heals all players within 100m
//requires object named AceHealObject
//for some reason doesn't work on flagpoles, perhaps the point where the action is attached to is at the top of the pole, too far away to count as close enough to show up for player?
[
	AceHealObject,											// Object the action is attached to
	"Heal All Entities in 100m",										// Title of the action
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
	"_this distance _target < 3",						// Condition for the action to be shown
	"_caller distance _target < 3",						// Condition for the action to progress
	{},													// Code executed when action starts
	{},													// Code executed on every progress tick
	{_nearPlayers = AceHealObject nearEntities ["Man", 100]; {[objNull, _x] call ace_medical_treatment_fnc_fullHeal} forEach _nearPlayers},													// Code executed on completion
	{},													// Code executed on interrupted
	[],													// Arguments passed to the scripts as _this select 3
	2,													// Action duration [s]
	0,													// Priority
	false,												// Remove on completion
	false												// Show in unconscious state 
] remoteExec ["BIS_fnc_holdActionAdd", 0, AceHealObject];	// MP compatible implementation