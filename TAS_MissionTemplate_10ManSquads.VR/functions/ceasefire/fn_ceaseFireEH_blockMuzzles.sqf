/*	KiloSwiss	*/
/*  https://steamcommunity.com/sharedfiles/filedetails/?id=2056899653  */

( CeaseFireThrowMuzzles +[(weaponState player)#1] ) apply { player setWeaponReloadingTime [player, _x, 1] };

if ( !isNil "ace_advanced_throwing_fnc_exitThrowMode" ) then
{
	[player] call ace_advanced_throwing_fnc_exitThrowMode;
};

private _vehicle = cameraOn;
if !( _vehicle isEqualTo player ) then
{
	/*
	private _vehTurrets = [[-1]] + allTurrets _vehicle;
	{
		private _currentWeapon = _vehicle currentWeaponTurret _x;
		private _weaponMuzzle = (weaponState [_vehicle, _x, _currentWeapon])#1;
		_vehicle setWeaponReloadingTime [player, _weaponMuzzle, 1];
		_vehicle setWeaponReloadingTime [player, "SmokeLauncher", 1];
		_vehicle setWeaponReloadingTime [player, "CMFlareLauncher", 1];
	} forEach _vehTurrets;
	*/
	
	{
		private _turret = _x;
		{
			private _turretUnit = _vehicle turretUnit _turret;
			_turretUnit = [_turretUnit, player] select ( isNull _turretUnit);
			private _turretWeapons = getArray( configFile >> "cfgWeapons" >> _x >> "muzzles" ) +["SmokeLauncher", "CMFlareLauncher", _x] -["this"];
			{
				private _muzzle = _x;
				_vehicle setWeaponReloadingTime [_turretUnit, _muzzle, 1];
			
			} forEach _turretWeapons;
	
		} forEach ( _vehicle weaponsTurret _turret );
	
	} forEach [[-1]] + allTurrets _vehicle;
	
	if ( isManualFire _vehicle ) then
	{
		player action ["manualFireCancel", _vehicle];
		_vehicle setVariable ["CeaseFireVehWasManualFire", true];
	};
};