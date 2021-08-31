private ["_veh","_vehType"];
_veh = _this select 0;
_vehType = getText(configFile>>"CfgVehicles">>typeOf _veh>>"DisplayName");


if ((_veh isKindOf "helicopter") && (driver _veh == player)) exitWith { 

	_veh sidechat format ["Servicing %1.", _vehType];
	_veh setFuel 0;
	sleep 3;
	
	_veh setVehicleAmmo 1;	
	_veh sidechat format ["%1 Rearmed.", _vehType];
	sleep 3;
	
	_veh setDamage 0;	
	_veh sidechat format ["%1 Repaired.", _vehType];	
	sleep 3;
	
	_veh setFuel 1;
	_veh sidechat format ["%1 Refueled.", _vehType];
	sleep 2;
	

	_veh sidechat format ["Service Complete", _vehType];

};
