private ["_veh","_vehType"];
_veh = _this select 0;
_vehType = getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName");

//note that trigger already checks for driver, this is just a backup
//TODO make chat appear for all players in vic for MP
if (driver _veh == player) exitWith { 

	private _message = format ["Servicing %1.", _vehType];
	{
		if (isPlayer _x) then { [_veh,_message] remoteExec ["vehicleChat",_x]; };
	} forEach crew _veh;
	_veh setFuel 0;
	sleep 3;
	
	_veh setVehicleAmmo 1;
	_message = format ["%1 Rearmed.", _vehType];
	{
		if (isPlayer _x) then { [_veh,_message] remoteExec ["vehicleChat",_x]; };
	} forEach crew _veh;
	sleep 3;
	
	_veh setDamage 0;	
	_message = format ["%1 Repaired", _vehType];
	{
		if (isPlayer _x) then { [_veh,_message] remoteExec ["vehicleChat",_x]; };
	} forEach crew _veh;
	sleep 3;
	
	_veh setFuel 1;
	_message = format ["%1 Refueled.", _vehType];
	{
		if (isPlayer _x) then { [_veh,_message] remoteExec ["vehicleChat",_x]; };
	} forEach crew _veh;
	sleep 2;

	_message = format ["Service Complete.", _vehType];
	{
		if (isPlayer _x) then { [_veh,_message] remoteExec ["vehicleChat",_x]; };
	} forEach crew _veh;

};
