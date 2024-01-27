// Gets executed when a player activates the open storage action
// Opens the storage inventory
// On exit, saves the storage inventory
// [_box] call TAS_fnc_saveStorageOpen;
params [["_container",player getVariable ["TAS_playerStorageBox",objNull]]];

_container setPos (getPos player); //tp to close enough for open to work
player action ["Gear",_container];

// Rest of the code is contained within an inventory closed event handler in saveStorageInit