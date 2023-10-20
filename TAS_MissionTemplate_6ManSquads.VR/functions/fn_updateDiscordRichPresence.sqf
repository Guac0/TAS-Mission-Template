private _delay = _this;

// Get mission version and readable world name for Discord rich presence. Only need to do once.
[ 
	["UpdateLargeImageText", format ["Playing %1 on %2",missionName,getText (configfile >> "CfgWorlds" >> worldName >> "description")]]
] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

while {true} do {
	
	//location setup
	private _location = format [" near %1", text (nearestLocation [player, ""])];
	if (_location == " near ") then {
		_location = ""
	};
	
	//details
	private _details = format ["On foot%1",_location];
	private _vehicle = vehicle player;
	if (vehicle player != player) then {
		private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _vehicle >> "displayName");

		switch (true) do {
			case (_vehicle isKindOf "StaticWeapon"): {
				_details = format ["Crewing a %1%2", _vehicleName,_location];
			};
			case (_vehicle isKindOf "Air"): {
				private _isDriver = if ((driver (vehicle player)) isEqualTo player) then {true} else {false};
				private _isGunner = if ((gunner (vehicle player)) isEqualTo player) then {true} else {false};
				private _isCommander = if ((commander (vehicle player)) isEqualTo player) then {true} else {false};

				switch (true) do {
					case (_isDriver): {
						_details = format ["Piloting a %1%2", _vehicleName,_location];
					};
					case (_isGunner): {
						_details = format ["Operating a %1's turret%2", _vehicleName,_location];
					};
					case (_isCommander): {
						_details = format ["Commanding a %1%2", _vehicleName,_location];
					};
					default {
						_details = format ["Riding in a %1%2", _vehicleName,_location];
					};
				};
			};
			default {
				private _isDriver = if ((driver (vehicle player)) isEqualTo player) then {true} else {false};
				private _isGunner = if ((gunner (vehicle player)) isEqualTo player) then {true} else {false};
				private _isCommander = if ((commander (vehicle player)) isEqualTo player) then {true} else {false};

				switch (true) do {
					case (_isDriver): {
						_details = format ["Driving a %1%2", _vehicleName,_location];
					};
					case (_isGunner): {
						_details = format ["Operating a %1's turret%2", _vehicleName,_location];
					};
					case (_isCommander): {
						_details = format ["Commanding a %1%2", _vehicleName,_location];
					};
					default {
						_details = format ["Riding in a %1%2", _vehicleName,_location];
					};
				};
			};
		};
	};
	
	//state, REQUIRES XIM to show combat state
	private _state = format ["Chilling out%1",_location];
	{
		if (_x getVariable ["XIM_bRecentCombat", false]) exitWith // if one of the units is the combat leader
		{
			_state = format ["In combat%1",_location];
			
			private _enemySides = [side player] call BIS_fnc_enemySides;
			private _radius = 500;
			private _nearEntities = player nearEntities _radius;
			{
				if (side _x in _enemySides) exitWith {
					private _faction = faction _x;
					private _factionName = getText (configfile >> "cfgFactionClasses" >> _faction >> "displayName");
					_state = format ["Engaged with %1 near %2", _factionName, _location];
				};
			} forEach _nearEntities;

		};
	} forEach (units (group player));

	//small image and text
	private _roleDescription = roleDescription player;
	if ((_roleDescription find "@") != -1) then { //-1 indicates no @ sign. If unit has @ sign, parse it and only count text before it (remove group info)
		private _roleDescriptionArray = _roleDescription splitString "@"; //splits string into array with values separated by @ sign, so "AAA@BBB" becomes "[AAA,BBB]"
		_roleDescription = _roleDescriptionArray select 0;
	};
	private _smallImageText = format ["%1 in %2",_roleDescription,groupId (group player)];
	private _smallImage = "select";
	if (leader player == player) then {
		_smallImage = "leader";
		_smallImageText = format ["%1 leading %2",_roleDescription,groupId (group player)];
	};
	if (player getVariable ["ACE_isUnconscious", false]) then {
		_smallImage = "wounded";
		_state = format ["Bleeding out%1",_location];
	};

	//party
	private _sizeCurrent 	= (playersNumber west) + (playersNumber independent) + (playersNumber east) + (playersNumber civilian);
	private _sizeMax		= (playableSlotsNumber west) + (playableSlotsNumber independent) + (playableSlotsNumber east) + (playableSlotsNumber civilian);

	//update
	[
		["UpdateDetails",_details],
		["UpdateState",_state],
		["UpdateSmallImageKey",_smallImage],
		["UpdateSmallImageText",_smallImageText],
		["UpdatePartySize",_sizeCurrent],
    	["UpdatePartyMax",_sizeMax]
	] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

	sleep _delay;
};

/*

[
	["UpdateSmallImageKey","wounded"]
] call (missionNamespace getVariable ["DiscordRichPresence_fnc_update", {}]);

[
    // ["task",value]
    ["UpdateDetails","New Details"],
    ["UpdateState","New State"],
    ["UpdateLargeImageKey","New Art Asset"],
    ["UpdateSmallImageKey","New Art Asset"],
    ["UpdatePartySize",count playableUnits],
    ["UpdatePartyMax",getNumber(missionConfigFile >> "Header" >> "maxPlayers")],
    ["UpdateStartTimestamp",[-1,-30]], // 1 Hour 30 Mins since mission start
    ["UpdateEndTimestamp",[1,30]], // 1 Hour 30 Mins until mission end
    ["UpdateButtons",["Arma 3","https://arma3.com"]]
] call (missionNameSpace getVariable ["DiscordRichPresence_fnc_update",{}]);
*/