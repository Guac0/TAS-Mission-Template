// Helper function for fn_vassGetLoadoutCost that recursively loops through a provided loadout array and compares it to a VASS shop to get the total loadout cost

params ["_inputData","_shopCrate",["_debug",false]];

private _cost = 0;
if (typeName _shopCrate == "STRING") then {
	_shopCrate = missionNamespace getVariable [_shopCrate, objNull]; //convert from string to object, otherwise we get errors
};

if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Checking item %1",_inputData]] call TAS_fnc_error; };

if (typeName _inputData == "ARRAY") then {
	if ((count (_inputData) >= 1) && { (typeName (_inputdata select 0) == "STRING") && { (typeName (_inputdata select 1) == "SCALAR") } } ) then { //lazy eval to avoid wrong index errors
		if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item is an array of item classname and quantity, checking cost of item and multiplying by quantity."]] call TAS_fnc_error; };
		private _returnedCost = [_inputData select 0,_shopCrate] call TAS_fnc_vassGetLoadoutCostRecursive;
		_returnedCost = _returnedCost * (_inputData select 1);
		_cost = _cost + _returnedCost;
		if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item costs %1 with quantity of %2 for combined cost of %3 and total cost of %4.",_returnedCost,_inputData select 1, _returnedCost * (_inputData select 1), _cost]] call TAS_fnc_error; };
	} else {
		if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item is array, starting recursive call."]] call TAS_fnc_error; };
		{
			private _returnedCost = [_x,_shopCrate] call TAS_fnc_vassGetLoadoutCostRecursive;
			_cost = _cost + _returnedCost;
		} forEach _inputData;
		if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Recursive call finished, new total cost of this section is %1",_cost]] call TAS_fnc_error; };
	};
} else {
	if (typeName _inputData == "STRING") then {
		if (_inputData != "") then {
			private _returnedCost = [_shopCrate, _inputData, 1] call TER_fnc_getItemValues;
			_cost = _cost + _returnedCost;
			if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item costs %1",_cost]] call TAS_fnc_error; };
		} else {
			if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item is empty string, disregarding.",_cost]] call TAS_fnc_error; };
		};
	} else {
		if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Item is not an array or string, disregarding."]] call TAS_fnc_error; };
	};
};

if (_debug) then { [format ["TAS_fnc_vassGetLoadoutCostRecursive: Exiting with a cost of %1 for item(s) %2",_cost,_inputData]] call TAS_fnc_error; };

_cost