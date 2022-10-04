//hide marker and reset to origin
"fobMarker" setMarkerAlpha 0;
"fobMarker" setMarkerPos [0,0,0];

//clean up objects 
{deleteVehicle _x} forEach TAS_fobObjects;

//remove respawn GUI stuff
//TAS_rallypointEchoRespawn call BIS_fnc_removeRespawnPosition;
if (TAS_fobRespawn) then {
	TAS_fobRespawn call BIS_fnc_removeRespawnPosition;
};
private _path = [TAS_rallypointLocations, "Forward Operating Base"] call BIS_fnc_findNestedElement;
private _indexOfOldRallyPair = _path select 0;
TAS_rallypointLocations deleteAt _indexOfOldRallyPair;

//apply new var
TAS_fobBuilt = false;
publicVariable "TAS_fobBuilt";