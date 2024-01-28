// Loops through player's inventory, compares everything to 
// Ideally, execute locally on player
// [shopCrate] call TAS_fnc_vassGetLoadoutCost
// [shop,player,true] call TAS_fnc_vassGetLoadoutCost
// Return value: Integer (cost of loadout)

// Example input loadout data:
/*
[
    ["rhs_weap_ak74m_gp25","rhs_acc_dtk1983","","rhs_acc_1p78",["rhs_30Rnd_545x39_7N6M_AK",30],
    ["rhs_GRD40_Red",1],""],
    ["rhs_weap_M136","","","",[],[],""],
    ["WBK_axe","","","",[],[],""],
    ["UK3CB_CW_SOV_O_Late_U_OFFICER_Uniform_02_KHK",[["ACE_IR_Strobe_Item",1],["tsp_lockpick",1],["ACE_CableTie",1]]],
    ["rhs_6b13_Flora_6sh92_headset_mapcase",[["rhs_30Rnd_545x39_7N10_2mag_camo_AK",5,30],["rhs_30Rnd_545x39_7N22_camo_AK",4,30]]]
    ,[],"","SCU_TacG_Yellow_Clear",["Laserdesignator_03","","","",["Laserbatteries",1],[],""],["","","","","",""]]

Another one:
    [[],[],[],
    ["UK3CB_CW_SOV_O_Late_U_OFFICER_Uniform_02_KHK",[["ACE_IR_Strobe_Item",1],["tsp_lockpick",1],["ACE_CableTie",1]]],
    ["V_Plain_medical_F",[["DSA_Antidote",6]]],
    ["FT_Titan_Backpack",[[["rhs_weap_ak74m_gp25","rhs_acc_dtk1983","","rhs_acc_1p78_3d",["rhs_30Rnd_545x39_7N6M_AK",30],["rhs_GRD40_Red",1],""],1],[["rhs_weap_M136","","","",[],[],""],1],[["WBK_axe","","","",[],[],""],1]]],"","SCU_TacG_Yellow_Clear",["Laserdesignator_03","","","",["Laserbatteries",1],[],""],["","","","","",""]]
*/

params ["_shop",["_unit",player],["_debug",false]]; //TODO change to false when done testing

private _loadout = getUnitLoadout _unit;
private _cost = 0;

if (typeName _shop == "STRING") then {
    _shop = missionNamespace getVariable [_shop, objNull]; //convert from string to object, otherwise we get errors
};

[format ["TAS_fnc_vassGetLoadoutCostRecursive: Checking loadout of %1",_loadout]] call TAS_fnc_error;

{
    private _loadoutContainer = _x;
    if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Checking loadout section of index %1 with value %2",_forEachIndex,_loadoutContainer]] call TAS_fnc_error; };

    private _returnedCost = [_loadoutContainer,_shop] call TAS_fnc_vassGetLoadoutCostRecursive;
    _cost = _cost + _returnedCost;

    if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Loadout section costed %1 for a total cost of %2",_returnedCost,_cost]] call TAS_fnc_error; };
} foreach _loadout;

[format ["TAS_fnc_vassGetLoadoutCostRecursive: Total loadout cost: %1",_cost]] call TAS_fnc_error;

//_unit setVariable ["TAS_playerRebuyCost",_rebuyCost]; //TODO save under player object or profileNamespace?

_cost