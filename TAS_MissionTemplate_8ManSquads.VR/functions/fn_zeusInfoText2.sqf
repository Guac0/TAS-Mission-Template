//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_title",
		"_loc",
		"_useLongDate",
		"_anim",
		"_allPlayers"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	if (_allPlayers) then {
		[_title,_loc,_useLongDate,_anim] remoteExec ["TAS_fnc_infoText"];
	} else {
		if (_unit isEqualTo objNull) then {
			systemChat "Spawn Info Text V2: No unit found - module must be placed on a unit if 'Play for All Players?' is FALSE!";
		} else {
			[_title,_loc,_useLongDate,_anim] remoteExec ["TAS_fnc_infoText",_unit];
		};
	};
};

[
	"Spawn Info Text", 
	[
		["EDIT",["Title"]],
		["EDIT","Location",worldName],
		["TOOLBOX:YESNO", ["Use Long Date?", 'Short Date Format is "01/11/2010", Long Date Format is "1st November 2010"'], false],
		["EDIT",["Animation",'Can be "NONE" (default), "WALK" (moves player), "SIT", "WAKE", "WAKESLOW", or "COFFIN"'],"NONE"],
		["TOOLBOX:YESNO", ["Play for All Players?", "If false, plays only for the player the module is placed on."], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;