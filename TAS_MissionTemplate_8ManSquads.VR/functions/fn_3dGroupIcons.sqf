private _eventhandler = addMissionEventHandler ["Draw3D",
	{
		{
			//skip if unit does not exist or is dead or is not group leader
			//if (isNil _x) then {continue};
			if !(alive _x) then {continue}; //alive alone should work fine since its on allPlayers
			if (leader _x != _x) then {continue};

			private ["_varName","_side","_icon","_color","_targetPositionAGLTop","_name"];

			//controls color
			_varName = vehicleVarName _x;
			if ("Actual" in _varName) then {
				_color = [0,1,0,1];
				_icon = "A3\ui_f\data\map\markers\nato\b_inf.paa";
			};	//infantry, lime green, infantry. hacky becuase multiple things have actual
			switch (true) do
			{
				case ("Z" in _varName): {
					_color = [1,0,1,1]; //zeus, purple (fuschia actually), flag
					_icon = "\A3\ui_f\data\map\markers\handdrawn\flag_CA.paa";
				};
				case ("CMD" in _varName): {
					_color = [1,0,0,1]; //GC, red, hq
					_icon = "\A3\ui_f\data\map\markers\nato\b_hq.paa";
				};
				case ("LOGI" in _varName): {
					_color = [0.5,0.5,0,1]; //logi, olive, maintenance
					_icon = "\A3\ui_f\data\map\markers\nato\b_maint.paa";
				};
				case ("RECON" in _varName): {
					_color = [0,0.5,0.5,1]; //Recon, teal, recon
					_icon = "\A3\ui_f\data\map\markers\nato\b_recon.paa";
				};
				case ("AIR" in _varName): {
					_color = [1,1,0,1];
					_icon = "A3\ui_f\data\map\markers\nato\b_air.paa";
				};	//air, yellow, air
				case ("GROUND" in _varName): {
					_color = [0,1,1,1];
					_icon = "A3\ui_f\data\map\markers\nato\b_armor.paa";
				};	//armor, cyan, armor
				case ("Actual" in _varName): {}; //no fall through, skip due to already being set
				default {
					_color = [1, 1, 1, 1];
					_icon = "\A3\ui_f\data\map\markers\nato\b_unknown.paa";
				};	//misc, white, unknown
			};
			
			//set location and name of text
			_targetPositionAGLTop = _x modelToWorldVisual (_x selectionPosition "Head");
			_targetPositionAGLTop set [2, (_targetPositionAGLTop select 2) + 1.75];
			_name = groupID group _x;

			drawIcon3D [
				_icon,								//icon texture path
				_color,								//color RBGA
				_targetPositionAGLTop,				//position
				1.5,								//icon width
				1.5,								//icon height
				0,									//icon angle
				_name,								//text to show
				2,									//2 for use outline
				0.025 / (getResolution select 5),	//adjust size based on uiScale
				"RobotoCondensed",					//font
				"center"							//text alignment
			];
		} forEach allPlayers;
	}
];
waitUntil {sleep 1; !(TAS_3dGroupIcons)};
removeMissionEventHandler ["draw3D",_eventhandler];