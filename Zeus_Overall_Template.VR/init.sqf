
sleep 1; //wait for mission start (so we can recieve the vars from initServer.sqf)

//show fps script by Mildly Interested/Bassbeard
//Code here is for headless clients, main server is in initServer.sqf
if (TAS_fpsDisplayEnabled) then {
	if (!isDedicated && !hasInterface && isMultiplayer) then { //anything in here gets executed on the headless clients
		[] execVM "scripts\show_Fps.sqf";
		diag_log text "--------------------[Executed show_fps on HC]--------------------"; //this will only show in  the HCs logs
	};
};
