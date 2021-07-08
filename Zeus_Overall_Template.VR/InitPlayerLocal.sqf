//short sleep for server to read init file
sleep 1;

//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group

//disableStamina
if (local player) then { 
  player enableFatigue false; 
  player addMPEventhandler ["MPRespawn", {player enableFatigue false}]; 
};

//Add TAS Afk Script
[] execVM "afkScript.sqf";

//Add FOB Script
[] execVM "buildfob\initfob.sqf";
