params [["_pos",[0,0,0]],["_unit",objNull],["_intensity",3],["_radius",0],["_doScale",false]];

private _debug = false;

private _units = _pos nearEntities ["Man", _radius];
_units pushBack _unit; //add the targetted unit just in case its missed due to 0 radius
private ["_specificIntensity"];
if (_debug) then {[format ["Units: %1",_units]] call TAS_fnc_error};
{
	if (_doScale) then {
		private _distance = _x distance _pos;
		if (_distance < 0.1) then {
			_distance = 0.1;
		};
		private _factor = _radius - _distance; //if radius is 30 and unit is 15 from center, then scale by 0.5
		_factor = _factor / _radius;
		_specificIntensity = _factor * _intensity;
		if (_debug) then {[format ["Unit: %1, Distance: %2, Factor: %3, Intensity: %4",_x,_distance,_factor,_specificIntensity]] call TAS_fnc_error};
	} else {
		_specificIntensity = _intensity;
	};
	_specificIntensity = (floor _intensity) + 1;
	if (_debug) then {[format ["Unit: %1, Intensity: %2",_x,_specificIntensity]] call TAS_fnc_error};
	["ace_fire_burn", [_x, _specificIntensity]] call CBA_fnc_globalEvent;
} forEach _units;