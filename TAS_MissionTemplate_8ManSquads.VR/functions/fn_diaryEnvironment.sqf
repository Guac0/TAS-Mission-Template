/*
	Author: Guac

	Requirements: None
	
	Description:
	Creates a diary record containing basic environmental information. Diary entry will be located under "BRIEFING" tab and will have the subject "Location of Orders"
	* Map name and time
	* Time accel
	* Human readable weather (supports lightning, rain, fog (density and fog base, displayed if density > 0.1), overcast)
	* Moon state
	* First and last light

	Return: true

	Examples: 
	[] spawn TAS_fnc_diaryEnvironment; //Add diary entry for the local player
	[] remoteExec ["TAS_fnc_diaryEnvironment"];  //Add diary entries for all players
*/
private _messageParts = [];

//Map and time
private _map = getText (configFile >> "CfgWorlds" >> worldName >> "description");
private _curDate = date;
private _time = format ["%3/%2/%1 %4:%5",
	_curDate select 0,
	(if (_curDate select 1 < 10) then { "0" } else { "" }) + str (_curDate select 1),
	(if (_curDate select 2 < 10) then { "0" } else { "" }) + str (_curDate select 2),
	(if (_curDate select 3 < 10) then { "0" } else { "" }) + str (_curDate select 3),
	(if (_curDate select 4 < 10) then { "0" } else { "" }) + str (_curDate select 4)
];
//_messageParts pushBack "LOCATION OF ORDERS"; //Already used for diary entry title
_messageParts pushBack format ["%1 - %2",_map,_time];
_messageParts pushBack format ["Time Acceleration: %1x",timeMultiplier];

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
_messageParts pushBack format ["Weather: %1",_weatherStr];
if (fog > 0.1) then { //Only bother with Fog Base if fog is significant
	_messageParts pushBack format ["Fog Base: %1m",round(fogParams select 2)]; //FogDecay is useful but difficult to translate into a layman's terms, so don't bother with that
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
_messageParts pushBack format ["Moon State: %1",_moon];
private _sunrise = [((date call BIS_fnc_sunriseSunsetTime) select 0), "HH:MM"] call BIS_fnc_timeToString;
private _sunset = [((date call BIS_fnc_sunriseSunsetTime) select 1), "HH:MM"] call BIS_fnc_timeToString;
_messageParts pushBack format ["First Light: %1",_sunrise];
_messageParts pushBack format ["Last Light: %1",_sunset];

//Assemble
private _message = "";
{
	_message = _message + "<br /><br />" + _x;
} forEach _messageParts;
_message = _message select [12]; //trim first <br>
//_message = parseText _message; //might be needed?
//systemChat str _message;
player createDiaryRecord ["Diary", ["Location of Orders", _message]];

true