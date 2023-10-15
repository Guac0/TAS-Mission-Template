//Written by Guac as a way to safely save and exit in missions using VASS
//[] remoteExec ["TAS_fnc_vassEndMission"];

hint "Debug, if you see this and no other messages please contact Zeus.";

if !(isServer) then { //only execute stuff with player on player machines
	player allowDamage false;
	private _retrievedMoneyForEnd = profileNamespace getVariable [TAS_vassShopSystemVariable,0];
	hint "MISSION SAVE BEGINNING, EXPECT SMALL FREEZE WHILE VARIABLES ARE SAVED. DO NOT DISCONNECT UNTIL MISSION ENDS!";
	sleep 3;
	profileNamespace setVariable [TAS_vassShopSystemLoadoutVariable,getUnitLoadout player]; //save loadout for next mission, money already saves automatically
	saveProfileNamespace;
	hint format ["Mission ending: Your current loadout and your balance of %1 has been saved!",_retrievedMoneyForEnd];
};

["epicWin", true] call BIS_fnc_endMission; //victory, local effect. plays after save is finished