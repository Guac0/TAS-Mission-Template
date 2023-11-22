params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];

//can target area too
if (isNull _unit) then {
	systemChat "Module was not placed on a unit, will use the module's position as the centerpoint for a radius burn instead!"
	//systemChat "Error: place the fire zeus module on the unit you wish to set on fire!!";
	//diag_log "TAS MISSION TEMPLATE: fn_zeusSetUnitOnFire was executed without being placed on an object!";
};

//ZEN dialog
private _onConfirm =
{
	params ["_dialogResult","_in"];
	_dialogResult params
	[
		"_intensity",
		"_radius",
		"_doScale"
	];
	//Get in params again
	_in params [["_pos",[0,0,0],[[]],3], ["_unit",objNull,[objNull]]];
	
	[_pos,_unit,_intensity,_radius,_doScale] call TAS_fnc_burnUnitOrArea;
};

[
	"Set Unit on Fire (Ace Medical Compat)", 
	[
		["SLIDER", ["Intensity", "1 is 1 roll, 3 is 5 rolls, 5 is 15 rolls, 8+ cant be put out before death"], [1,10,5,0]],	//min 1 intensity, max 10 intensity, default 5 intensity, 0 decimal places
		["SLIDER", ["Radius", "If you want to set multiple people on fire, here you go"], [0,100,0,0]],
		["TOOLBOX:YESNO", ["Scale fire intensity with radius?", "Players further away will have a smaller burn effect"], false]
	],
	_onConfirm,
	{},
	_this
] call zen_dialog_fnc_create;