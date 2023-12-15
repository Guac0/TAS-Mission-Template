/*
	Author: Guac

	Description:
		Creates a marker, attaches it to an object, and updates its position every X seconds. Should only be executed on server.

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
		[myObjectToFollow,"hd_flag","ColorUNKNOWN","My Awesome Marker Text That People Can See",true,30] remoteExec ["TAS_fnc_markerFollow",2];
		[myObjectToFollow] remoteExec ["TAS_fnc_markerFollow",2];
*/
//TODO add compatibility for declaring side and creator of markers, plus other options like alpha

if !(isServer) exitWith {
	[[format ["TAS_fnc_markerFollow called on %1 when it should only be called on server! Arguments: %2",name player,_this],false]] call TAS_fnc_error;
};

//TODO replace with params
params [["_attachedObject",objNull],["_markerType","hd_flag"],["_markerColor","ColorUNKNOWN"],["_markerText",""],["_deleteOnDeath",true],["_interval",1]];

private _marker = createMarkerLocal [format ["%1%2",_markerText,random 100],getPos _attachedObject]; //give it a semi-random name to avoid having multiple markers with the same name
_marker setMarkerAlphaLocal 1;
_marker setMarkerTypeLocal _markerType;
_marker setMarkerColorLocal _markerColor;
_marker setMarkerTextLocal _markerText;
//it's made public by the first set pos in the spawn below

[_attachedObject,_deleteOnDeath,_interval,_marker,_markerText] spawn {
	private _attachedObject 	= _this select 0;
	private _deleteOnDeath 		= _this select 1;
	private _interval 			= _this select 2;
	private _marker 			= _this select 3;
	private _markerText			= _this select 4;
	while {alive _attachedObject} do {
		private _markerPos = getMarkerPos _marker;
		private _objectPos = getPos _attachedObject;
		if (((_markerPos select 0) != (_objectPos select 0)) || ((_markerPos select 1) != (_objectPos select 1))) then {	//some optimization to save network traffic if marker has not moved
			_marker setMarkerPos getPos _attachedObject;
		};
		sleep _interval;
	};
	diag_log format ["TAS MISSION TEMPLATE: fn_markerfollow ceasing operation on marker %1 with name %2 attached to object %3 with deletion status %4!",_marker,_markerText,_attachedObject,_deleteOnDeath];
	//runs when _attachedObject is dead or null
	if (_deleteOnDeath) then {
		deleteMarker _marker;
	};
};

diag_log format ["TAS MISSION TEMPLATE: fn_markerfollow attaching marker %1 with name %2 to object %3!",_marker,_markerText,_attachedObject];
_marker