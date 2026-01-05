if (!(hasInterface) && {!(isServer)}) exitWith {
	if !(isServer) exitWith { ["TAS_fnc_3dGroupIcons: called on HC, exiting!"] call TAS_fnc_error };
};

if (isServer) then {
	if !(hasInterface) exitWith { //normal dedicated server
		waitUntil {
			//private _numPlayerGroups = localNamespace getVariable ["TAS_numPlayerGroups",0];
			private _playerGroupLeaders = [];
			{
				if (isPlayer (leader _x)) then {
				//if (alive (leader _x)) then {
					//_numPlayerGroups = _numPlayerGroups + 1;
					_playerGroupLeaders pushBack (leader _x);
				};
			} forEach allGroups;
			//missionNamespace setVariable ["TAS_numPlayerGroups",_numPlayerGroups];
			missionNamespace setVariable ["TAS_playerGrpLeads",_playerGroupLeaders];
			sleep 10; //seems like a good balanced
			!(TAS_3dGroupIcons)
		};
	};
	//special case for local host. same code as above
	[] spawn {
		waitUntil {
			//private _numPlayerGroups = localNamespace getVariable ["TAS_numPlayerGroups",0];
			private _playerGroupLeaders = [];
			{
				if (isPlayer (leader _x)) then {
				//if (alive (leader _x)) then {
					//_numPlayerGroups = _numPlayerGroups + 1;
					_playerGroupLeaders pushBack (leader _x);
				};
			} forEach allGroups;
			//missionNamespace setVariable ["TAS_numPlayerGroups",_numPlayerGroups];
			missionNamespace setVariable ["TAS_playerGrpLeads",_playerGroupLeaders];
			sleep 10; //seems like a good balance
			!(TAS_3dGroupIcons)
		};
	};
};

//players only
private _eventhandler = addMissionEventHandler ["Draw3D",
	{
		private _playerGroupLeaders = missionNamespace getVariable ["TAS_playerGrpLeads",[]];
		private _friendlySides = [civilian];
		{
			if ([_x,side player] call BIS_fnc_sideIsFriendly) then {
				_friendlySides pushBack _x;
			};
		} forEach [west,independent,east];
		_playerGroupLeaders = _playerGroupLeaders select { (side _x) in _friendlySides };
		private _numPlayerGroups = count _playerGroupLeaders;
		{
			//skip if unit does not exist or is dead or is not group leader
			//if (isNil _x) then {continue};
			//if !(alive _x) then {continue}; //alive alone should work fine since its on allPlayers
			//if (leader _x != _x) then {continue};

			private ["_varName","_side","_icon","_color","_targetPositionAGLTop","_name"];

			//controls color
			_varName = vehicleVarName _x;
			private _alpha = 0.5;
			if ("Actual" in _varName) then {
				_color = [0,1,0,_alpha];
				_icon = "A3\ui_f\data\map\markers\nato\b_inf.paa";
			};	//infantry, lime green, infantry. hacky becuase multiple things have actual
			switch (true) do
			{
				case ("Z" in _varName): {
					_color = [1,0,1,_alpha]; //zeus, purple (fuschia actually), flag
					_icon = "\A3\ui_f\data\map\markers\handdrawn\flag_CA.paa";
				};
				case ("CMD" in _varName): {
					_color = [1,0,0,_alpha]; //GC, red, hq
					_icon = "\A3\ui_f\data\map\markers\nato\b_hq.paa";
				};
				case ("LOGI" in _varName): {
					_color = [0.5,0.5,0,_alpha]; //logi, olive, maintenance
					_icon = "\A3\ui_f\data\map\markers\nato\b_maint.paa";
				};
				case ("RECON" in _varName): {
					_color = [0,0.5,0.5,_alpha]; //Recon, teal, recon
					_icon = "\A3\ui_f\data\map\markers\nato\b_recon.paa";
				};
				case ("AIR" in _varName): {
					_color = [1,1,0,_alpha];
					_icon = "A3\ui_f\data\map\markers\nato\b_air.paa";
				};	//air, yellow, air
				case ("GROUND" in _varName): {
					_color = [0,1,1,_alpha];
					_icon = "A3\ui_f\data\map\markers\nato\b_armor.paa";
				};	//armor, cyan, armor
				case ("Actual" in _varName): {}; //no fall through, skip due to already being set
				default {
					_color = [1, 1, 1, _alpha];
					_icon = "\A3\ui_f\data\map\markers\nato\b_unknown.paa";
				};	//misc, white, unknown
			};
			
			//set location and name of text
			private _heightAboveHead = 1.8; //min
			_heightAboveHead = _heightAboveHead + (0.10 * _numPlayerGroups);
			if (_heightAboveHead > 3) then { _heightAboveHead = 3 }; //clamp max

			_targetPositionAGLTop = _x modelToWorldVisual (_x selectionPosition "Head");
			_targetPositionAGLTop set [2, (_targetPositionAGLTop select 2) + _heightAboveHead];
			_name = groupID group _x;

			private _iconWidth = 1.5; //max
			_iconWidth = _iconWidth - (0.05 * _numPlayerGroups);
			if (_iconWidth < 1) then { _iconWidth = 1.2 }; //clamp min

			private _iconHeight = 1.5; //max
			_iconHeight = _iconHeight - (0.05 * _numPlayerGroups);
			if (_iconHeight < 1) then { _iconHeight = 1.2 }; //clamp min

			private _textSize = 0.025 / (getResolution select 5); //adapts to system size
			_textSizeFactor = 1 - (0.04 * _numPlayerGroups);
			if (_textSizeFactor < 0.6) then { _textSizeFactor = 0.6 }; //clamp min
			_textSize = _textSize * _textSizeFactor;

			drawIcon3D [
				_icon,								//icon texture path
				_color,								//color RBGA
				_targetPositionAGLTop,				//position
				_iconWidth,							//icon width
				_iconHeight,						//icon height
				0,									//icon angle
				_name,								//text to show
				2,									//2 for use outline
				_textSize,	//adjust size based on uiScale //0.025 / (getResolution select 5)
				"RobotoCondensed",					//font
				"center"							//text alignment
			];
		//} forEach allGroups;
		} forEach _playerGroupLeaders;
	}
];
waitUntil {sleep 1; !(TAS_3dGroupIcons)};
removeMissionEventHandler ["draw3D",_eventhandler];