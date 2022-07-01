//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_text1",
		"_text2",
		"_text3"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	//[[[_text1, 2, 3], [_text2, 2, 3],[_text3, 2, 3, 8]],BIS_fnc_EXP_camp_SITREP] remoteExec ["spawn"];
	[[_text1, _text2, _text3],BIS_fnc_infoText] remoteExec ["spawn"];
	/*[[
		[
			[_text1, "<t align = 'center' shadow = '1' size = '0.7' font='PuristaBold'>%1</t>"],
			[_text2, "<t align = 'center' shadow = '1' size = '0.7'>%1</t><br/>"],
			[_text3, "<t align = 'center' shadow = '1' size = '1.0'>%1</t>", 15]
		]
	],BIS_fnc_typeText] remoteExec ["spawn"];*/ //center of screen
};

[
	"Spawn Info Text", 
	[
		["EDIT","Line 1"],
		["EDIT","Line 2"],
		["EDIT","Line 3"] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;