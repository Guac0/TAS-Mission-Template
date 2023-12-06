//executed from initPlayerLocal. note that some aspects are handled in applyHoldAction.sqf and zenCustomModulesRegister.sqf

if (count TAS_vassPrebriefing > 0) then {
	"Shop System Prebriefing" hintC TAS_vassPrebriefing;
} else {
	["TAS_fnc_vassPlayerInit: TAS_vassPrebriefing is empty and therefore will not be displayed!"] call TAS_fnc_error;
};

//save player loadout from editor so that zeus can custom-make loadouts
player setVariable ["editorLoadout",getUnitLoadout player]; //not profileNameSpace since unique to each mission
//if player does not have money from previous missions, start at 700
private _initialRetrievedBalance = profileNamespace getVariable [TAS_vassShopSystemVariable,TAS_vassDefaultBalance];
if (_initialRetrievedBalance == TAS_vassDefaultBalance) then {
	profileNamespace setVariable [TAS_vassShopSystemVariable,TAS_vassDefaultBalance];
};

if (TAS_vassBonusStartingMoney != 0) then {
	private _moreMoneyAtStart = _initialRetrievedBalance + 700;
	profileNamespace setVariable [TAS_vassShopSystemVariable,_moreMoneyAtStart];
};

//set player loadout cost to 0 to start with
player setVariable ["rebuyCost",0]; //not profileNameSpace since unique to each mission
//apply loadout from last mission
private _initialLoadout = profileNamespace getVariable [TAS_vassShopSystemLoadoutVariable,player getVariable "editorLoadout"]; //if no loadout saved, use editor loadout
player setUnitLoadout _initialLoadout;

//player self interact to see balance
seeSelfBalanceAction = ["viewSelfBalance","View Current Balance","",{private _money = profileNamespace getVariable TAS_vassShopSystemVariable; hint format ["You have %1$ in cash.",_money];},{true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], seeSelfBalanceAction] call ace_interact_menu_fnc_addActionToObject;

{
	//do some fancy stuff before removing items to account for arsenals that don't actually exist.
	private _shop = _x;
	_shop = missionNamespace getVariable [_shop, objNull]; //convert from string to object, otherwise we get errors
	
	if (!isNull _shop) then {
	/*
		Author: 7erra <https://forums.bohemia.net/profile/1139559-7erra/>

		Description:
		Add shop action to an object. Any previous actions of this type are removed. VASS is only activated when the arsenal is opened via this function.

		Parameter(s):
		0: OBJECT - Object to which the action is added.
		(optional) 1: STRING - Title of the action
			default: "Shop"
		(optional) 2: NUMBER - Priority of the action, see BIKI: addAction
			default: 1.5
		(optional) 3: STRING - Condition which has to be fullfilled for shop to be accessible, see BIKI: addAction
			default: "alive _this && alive _object"
		(optional) 4: NUMBER - Distance from which the action is activatable
			default: 5

		Note: Run this on every client.
		Returns:
		NUMBER - ID of the action, alos saved as "TER_VASS_actionID" on the object.
	*/
	_shopAction = [_shop,"Open Shop",5] call TER_fnc_addShop;
	} else {
		if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorLogic player))) then { //only do visual error if server (singleplayer testing) or admin or zeus
			systemchat format ["WARNING: One or more objects (%1) in TAS_vassShops does not exist!",_x];
		};
		diag_log text format ["TAS-MISSION-TEMPLATE WARNING: One or more objects (%1) in TAS_vassShops does not exist!",_x];
	};
} forEach TAS_vassShops;




//adding shop items via script
//initServer
/*
	Author: 7erra <https://forums.bohemia.net/profile/1139559-7erra/>

	Description:
	Change the inventory of a shop.

	Parameter(s):
	0: OBJECT - The shop object whose inventory will be changed.
	1: ARRAY - List of items, prices and amounts to add
		Format: ["class0", price, amount, "class1", price, amount,..., "classN", price, amount]
			Class: STRING - Class name of the item
			Price: NUMBER - The cost of the item
			Amount: NUMBER or BOOL - How many items the trader has. true means unlimited, false removes it from the inventory.
	(optional) 2: NUMBER - Overwrite mode:
		0 - Don't overwrite, only add new things
		1 - (default) Overwrite soft, only adjust prices and add new things
		2 - Hard overwrite, the passed array becomes the new inventory
		3 - Overwrite old, don't add new entries, only modify old ones
		4 - Amount diff, add/substract amounts
	(optional) 3: BOOL - Change inventory for all players. If not specified, the _object's "TER_VASS_shared" variable is used. If this isn't set either it defaults totrue.

	Note: only needs to be run on server (see option 3).
	
	Returns:
	ARRAY - New inventory
*/
/*
[
	shopCrate,// object
	[// array in format: "class", price, amount
		////////////////////////////////////////
		///////////// WEAPONS //////////////
		////////////////////////////////////////

		"launch_RPG7_f",400, 2,
		"CUP_lmg_MG3",200,true,
		"CUP_lmg_minimi",300,true,
		"KA_M1014", 150,true,
		"KA_Model_733", 250,true,
		"CUP_arifle_Gewehr1", 200,true,
		"Hatchet", 150, 1,
		"KA_dagger", 20,true,
		"KA_axe", 20,true,
		"AGE_AKM",200,true,
		"KICKASS_Sawed_Off_Shotgun", 30,true,
		"CUP_hgun_CZ75", 30,true,
		"AGE_Stechkin", 30,true,
		"CUP_arifle_AK47_Early", 150,true, 
		////////////////////////////////////////
		///////////// AMMO /////////////////////
		////////////////////////////////////////
		"CUP_16Rnd_9x19_cz75", 5,true,
		"B_545x39_Ball_Green_F", 10,true,
		"AGE_20Rnd_9x21mm_Mag", 5,true,
		"AGE_30Rnd_762x39_Mag", 10,true,
		"CUP_120Rnd_TE4_LRT4_Green_Tracer_762x51_Belt_M", 45,true,
		"CUP_100Rnd_TE4_Green_Tracer_556x45_M249", 35,true,
		"ACE_30Rnd_556x45_Stanag_Mk318_mag", 10,true,
		"CUP_PG7V_M", 50,true,
		"6Rnd_M1014_buck", 2,true,
		"6Rnd_M1014_slug", 5,true,
		"KA_M16_30rnd_M193_Ball_mag", 10,true,

		"CUP_10Rnd_762x51_FNFAL_M", 2,true,
		
		"KICKASS_2Rnd_Sawed_Off_Shotgun_Pellets", 1,true,
		////////////////////////////////////////
		///////////// ATTACHMENTS //////////////
		////////////////////////////////////////
		"optic_holosight_blk_f",50,true, //1x holosight
		"optic_erco_blk_f",125,true, //2x with alt red dot
		"optic_sos",150,true, //5x with alt irons
		"optic_nightstalker",250,true, //10x with alt red dot and thermals
		"acc_flashlight",25,true, //flashlight
		"ace_acc_pointer_green",50,true, //laser pointer, visible and IR
		"ace_muzzle_mzls_l",25,true, //flash hider
		"muzzle_snds_m",50,true, //suppressor
		"bipod_01_f_blk",25,true, //bipod black
		////////////////////////////////////////
		///////////// EQUIPMENT ////////////////
		////////////////////////////////////////

		///////////// VESTS ////////////////
		"CUP_V_MBSS_PACA_CB",20,true,
		"CUP_V_CPC_light_coy", 20,true,
		"CUP_Vest_RUS_6B45_Sh117_VOG_Full_BeigeDigital", 20,true,

		///////////// BACKPACKS ////////////////
		"B_FieldPack_cbr", 20,true,
		"CUP_B_US_IIID_OEFCP", 20,true,
		"B_ViperHarness_khk_F", 25,true,

		///////////// SEEING DEVICES ////////////////
		"Binocular", 0,true,

		///////////// GRENADES ////////////////
		"CUP_HandGrenade_M67", 10,true,
		"HandGrenade", 10,true,
		"SmokeShellRed",2,true,
		"SmokeShellYellow", 2,true,
		"SmokeShell",2,true
	],
	2,// overwrite mode: see VASS\fnc\fn_addShopCargo.sqf for more. in this case set the inventory as the passed array
	true// make inventory the same for everyone
] call TER_fnc_addShopCargo;
*/