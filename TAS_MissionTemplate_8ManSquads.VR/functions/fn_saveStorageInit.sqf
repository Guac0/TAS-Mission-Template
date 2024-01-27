// Gets executed when a player joins the server
// Spawns their box at 0 0 0, sets up variables, loads inventory, adds action to AceHealObject

//options
params [["_containerClassname",TAS_storageClassname],["_spawnLocation",TAS_storageLocation],["_debug",false]]; //default to supply crate and 0 0 0

// check if player already has a box somehow
if ((player getVariable ["TAS_playerStorageBox",false]) isNotEqualTo false) exitWith {
	[format ["TAS_saveStorageInit called but player already has a storage box with value of %1!",player getVariable ["TAS_playerStorageBox",false]]] call TAS_fnc_error;
};

// Create box
private _container = createVehicle [_containerClassname, _spawnLocation, [], 0, "NONE"];
_container allowDamage false;
_container hideObject true;
clearItemCargoGlobal _container;
clearWeaponCargoGlobal _container;
clearBackpackCargoGlobal _container;
clearMagazineCargoGlobal _container;

if (_debug) then { [format ["TAS_fnc_saveStorageInit: Created box %1",_container]] call TAS_fnc_error; };

player setVariable ["TAS_playerStorageBox",_container];

TAS_fnc_setContents = {
	// Code by Larrow
	// https://forums.bohemia.net/forums/topic/230527-sort-weaponsitembackpacksmagazines-help/
	params[ "_container", "_contents" ];
	_contents params[ "_cargo", "_containers" ];
	
	{
		_x params[ "_cont", "_contents" ];
		
		_every = everyContainer _container;
		if ( _cont call BIS_fnc_itemType select 1 == "backpack" ) then {
			_container addBackpackCargoGlobal[ _cont, 1 ];
		}else{
			_container addItemCargoGlobal[ _cont, 1 ];
		};
		_addedContainer = ( everyContainer _container - _every ) select 0 select 1;
		
		clearItemCargoGlobal _addedContainer;
		clearWeaponCargoGlobal _addedContainer;
		clearBackpackCargoGlobal _addedContainer;
		clearMagazineCargoGlobal _addedContainer;
		
		[ _addedContainer, _contents ] call TAS_fnc_setContents;
	}forEach _containers;
	
	_fnc_addContents = {
		params[ "_index", "_details", "_count" ];
		
		switch ( _index ) do {
			//weapons
			case ( 0 ) : {
				_container addWeaponWithAttachmentsCargoGlobal[ _details, _count ];
			};
			//items
			case ( 1 ) : {
				_container addItemCargoGlobal[ _details, _count ];
			};
			//magazines
			case ( 2 ) : {
				_details params[ "_mag", "_ammo" ];
				
				_container addMagazineAmmoCargo[ _mag, _count, _ammo ];
			};
		};
	};
	
	{
		private _index = _forEachIndex;
		{
			_x params[ "_item", "_count" ];

			[ _index, _item, _count ] call _fnc_addContents;
		}forEach _x;
	}forEach _cargo;
	
};

//Add cargo back in
[ _container, profileNamespace getVariable [format ["TAS_playerStorageBoxContents%1",TAS_playerStorageVar],[]] ] call TAS_fnc_setContents;

// Save contents when box is closed
_container addEventHandler ["ContainerClosed", {
	params ["_container", "_unit", ["_debug",true]];

	if (_debug) then { [format ["TAS_fnc_saveStorageInit ContainerClosed: Operating on box %1",_container]] call TAS_fnc_error; };

	TAS_fnc_getContents = {
		// Code by Larrow
		// https://forums.bohemia.net/forums/topic/230527-sort-weaponsitembackpacksmagazines-help/
		params[ "_container" ];
		
		private _cargo = [ 
			weaponsItemsCargo _container call BIS_fnc_consolidateArray,
			( itemCargo _container select{ !( toLowerANSI( _x call BIS_fnc_itemType select 1 ) in [ "backpack", "uniform", "vest" ] ) } ) call BIS_fnc_consolidateArray,
			magazinesAmmoCargo _container call BIS_fnc_consolidateArray
		];
		
		private _containerCargo = everyContainer _container;
		{
			_x params[ "_type", "_object" ];
			
			_containerCargo set[ _forEachIndex, [ _type, _object call TAS_fnc_getContents ] ];
		}forEach _containerCargo;
		
		[ _cargo, _containerCargo ]
	};

	//Get the contents
	private _containerContents = [_container] call TAS_fnc_getContents;

	if (_debug) then { [format ["TAS_fnc_saveStorageInit ContainerClosed: found container data %1",_containerContents]] call TAS_fnc_error; };

	profileNamespace setVariable [format ["TAS_playerStorageBoxContents%1",TAS_playerStorageVar],_containerContents];
	//hint "Your personal storage container's inventory has been saved!\n\nNote: saved data will be lost if game crashes.";

	_container setPos TAS_storageLocation;
	
	if (TAS_storageFullSave) then {
		saveProfileNamespace;
	};

	if (_debug) then { [format ["TAS_fnc_saveStorageInit ContainerClosed: Finished operating on %1, data stored to %2 and container set to %3",_container,format ["TAS_playerStorageBoxContents%1",TAS_playerStorageVar],TAS_storageLocation]] call TAS_fnc_error; };

	//Save storage inventory (old way)
	/*
	private _magazines = getMagazineCargo _box; //[["item1","item2"],[3,2]]
	private _items = getItemCargo _box;
	private _weapons = getWeaponCargo _box;
	profileNamespace setVariable ["TAS_playerStorageBoxMags",_magazines];
	profileNamespace setVariable ["TAS_playerStorageBoxItems",_items];
	profileNamespace setVariable ["TAS_playerStorageBoxMWeapons",_weapons];
	*/
	//private _container = _box;
}];

// Allow player to open the box anywhere if configured
if (TAS_storageOpenAnywhere) then {
	// ace probably auto reapplies this after death?
	private _openAction = ["storageOpenAction","Open Player Storage","",{[] call TAS_fnc_saveStorageOpen},{true}] call ace_interact_menu_fnc_createAction;
	[player, 1, ["ACE_SelfActions"], _openAction] call ace_interact_menu_fnc_addActionToObject;
};

// Add items (old way)
/*
private _magazinesToAdd = profileNamespace getVariable ["TAS_playerStorageBoxMags",[]];
private _magazinesClassnames = _magazinesToAdd select 0;
private _magazinesQuantities = _magazinesToAdd select 1;
{
	_container addItemCargoGlobal [_magazinesClassnames select _forEachIndex,_magazinesQuantities select _forEachIndex];
} forEach _magazinesToAdd;

private _itemsToAdd = profileNamespace getVariable ["TAS_playerStorageBoxItems",[]];
private _itemsClassnames = _itemsToAdd select 0;
private _itemsQuantities = _itemsToAdd select 1;
{
	_container addItemCargoGlobal [_itemsClassnames select _forEachIndex,_itemsQuantities select _forEachIndex];
} forEach _itemsToAdd;

private _weaponsToAdd = profileNamespace getVariable ["TAS_playerStorageBoxweapons",[]];
private _weaponsClassnames = _weaponsToAdd select 0;
private _weaponsQuantities = _weaponsToAdd select 1;
{
	_container addItemCargoGlobal [_weaponsClassnames select _forEachIndex,_weaponsQuantities select _forEachIndex];
} forEach _weaponsToAdd;
*/