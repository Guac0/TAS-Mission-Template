//from FNF: https://github.com/FridayNightFight/FNF/blob/master/FNF_MissionTemplate.VR/server/init/fn_markCustomObjs.sqf
//licensed under BSD 3-Clause "New" or "Revised" license, see https://github.com/FridayNightFight/FNF/blob/master/LICENSE
/*
BSD 3-Clause License

Copyright (c) 2022, Friday Night Fight
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

private _baseClasses = ["Static","Cargo_base_F"]; //anything that is a subtype of these classes and is big enough will be marked
private _classBlacklist = ["Land_DataTerminal_01_F","Wreck_Base","FlagCarrierCore","Base_CUP_Plant","Land_JumpTarget_F","Land_HelipadSquare_F","Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F","Land_HelipadRescue_F"]; //blacklist of item or parent classes to never mark
/*private _markerBlacklist = switch (fnf_attackingSide) do {
  case west: {[nil, west, true] call fnf_fnc_inSafeZone};
  case east: {[nil, east, true] call fnf_fnc_inSafeZone};
  case independent: {[nil, independent, true] call fnf_fnc_inSafeZone};
  case sideEmpty: {[nil, nil, true] call fnf_fnc_inSafeZone};
};*/
private _markerBlacklist = []; //add variable names (in quotations) of marker areas wherein not to mark buildings here

//checks bounding sphere value to see if object is large enough, not in the blacklist, and not in an excluded start zone
_canMark = {
  params ["_obj"];

  if (_obj getVariable ["fnf_autoMarkExclude", false]) exitWith {false};
  //private _size = getNumber (configFile >> "CfgVehicles" >> typeOf _obj >> "mapSize");
  private _size = (boundingBox _x) select 2;

  _inSafeZone = false;

  {
    if (typeName _x == "ARRAY") then
    {
      _polygonToCheck = [];
      {
        _polygonToCheck pushback (getMarkerPos _x);
      } forEach _x;
      _polygonToCheck pushback (getMarkerPos (_x select 0));
      if ((getPos _obj) inPolygon _polygonToCheck) then {_inSafeZone = true;};
    } else {
      if (_obj inArea _x) then {_inSafeZone = true;};
    };
  } forEach _markerBlacklist;

  _size > 1.5
  and
  !_inSafeZone
  and
  {if (_obj isKindOf _x) exitWith {false}; true} forEach _classBlacklist
};

//get buildings to create markers for - only include objects large enough
private _objectsToMark = [];
{_objectsToMark append allMissionObjects _x} forEach _baseClasses;
_objectsToMark = _objectsToMark select {_x call _canMark};

// Used for unique marker names
private _markerNum = 0;

_createMarker = {
  private _obj = _this;

  // Create marker locally to save network bandwidth
  private _marker = createMarkerlocal ["ObjectMarker" + str _markerNum, getPos _obj];

  // increase marker number for unique marker names
  _markerNum = _markerNum + 1;

  // format marker and set direction
  _marker setMarkerShapeLocal "Rectangle";
  _marker setMarkerBrushLocal "SolidFull";
  //_marker setMarkerColorLocal "ColorGrey";
  _marker setMarkerColorLocal "ColorBlack";
  //_marker setMarkerAlphaLocal 0.5;
  _marker setMarkerDirLocal getDir _obj;

  // Grab dimensions of bounding box of the object
  _bbr = boundingBoxReal _obj;
  _p1 = _bbr select 0;
  _p2 = _bbr select 1;
  _maxWidth = abs ((_p2 select 0) - (_p1 select 0));
  _maxLength = abs ((_p2 select 1) - (_p1 select 1));

  // set marker size to size of bounding box
  _marker setMarkersize [_maxWidth / 2, _maxLength / 2]; //shares marker state over network
};

{_x call _createMarker} forEach _objectsToMark;

//missionNamespace setVariable ["fnf_markCustomObjs_ready", true, true];