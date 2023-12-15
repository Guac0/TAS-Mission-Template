/*	KiloSwiss	*/
/*  https://steamcommunity.com/sharedfiles/filedetails/?id=2056899653  */

params
[
	["_mode",		true,	[true,""]	],
	["_playSoundFX",	true,	[true]		],
	["_showNotification",	true,	[true]		],
	["_setUIEventHandler",	false,	[true]		]
	// The last option is not recommended as this UIEventHandler can't be stacked!
	// It might overwrite another script or mod that uses it or will be overwritten by them.
	// Use with caution and only if you know what you do and are 100% sure it won't break anything.
];

private _return = false;

if ( _mode isEqualType true ) then { _mode = str _mode };

switch ( toLower _mode ) do
{
	default { _return = ["init"] call KS_fnc_ceaseFire; };
	
	case "init";
	case "initialize":
	{
		//-- Change the sounds and messages here:
		CeaseFireSoundFXDisable		= "FD_CP_not_clear_F";		// "FD_CP_not_clear_F" "FD_Course_active_F" "Simulation_Fatal"
		CeaseFireSoundFXEnable		= "FD_CP_clear_F";		// "FD_CP_clear_F" "Simulation_Restart" "Hint3"
		CeaseFireNotificationDisable	= "[ Weapons Disabled ]";
		CeaseFireNotificationEnable	= "[ Weapons Enabled ]";
		//-- DO NOT EDIT BELOW THIS LINE! DO NOT EDIT BELOW THIS LINE! DO NOT EDIT BELOW THIS LINE!
		CeaseFireThrowMuzzles = getArray (configFile >> "CfgWeapons" >> "Throw" >> "muzzles");
		CeaseFireEHID_onFiredMan = -1;
		CeaseFireMEHID_blockMuzzle = -1;
		CeaseFireUIEventHandlerSet = false;
		CeaseFireInitDone = true;
		_return = true;
	};
	//-- Disable weapons
	case "true";
	case "lock";
	case "block";
	case "ceasefire";
	case "lockweapon";
	case "lockweapons";
	case "blockfiring";
	case "blockweapon";
	case "blockweapons":
	{
		if ( isNil "CeaseFireInitDone" ) then
		{
			["init"] call KS_fnc_ceaseFire;
		};
		
		CeaseFireEHID_onFiredMan = player addEventHandler ["FiredMan",
		{
			_this call KS_fnc_ceaseFireEH_onFiredMan;
		}];
		
		CeaseFireMEHID_blockMuzzle = addMissionEventHandler ["EachFrame",
		{
			[] call KS_fnc_ceaseFireEH_blockMuzzles;
		}];
		
		_return = ( CeaseFireEHID_onFiredMan > -1 && { CeaseFireMEHID_blockMuzzle > -1 } );
		
		if ( _playSoundFX ) then { playSound CeaseFireSoundFXDisable };
		
		if ( _showNotification ) then { systemChat CeaseFireNotificationDisable };
		
		if ( _setUIEventHandler ) then
		{
			inGameUISetEventHandler ["Action", "toUpper(_this#3) in ['USEMAGAZINE','MANUALFIRE']"];
			CeaseFireUIEventHandlerSet = true;
		};
	};
	//-- Enable weapons
	case "false";
	case "allow";
	case "unlock";
	case "unblock";
	case "allowfire";
	case "allowfiring";
	case "weaponsfree";
	case "alloweapons";
	case "allowweapons":
	{		
		if ( !isNil "CeaseFireEHID_onFiredMan" && { CeaseFireEHID_onFiredMan > -1 } ) then
		{
			player removeEventHandler ["FiredMan", CeaseFireEHID_onFiredMan];
			CeaseFireEHID_onFiredMan = -1;
		};
		
		if ( !isNil "CeaseFireMEHID_blockMuzzle" && { CeaseFireMEHID_blockMuzzle > -1 } ) then
		{
			removeMissionEventHandler ["EachFrame", CeaseFireMEHID_blockMuzzle];
			CeaseFireMEHID_blockMuzzle = -1;
		};
		
		_return = ( CeaseFireEHID_onFiredMan isEqualTo -1 && { CeaseFireMEHID_blockMuzzle isEqualTo -1 } );
		
		private _vehicle = cameraOn;
		if ( _vehicle getVariable ["CeaseFireVehWasManualFire", false] ) then
		{
			player action ["ManualFire", _vehicle];
			_vehicle setVariable ["CeaseFireVehWasManualFire", false];
		};
		
		if ( _playSoundFX ) then { playSound CeaseFireSoundFXEnable };
		
		if ( _showNotification ) then { systemChat CeaseFireNotificationEnable };
		
		if ( _setUIEventHandler || CeaseFireUIEventHandlerSet ) then { inGameUISetEventHandler ["Action", ""] };
	};
};

_return