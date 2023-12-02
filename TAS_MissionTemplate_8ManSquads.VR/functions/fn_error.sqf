// %1: error string
params ["_msg",["_adminOnly",true]];

private _prefix = "TAS-MISSION-TEMPLATE: ";

if (typename _msg != "STRING") then {
    ["ERROR: TAS_fnc_error called with a non-string message variable! Attempting to stringify parameter...",true] call TAS_fnc_error;
    _msg = str _msg;
};

private _log_msg = _prefix + _msg;
diag_log _log_msg; // Log message locally no matter if it's for admin only or not
if (_adminOnly) then {
    if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorlogic player))) then {
        systemChat _msg;
    };
} else {
    systemChat _msg;
};
if (clientOwner != 2) then { // Don't bother logging message twice if local machine is the server
    _log_msg remoteExec ["diag_log", 2]; // log error in server rpt
};