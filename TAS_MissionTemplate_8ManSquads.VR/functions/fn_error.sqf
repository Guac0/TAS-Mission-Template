// %1: error string
params ["_msg",["_adminOnly",true]];

if (typename _msg != "STRING") then {
    ["ERROR: TAS_fn_error called with a non-string message variable! Attempting to stringify parameter...",true] call TAS_fnc_error;
    _msg = str _msg;
};

diag_log _msg; // Log message locally no matter if it's for admin only or not
if (_adminOnly) then {
    if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorlogic player))) then {
        systemChat _msg;
    };
} else {
    systemChat _msg;
};
if (clientOwner != 2) then { // Don't bother logging message twice if local machine is the server
    _msg remoteExec ["diag_log", 2]; // log error in server rpt
};