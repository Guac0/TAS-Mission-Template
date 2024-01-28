// Adds the various lodging buy actions to the buy object
// Uses store data in TAS_lodgingBuyOptions as default
// [AceHealObject] call TAS_fnc_lodgingAddBuyActions;

params ["_actionObject",["_itemsArray",TAS_lodgingBuyOptions],["_debug",true]]; // _itemsArray = [[item1classname,cost,prettyName],[item2classname,cost,prettyName]]

if (_debug) then { [format ["TAS_lodgingAddBuyActions: Adding actions to object %1 for shop data %2!",_actionObject,_itemsArray]] call TAS_fnc_error; };

{
	params ["_itemClassname","_cost","_name"];
	[
		_actionObject,											// Object the action is attached to
		format ["Buy %1 [Cost: %2]",_name,_cost],										// Title of the action
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Idle icon shown on screen
		"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa",	// Progress icon shown on screen
		"_this distance _target < 15",						// Condition for the action to be shown
		"_caller distance _target < 15",						// Condition for the action to progress
		{},													// Code executed when action starts
		{},													// Code executed on every progress tick
		{
			_x call TAS_fnc_lodgingBuyItem;
		},												// Code executed on completion
		{},													// Code executed on interrupted
		[],													// Arguments passed to the scripts as _this select 3
		2,													// Action duration [s]
		3,													// Priority
		false,												// Remove on completion
		false												// Show in unconscious state 
	] call BIS_fnc_holdActionAdd;
} forEach _itemsArray;

if (_debug) then { [format ["TAS_lodgingAddBuyActions: Finished adding actions!"]] call TAS_fnc_error; };