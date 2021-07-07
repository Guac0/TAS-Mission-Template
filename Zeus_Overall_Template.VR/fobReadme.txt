Adds a rallypoint/fob system for respawns and light logistical use
To add to your mission:

Put the following in your initServer.sqf
//setup rally variables
FOBEnabled = true; //set to false to disable FOB building and rallypoints
publicVariable "FOBEnabled";
if !(FOBEnabled) exitWith {systemChat "FOB/Rallypoint building disabled"}; //if system is disabled then no need for publicVariables
//{ 
//	_x = createMarkerLocal [_x, [0,0,0]]; _x setMarkerTypeLocal "Flag"; _x setMarkerColorLocal "ColorCIV";
//} forEach ["fobMarker","rallypointCmdMarker","rallypointAlphaMarker"]; //create the markers via script (unused, placed in editor instead)
fobBuilt = false;
publicVariable "fobBuilt";
cmdRallyUsed = false;
publicVariable "cmdRallyUsed";
alphaRallyUsed = false;
publicVariable "alphaRallyUsed";
bravoRallyUsed = false;
publicVariable "bravoRallyUsed";
charlieRallyUsed = false;
publicVariable "charlieRallyUsed";
deltaRallyUsed = false;
publicVariable "deltaRallyUsed";
echoRallyUsed = false;
publicVariable "echoRallyUsed";
foxtrotRallyUsed = false;
publicVariable "foxtrotRallyUsed";

Put the following in your initPlayerLocal.sqf
//Add FOB Script
[] execVM "buildfob\initfob.sqf";

Place the buildfob folder in your mission file's root