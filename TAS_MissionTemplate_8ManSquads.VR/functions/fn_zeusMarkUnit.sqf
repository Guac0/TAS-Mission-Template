params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the mark unit zeus module on the object that you wish to attach the mark to!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusMarkUnit was executed without being placed on an object!";
};

if !(alive _unit) exitWith {
	systemChat "Error: place the mark unit zeus module on an alive unit or vehicle!!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusMarkUnit was executed without being placed on an alive object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		//"_doSideEnemy",
		//"_friendlySide",
		"_name",
		"_customColor",
		"_doMarker",
		"_do3dIcon",
		"_deleteOnDeath"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	/*if (_doSideEnemy) then {
		_friendlySide = sideEnemy;
	};*/ //Why even have this as an option? Zeus knows that they want it marked, just do sideEnemy as default
	[_unit,sideEnemy,_doMarker,_do3dIcon,_name,_customColor,_deleteOnDeath] remoteExec ["TAS_fnc_markUnit",2];

};

[
	"Spawn Info Text", 
	[
		//["TOOLBOX:YESNO", ["Use sideEnemy?", "Overrides the side selection. Makes the given object marked no matter its friendlySide."], true],
		//["SIDES", ["Select friendly side (sideEnemy = no)", "Only the first selected side will be taken into account. If object is friendly to this side, it won't be marked."], [east]],
		["EDIT",["Name on Marker","Leave blank for no name. Shows for both map and 3d icon."],[""]],
		["EDIT",["Color","Must be one of CfgMarkerColors. 3d icon will be red no matter what due to current technical limitations."],["ColorRED"]],
		["TOOLBOX:YESNO", ["Add map marker?", "Will update position every second."], true],
		["TOOLBOX:YESNO", ["Add 3d icon?", "Currently WIP: has infinite range and is shown through terrain/buildings."], true],
		["TOOLBOX:YESNO", ["Delete marker on death?", ""], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;