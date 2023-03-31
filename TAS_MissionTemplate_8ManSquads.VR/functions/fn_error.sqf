// %1: error string

if (isServer || (serverCommandAvailable "#logout") || (!isNull (getAssignedCuratorlogic player))) then {
    // only do visual error if server (singleplayer testing) or admin or zeus
    systemChat "WARNinG: You have enabled the Rallypoint system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoints system...";
};
diag_log text "TAS-Mission-Template WARNinG: You have enabled the Rallypoint system in the mission template options, but the mission.sqm does not contain the needed rallypoint markers! Disabling Rallypoints system...";

remoteExec ["diag_log", 2];
// log error in server rpt