
sleep 1; //wait for mission start (server init first)

//adds two resupply options to ZEN under the "Resupply" catagory
//each spawns a large crate with medical and 6 mags for each player's weapon
//to customize contents of resupply, edit the files in Scripts\ammocrate.sqf and ammocratepara.sqf
//REQUIRES ZEN TO BE LOADED (on all clients! although maybe just the zeus if you adjusted the code [i.e. not init.sqf] https://zen-mod.github.io/ZEN/#/frameworks/custom_modules)
if (TAS_zeusResupply) then {
	["Resupply", "Spawn Resupply Crate", {[_this select 0]execVM "Scripts\AmmoCrate.sqf"}] call zen_custom_modules_fnc_register;
	["Resupply", "Paradrop Resupply Crate", {[_this select 0]execVM "Scripts\AmmoCratePara.sqf"}] call zen_custom_modules_fnc_register;
	systemChat "Custom Zeus resupply modules enabled.";
} else {
	systemChat "Custom Zeus resupply modules disabled.";
};