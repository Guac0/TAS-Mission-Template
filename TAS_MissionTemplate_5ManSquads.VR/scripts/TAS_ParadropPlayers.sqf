if !(isServer) exitWith {};
private _vehicle = _this;

//do chat messages
private _playersInVehicle= [];
{
    if (vehicle _x == _vehicle) then { _playersInVehicle pushBack _x };
} forEach allPlayers;
[driver _vehicle,"GREEN LIGHT: GO, GO, GO"] remoteExec ["sideChat",_playersInVehicle];
"You will be ejected from the plane and your parachute will open automatically." remoteExec ["systemChat",_playersInVehicle];

//eject paradrops
_crew = crew _vehicle;
{
    _role = assignedVehicleRole _x;
    //systemChat format ["a %1 %2", _x, _role];
    if (count _role > 0) then
    {
        if((_role select 0) == "cargo") then
        {
            //player sidechat format["Ejecting: %1", _x]; // debug...
            //unassignvehicle _x;
            moveout _x;
            //player action ["OpenParachute", player];
            [] spawn {
                sleep 2;
                [player,["OpenParachute", player]] remoteExec ["action",_x];
            };
            //soldierOne action ["Eject", vehicle soldierOne];
            //[_x,["Eject", vehicle _x]] remoteExec ["action",_x];
        };
    };
    sleep 1;
} foreach _crew;