/*
Changes loadout to gear appropriate for a "scaveneger" style one. Vaguely themed for woodland environments. Adjusts gear automatically based on presence of loaded mods.

[unit] remoteExec ["TAS_fnc_scavLoadout",unit]; //execute locally to unit
[player] call TAS_fnc_scavLoadout;
*/
params ["_unit",["_numberOfMags",8],["_giveRadio",0],["_addGrenades",false],["_changeSkill",true]];

//check flag to see if scav system is running
if !(TAS_scavSystemEnabled) exitWith {
	["fn_scavLoadout called but system is disabled!",true] call TAS_fnc_error;
};

if (_unit isEqualTo objNull) exitWith { ["fn_scavLoadout called with a null unit!",true] call TAS_fnc_error }; //BIS commands seem to fail gracefully with a non-existing unit (createVehicle fed nonexistant classname) but ACE will throw a hissy fit

if (_giveRadio == 0) then { //if not defined by params, default to yes if player and no if AI
	if (isPlayer _unit) then {
		_giveRadio = true;
	} else {
		_giveRadio = false;
	};
};

//clear _unit inventory and give scav-appropriate gear and set radio
removeAllItems _unit;
removeAllAssignedItems [_unit,true,true]; //remove  headgear, binos, goggles
removeAllContainers _unit;
removeAllWeapons _unit;

/*
UNIFORMS
*/
private _uniformPool = [];
private _vanillaUniforms = ["U_BG_Guerilla3_1","U_BG_Guerilla2_3","U_I_G_resistanceLeader_F","U_BG_Guerrilla_6_1","U_C_HunterBody_grn","U_BG_Guerilla2_2"];
private _rhsUniforms = [];
private _3cbUniforms = ["UK3CB_ADC_C_Pants_U_12","UK3CB_ADC_C_Pants_U_19","UK3CB_MEI_B_U_Pants_02","UK3CB_LNM_B_U_Shirt_Pants_11","UK3CB_LNM_B_U_Shirt_Pants_02","UK3CB_LFR_B_U_Officer_03","UK3CB_LFR_B_U_RANGER_03"];

_uniformPool = _uniformPool + _vanillaUniforms;
if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { _uniformPool = _uniformPool + _rhsUniforms };
if (isClass(configFile >> "CfgPatches" >> "uk3cb_factions_weapons")) then { _uniformPool = _uniformPool + _3cbUniforms };

/*
VESTS
*/
private _vestPool = [];
private _vanillaVests = ["V_HarnessOSpec_brn","V_HarnessOSpec_gry","V_TacVest_oli","V_TacVest_camo","V_TacVest_khk"];
private _csatEnhancedVests = ["TEC_V_Hamel_New_Light_Brown","TEC_V_Recon_Light","TEC_V_PC_New_Patrol_Brown"];
private _rhsVests = ["rhs_chicom_khk","rhs_lifchik_light","rhsgref_chestrig"];
private _3cbVests = ["UK3CB_V_CW_Chestrig_2_Small","UK3CB_V_Belt_Rig_Lite_KHK","UK3CB_V_Chicom_Desert","UK3CB_V_Chestrig_ERDL","UK3CB_ARD_B_V_vydra_3m_TAN"];

_vestPool = _vestPool + _vanillaVests;
if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { _vestPool = _vestPool + _rhsVests };
if (isClass(configFile >> "CfgPatches" >> "CSAT_Vests")) then { _vestPool = _vestPool + _csatEnhancedVests }; //csat modification project https://steamcommunity.com/sharedfiles/filedetails/?id=441854566&searchtext=csat+enhanced
if (isClass(configFile >> "CfgPatches" >> "uk3cb_factions_weapons")) then { _vestPool = _vestPool + _3cbVests };

/*
BACKPACKS
*/
private _backpackPool = [];
private _vanillaBackpacks = ["B_FieldPack_khk","B_FieldPack_oli","B_FieldPack_green_F","B_AssaultPack_khk","B_AssaultPack_cbr","B_AssaultPack_cbr","B_AssaultPack_sgg"];
private _rhsBackpacks = [];
private _3cbBackpacks = ["UK3CB_KDF_B_B_Sidor_RIF_OLI","UK3CB_TKA_O_B_RIF_Khk","UK3CB_B_Alice_K","UK3CB_CHC_C_B_HIKER"];

_backpackPool = _backpackPool + _vanillaBackpacks;
if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { _backpackPool = _backpackPool + _rhsBackpacks };
if (isClass(configFile >> "CfgPatches" >> "uk3cb_factions_weapons")) then { _backpackPool = _backpackPool + _3cbBackpacks };

/*
HEADGEAR
*/
private _headgearPool = [];
private _vanillaHeadgear = ["H_Booniehat_oli","H_Booniehat_mgrn","H_Cap_oli","H_Cap_grn","H_Bandanna_khk","H_Bandanna_cbr","H_Watchcap_camo","H_Watchcap_khk","H_StrawHat_dark"];
private _rhsHeadgear = [];
private _3cbHeadgear = ["UK3CB_H_Cap_ERDL_AFG","UK3CB_H_Cap_TRK","UK3CB_LSM_B_H_Field_Cap_TIG_01","UK3CB_LSM_B_H_M88_Field_Cap_TIG_02","UK3CB_H_MilCap_WDL_01","UK3CB_TKA_I_H_Patrolcap_OLI","UK3CB_CW_US_B_LATE_H_Patrol_Cap_WDL_01","UK3CB_H_Bandanna_Brown_Check","UK3CB_H_Bandanna_Green_Check","UK3CB_H_Bandanna_Camo","UK3CB_H_Beanie_01","UK3CB_H_Woolhat_CBR","UK3CB_LNM_B_H_BoonieHat_MULTICAM","UK3CB_LSM_B_H_BoonieHat_TIG_02","UK3CB_LNM_B_H_BoonieHat_WDL_03"];

_headgearPool = _headgearPool + _vanillaHeadgear;
if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { _headgearPool = _headgearPool + _rhsHeadgear };
if (isClass(configFile >> "CfgPatches" >> "uk3cb_factions_weapons")) then { _headgearPool = _headgearPool + _3cbHeadgear };

/*
WEAPONS
*/
private _weaponPool = [];
private _vanillaWeapons = ["srifle_DMR_06_hunter_F","arifle_AKM_F","arifle_AKS_F"/*,"arifle_TRG21_F","srifle_EBR_F"*/];
//"NAA_arifle_Mk20C_black_F","MYR_arifle_MX_sage_F","arifle_CDF_AK74M_blk_F","arifle_RK95TPM30_F","jpab_arifle_SPAR_04_khk_F" //variaty of random mod weapons
private _rhsWeapons = ["rhs_weap_aks74u","rhs_weap_pm63","rhs_weap_l1a1_wood","rhs_weap_kar98k","rhs_weap_m3a1","rhs_weap_m38","rhs_weap_MP44","rhs_weap_m76","rhs_weap_m14","rhs_weap_m14_socom"];
private _3cbWeapons = ["uk3cb_sks_01"];

_weaponPool = _weaponPool + _vanillaWeapons;
if (isClass(configFile >> "CfgPatches" >> "rhsusf_weapons")) then { _weaponPool = _weaponPool + _rhsWeapons };
if (isClass(configFile >> "CfgPatches" >> "uk3cb_factions_weapons")) then { _weaponPool = _weaponPool + _3cbWeapons };

_unit forceAddUniform selectRandom _uniformPool;
_unit addVest selectRandom _vestPool;
_unit addBackpack selectRandom _backpackPool;
_unit addHeadgear selectRandom _headgearPool;
_unit addWeapon selectRandom _weaponPool; //will not be loaded if ammo is not added first

if (count ([primaryWeapon _unit] call CBA_fnc_compatibleMagazines) > 0) then {									
	for "_i" from 1 to _numberOfMags do { _unit addItem ([primaryWeapon _unit] call CBA_fnc_compatibleMagazines select 0) };
	/*if (count ([primaryWeapon _unit] call CBA_fnc_compatibleMagazines) > 1) then {  								
		for "_i" from 1 to 4 do { _unit addItem ([primaryWeapon _unit] call CBA_fnc_compatibleMagazines select 1) }; 
	};*/
};
reload _unit;
_unit linkItem "ItemMap";
_unit linkItem "ItemWatch";
_unit linkItem "ItemCompass";
//_unit linkItem "ItemGPS";

//basic medical
for "_i" from 1 to 16 do { _unit addItem "ACE_quikclot" };
for "_i" from 1 to 8 do { _unit addItem "ACE_morphine" };
for "_i" from 1 to 4 do { _unit addItem "ACE_epinephrine" };
for "_i" from 1 to 3 do { _unit addItem "ACE_tourniquet"};
for "_i" from 1 to 3 do { _unit addItem "ACE_bloodIV_500" };
for "_i" from 1 to 2 do { _unit addItem "ACE_splint" };

private _bisMedic = _unit getUnitTrait "Medic";
private _aceMedic = [_unit,1] call ace_medical_treatment_fnc_isMedic;
private _aceDoctor = [_unit,2] call ace_medical_treatment_fnc_isMedic;
if ( _bisMedic == true || _aceMedic == true || _aceDoctor == true ) then {
	_unit addItem "adv_aceCPR_AED";
	//_unit addItem "ACE_personalAidKit";
	_unit addItem "ACE_surgicalKit";
};

//misc
for "_i" from 1 to 2 do { _unit addItem "ACE_CableTie" };
//_unit addItem "ACE_Earplugs";
//_unit addItem "ACE_EntrenchingTool";

//grenades
if (_addGrenades) then {
	for "_i" from 1 to 2 do { _unit addMagazine "MiniGrenade" }; //HandGrenade is m67 vanilla, v40 is MiniGrenade
	for "_i" from 1 to 2 do { _unit addMagazine "SmokeShell" }; //white smoke
	//for "_i" from 1 to 1 do { _unit addItem "SmokeShellPurple" }; //purple smoke
	for "_i" from 1 to 2 do { _unit addMagazine "Chemlight_yellow" };
};

if (_changeSkill) then {
	if !(isPlayer _unit) then {
		{
			_unit setSkill [_x select 0, _x select 1];
		} forEach TAS_scavSkill;
	};
};

//at end due to waitUntil
//TODO option to give radio to AI scavs for lambs intel?
if (_giveRadio) then {
	if (isPlayer _unit) then {
		_unit linkItem "TFAR_anprc152";
		waitUntil {(call TFAR_fnc_haveSWRadio)};
		[(call TFAR_fnc_activeSwRadio), 1, TAS_scavRadioFreq] call TFAR_fnc_SetChannelFrequency;
	};
};