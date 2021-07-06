//dynamic groups code
["InitializePlayer", [player, true]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework and registers the player group
if (local player) then { 
  player enableFatigue false; 
  player addMPEventhandler ["MPRespawn", {player enableFatigue false}]; 
};

//TAS Afk Script
//Written by Guac
//Requirements: CBA, ACE

//make a diary record tutorial
player createDiaryRecord ["Diary", ["TAS Afk Script", "To start/stop the AFK script, input the keybinding you added under Controls\Addon Controls\TAS Keybindings\Run AFK Script. By default, it will be Left Control + O."]];

//function to use in making/unmaking afk
TAS_fnc_AfkScript = 
{
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
		_AfkPlayer setVariable ["TAS_Afk",false];
		[_AfkPlayer] call ace_medical_treatment_fnc_fullHealLocal; //heal again because sometimes explosives damage even when afk
		format ["%1 is back from being AFK", name _AfkPlayer] remoteExec ["globalChat", 0]; //if someone goes afk excessively, then they might be abusing the heal
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
		[_AfkPlayer] call ace_medical_treatment_fnc_fullHealLocal;
		//_AfkPlayer enableSimulationGlobal false;
		[_AfkPlayer, true] remoteExec ["hideObjectGlobal", 2];
		[_AfkPlayer, false] remoteExec ["enableSimulationGlobal", 2];
		_AfkPlayer setVariable ["TAS_Afk",true];
		_AfkPlayer globalChat format ["%1 went AFK.", name _AfkPlayer];
		format ["%1 is now AFK", name _AfkPlayer] remoteExec ["globalChat", 0];
		systemChat "See your diary entries for how to exit AFK.";
	};
};

// Register a simple keypress to an action
#include "\a3\ui_f\hpp\defineDIKCodes.inc" //these two lines can be removed if wanted, rn script uses the number codes instead
#define USER_19 0x10C
//25 for P, 0x10C for User Action 19
["TAS Keybindings","afk_script_key","Run TAS Afk Script", {call TAS_fnc_AfkScript}, "", [25, [false, true, false]]] call CBA_fnc_addKeybind;

//FOB Script
sleep 2; //wait for init
if !(FOBEnabled) exitWith {systemChat "FOB building disabled"};

// Vars for picking medic class
private _builders = ["CMD_Actual"]; //var names of roles with access to fob building
									//Depending on mission, add more/less, such as the other members of the command element, a dedicated logi crew, or the alpha SL (if GC not used), or all SLs
//fobUsed = false;
private _playerClass = vehicleVarName player;
if (_playerClass in _builders) then {
	FH_Unpack_Action = ["unpackFOB","Unpack Foward Operating Base","",{[] execVM "scripts\buildccp\unpack_platoon.sqf";},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], FH_Unpack_Action] call ace_interact_menu_fnc_addActionToObject;
};
