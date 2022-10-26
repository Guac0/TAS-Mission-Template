//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_isPara",
		"_paradropHeight",//doesn't work correctly
		"_addMedical",
		"_addBasicAmmo",
		"_addAdvancedAmmo",
		"_addGrenades",
		"_emptyBox",
		"_useAttachedCrate",
		"_boxClass"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	//systemChat str _boxClass;
	if !(isNull _unit) then {
		_boxClass = _unit;
	};
	[_pos,_isPara,_addMedical,_addBasicAmmo,_addAdvancedAmmo,_addGrenades,_emptyBox,_paradropHeight,_boxClass] call TAS_fnc_ammoCrate;
};

[
	"Set Resupply Crate Options [Hover over question for more info]", 
	[
		["TOOLBOX:YESNO", ["Paradrop crate?", "Paradrops the crate in at the specified height with smoke attached. Leave HEIGHT blank for default height of 250m."], false],
		["EDIT","[Broken, is 215m] Paradrop Height?"],
		["TOOLBOX:YESNO", ["Add medical?", "Adds various medical items to the box."], true],
		["TOOLBOX:YESNO", ["Add ammo [basic]?", "SET ADVANCED TO FALSE IF USING. Adds 6 magazines for each player's primary weapon, based on currently equiped magazine OR (if player has no magazines loaded) CBA's best guess at a compatible magazine."], false],
		["TOOLBOX:YESNO", ["Add ammo [advanced]?", "SET BASIC TO FALSE IF USING. Adds 6 magazines for each player's primary weapon and 2 mags/rounds each for each player's secondary and handgun weapons. Ammo is based on currently equiped magazine OR (if player has no magazines loaded) CBA's best guess at a compatible magazine."], true],
		["TOOLBOX:YESNO", ["Add hand grenades?", "Adds two m67s and two white smoke grenades for each player."], true],
		["TOOLBOX:YESNO", ["Empty crate?", "Remove exiting inventory of box before adding the resupply gear."], true],
		["TOOLBOX:YESNO", ["[broken] Use attached crate?", "If you placed the module on a crate, then it will use this crate instead of spawning a new one. If true, overrides the '[Custom] crate classname' option."], false],
		["EDIT",["[Custom] Crate classname","Leave blank for default. USE ATTACHED CRATE overrides this."],["B_CargoNet_01_ammo_F"]]

	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;