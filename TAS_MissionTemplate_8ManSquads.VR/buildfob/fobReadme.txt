Adds a rallypoint/fob system for respawns and light logistical use
To add to your mission:

Put the following in your initServer.sqf

//turn FOB on/off
FOBEnabled = true; //set to false to disable FOB building and rallypoints
publicVariable "FOBEnabled";
useSmallRally = true; //set to true if you want to use the small rallypoint without a supply crate
publicVariable "useSmallRally";

//setup fob variables if fob system is enabled
if (FOBEnabled) then {
	//{ 
	//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
	//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
	fobBuilt = false;
	publicVariable "fobBuilt";
	rallyCmdUsed = false;
	publicVariable "rallyCmdUsed";
	rallyAlphaUsed = false;
	publicVariable "rallyAlphaUsed";
	rallyBravoUsed = false;
	publicVariable "rallyBravoUsed";
	rallyCharlieUsed = false;
	publicVariable "rallyCharlieUsed";
	rallyDeltaUsed = false;
	publicVariable "rallyDeltaUsed";
	rallyEchoUsed = false;
	publicVariable "rallyEchoUsed";
	rallyFoxtrotUsed = false;
	publicVariable "rallyFoxtrotUsed";
};


Put the following in your initPlayerLocal.sqf
//Add FOB Script
[] execVM "buildfob\initfob.sqf";

Place the buildfob folder in your mission file's root
Name each squad leader according to how they are named in the template mission.