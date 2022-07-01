/*
	Author: Guac

	Description:
		Creates a marker, attaches it to an object, and updates its position every X seconds.

	Parameter(s):
		0: OBJECT - object to attach marker to
		1: STRING - type of marker to spawn
		2: STRING - color of marker to spawn
		3: STRING - displayed name of marker
		4: BOOL - whether to delete marker on dealth on attached object
		5: NUMBER - interval to update marker position in

	Returns:
		STRING - created marker

	Examples:
		[myObjectToFollow,"hd_flag","ColorUNKNOWN","My Awesome Marker Text That People Can See",true,30] call TAS_fnc_followMarker;
*/
//TODO add compatibility for declaring side and creator of markers, plus other options like alpha

//TODO replace with params
private _attachedObject 	= _this select 0;
private _markerType 		= _this select 1;
private _markerColor 		= _this select 2;
private _markerText 		= _this select 3;
private _deleteOnDeath 		= _this select 4;
private _interval			= _this select 5;

private _marker = createMarkerLocal [format ["%1%2",_markerText,random 100],getPos _attachedObject]; //give it a semi-random name to avoid having multiple markers with the same name
_marker setMarkerAlphaLocal 1;
_marker setMarkerTypeLocal _markerType;
_marker setMarkerColorLocal _markerColor;
_marker setMarkerTextLocal _markerText;
//it's made public by the first set pos in the spawn below

[_attachedObject,_deleteOnDeath,_interval,_marker] spawn {
	private _attachedObject 	= _this select 0;
	private _deleteOnDeath 		= _this select 1;
	private _interval 			= _this select 2;
	private _marker 			= _this select 3;
	while {alive _attachedObject} do {
		_marker setMarkerPos getPos _attachedObject;
		sleep _interval;
	};
	//runs when _attachedObject is dead or null
	if (_deleteOnDeath) then {
		deleteMarker _marker;
	};
};

_marker