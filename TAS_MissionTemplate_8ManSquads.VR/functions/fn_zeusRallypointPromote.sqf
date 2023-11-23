params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the zeus module on the object that you wish to promote to a rallypoint placer!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusRallypointPromote was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_rallypointInternalName",
		"_rallyMarkerName"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	private _number = missionNamespace getVariable ["TAS_numberOfZeusRallypoints",0];
	_number = _number + 1;
	private _rallyAction = [format ["zeusRallyAction%1",_number],"Place Squad Rallypoint","",{[3,[],{[player,_rallypointInternalName,_rallyMarkerName] call TAS_fnc_genericRallypoint;},{},"Establishing rallypoint..."] call ace_common_fnc_progressBar},{true}] call ace_interact_menu_fnc_createAction;
	missionNamespace setVariable ["TAS_numberOfZeusRallypoints",_number,true];
	[_unit, 1, ["ACE_SelfActions"], _Rally_Hotel_Action] call ace_interact_menu_fnc_addActionToObject;

};

[
	"Rallypoint Options", 
	[
		["EDIT","Rallypoint internal name (not visible)",["TAS_alphaRallypoint"]],
		["EDIT","Rallypoint marker variable name",["rallypointAlphaMarker"]]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;