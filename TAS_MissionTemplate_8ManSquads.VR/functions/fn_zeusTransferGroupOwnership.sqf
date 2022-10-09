//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining.
//Not tested in multiplayer, so there's a chance this literally doesn't work! Eh, small usage case anyways.
//Future plans: add module for seeing current owner of group
params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

if (isNull _unit) exitWith {
	systemChat "Error: place the group transfer module on the object that you wish to transfer the ownership of!";
	diag_log "TAS MISSION TEMPLATE: fn_zeusTransferGroupOwnership was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_newOwner",
		"_customId"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	TAS_GroupToChange = (group _unit);
	publicVariableServer "TAS_GroupToChange";
	
	if (_customId != "") then {
		private _id = parseNumber _customId;
		[TAS_GroupToChange,_id] remoteExec ["setGroupOwner",2]; //TODO check if remoteExec works with _id
		//systemChat str _id;
	} else {
		switch (_newOwner) do {
			case "Server": { [TAS_GroupToChange,2] remoteExec ["setGroupOwner",2]; };
			case "HC1": { [TAS_GroupToChange,(owner HC1)] remoteExec ["setGroupOwner",2]; };
			case "HC2": { [TAS_GroupToChange,(owner HC2)] remoteExec ["setGroupOwner",2]; };
			case "HC3": { [TAS_GroupToChange,(owner HC3)] remoteExec ["setGroupOwner",2]; };
			case "Player": { [TAS_GroupToChange,remoteExecutedOwner] remoteExec ["setGroupOwner",2]; };
			default { [TAS_GroupToChange,2] remoteExec ["setGroupOwner",2]; }; //default to server
		};
	};
	diag_log format ["TAS-MISSION-TEMPLATE transferGroupOwnership: transfering %1 to %3!",TAS_GroupToChange,_newOwner]; //can't get current owner without remoteExecing to server
};

[
	"Set Group Owner", 
	[
		["COMBO",["New Group Owner", "These are presets. To transfer ownership to a specific machine, use the next option."],
			[["Server", "HC1", "HC2", "HC3", "Player"], 
			["Server", "HC1", "HC2", "HC3", "Player"]
			,0]],
		["EDIT","[Optional] Custom Machine ID"] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;