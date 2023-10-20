//TAS Afk Script
//Written by Guac
//Requirements: CBA, ACE

//function to use in making/unmaking afk

//setup TAS_Afk, if player does not have TAS_Afk already defined then default to false
private _AfkPlayer = player;
private _isPlayerAfk = _AfkPlayer getVariable ["TAS_Afk", false];

//if script activates while player is already AFK, then undo what the AFK script did
//could make into if/else
if (_isPlayerAfk == true) then
{
	_AfkPlayer setUnitLoadout (_AfkPlayer getVariable ["Afk_Saved_Loadout",[]]);
	//player enableSimulationGlobal true;
	[_AfkPlayer, true] remoteExec ["enableSimulationGlobal", 2];
	[_AfkPlayer, false] remoteExec ["hideObjectGlobal", 2];
	_AfkPlayer allowDamage true;
	_AfkPlayer setCaptive false;
	[_AfkPlayer] call ace_medical_treatment_fnc_fullHealLocal; //heal again because sometimes explosives damage even when afk
	[_AfkPlayer, format ["%1 is back from being AFK", name _AfkPlayer]] remoteExec ["globalChat", 0]; //if someone goes afk excessively, then they might be abusing the heal
	_AfkPlayer setVariable ["TAS_Afk",false];
};

//when player goes AFK, disable their simulation, make them invisible, and take away their loadout (so they don't have access to radio)
//need to make captive, invincible, and ace heal so AI doesn't engage and they don't get damaged or bleed out
//also say that they are afk/unafk in global chat and add a systemchat (local) prompt in case they accidentally went AFK and don't know what to do
//todo: find a way to prevent bleedout without using a full heal
if (_isPlayerAfk == false) then
{
	_AfkPlayer setVariable ["Afk_Saved_Loadout",getUnitLoadout _AfkPlayer];
	removeBackpackGlobal _AfkPlayer;
	removeAllAssignedItems _AfkPlayer;
	removeAllItems _AfkPlayer;
	removeAllWeapons _AfkPlayer;
	_AfkPlayer allowDamage false;
	_AfkPlayer setCaptive true;
	[_AfkPlayer] call ace_medical_treatment_fnc_fullHealLocal; //watch out: if players realize they get a heal with the afk script, they might abuse it. Going afk is logged in chat.
	[_AfkPlayer, true] remoteExec ["hideObjectGlobal", 2];
	[_AfkPlayer, false] remoteExec ["enableSimulationGlobal", 2];
	_AfkPlayer setVariable ["TAS_Afk",true];
	[_AfkPlayer, format ["%1 is now AFK", name _AfkPlayer]] remoteExec ["globalChat", 0];
	systemChat "See your diary entries for how to exit AFK.";
};
