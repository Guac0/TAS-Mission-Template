
sleep 1; //wait for mission start (so we can recieve the vars from initServer.sqf)



//////////////////////////////////////////////////////////////////
/////ALL CODE BELOW WILL ONLY BE EXECUTED ON HEADLESS CLIENTS/////
//////////////////////////////////////////////////////////////////

if (isDedicated || hasInterface) exitWith {};

diag_log format ["Init.sqf: Client has survived beheading."];

//show fps script by Mildly Interested/Bassbeard
//Code here is for headless clients, main server is in initServer.sqf
if (TAS_fpsDisplayEnabled) then {
	//if (!isDedicated && !hasInterface && isMultiplayer) then { //anything in here gets executed on the headless clients
		[] execVM "scripts\show_Fps.sqf";
		diag_log text "--------------------[Executed show_fps on HC]--------------------"; //this will only show in the HCs logs
	//};
};

//where the magic happens for spawning on HC. Advanced users only.
if (TAS_spawnUnitsOnHC) then {
	
	//setup our logics
	private _HC1Present = if(isNil "HC1") then {false} else {true};
	private _HC2Present = if(isNil "HC2") then {false} else {true};
	private _HC3Present = if(isNil "HC3") then {false} else {true};
	private _playerRole = roleDescription player;

	//spawn first set of units, preferably on HC1
	private _firstUnitsSpawned = missionNamespace getVariable ["firstUnitsSpawned",false];
	if (!_firstUnitsSpawned) then { //if the units aren't spawned yet then start the rest of the logic

		if (_HC1Present) then { //if HC1 is connected then spawn on HC1 and other HCs ignore, if HC1 is not connected then do it on whatever
			
			if (_playerRole == "HC1") then {
				
				[["first"]] execVM "scripts\spawnUnits.sqf";
				//[] execVM "scripts\spawnUnits.sqf";
				diag_log format ["Spawned first set of units on %1",name player];
				missionNamespace setVariable ["firstUnitsSpawned",true];
				
			};
			
		} else { //spawn on whatever HC is available if HC1 not connected
		
			[["first"]] execVM "scripts\spawnUnits.sqf";
			//[] execVM "scripts\spawnUnits.sqf";
			diag_log format ["Spawned first set of units on %1",name player];
			missionNamespace setVariable ["firstUnitsSpawned",true];
			
		};
		
	};

	//spawn second set of units, preferably on HC2
	private _secondUnitsSpawned = missionNamespace getVariable ["secondUnitsSpawned",false];
	if (!_secondUnitsSpawned) then { //if the units aren't spawned yet then start the rest of the logic

		if (_HC2Present) then { //if HC2 is connected then spawn on HC2 and other HCs ignore, if HC2 is not connected then do it on whatever
			
			if (_playerRole == "HC2") then {
				
				[["second"]] execVM "scripts\spawnUnits.sqf"; //TODO only second
				diag_log format ["Spawned second set of units on %1",name player];
				missionNamespace setVariable ["secondUnitsSpawned",true];
				
			};
			
		} else { //spawn on whatever HC is available if HC2 not connected
		
			[["second"]] execVM "scripts\spawnUnits.sqf";
			diag_log format ["Spawned second set of units on %1",name player];
			missionNamespace setVariable ["secondUnitsSpawned",true];
			
		};
		
	};

	//spawn third set of units units, preferably on HC3
	private _thirdUnitsSpawned = missionNamespace getVariable ["thirdUnitsSpawned",false];
	if (!_thirdUnitsSpawned) then { //if the units aren't spawned yet then start the rest of the logic

		if (_HC3Present) then { //if HC3 is connected then spawn on HC3 and other HCs ignore, if HC3 is not connected then do it on whatever
			
			if (_playerRole == "HC3") then {
				
				[["third"]] execVM "scripts\spawnUnits.sqf";
				diag_log format ["Spawned third set of units on %1",name player];
				missionNamespace setVariable ["thirdUnitsSpawned",true];
				
			};
			
		} else { //spawn on whatever HC is available if HC3 not connected
		
			[["third","depot"]] execVM "scripts\spawnUnits.sqf";
			diag_log format ["Spawned third set of units on %1",name player];
			missionNamespace setVariable ["thirdUnitsSpawned",true];
		
		};
		
	};
};
//diag_log format ["Init.sqf: finished"];