params [["_position",getPos player],["_radius",15],["_delete",true],["_playerVar",format ["TAS_lodgingObject%1",name player]],["_debug",true]];

private _objectData = [];
private _nearObjects = _position nearObjects _radius;

if (_debug) then { [format ["TAS_fnc_lodgingGetNearbyItems: Grabbing items near %1 with radius of %2 and player variable of %3!",_position,_radius,_playerVar]] call TAS_fnc_error; };
if (_debug) then { [format ["TAS_fnc_lodgingGetNearbyItems: Near objects: %1",_nearObjects]] call TAS_fnc_error; };

/*
String - arrays are in format [classname, relPos, azimuth, fuel, damage, pitchBankResult, vehicleVarName, initCommands, simulationEnabled, isASL]:
classname: String
relPos: Array
azimuth: Number
fuel: Number
damage: Number
pitchBankResult: Array - return from BIS_fnc_getPitchBank (only if objectOrientation is true)
vehicleVarName: String
initCommands: String
simulationEnabled: Boolean
isASL: Boolean
*/

{
	if (_debug) then { [format ["TAS_fnc_lodgingGetNearbyItems: Does item %1 belong to player: %2",_x, _x getVariable [_playerVar,false]]] call TAS_fnc_error; };

	if (_x getVariable [_playerVar,false]) then {
		_objectData pushBack [typeOf _x, player getRelPos _x,getDir _x,0,0, _x call BIS_fnc_getPitchBank,vehicleVarName _x,"",true,false];
		
		if (_debug) then { [format ["TAS_fnc_lodgingGetNearbyItems: Adding item to _objectData!"]] call TAS_fnc_error; };

		if (_delete) then {
			deleteVehicle _x;
		};
	};
} forEach _nearObjects;

//save to player variable
profileNamespace setVariable ["TAS_lodging",_objectdata];

if (_debug) then { [format ["TAS_fnc_lodgingGetNearbyItems: Finishing with total _objectData of %1",_objectdata]] call TAS_fnc_error; };

_objectData