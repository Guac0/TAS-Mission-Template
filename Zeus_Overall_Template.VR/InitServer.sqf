//dynamic groups code
["Initialize", [true]] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework and groups led by a player at mission start will be registered

//setup rally variables
FOBEnabled = true; //set to false to disable FOB building and rallypoints
publicVariable "FOBEnabled";
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