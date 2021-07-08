//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group
if (local player) then { 
  player enableFatigue false; 
  player addMPEventhandler ["MPRespawn", {player enableFatigue false}]; 
};