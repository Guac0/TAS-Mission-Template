//Note: Code structure from Crowdedlight's setNumberplate as ZEN does a horrible job at explaining. Thanks Crow, I think I know it now!

params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_isPara",
		"_paradropHeight",
		"_addMedical",
		"_addBasicAmmo",
		"_addAdvancedAmmo",
		"_addGrenades",
		"_boxClass"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	[_pos,_isPara,_addMedical,_addBasicAmmo,_addAdvancedAmmo,_addGrenades,_boxClass,_paradropHeight] call TAS_fnc_ammoCrate;
};

[
	"Set Resupply Crate Options [Hover over question for more info]", 
	[
		["TOOLBOX:YESNO", ["Paradrop crate?", "Paradrops the crate in at the specified height with smoke attached. Leave HEIGHT blank for default height of 250m."], false],
		["EDIT","Height to paradrop crate at?"],
		["TOOLBOX:YESNO", ["Add medical?", "Adds various medical items to the box."], true],
		["TOOLBOX:YESNO", ["Add ammo [basic]?", "SET ADVANCED TO FALSE IF USING. Adds 6 magazines for each player's primary weapon, based on currently equiped magazine OR (if player has no magazines loaded) CBA's best guess at a compatible magazine."], false],
		["TOOLBOX:YESNO", ["Add ammo [advanced]?", "SET BASIC TO FALSE IF USING. Adds 6 magazines for each player's primary weapon and 2 mags/rounds each for each player's secondary and handgun weapons. Ammo is based on currently equiped magazine OR (if player has no magazines loaded) CBA's best guess at a compatible magazine."], true],
		["TOOLBOX:YESNO", ["Add hand grenades?", "Adds two m67s and two white smoke grenades for each player."], true],
		["EDIT","Crate classname, blank for default."] //all defaults, no sanitizing function as we shouldn't need it
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;