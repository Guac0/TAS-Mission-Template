//this is basically useless but it makes user-interface more friendly so zeuses dont need to copy paste of all this
//[object,"Flagpole 1"] remoteExec ["TAS_fnc_assignRespawnFlagpoleInit",2];
params ["_object","_name"];
if !(isServer) exitWith {systemChat "TAS-MISSION-TEMPLATE ERROR: fn_assignRespawnFlagpoleInit called on client instead of on server! Contact Admin!"};

if (isNil "TAS_respawnLocations") then { //mightve already been set up elsewhere
	TAS_respawnLocations = [];
	publicVariable "TAS_respawnLocations";
};
if !(TAS_flagpoleRespawn) then {
	TAS_flagpoleRespawn = true;
	publicVariable "TAS_flagpoleRespawn";
};

if (vehicleVarName _object == "") then { //if vic doesn't have a var name, then give it one
	_object setVehicleVarName format ["TAS_zeusRespawnFlagpole%1",count TAS_respawnLocations]; //TODO make better
	//systemChat format ["3: %1",_object];
};
private _objectName = vehicleVarName _object;
//systemChat format ["4: %1",_objectName];
missionNamespace setVariable [_objectName, _object];
publicVariable _objectName;

TAS_respawnLocations pushBack [_object,_name];