/*
	Author: Guac

	Requirements: None
	
	Creates a 3D icon and a map icon over the provided object if object is unfriendly to the specified side.
	Is highly customizable.
	Note: the 3D icon will have infinite range and will be shown through buildings/terrain.

	Examples:
	[_object,sideEnemy] remoteExec ["TAS_fnc_markUnit",2]; 			//mark _object regardless of side. Useful for objectives.
	[cursorTarget,side player] remoteExec ['TAS_fnc_markUnit',2]; 	//mark object that player is looking at IF it is an enemy
*/

params [["_cursorObject",objNull],["_friendlySide",sideEnemy],["_doMarker",true],["_do3dIcon",true],["_name",""],["_customColor","ColorRed"],["_deleteOnDeath",true]]; //can just pass TRUE to _customColor to auto adapt per side

if (isNull _cursorObject) exitWith {["TAS_fnc_markUnit called with objNull as cursorObject!"] call TAS_fnc_error};

if (_cursorObject getVariable ["TAS_isMarkedUnit",false]) exitWith {[format ["TAS_fnc_markUnit called on a unit already being tracked! Unit: %1",_cursorObject]] call TAS_fnc_error};

if (!(_cursorObject isKindOf "CAManBase") && !(_cursorObject isKindOf "AllVehicles")) exitWith {["TAS_fnc_markUnit called without a unit or vehicle as cursorObject!"] call TAS_fnc_error}; //well, AllVehicles should include soldiers, but not sure if CAManBase is included

if !(alive _cursorObject) exitWith {["TAS_fnc_markUnit called with a dead object as cursorObject!"] call TAS_fnc_error}; 

private _friendlySides = _friendlySide call BIS_fnc_friendlySides;
private _objectSide = side _cursorObject;
if (_objectSide in _friendlySides) exitWith {["TAS_fnc_markUnit called with a friendly object as cursorObject!"] call TAS_fnc_error}; 

if (_customColor isEqualTo true) then {
	switch (side _cursorObject) do
	{
		case west: { _customColor = "ColorWEST" }; //ColorWEST
		case east: { _customColor = "ColorEAST" };
		case independent: { _customColor = "ColorGUER" };
		case civilian: { _customColor = "ColorCIV" };
		default { _customColor = "ColorRed"; [format ["TAS_fnc_markUnit called with object %1 with side %2!",_cursorObject,side _cursorObject]] call TAS_fnc_error };
	};
};

[format ["TAS_fnc_markUnit marking unit %1 with color %2!",_cursorObject,_customColor]] call TAS_fnc_error;
_cursorObject setVariable ["TAS_isMarkedUnit",true];

//ok, we've done input validation and the cursorObject is enemy, so let's mark it
if (_doMarker) then {
	if (_deleteOnDeath) then {
		[_cursorObject,"o_unknown",_customColor,_name,true,1] call TAS_fnc_markerFollow; //no text, dot, red, 1 second between marks
	} else {
		[_cursorObject,"o_unknown",_customColor,_name,false,1] call TAS_fnc_markerFollow; //no text, dot, red, 1 second between marks
	};
};

if (_do3dIcon) then {

	[[_cursorObject,_name,_customColor,_deleteOnDeath],
	{
		params ["_cursorObject","_name","_color","_deleteOnDeath"];
		private _eventhandler = addMissionEventHandler ["Draw3D",
			{
				private ["_icon","_color","_targetPositionAGLTop","_name","_width","_height"];
				_cursorObject = _thisArgs select 0;
				_name = _thisArgs select 1;
				//_color = _thisArgs select 2;
				_color = [1,0,0,1]; //TODO fix hardcoding
				_icon = "\A3\ui_f\data\map\markers\nato\o_unknown.paa";
				
				//set location and name of text
				if (_cursorObject isKindOf "CAManBase") then {
					_targetPositionAGLTop = _cursorObject modelToWorldVisual (_cursorObject selectionPosition "Head");
					_targetPositionAGLTop set [2, (_targetPositionAGLTop select 2) + 0.75];
					_width = 0.5;
					_height = 0.5;
				} else { //AllVehicles
					_targetPositionAGLTop = _cursorObject modelToWorldVisual [0,0,0]; //vehicle
					_targetPositionAGLTop set [2, (_targetPositionAGLTop select 2) + 1.25];
					_width = 1.5;
					_height = 1.5;
				};

				drawIcon3D [
					_icon,								//icon texture path
					_color,								//color RBGA
					_targetPositionAGLTop,				//position
					_width,								//icon width
					_height,								//icon height
					0,									//icon angle
					_name,								//text to show
					2,									//2 for use outline
					0.025 / (getResolution select 5),	//adjust size based on uiScale
					"RobotoCondensed",					//font
					"center"							//text alignment
				];
			},
			[_cursorObject,_name,_color]
		];
		if (_deleteOnDeath) then {
			waitUntil {sleep 1; !(alive _cursorObject)};
			removeMissionEventHandler ["draw3D",_eventhandler];
		};
	}] remoteExec ["spawn"]; //dont do -2 in case we're doing local multiplayer. cursed, but oh well.
};

//we never need to un-set the Marked variable since, well, it never gets removed before death
	//also, marking dead units isn't supported