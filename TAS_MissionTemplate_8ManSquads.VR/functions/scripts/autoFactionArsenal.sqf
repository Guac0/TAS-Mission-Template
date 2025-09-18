/*
	Author: Guac

	Requirements: CBA
	
	Automatically generates Ace Arsenals from all items found in unit inventories of the given factions, plus some extra gear (radios, medical, facewear, etc)
	Get classname of the faction you want by placing a unit from that faction (or one unit from each faction if doing multiple factions), right clicking it, go to LOG tab in the right click menu that opens, select "log faction names to clipboard", and then insert the given classname(s) into the array in the code example snippet
	You will receive various debug messages in chat while the script is running. At script completion, it will copy the arsenal data in an import-ready format to your clipboard, and will open an example arsenal with the given items.

	Examples (run in your standard method of code execution while ingame [not in editor], such as the debug console or "code execution" Zeus module):
	//Grabs gear from the vanilla civilian faction
		["CIV_F"] execVM "functions\scripts\autoFactionArsenal.sqf";
	//Grabs gear from the 5 main vanilla factions — NATO, AAF, FIA (indfor variant), CSAT, and Civilians
		["BLU_F","IND_F","IND_G_F","OPF_F","CIV_F"] execVM "functions\scripts\autoFactionArsenal.sqf";

*/

//get the array of factions
private _factionList = _this;
systemChat format ["Factions to grab data from: %1",_factionList];

//setup our array of stuff to export
private _allExportItems = [];

//do the whole equipment grabbing for each given faction
{
	//get faction classname from passed argument
	private _faction = _x;

	systemChat format ["Now processing loadout data from %1", _faction];

	//get the list of classnames of all the units of given faction
	//single quotes are becuase of outside large quotes
	private _MyUnitArray = ("(configname _x iskindOf 'CAManBase') && (getNumber (_x >> 'scope') >= 2) && (gettext (_x >> 'faction') == _faction)" configClasses (configfile >> "CfgVehicles")) apply {configName _x};
	_MyUnitArray = _MyUnitArray arrayIntersect _MyUnitArray; //remove duplicated items

	//spawn a fake group for createUnit. east works, civ doesnt
	private _group = createGroup [east, true];

	//spawn all the units at origin and add them to our array to check later
	//double check that they all survive long enough to get copied
	private _allCreatedUnits = [];
	{
		private _createdUnit = _group createUnit [_x,[0,0,0],[],0,"CAN_COLLIDE"];
		_createdUnit disableAI "ALL";
		_createdUnit enableSimulationGlobal false;
		_createdUnit allowDamage false;
		_allCreatedUnits pushBackUnique _createdUnit;
	} forEach _myUnitArray;

	private _allFactionUnitsItems = [];
	{
		private _tempWeapons = weapons _x;
		{
			//if ( "(configname _x iskindOf 'CAManBase') && (getNumber (_x >> 'scope') >= 2) && (gettext (_x >> 'faction') == _faction)" configClasses (configfile >> "CfgVehicles") ) then {
			//	LinkedItems
			//	inheritsFrom _x;
			//};
			private _mags = [_x,true] call CBA_fnc_compatibleMagazines;
			_allFactionUnitsItems = _allFactionUnitsItems + _mags; 
		} forEach _tempWeapons;
		_allFactionUnitsItems = _allFactionUnitsItems + [(headgear _x)] + [(goggles _x)] + (assignedItems _x) + (backpackitems _x)+ [(backpack _x)] + (uniformItems _x) + [(uniform _x)] + (vestItems _x) + [(vest _x)] + (magazines _x) + (weapons _x) + (primaryWeaponItems _x)+ (primaryWeaponMagazine _x) + (handgunMagazine _x) + (handgunItems _x) + (secondaryWeaponItems _x) + (secondaryWeaponMagazine _x)
	} forEach _allCreatedUnits;
	//_allFactionUnitsItems = _allFactionUnitsItems select {count _x > 0}; //remove any empty indexes. Might be unneccessary? */
	_allFactionUnitsItems = _allFactionUnitsItems arrayIntersect _allFactionUnitsItems; //remove duplicated items

	//add the given faction's gear to the export list
	_allExportItems = _allExportItems + _allFactionUnitsItems;
	_allExportItems = _allExportItems arrayIntersect _allExportItems; //remove duplicated items

	//clean up after ourselves
	{ deleteVehicle _x } forEach _allCreatedUnits;
} forEach _factionList;

//misc inventory items like bandages. By default, only has whatever's in the misc category with ACE + vanilla loaded
//private _allInventoryItems = [];
//_allInventoryItems = "configname _x iskindOf 'InventoryItem_Base_F'" configClasses (configfile >> "CfgWeapons") apply {configName _x};
private _allMiscItems = ["ACE_RangeTable_82mm","ACE_adenosine","ACE_artilleryTable","ACE_ATragMX","ACE_Banana","ACE_fieldDressing","ACE_packingBandage","ACE_quikclot","ACE_bloodIV","ACE_bloodIV_250","ACE_bloodIV_500","ACE_bodyBag","ACE_CableTie","ACE_Can_Franta","ACE_Can_RedGull","ACE_Can_Spirit","ACE_Canteen","ACE_Canteen_Empty","ACE_Canteen_Half","ACE_Chemlight_Shield","ACE_DAGR","ACE_DeadManSwitch","ACE_DefusalKit","ACE_EntrenchingTool","ACE_epinephrine","FirstAidKit","ACE_Fortify","ACE_Humanitarian_Ration","ACE_HuntIR_monitor","ACE_IR_Strobe_Item","ACE_Kestrel4500","ACE_Flashlight_KSF1","ACE_M26_Clacker","ACE_Clacker","ACE_Flashlight_XL50","ACE_MapTools","Medikit","ACE_microDAGR","MineDetector","ACE_morphine","ACE_MRE_ChickenTikkaMasala","ACE_MRE_ChickenHerbDumplings","ACE_MRE_CreamChickenSoup","ACE_MRE_CreamTomatoSoup","ACE_MRE_LambCurry","ACE_MRE_MeatballsPasta","ACE_MRE_SteakVegetables","ACE_personalAidKit","ACE_plasmaIV","ACE_plasmaIV_500","ACE_RangeCard","ACE_rope12","ACE_rope15","ACE_rope27","ACE_rope3","ACE_rope36","ACE_rope6","ACE_salineIV","ACE_salineIV_250","ACE_salineIV_500","ACE_Sandbag_empty","ACE_SpareBarrel_Item","ACE_splint","ACE_SpottingScope","ACE_SpraypaintBlack","ACE_SpraypaintBlue","ACE_SpraypaintRed","ACE_Tripod","ACE_surgicalKit","ToolKit","ACE_UAVBattery","ACE_WaterBottle","ACE_WaterBottle_Empty","ACE_WaterBottle_Half","ACE_wirecutter","ACE_tourniquet","ACE_SpraypaintGreen","ACE_rope18","ACE_plasmaIV_250","ACE_MRE_BeefStew","ACE_Flashlight_MX991","ACE_EarPlugs","ACE_Cellphone","ACE_elasticBandage"];

//personal and backpack radios. Only the ones in default tfar beta.
private _allRadios = ["TFAR_anprc148jem","TFAR_anprc152","TFAR_anprc154","TFAR_fadak","TFAR_pnr1000a","ItemRadio","TFAR_rf7800str","TFAR_anarc164","TFAR_anarc210","TFAR_anprc155","TFAR_anprc155_coyote","TFAR_bussole","TFAR_mr3000","TFAR_mr3000_bwmod_tropen","TFAR_mr3000_multicam","TFAR_mr3000_rhs","TFAR_mr6000l","TFAR_mr3000_bwmod","B_RadioBag_01_black_F","B_RadioBag_01_digi_F","B_RadioBag_01_eaf_F","B_RadioBag_01_ghex_F","B_RadioBag_01_hex_F","B_RadioBag_01_tropic_F","B_RadioBag_01_oucamo_F","B_RadioBag_01_wdl_F","B_RadioBag_01_mtp_F","TFAR_rt1523g","TFAR_rt1523g_big","TFAR_rt1523g_big_bwmod","TFAR_rt1523g_big_bwmod_tropen","TFAR_rt1523g_black","TFAR_rt1523g_fabric","TFAR_rt1523g_green","TFAR_rt1523g_rhs","TFAR_rt1523g_sage","TFAR_rt1523g_bwmod","TFAR_rt1523g_big_rhs"];

//all facewear. This needs to be adjusted for the current modpack. By default, has vanilla and ace items.
private _allFacewear = ["TFAR_anprc148jem","TFAR_anprc152","TFAR_anprc154","TFAR_fadak","TFAR_pnr1000a","ItemRadio","TFAR_rf7800str","G_AirPurifyingRespirator_02_olive_F","G_AirPurifyingRespirator_02_sand_F","G_AirPurifyingRespirator_01_F","G_Aviator","G_Balaclava_blk","G_Balaclava_combat","G_Balaclava_lowprofile","G_Balaclava_oli","G_Bandanna_aviator","G_Bandanna_beast","G_Bandanna_blk","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_shades","G_Bandanna_sport","G_Bandanna_tan","G_Blindfold_01_black_F","G_Blindfold_01_white_F","G_Combat","G_Combat_Goggles_tna_F","G_Diving","G_I_Diving","G_O_Diving","G_B_Diving","G_Lady_Blue","None","G_RegulatorMask_F","G_Respirator_blue_F","G_Respirator_white_F","G_Respirator_yellow_F","G_EyeProtectors_F","G_EyeProtectors_Earpiece_F","G_Shades_Black","G_Shades_Blue","G_Shades_Green","G_Shades_Red","G_Spectacles","G_Sport_Red","G_Sport_Blackyellow","G_Sport_BlackWhite","G_Sport_Checkered","G_Sport_Blackred","G_Sport_Greenblack","G_Squares_Tinted","G_Squares","G_Balaclava_TI_G_blk_F","G_Balaclava_TI_tna_F","G_Tactical_Clear","G_Tactical_Black","G_Spectacles_Tinted","G_Goggles_VR","G_WirelessEarpiece_F","G_Balaclava_TI_G_tna_F","G_Balaclava_TI_blk_F","G_Lowprofile","G_AirPurifyingRespirator_02_black_F"];

private _allItems = _allExportItems + _allMiscItems + _allRadios + _allFacewear;
_allItems = _allItems arrayIntersect _allItems; //remove common (duplicated) items

//export
private _box = "B_supplyCrate_F" createVehicle (getPos player);
[_box, _allItems] call ace_arsenal_fnc_initBox;
[_box, player] call ace_arsenal_fnc_openBox;
copyToClipboard str _allItems;
systemChat "All inventory items of given faction(s) copied to clipboard and example Ace arsenal opened!";

//Example : FIA
//["H_Bandanna_surfer_grn","ItemMap","ItemCompass","ItemWatch","ItemRadio","FirstAidKit","30Rnd_556x45_Stanag","Chemlight_blue","U_IG_Guerilla1_1","HandGrenade","MiniGrenade","SmokeShell","SmokeShellGreen","V_Chestrig_oli","arifle_TRG21_F","H_Booniehat_khk_hs","V_BandollierB_blk","arifle_TRG20_F","H_Cap_oli_hs","Binocular","U_IG_leader","30Rnd_556x45_Stanag_Tracer_Yellow","9Rnd_45ACP_Mag","SmokeShellRed","SmokeShellBlue","V_Chestrig_blk","arifle_TRG20_ACO_F","hgun_ACPC2_F","optic_ACO_grn","H_Cap_oli","1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_SmokeGreen_Grenade_shell","1Rnd_SmokeRed_Grenade_shell","1Rnd_SmokeBlue_Grenade_shell","V_TacVest_blk","arifle_Mk20_GL_ACO_F","H_Cap_blk","G_Shades_Green","U_IG_Guerilla2_1","200Rnd_65x39_cased_Box","LMG_Mk200_BI_F","bipod_03_F_blk","Medikit","G_FieldPack_Medic","U_IG_Guerilla2_3","arifle_Mk20_F","H_Cap_tan","ToolKit","MineDetector","SatchelCharge_Remote_Mag","DemoCharge_Remote_Mag","G_TacticalPack_Eng","ACE_Clacker","ACE_DefusalKit","U_IG_Guerilla2_2","H_Cap_grn","APERSBoundingMine_Range_Mag","SLAMDirectionalMine_Wire_Mag","G_Carryall_Exp","APERSMine_Range_Mag","arifle_Mk20C_ACO_F","H_Bandanna_khk","G_Sport_Checkered","arifle_TRG21_GL_F","U_IG_Guerilla3_1","V_BandollierB_khk","arifle_Mk20_MRCO_F","optic_MRCO","H_ShemagOpen_khk","RPG32_F","RPG32_HE_F","G_FieldPack_LAT","U_IG_Guerrilla_6_1","launch_RPG32_F","H_Bandanna_surfer_blk","G_Shades_Blue","20Rnd_762x51_Mag","G_Carryall_Ammo","H_Beret_blk","G_Sport_Blackyellow","ItemGPS","arifle_TRG21_MRCO_F","H_Bandanna_cbr","H_Bandanna_sand","H_Booniehat_oli","V_BandollierB_oli","srifle_DMR_06_camo_khs_F","optic_KHS_old","MRAWS_HEAT_F","MRAWS_HE_F","G_FieldPack_LAT2","launch_MRAWS_olive_rail_F"]