/*
	Author: Guac

	Requirements: None
	
	Description:
	Gathers statistics about the mission to assist in quickly assessing the mission from a technical/statistics viewpoint.

	Return: string - review results (also copied to your clipboard)

	Examples: 
	[] call TAS_fnc_automatedReviewer; //Works best when played in singleplayer from Eden
*/

private _outputArray = [];

//mission, map, and template version
_outputArray pushBack format ["Mission name: %1, Map: %2 / %3, Mission Template Version: %4",missionName,worldName, getText (configFile >> "CfgWorlds" >> worldName >> "description"),TAS_templateVersion];


//Environment brief - largely copied by fn_diaryEnvironment
//Map and time
private _curDate = date;
private _time = format ["%3/%2/%1 %4:%5",
	_curDate select 0,
	(if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
	(if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2),
	(if (_curDate select 3 < 10) then { "0" } else { "" }) + str (_curDate select 3),
	(if (_curDate select 4 < 10) then { "0" } else { "" }) + str (_curDate select 4)
];
//_messageParts pushBack "LOCATION OF ORDERS"; //Already used for diary entry title
_outputArray pushBack format ["Time: %1, Time Acceleration: %2x",_time, timeMultiplier];
//Weather
private _weather = [];
if (lightnings > 0.1) then { _weather pushBack "Lightning"}; //Note: other conditions need to also be true before lightning will visually occur (rain/overcast? not very documented)
switch (true) do {
	case (rain > 0.7): {_weather pushBack "Monsoon Rainstorm"};
	case (rain > 0.5): {_weather pushBack "Rainstorm"};
	case (rain > 0.3): {_weather pushBack "Raining"};
	case (rain > 0.1): {_weather pushBack "Drizzling"};
};
switch (true) do {
	case (fog > 0.7): {_weather pushBack "Impenetrable Fog"};
	case (fog > 0.5): {_weather pushBack "Thick Fog"};
	case (fog > 0.3): {_weather pushBack "Moderate Fog"};
	case (fog > 0.1): {_weather pushBack "Light Fog"};
};
switch (true) do {
	case (overcast > 0.7): {_weather pushBack "Sullen Skies"};
	case (overcast > 0.5): {_weather pushBack "Thick Clouds"};
	case (overcast > 0.3): {_weather pushBack "Cloudy"};
	case (overcast > 0.1): {_weather pushBack "Scattered Clouds"};
	default {_weather pushBack "Sunny"};
};
private _weatherStr = "";
{_weatherStr = _weatherStr + ", " + _x} forEach _weather;
_weatherStr = _weatherStr select [2]; //trim first ", "
if (fog > 0.1) then { //Only bother with Fog Base if fog is significant
	_weatherStr = _weatherStr + format ["Fog Base: %1m",round(fogParams select 2)]; //FogDecay is useful but difficult to translate into a layman's terms, so don't bother with that
};
//Misc - Moon, Sunrise/Sunset
private _moon = "";
switch (true) do { //Note: also see moonIntensity. It is unclear how they interact besides moonPhase being more documented
	case (moonPhase _curDate > 0.8): {_moon = "Full Moon";};
	case (moonPhase _curDate> 0.6): {_moon = "Waxing Gibbous";};
	case (moonPhase _curDate> 0.4): {_moon = "Half Moon";};
	case (moonPhase _curDate > 0.2): {_moon = "Waning Crescent";};
	default {_moon = "New Moon";};
};
_weatherStr = _weatherStr + format ["; Moon State: %1",_moon];
_outputArray pushBack format ["Weather: %1",_weatherStr];
private _sunrise = [((date call BIS_fnc_sunriseSunsetTime) select 0), "HH:MM"] call BIS_fnc_timeToString;
private _sunset = [((date call BIS_fnc_sunriseSunsetTime) select 1), "HH:MM"] call BIS_fnc_timeToString;
_outputArray pushBack format ["First Light: %1, Last Light: %2",_sunrise,_sunset];


//check number of groups and if they are auto deleted when empty
private _numberOfGroups = count allGroups;
private _numberOfGroupsAutodelete = count (allGroups select {isGroupDeletedWhenEmpty _x});
_outputArray pushBack format ["Total number of groups: %1, wherein %2 will be automatically deleted when empty. Remember that there is a max of 288 groups per side!",_numberOfGroups,_numberOfGroupsAutodelete]; // Remember that there can only be 288 groups per side at the same time!
_outputArray pushBack format ["    Groups breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",count (allGroups select {side _x == west}),count (allGroups select {side _x == east}),count(allGroups select {side _x == independent}),count (allGroups select {side _x == civilian})];


//check for DLC restrictions? no great ways to do this...


//check for number of units and if any are dead on mission start
private _numberOfUnits = count allUnits; //does not include agents or vehicles
private _numberOfAgents = count agents;
private _numberOfUnitsWest = count units West;
private _numberOfUnitsEast = count units East;
private _numberOfUnitsIndependent = count units Independent;
private _numberOfUnitsCiv = count units Civilian;
private _numberOfDeadUnits	= count allDeadMen; //includes agents
_outputArray pushBack format ["Total number of units: %1, wherein %2 are dead on mission start and %3 are agents.",_numberOfUnits,_numberOfDeadUnits,_numberOfAgents];
_outputArray pushBack format ["    Unit breakdown per side: West - %1, East - %2, Independent - %3, Civilian - %4.",_numberOfUnitsWest,_numberOfUnitsEast,_numberOfUnitsIndependent,_numberOfUnitsCiv];

//check for number of objects
private _numberOfObjects = count allMissionObjects "all"; //does not count (most) ambient animals, does not track mines, might track some unintended game-created items
private _numberOfObjectsNoSim = count ((allMissionObjects "all") select {!(simulationEnabled _x)});
private _numberOfObjectsDySim = count ((allMissionObjects "all") select {dynamicSimulationEnabled _x});
private _numberOfSimpleObjects = count allSimpleObjects [];
_outputArray pushBack format ["Total number of objects: %1, wherein %2 have their simulation disabled and %3 have dynamic simulation enabled (not counting units). There are also an additional %4 simple objects.",_numberOfObjects,_numberOfObjectsNoSim,_numberOfObjectsDySim,_numberOfSimpleObjects];

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

//count zeuses and list the units attached to them - for #adminLogged, returns the current admin, not the adminLogged string
private _numberOfZeusLogics = count allCurators;
private _zeusUnits = [];
{_zeusUnits pushBack (roleDescription (getAssignedCuratorUnit _x))} forEach allCurators;
_outputArray pushBack format ["Total number of Zeus logics: %1.",_numberOfZeusLogics];

//count HCs
private _headlessClients = entities "HeadlessClient_F";
private _numberOfHeadlessClients = count _headlessClients;
private _headlessNames = [];
{_headlessNames pushBack (roleDescription _x)} forEach _headlessClients;
_outputArray pushBack format ["Total number of headless clients: %1. Names: %2",_numberOfHeadlessClients,_headlessNames];

//todo - maybe check if heal box is enabled but nonfunctional? and other template features


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


//todo init field checks - not really feasible as of now with the methods that I know of


//Triggers. Kind of a rough way to evaluate them but good enough.
private _allTriggers = allMissionObjects "EmptyDetector";
_outputArray pushBack format ["Total number of triggers: %1, where %2 have a condition of 'true', %3 have an interval of less than 1 second, %4 have an interval of every 1 second, and %5 have an interval of more than 1 second",count _allTriggers, count (_allTriggers select {(trim(toLowerANSI ((triggerStatements _x) select 0))) == "true"}),count (_allTriggers select {(triggerInterval _x) < 1}), count (_allTriggers select {(triggerInterval _x) == 1}), count (_allTriggers select {(triggerInterval _x) > 1})];


//check if template settings are customized from the defaults
_outputArray pushBack format ["Mission Template Settings Check:"];
{
    private _settingName = _x select 0;
    private _settingValue = _x select 1;
    private _defaultValue = _x select 2;
    if (_settingValue isNotEqualTo _defaultValue) then {
        _outputArray pushBack format ["    %1 has been set to %2!",_settingName,_settingValue];
    };
} forEach [
	//CHVD CH View
	["CHVD_allowNoGrass",CHVD_allowNoGrass,true],
	["CHVD_maxView",CHVD_maxView,10000],
	["CHVD_maxObj",CHVD_maxObj,10000],
	//bft
    ["TAS_bftEnabled",TAS_bftEnabled,true],
	["TAS_bftOnlyShowOwnGroup",TAS_bftOnlyShowOwnGroup,false],
	//group icons
    ["TAS_3dGroupIcons",TAS_3dGroupIcons,true],
    ["TAS_3dGroupIconsTime",TAS_3dGroupIconsTime,0],
    ["TAS_3dGroupIconsRange",TAS_3dGroupIconsRange,150],
	//resupply
    ["TAS_resupplyObjectEnabled",TAS_resupplyObjectEnabled,true],
	//briefing
	["TAS_textBriefing",TAS_textBriefing,false],
	//arsenal curate
	["TAS_arsenalCurate",TAS_arsenalCurate,true],
	//custom object mapper
	["TAS_markCustomObjectsMap",TAS_markCustomObjectsMap,false],
	//buddy blood drawing
	["TAS_allowBloodDrawing",TAS_allowBloodDrawing,true],
	//punish civ killers
	["TAS_punishCivKillsThreshold",TAS_punishCivKillsThreshold,2],
	["TAS_punishCivKillTimeout",TAS_punishCivKillTimeout,60],
	["TAS_punishCivKillsSpectator",TAS_punishCivKillsSpectator,true],
	["TAS_punishCivKillerTpToLeader",TAS_punishCivKillerTpToLeader,true],
	["TAS_punishCivKillerHumiliate",TAS_punishCivKillerHumiliate,true],
	//Scav Basic
	["TAS_scavSystemEnabled",TAS_scavSystemEnabled,false],
	["TAS_scavInsertActionObject",TAS_scavInsertActionObject,"scavActionObject"],
	["TAS_scavSafeZoneTpHelper",TAS_scavSafeZoneTpHelper,"scavTpHelper"],
	["TAS_scavAoMarker",TAS_scavAoMarker,"TAS_ScavZone_Marker"],
	["TAS_scavBlacklistLocations",TAS_scavBlacklistLocations,["TAS_ObjectiveBlacklistObject_1","TAS_ObjectiveBlacklistObject_2","TAS_ObjectiveBlacklistObject_3","TAS_ObjectiveBlacklistObject_4","TAS_ObjectiveBlacklistObject_5","TAS_ObjectiveBlacklistObject_6","TAS_ObjectiveBlacklistObject_7","TAS_ObjectiveBlacklistObject_8","TAS_ObjectiveBlacklistObject_9","TAS_ObjectiveBlacklistObject_10","TAS_ObjectiveBlacklistObject_11","TAS_ObjectiveBlacklistObject_12","TAS_ObjectiveBlacklistObject_13","TAS_ObjectiveBlacklistObject_14","TAS_ObjectiveBlacklistObject_15"]],
	["TAS_scavExtractObjects",TAS_scavExtractObjects,["TAS_extract_1","TAS_extract_2","TAS_extract_3","TAS_extract_4","TAS_extract_5","TAS_extract_6","TAS_extract_7","TAS_extract_8","TAS_extract_9","TAS_extract_10","TAS_extract_11","TAS_extract_12","TAS_extract_13","TAS_extract_14","TAS_extract_15"]],
	["TAS_scavPmcMarkers",TAS_scavPmcMarkers,[]],
	//Scav Advanced
	["TAS_scavNumberOfObjectives",TAS_scavNumberOfObjectives,10],
	["TAS_scavSkill",TAS_scavSkill,[["general",0.8],["courage",0.8],["aimingAccuracy",0.25],["aimingShake",0.25],["aimingSpeed",0.25],["commanding",0.8],["spotDistance",0.25],["spotTime",0.25],["reloadSpeed",0.3]]],
	["TAS_scavRadioFreq",TAS_scavRadioFreq,"44"],
	["TAS_scavValuableClassname",TAS_scavValuableClassname,"TAS_RationPizza"],
	["TAS_scavRewardPerItem",TAS_scavRewardPerItem,100],
	["TAS_scavStartingValuables",TAS_scavStartingValuables,10],
	["TAS_scavNeededValuables",TAS_scavNeededValuables,3],
	["TAS_scavSleepInterval",TAS_scavSleepInterval,120],
	["TAS_scavPlayerDistanceThreshold",TAS_scavPlayerDistanceThreshold,400],
	["TAS_scavObjectiveDistanceThreshold",TAS_scavObjectiveDistanceThreshold,200],
	["TAS_scavPlayerSide",TAS_scavPlayerSide,west],
	["TAS_scavAiSide",TAS_scavAiSide,independent],
	["TAS_scavAiRoamerSide",TAS_scavAiRoamerSide,east],
	["TAS_scavRoamersSmall",TAS_scavRoamersSmall,7],
	["TAS_scavRoamersBig",TAS_scavRoamersBig,7],
	["TAS_scavRoamersSmallPatrolChance",TAS_scavRoamersSmallPatrolChance,100],
	["TAS_scavRoamersBigPatrolChance",TAS_scavRoamersBigPatrolChance,0],
	["TAS_scavRoamersObjectiveDistance",TAS_scavRoamersObjectiveDistance,200],
	["TAS_scavRoamersPlayerDistance",TAS_scavRoamersPlayerDistance,400],
	["TAS_scavRespawnRoamers",TAS_scavRespawnRoamers,true],
	["TAS_scavRespawnObjectives",TAS_scavRespawnObjectives,true],
	//Mortar Monitor
	["TAS_mortarLog",TAS_mortarLog,true],
	["TAS_mortarLogPlayerOnly",TAS_mortarLogPlayerOnly,true],
	//Spotting system/marking units
	["TAS_addUnitMarkAction",TAS_addUnitMarkAction,false],
	["TAS_markTargetOnMap",TAS_markTargetOnMap,true],
	["TAS_markTarget3d",TAS_markTarget3d,true],
	//////////////////////////////////
	/////////Inventory Options////////
	//////////////////////////////////
	//radio assignment
	["TAS_radiosEnabled",TAS_radiosEnabled,true],
	["TAS_NoSquadleadLr",TAS_NoSquadleadLr,true],
	["TAS_radioAdditionals",TAS_radioAdditionals,false],
	["TAS_radioPersonal",TAS_radioPersonal,"TFAR_anprc152"],
	["TAS_radioBackpack",TAS_radioBackpack,"TFAR_anprc155_coyote"],
	//config loadouts
	["TAS_useConfigLoadout",TAS_useConfigLoadout,false],
	["TAS_configLoadoutCustom",TAS_configLoadoutCustom,false],
	["TAS_configFaction",TAS_configFaction,"BLU_F"],
	["TAS_configUnitPrefix",TAS_configUnitPrefix,""],
	["TAS_defaultConfigUnit",TAS_defaultConfigUnit,"Rifleman"],
	["TAS_configLoadoutNumber",TAS_configLoadoutNumber,0],
	//populate inventory
	["TAS_populateInventory",TAS_populateInventory,true],
	["TAS_inventoryAddGps",TAS_inventoryAddGps,true],
	["TAS_inventoryAddCtab",TAS_inventoryAddCtab,true],
	//role based arsenals
	["TAS_roleBasedArsenals",TAS_roleBasedArsenals,false],
	["TAS_visibleArsenalBoxes",TAS_visibleArsenalBoxes,["arsenal_1","arsenal_2"]],
	//////////////////////////////////
	/////////Respawns Options/////////
	//////////////////////////////////
	//respawn gear
	["TAS_respawnDeathGear",TAS_respawnDeathGear,false],
	["TAS_respawnArsenalGear",TAS_respawnArsenalGear,true],
	//respawn spectator
	["TAS_respawnSpectator",TAS_respawnSpectator,false],
	["TAS_respawnSpectatorForceInterface",TAS_respawnSpectatorForceInterface,false],
	["TAS_respawnSpectatorHideBody",TAS_respawnSpectatorHideBody,true],
	["TAS_respawnSpectatorTime",TAS_respawnSpectatorTime,30],
	//wave respawns
	["TAS_waveRespawn",TAS_waveRespawn,false],
	["TAS_waveTime",TAS_waveTime,300],
	//respawn in vehicle
	["TAS_respawnInVehicle",TAS_respawnInVehicle,false],
	//flagpole respawn
	["TAS_flagpoleRespawn",TAS_flagpoleRespawn,false],
	//fob system main
	["TAS_fobEnabled",TAS_fobEnabled,false],
	["TAS_fobPackup",TAS_fobPackup,false],
	["TAS_fobFullArsenals",TAS_fobFullArsenals,false],
	["TAS_fobDistance",TAS_fobDistance,200],
	["TAS_fobRespawn",TAS_fobRespawn,false],
	//fob overrun
	["TAS_fobOverrun",TAS_fobOverrun,false],
	["TAS_fobOverrunDestroy",TAS_fobOverrunDestroy,true],
	["TAS_fobOVerrunFactor",TAS_fobOVerrunFactor,2],
	["TAS_fobOverrunMinEnemy",TAS_fobOverrunMinEnemy,8],
	["TAS_fobOverrunTimer",TAS_fobOverrunTimer,300],
	["TAS_fobOverrunInterval",TAS_fobOverrunInterval,30],
	//rallypoints main
	["TAS_rallypointsEnabled",TAS_rallypointsEnabled,false],
	["TAS_useSmallRally",TAS_useSmallRally,true],
	["TAS_rallyDistance",TAS_rallyDistance,50],
	["TAS_rallyOutnumber",TAS_rallyOutnumber,true],
	//rallypoint overrun
	["TAS_rallypointOverrun",TAS_rallypointOverrun,false],
	["TAS_rallyOutnumberFactor",TAS_rallyOutnumberFactor,2],
	["TAS_rallyOverrunMinEnemy",TAS_rallyOverrunMinEnemy,4],
	["TAS_rallyOverrunTimer",TAS_rallyOverrunTimer,90],
	["TAS_rallyOverrunInterval",TAS_rallyOverrunInterval,15],
	//////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////Advanced Options///////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////
	////Scripts/Functions Options/////
	//////////////////////////////////
	["TAS_aceHealObjectEnabled",TAS_aceHealObjectEnabled,true],
	["TAS_aceSpectateObjectEnabled",TAS_aceSpectateObjectEnabled,true],
	//////////////////////////////////
	//////////Misc Options////////////
	//////////////////////////////////
	//boss options
	["TAS_bossEnabled",TAS_bossEnabled,true],
	["TAS_bossImagePath",TAS_bossImagePath,"media/logo256x256.paa"],
	//["TAS_bossParts",TAS_bossParts,[[leg1,"LeftLeg",10],[leg2,"RightLeg",10],[torso,"Torso",30],[head,"Head",20]]], //not checked due to 'leg1' and etc being ANY if not defined and thus not matching
	["TAS_bossInterval",TAS_bossInterval,0.5],
	["TAS_bossHealthModifier",TAS_bossHealthModifier,1],
	//VASS options
	["TAS_vassEnabled",TAS_vassEnabled,false],
	["TAS_vassShopSystemVariable",TAS_vassShopSystemVariable,"TAS_exampleVassMoney"],
	["TAS_vassShopSystemLoadoutVariable",TAS_vassShopSystemLoadoutVariable,"TAS_exampleVassLoadout"],
	["TAS_vassDefaultBalance",TAS_vassDefaultBalance,700],
	["TAS_vassBonusStartingMoney",TAS_vassBonusStartingMoney,0],
	["TAS_vassPrebriefing",TAS_vassPrebriefing,["In this campaign, we have to buy our gear from the black market.","Each player's balance and loadout at mission end will carry over to the next mission.","All free items (cosmetics) are in the red crate's ace arsenal, everything else is in the other box.","Save your loadout at the sign to be able to rebuy it in the future for a small cost."]],
	["TAS_vassShops",TAS_vassShops,["arsenal_1","arsenal_2"]],
	["TAS_vassSigns",TAS_vassSigns,["AceHealObject"]],
	["TAS_rebuyCostPrimary",TAS_rebuyCostPrimary,35],
	["TAS_rebuyCostSecondary",TAS_rebuyCostSecondary,50],
	["TAS_rebuyCostHandgun",TAS_rebuyCostHandgun,15],
	//other assorted stuff 
	["TAS_vanillaStaminaDisabled",TAS_vanillaStaminaDisabled,true],
	["TAS_doAimCoefChange",TAS_doAimCoefChange,false],
	["TAS_aimCoef",TAS_aimCoef,0.5],
	["TAS_recoilCoef",TAS_recoilCoef,0.75],
	//////////////////////////////////
	////////Template Options//////////
	//////////////////////////////////
	//skip version and briefing
	["TAS_cleanBriefing",TAS_cleanBriefing,true],
	//////////////////////////////////
	////////Scripts Options///////////
	//////////////////////////////////
	["TAS_spawnUnitsOnHC",TAS_spawnUnitsOnHC,false],
	["TAS_globalTfarEnabled",TAS_globalTfarEnabled,true],
	["TAS_dynamicGroupsEnabled",TAS_dynamicGroupsEnabled,true],
	["TAS_fpsDisplayEnabled",TAS_fpsDisplayEnabled,true],
	["TAS_fixDeathColor",TAS_fixDeathColor,true],
	["TAS_trimGroupNames",TAS_trimGroupNames,true],
	["TAS_diaryEnvironmentEnabled",TAS_diaryEnvironmentEnabled,true],
	//////////////////////////////////
	///////Logistics Options//////////
	//////////////////////////////////
	//["TAS_kpCratefiller",TAS_kpCratefiller,true],
	//////////////////////////////////
	//////////Zeus Options////////////
	//////////////////////////////////
	["TAS_zeusResupply",TAS_zeusResupply,true],
	["TAS_zeusInfoText",TAS_zeusInfoText,true],
	["TAS_zeusHcTransfer",TAS_zeusHcTransfer,true],
	["TAS_zeusActionDebug",TAS_zeusActionDebug,true],
	["TAS_zeusSpectateManager",TAS_zeusSpectateManager,true],
	["TAS_zeusGroupDeletion",TAS_zeusGroupDeletion,true],
	["TAS_zeusFollowMarker",TAS_zeusFollowMarker,true],
	["TAS_zeusServiceVehicle",TAS_zeusServiceVehicle,true],
	//////////////////////////////////
	//Client Hotkeys/Actions Options//
	//////////////////////////////////
	["TAS_aceWindowBreak",TAS_aceWindowBreak,false],
	["TAS_afkEnabled",TAS_afkEnabled,true],
	["TAS_earplugsEnabled",TAS_earplugsEnabled,true],
	["TAS_earplugVolume",TAS_earplugVolume,0.25],
	["TAS_musicKeyEnabled",TAS_musicKeyEnabled,true],
	//////////////////////////////////
	//////////Admin Options///////////
	//////////////////////////////////
	["TAS_ModLog",TAS_ModLog,true],
	["TAS_ModLogShame",TAS_ModLogShame,false],
	["TAS_trackPeformance",TAS_trackPerformance,true],
	["TAS_doDiscordUpdate",TAS_doDiscordUpdate,true],
	["TAS_discordUpdateDelay",TAS_discordUpdateDelay,30]
]; //2D array of ALL config parameters and their default values



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
_finalOutput
/* example results for mission template
Mission name: tas_missiontemplate_8mansquads, Map: vr / Virtual Reality, Mission Template Version: 12
Time: 28/05/2035 13:37, Time Acceleration: 1x
Weather: Sunny; Moon State: New Moon
First Light: 04:59, Last Light: 19:00
Total number of groups: 34, wherein 0 will be automatically deleted when empty. Remember that there is a max of 288 groups per side!
    Groups breakdown per side: West - 10, East - 10, Independent - 10, Civilian - 4.
Total number of units: 162, wherein 0 are dead on mission start and 0 are agents.
    Unit breakdown per side: West - 50, East - 50, Independent - 50, Civilian - 12.
Total number of objects: 200, wherein 4 have their simulation disabled and 1 have dynamic simulation enabled (not counting units). There are also an additional 7 simple objects.
Total number of playable units: 153 (not counting logic entities like headless clients or spectators).
    Player slots breakdown per side: West - 50, East - 50, Independent - 50, Civilian - 3.
Total number of map markers: 14.
Total number of mines: 7.
Total number of Zeus logics: 4.
Total number of headless clients: 3. Names: ["","",""]
Total number of respawns: 4. Vanilla respawn delay: 5
    Respawn breakdown per side: West - 1, East - 1, Independent - 1, Civilian - 1.
Dynamic simulation enabled. Unit simulation range: 700, vehicle simulation range: 700, empty vehicle simulation range: 700, object simulation range: 50, moving multiplier: 1
Total number of triggers: 8, where 1 have a condition of 'true', 7 have an interval of less than 1 second, 0 have an interval of every 1 second, and 1 have an interval of more than 1 second
Mission Template Settings Check:
    TAS_inventoryAddCtab has been set to false!

*/