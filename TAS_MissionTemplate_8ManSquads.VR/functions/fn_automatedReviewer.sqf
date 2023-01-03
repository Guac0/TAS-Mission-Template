// [] call fn_automatedReviewer.sqf
//4 spaces to count as a tab

private _outputArray = [];

//mission, map, and template version
_outputArray pushBack format ["Mission name: %1, Map: %2, Mission Template Version: %3",missionName,worldName,TAS_templateVersion];


//time
private _time = [dayTime, "HH:MM"] call BIS_fnc_timeToString;
_outputArray pushBack format ["Mission time: %1. Time acceleration: %2",_time,timeMultiplier];

//todo weather 


//check number of groups and if the majority (75%+ have automated group deletion on)
private _numberOfGroups = count allGroups;
private _numberOfGroupsAutodelete = count (allGroups select {isGroupDeletedWhenEmpty _x});
_outputArray pushBack format ["Total number of groups: %1, wherein %2 will be automatically deleted when empty.",_numberOfGroups,_numberOfGroupsAutodelete]; // Remember that there can only be 288 groups per side at the same time!
//todo group breakdown per side 


//check for DLC restrictions?


//check for number of units and if any are dead on mission start
private _numberOfUnits = count allUnits; //does not include agents or vehicles
private _numberOfAgents = count agents;
private _numberOfUnitsWest = count units West;
private _numberOfUnitsEast = count units West;
private _numberOfUnitsIndependent = count units Independent;
private _numberOfUnitsCiv = count units Civilian;
private _numberOfDeadUnits	= count allDeadMen; //includes agents
_outputArray pushBack format ["Total number of units: %1, wherein %2 are dead on mission start and %3 are agents.",_numberOfUnits,_numberOfDeadUnits,_numberOfAgents];
_outputArray pushBack format ["    Unit breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfUnitsWest,_numberOfUnitsEast,_numberOfUnitsIndependent,_numberOfUnitsCiv];

//check for number of objects
private _numberOfObjects = count allMissionObjects "all"; //does not count (most) ambient animals, does not track mines, might track some unintended game-created items
private _numberOfObjectsNoSim = count ((allMissionObjects "all") select {!(simulationEnabled _x)});
private _numberOfSimpleObjects = count allSimpleObjects [];
_outputArray pushBack format ["Total number of objects: %1, wherein %2 have their simulation disabled. There are also an additional %3 simple objects.",_numberOfObjects,_numberOfObjectsNoSim,_numberOfSimpleObjects];

//player units
private _numberOfPlayersWest = playableSlotsNumber west;
private _numberOfPlayersEast = playableSlotsNumber east;
private _numberOfPlayersIndependent = playableSlotsNumber independent;
private _numberOfPlayersCiv = playableSlotsNumber civilian;
private _numberOfPlayers = _numberOfPlayersWest + _numberOfPlayersEast + _numberOfPlayersIndependent + _numberOfPlayersCiv;
_outputArray pushBack format ["Total number of playable units: %1 (not counting logic entities like headless clients or spectators).",_numberOfPlayers];
_outputArray pushBack format ["    Player slots breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfPlayersWest,_numberOfPlayersEast,_numberOfPlayersIndependent,_numberOfPlayersCiv];

//check for map markers
private _numberOfMapMarkers = count allMapMarkers;
_outputArray pushBack format ["Total number of map markers: %1.",_numberOfMapMarkers];

//check for mines 
private _numberOfMines = count allMines;
_outputArray pushBack format ["Total number of mines: %1.",_numberOfMines];

//count zeuses. TODO check what they're attached to
private _numberOfZeusLogics = count allCurators;
_outputArray pushBack format ["Total number of zeus logics: %1.",_numberOfZeusLogics];

//count HCs - TODO check if theyre set up properly?
private _headlessClients = entities "HeadlessClient_F";
private _numberOfHeadlessClients = count _headlessClients;
_outputArray pushBack format ["Total number of headless clients: %1.",_numberOfHeadlessClients];

//maybe check if heal box is enabled but nonfunctional? and other template features


//get number and type of respawns?
//https://community.bistudio.com/wiki/BIS_fnc_getRespawnPositions
private _numberOfRespawnsWest = count (west call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsEast = count (east call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsIndependent = count (independent call BIS_fnc_getRespawnPositions);
private _numberOfRespawnsCiv = count (civilian call BIS_fnc_getRespawnPositions);
private _numberOfRespawns = _numberOfRespawnsWest + _numberOfRespawnsEast + _numberOfRespawnsIndependent + _numberOfRespawnsCiv;
private _respawnTime = getMissionConfigValue ["respawnDelay",0];
_outputArray pushBack format ["Total number of respawns: %1. Vanilla respawn delay: %2",_numberOfRespawns,_respawnTime];
_outputArray pushBack format ["    Respawn breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfRespawnsWest,_numberOfRespawnsEast,_numberOfRespawnsIndependent,_numberOfRespawnsCiv];


//dysim
if (dynamicSimulationSystemEnabled) then {
	_outputArray pushBack format ["Dynamic simulation enabled. Unit simulation range: %1, vehicle simulation range: %2, empty vehicle simulation range: %3, object simulation range: %4, moving multiplier: %5",dynamicSimulationDistance "Group",dynamicSimulationDistance "Vehicle",dynamicSimulationDistance "EmptyVehicle",dynamicSimulationDistance "Prop", dynamicSimulationDistanceCoef "IsMoving"];
} else {
	_outputArray pushBack format ["Dynamic simulation disabled!"];
};


//todo init field checks


//todo triggers



/////////////////////////////
//////////output/////////////
/////////////////////////////
private _br = toString [13,10];//(carriage return & line feed)
//_string = "Line 1" + _br + "Line 2";
//copyToClipboard _string;
private _finalOutput = "";
{
 _finalOutput = _finalOutput + _x + _br;
} forEach _outputArray;
copyToClipboard _finalOutput;
diag_log _finalOutput;
hint "Results of automated reviewer copied to clipboard!";
systemChat "Results of automated reviewer copied to clipboard!";

/* example results for template
Mission name: tas_missiontemplate_8mansquads, Map: vr, Mission Template Version: 10.1
Mission time: 13:37. Time acceleration: 1
Total number of groups: 35, wherein 0 will be automatically deleted when empty.
Total number of units: 13, wherein 0 are dead on mission start and 0 are agents.
    Unit breakdown per side: West - 1, East - 1, Independent - 0, Civilian - 12.
Total number of objects: 43, wherein 5 have their simulation disabled. There are also an additional 7 simple objects.
Total number of playable units: 153 (not counting logic entities like headless clients or spectators).
    Player slots breakdown per side: West - 50, East - 50, Independent - 50, Civilian - 3.
Total number of map markers: 15.
Total number of mines: 0.
Total number of zeus logics: 5.
Total number of headless clients: 0.
Total number of respawns: 4. Vanilla respawn delay: 
    Respawn breakdown per side: West - 1, East - 1, Independent - 1, Civilian - 1.
Dynamic simulation enabled. Unit simulation range: 700, vehicle simulation range: 700, empty vehicle simulation range: 700, object simulation range: 50, moving multiplier: 1

*/