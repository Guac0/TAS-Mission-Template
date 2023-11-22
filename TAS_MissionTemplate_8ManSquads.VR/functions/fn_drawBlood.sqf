//from https://gist.github.com/Drofseh/4b650d0c06f8034f2c8f69cedf5eb8f6, credit to Drofseh
//script has been adapted to not need to be executed from unit init
//must be executed locally on each client and JIPed
	// if (isServer) then { this remoteExec ["TAS_fnc_drawBlood",0,true]; };
//todo: does this persist after respawn?

private _unit = _this;

private _statementDrawBlood = {
    private _unit = _this select 0;
    //systemChat format ["1: %1, %2",_unit, count _this]; //undefined
    //diag_log format ["1: %1",_unit];
    if (!alive _unit) exitWith { //TODO doesnt work
        [
            ["You are attempting to draw blood from a dead body whose blood has cooled to the point of uselessness."],
            true
        ] call CBA_fnc_notify;
    };
    
    if (!([ace_player, "ACE_bloodIV_250", 1, true, true, true] call CBA_fnc_canAddItem)) exitWith {
        [
            ["You don't have any room to carry a bag of blood."],
            true
        ] call CBA_fnc_notify;
    };

    [
        4, //Time it takes to complete the action
        [_unit],
        {
            //_this = [[_param],position1,position2,position3]
            //systemChat format ["3: %1",_this];
            private _target = _this select 0 select 0;
            //systemChat format ["3: %1",_target];

            //Reduce the blood volume of the target by 0.25 L
            _target setVariable ["ace_medical_bloodVolume", ((_target getVariable ["ace_medical_bloodVolume", 6]) - 0.25)], true;

            //Attempt to add a 250 ml blood bag to the player, warn if it will be placed on the ground instead.
            if (!([ace_player, "ACE_bloodIV_250", 1, true, true, true] call CBA_fnc_canAddItem)) then {
                [
                    ["You don't have any room to carry a bag of blood so you've dropped it on the ground."],
                    true
                ] call CBA_fnc_notify;
            } else {
                [
                    ["You've withdrawn 250mL of blood from the patient and stored it inside a blood bag."],
                    true
                ] call CBA_fnc_notify;
            };
            [ace_player, "ACE_bloodIV_250", true] call CBA_fnc_addItem;
        },
        {
            [
                ["You didn't spend enough time drawing blood to get a complete sample."],
                true
            ] call CBA_fnc_notify;
        },
        "Drawing blood.",
        nil,
        ["isNotInside", "isNotSitting"]
    ] call ace_common_fnc_progressBar;
};

private _actionDrawBlood = ["Draw Blood", "Draw Blood", "\z\ace\addons\medical_gui\ui\iv.paa", _statementDrawBlood, {true}] call ace_interact_menu_fnc_createAction;

{
    [_unit, 0, [_x], _actionDrawBlood] call ace_interact_menu_fnc_addActionToObject;
    [_unit, 0, ["ACE_MainActions", "ACE_Medical_Radial",_x], _actionDrawBlood] call ace_interact_menu_fnc_addActionToObject;
} forEach ["ACE_ArmLeft", "ACE_ArmRight"];