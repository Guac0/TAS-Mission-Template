/*
	Author: Guac

	Requirements: none
	
	Description:
	Provides one-way private message functionality from one player to another.
		Messages are displayed in systemChat with audio cue.
		Messages are logged to server log for moderation purposes.
		Supports limited wildcards - if _targetPlayer is a string instead of a player object, script will do the following:
			target is an object - whisper will be sent to where that object is local
			target is a machine ID - whisper will be sent to that machine
			If "admin", sends to any logged in admin
			If "zeus", sends to all zeuses
			If other string, tries to find a player with a name of that exact string
		_sourcePlayer must be a unit object or string

	Return value: true

	Examples:
	
*/

params ["_sourcePlayer","_targets","_message",["_doZeusLog",TAS_whisperZeus],["_doAdminLog",TAS_whisperAdmin],["_doLog",TAS_whisperLog]];

if !(isServer) exitWith {["TAS_fnc_whisper: must be executed on the server!"] call TAS_fnc_error};

if !(_targets isEqualType []) then {
	[format ["TAS_fnc_whisper: _targets %1 is not an array, placing it inside index 0 of a new array!",_targets]] call TAS_fnc_error;
	_targets = [_targets];
};

private _sourcePlayerName = "";
if (_sourcePlayer isEqualType "") then {
	_sourcePlayerName = _sourcePlayer;
	_sourcePlayer = objNull;
	{
		if (name _x == _sourcePlayerName) then {
			_sourcePlayer = _x;
		};
	} foreach allPlayers;
} else {
	_sourcePlayerName = name _sourcePlayer;
};

private _targetPlayers = [];

private _allZeuses = [];
{
	if (!isNull (getAssignedCuratorlogic _x)) then {
		_allZeuses pushBack _x;
	};
} forEach allPlayers;

private _allAdmins = [];
{
	private _id = owner _x;
	if (admin _id > 0) then {
		_allAdmins pushBack _x;
	};
} forEach allPlayers;

{
	private _target = _x;

	if (_target isEqualType "") then {
		//string wildcard
		if ((_target isEqualTo "zeus") || (_target isEqualTo "admin")) then {
			if (_target isEqualTo "zeus") then {
				{
					_targetPlayers pushBack _x;
				} forEach _allZeuses;
			};
			if (_target isEqualTo "admin") then {
				
				{
					_targetPlayers pushBack _x;
				} forEach _allAdmins;
			};
		} else {
			{
				if ((name _x) isEqualTo _target) then {
					_targetPlayers pushBack _x;
				};
			} forEach allPlayers; // no early out cause i dont want to introduce random logic error. fun!
		};
	};

	if (_target isEqualType 0) then {
		// machine ID
		{
			private _player = _x;
			private _id = owner _player;
			if (_id isEqualTo _target) then {
				_targetPlayers pushBack _player;
			};
		} forEach allPlayers;
	};

	if (_target isEqualType objNull) then {
		// object
		private _desiredId = owner _target;
		{
			private _player = _x;
			private _id = owner _player;
			if (_id isEqualTo _desiredId) then {
				_targetPlayers pushBack _player;
			};
		} forEach allPlayers;
	};
} forEach _targets;

//_targetPlayers is now a unique list of player objects that are whisper destinations
_targetPlayers = _targetPlayers arrayIntersect _targetPlayers;

if (count _targetPlayers < 1) exitWith {
	private _msg = format ["Could not find any destination players for your whisper's target."];
	[_msg,false] remoteExec ["TAS_fnc_error",_sourcePlayer];
	["Hint"] remoteExec ["playSound",_sourcePlayer];
	if (_doLog) then {
		private _msg = format ["TAS_fnc_whisper: %1 tried to whisper but no destination could be found. Targets: %2, msg: %3",_sourcePlayerName,_targets,_message];
		[_msg] call TAS_fnc_error;
	};
	false
};

{
	private _msg = format ["%1 whispers to you: %2",_sourcePlayerName,_message];
	[_msg,false] remoteExec ["TAS_fnc_error",_x];
	["Hint"] remoteExec ["playSound",_x];
	_msg = format ["You whisper to %1: %2",name _x,_message];
	[_msg,false] remoteExec ["TAS_fnc_error",_sourcePlayer];
	["Hint"] remoteExec ["playSound",_sourcePlayer];

	if (_doLog) then {
		private _msg = format ["TAS_fnc_whisper: %1 whispers to %2: %3",_sourcePlayerName,name _x,_message];
		[_msg] call TAS_fnc_error;
	};

	if (_doZeusLog) then {
		private _msg = format ["TAS_fnc_whisper: %1 whispers to %2: %3",_sourcePlayerName,name _x,_message];
		{
			if (_sourcePlayerName isNotEqualTo (name _x)) then {
				private _playerStatus = _x getVariable ["TAS_zeusGetWhispers",0];
				if (_playerStatus isNotEqualTo 2) then {
					[_msg,false] remoteExec ["TAS_fnc_error",_x];
					["Hint"] remoteExec ["playSound",_x];
				};
				if (_playerStatus isEqualTo 0) then {
					private _msg = format ["You can disable these messages by using the 'Whisper' Zeus module."];
					[_msg,false] remoteExec ["TAS_fnc_error",_x];
					_x setVariable ["TAS_zeusGetWhispers",1,true];
				};
			};
		} forEach _allZeuses;
	};

	if (_doAdminLog) then {
		private _msg = format ["TAS_fnc_whisper: %1 whispers to %2: %3",_sourcePlayerName,name _x,_message];
		{
			if (_sourcePlayerName isNotEqualTo (name _x)) then {
				private _playerStatus = _x getVariable ["TAS_zeusGetWhispers",0];
				if (_playerStatus != 2) then {
					[_msg,false] remoteExec ["TAS_fnc_error",_x];
					["Hint"] remoteExec ["playSound",_x];
				};
				if (_playerStatus == 0) then {
					private _msg = format ["You can disable these messages by using the 'Whisper' Zeus module."];
					[_msg,false] remoteExec ["TAS_fnc_error",_x];
					_x setVariable ["TAS_zeusGetWhispers",1,true];
				};
			};
		} forEach _allAdmins;
	};
} forEach _targetPlayers;

true