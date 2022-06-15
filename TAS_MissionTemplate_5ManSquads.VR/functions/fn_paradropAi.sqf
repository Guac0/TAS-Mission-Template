if !(isServer) exitWith {};
private _vehicle = _this;

//[plane1D,"GREEN LIGHT: GO, GO, GO"] remoteExec ["sideChat"];
//"You will be ejected from the plane and your parachute will open automatically." remoteExec ["systemChat"];

_crew = crew _vehicle;
{
    _role = assignedVehicleRole _x;
    //systemChat format ["a %1 %2", _x, _role];
    if (count _role > 0) then
    {
        //systemChat "b";
        if((_role select 0) == "cargo") then
        {
            //systemChat "c";
            //player sidechat format["Ejecting: %1", _x]; // debug...
            unassignvehicle _x;
            moveout _x;
            //player action ["OpenParachute", player];
            _x spawn {
                sleep 2;
                //[player,["OpenParachute", player]] remoteExec ["action",_x];
                _this action ["OpenParachute", _this];
            };
            //soldierOne action ["Eject", vehicle soldierOne];
            //[_x,["Eject", vehicle _x]] remoteExec ["action",_x];
        };
    };
    sleep 1;
} foreach _crew;