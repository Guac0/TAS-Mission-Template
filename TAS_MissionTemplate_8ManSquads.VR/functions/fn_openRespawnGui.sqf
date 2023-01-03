//in a separate file than respawnGUI since disableSerialization messes with stuff
//waits until player is out of ace arsenal and vehicles to show the respawn GUI
//execute locally on player
if (player getVariable ["TAS_aceArsenalOpen",false]) then {
	hint "Please close any displays (such as Arsenal) before being shown the respawn GUI!";
	systemChat "Please close any displays (such as Arsenal) before being shown the respawn GUI!"; //this too because while in arsenal, hints are hidden
	waitUntil {sleep 0.25; !(player getVariable ["TAS_aceArsenalOpen",false])}; //wait until ace arsenal is exited to avoid gui errors
};

if (vehicle player != player) then {
	hint "Exit the vehicle before being shown the respawn GUI!";
	systemChat "Exit the vehicle before being shown the respawn GUI!"; //this too because while in arsenal, hints are hidden
	waitUntil {sleep 0.25; vehicle player == player}; //wait until ace arsenal is exited to avoid gui errors
};
[] spawn TAS_fnc_respawnGui;