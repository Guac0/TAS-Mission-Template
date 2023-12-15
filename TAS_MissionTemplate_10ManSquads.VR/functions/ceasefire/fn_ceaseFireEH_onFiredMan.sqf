/*	KiloSwiss	*/
/*  https://steamcommunity.com/sharedfiles/filedetails/?id=2056899653  */

params ["", "_weapon", "", "", "", "_magazine", "_projectile"];

//-- Immediately delete the projectile.
deleteVehicle _projectile;

if ( _weapon isEqualTo "Put" ) then
{
	//-- Put the Mine/Satchel back into the players inventory.
	player addMagazine _magazine;
	
	private _message = switch ( round random 4 ) do
	{
		case 0: { "Go blow shit up somewhere else soldier!" };
		case 1: { "This goes right back into your pocket." };
		case 2: { "Keep those explosives on you soldier!" };
		case 3: { "No explosives can be placed here." };
		case 4: { "Please keep this area clean!" };
		default { "HEY! No littering you twat!" };
	};
	cutText [format["<t font='PuristaBold' shadow='1' color='#ff0000' size='4'>NO NO NO...</t><br/><br/><t size='1.3' shadow='2'>%1</t>", _message], "PLAIN", 1, false, true]; 
}
else
{
	// Fall back in case the blockMuzzle function doesn't work.
	cutText ["<t font='PuristaBold' shadow='1' color='#ff0000' size='4'>CEASE FIRE!</t><br/><br/>STOP WASTING YOUR AMUNITION SOLDIER!", "PLAIN", 0.1, false, true];
};

/*
params
[
	"_unit",	// unit: Object - Unit the event handler is assigned to (the instigator)
	"_weapon",	// weapon: String - Fired weapon
	"_muzzle",	// muzzle: String - Muzzle that was used
	"_mode",	// mode: String - Current mode of the fired weapon
	"_ammo",	// ammo: String - Ammo used
	"_magazine",	// magazine: String - magazine name which was used
	"_projectile",	// projectile: Object - Object of the projectile that was shot out
	"_vehicle"	// vehicle: Object - Vehicle, if weapon is vehicle weapon, otherwise objNull
];

hintSilent format [
	"Unit: %1\nWeapon: %2\nMuzzle: %3\nMode: %4\nAmmo: %5\nMagazine: %6\nProjectile: %7\nVehicle %8",
	_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _vehicle
];
*/