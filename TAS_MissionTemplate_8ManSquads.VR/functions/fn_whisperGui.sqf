params [["_zeusAdminOnly",TAS_whisperLimit],["_baseXPos",0],["_baseYPos",0]];

disableSerialization;
//various vars
private ["_background","_button"];
//colors
private ["_black","_red","_blue","_green","_cyan","_white"];
_black = [0,0,0,0.5];
_red = [1,0,0,0.5];
_blue = [0,1,0,0.5];
_green = [0,0,1,0.5];
_cyan = [0,1,1,0.5];
_white = [1,1,1,1];

private _allPlayers = [];
if !(_zeusAdminOnly) then {
	{
		_allPlayers pushBack _x;
	} forEach (allPlayers - entities "HeadlessClient_F");
};
_allPlayers = [_allPlayers, [], {name _x}, "ASCEND"] call BIS_fnc_sortBy;
//_allPlayers sort true;
_allPlayers pushBack ""; //dummy for zeus
_allPlayers pushBack ""; //dummy for admin

private _whisperGui = findDisplay 46 createDisplay "RscDisplayEmpty"; //uses main screen as basis
uiNamespace setVariable ["TAS_whisperGui", _whisperGui];	//to get around restrictions about disableSerialization in normal local variables

private _maxPerCol = 0;
switch (floor ((count _allPlayers) / 5)) do {
	case 0: {
		_maxPerCol = 5;
	};
	case 1: {
		_maxPerCol = 5;
	};
	case 2: {
		_maxPerCol = 5;
	};
	case 3: { //15+ players
		_maxPerCol = 10;
	};
	case 4: {
		_maxPerCol = 10;
	};
	case 5: {
		_maxPerCol = 10;
	};
	case 6: {
		_maxPerCol = 10;
	};
	case 7: { //<40 players
		_maxPerCol = 10;
	};
	default { //40+ players
		_maxPerCol = 15;
	};
};
private _totalCols = ceil((count _allPlayers) / _maxPerCol);

//private _baseXPos = 0;
//private _baseYPos = 0;
private _width = (0.3*_totalCols);
if (_width < 0.6) then {_width = 0.6};
private _height = 0.11+(0.08*(_maxPerCol+1));
if (_maxPerCol > (count _allPlayers)) then {
	_height = 0.11+(0.08*((count _allPlayers)+1));
};
_background = _whisperGui ctrlCreate ["IGUIBack", -1];
//[format ["TAS_fnc_whisperGui: creating background at %1 with maxPerCol %2",[_baseXPos,_baseYPos,_width,_height],_maxPerCol]] call TAS_fnc_error;
_background ctrlSetPosition [_baseXPos,_baseYPos,_width,_height]; //xywh
_background ctrlSetBackgroundColor _black;
_background ctrlCommit 0;

_menuInfoButton = _whisperGui ctrlCreate ["RscText", -1];
//[format ["TAS_fnc_whisperGui: creating choose text at %1",[_baseXPos + 0.01,_baseYPos+0.03,(_width-0.04)/2,0.05]]] call TAS_fnc_error;
_menuInfoButton ctrlSetPosition [_baseXPos + 0.01,_baseYPos+0.03,(_width-0.04)/2,0.05];
_menuInfoButton ctrlSetText ("Choose Player to Whisper To");
//_background ctrlSetTextColor _cyan;
//_menuInfoButton buttonSetAction 'systemChat "Hit one of the other buttons that actually does something, not the title card!"';
_menuInfoButton ctrlCommit 0;

_escapeButton = _whisperGui ctrlCreate ["RscButton", -1]; 
//_escapeButton ctrlSetPosition [0.255,0.11+(0.08*_maxPerCol),(0.25*_totalCols),0.05];
//[format ["TAS_fnc_whisperGui: creating escape button at %1",[_baseXPos + 0.03 +(_width-0.04)/2,_baseYPos+0.03,(_width-0.04)/2,0.05]]] call TAS_fnc_error;
_escapeButton ctrlSetPosition [_baseXPos + 0.03 +(_width-0.04)/2,_baseYPos+0.03,(_width-0.04)/2,0.05];
_escapeButton ctrlSetText ("Exit Whisper GUI");
//_background ctrlSetTextColor _red;
_escapeButton buttonSetAction "
	(uiNamespace getVariable ['TAS_whisperGui',displayNull]) closeDisplay 1;
	TAS_inWhisperGui = false;
";
_escapeButton ctrlCommit 0;

private _vertIndex = 0;
private _horizIndex = 0;

//admin button
_button = _whisperGui ctrlCreate ["RscButton", -1]; 
//[format ["TAS_fnc_whisperGui: creating button for %1 at %2 with vertIndex %3 and horizIndex %4","admin",[_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05],_vertIndex,_horizIndex]] call TAS_fnc_error;
_button ctrlSetPosition [_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05]; //width is intentionally off by +0.01 if theres only one
_button ctrlSetTextColor _red;
_button ctrlSetText "Active Admin";
_button buttonSetAction format [
	'[player,["admin"],"test"] remoteExec ["TAS_fnc_whisper",2]'
];
_button ctrlCommit 0;
_vertIndex = _vertIndex + 1;

_button = _whisperGui ctrlCreate ["RscButton", -1]; 
//[format ["TAS_fnc_whisperGui: creating button for %1 at %2 with vertIndex %3 and horizIndex %4","zeus",[_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05],_vertIndex,_horizIndex]] call TAS_fnc_error;
_button ctrlSetPosition [_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05]; //width is intentionally off by +0.01 if theres only one
_button ctrlSetTextColor _blue;
_button ctrlSetText "All Zeuses";
_button buttonSetAction format [
	'[player,["zeus"],"test"] remoteExec ["TAS_fnc_whisper",2]'
];
_button ctrlCommit 0;
_vertIndex = _vertIndex + 1;

{
	if (_x isNotEqualTo "") then {
		if (_vertIndex >= _maxPerCol) then {
			_vertIndex = 0;
			_horizIndex = _horizIndex + 1;
		};
		_button = _whisperGui ctrlCreate ["RscButton", -1]; 
		//[format ["TAS_fnc_whisperGui: creating button for %1 at %2 with vertIndex %3 and horizIndex %4",_x,[_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05],_vertIndex,_horizIndex]] call TAS_fnc_error;
		_button ctrlSetPosition [_baseXPos + 0.01+(0.3*_horizIndex),_baseYPos+0.11 + (0.08 * _vertIndex),(_width-0.02-(0.01*_totalCols))/_totalCols,0.05]; //width is intentionally off by +0.01 if theres only one
		//_background ctrlSetTextColor _blue;
		_button ctrlSetText format ["%1",name _x];
		_button buttonSetAction format [
			'[player,[%1],"test"] remoteExec ["TAS_fnc_whisper",2]',
			_x
		];
		_button ctrlCommit 0;
		_vertIndex = _vertIndex + 1;
	};
} foreach _allPlayers;

_menuInfoButton = _whisperGui ctrlCreate ["RscText", -1];
_menuInfoButton ctrlSetPosition [_baseXPos + 0.01,_height-0.08,(_width-0.02),0.05];
_menuInfoButton ctrlSetText ("Note: all messages may be reviewed for moderation purposes.");
//_background ctrlSetTextColor _cyan;
//_menuInfoButton buttonSetAction 'systemChat "Hit one of the other buttons that actually does something, not the title card!"';
_menuInfoButton ctrlCommit 0;

/*
while {TAS_inWhisperGui} do { //respawn the menu if player closes it without picking an option
	if (isNull _whisperGui) then {

	};
};
*/