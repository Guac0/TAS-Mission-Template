// %1: error string
params [_msg,[_adminOnly,true]];

if (typename _msg != "STRING") then {
    ["ERROR: TAS_fn_error called with a non-string message variable! Attempting to stringify parameter...",true];
    _msg = str _msg;
};

if (_adminOnly) then {
    if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorlogic player))) then {
        systemChat _msg;
    };
} else {
    systemChat _msg;
};
_msg remoteExec ["diag_log", 2];
// log error in server rpt