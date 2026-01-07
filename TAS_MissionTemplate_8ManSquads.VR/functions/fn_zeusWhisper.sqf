params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_sourcePlayer",
		"_targets",
		"_msg",
		"_zeusListen"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

	if (_msg != "") then {
		systemChat "Whisper module: attempting array conversion (you will receive a follow-up message if successful)...";

		private _targetsArr = parseSimpleArray _targets;
		if (_unit isNotEqualTo objNull) then {
			_targetsArr pushBack _unit;
		};

		systemChat "Whisper module: successfully converted array, sending whisper.";

		[format ["TAS_fnc_zeusWhsiper: zeus %1 sent whisper with source %2, target(s) %3, and message %4",name player, _sourcePlayer,_targetsArr,_msg]] call TAS_fnc_error;

		[_sourcePlayer,_targetsArr,_msg] remoteExec ["TAS_fnc_whisper",2];
	};

	player setVariable ["TAS_zeusGetWhispers",_zeusListen,true];

};

[
	"Whisper", 
	[
		["EDIT",["Source","Any String or string matching player name. If a player name, then player will get whisper confirmation."],[str (name player)]],
		["EDIT",["Targets","Accepts player name(s), 'admin' or 'zeus' wildcards, and attached object (if present). MUST BE VALID ARRAY"],['["admin","zeus","playername"]']],
		["EDIT",["Message","Leave blank if just modifying the LISTEN field to cancel whisper being sent"],[""]],
		["TOOLBOX:YESNO", ["Listen to All Whispers?", "Opts your local character out of eavesdropping on all sent whispers."], true]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;