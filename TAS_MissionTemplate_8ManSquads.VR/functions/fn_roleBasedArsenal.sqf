private _unit = _this;

//setup variables
private _roleDescription = roleDescription _unit;
private _roleDescriptionSimple = roleDescription _unit; //we'll use this in a sec
if ((_roleDescription find "@") != -1) then { //-1 indicates no @ sign. If unit has @ sign, parse it and only count text before it (remove group info)
	private _roleDescriptionArray = _roleDescription splitString "@"; //splits string into array with values separated by @ sign, so "AAA@BBB" becomes "[AAA,BBB]"
	_roleDescriptionSimple = _roleDescriptionArray select 0;
};
if ((_roleDescription find "[") != -1) then { //remove info about assigned color team if _unit has it
	private _indexOfBracket = _roleDescription find "[";
	_roleDescriptionSimple = _roleDescription select [0,(_indexOfBracket - 1)]; //-1 to remove the space before it
};



////////////////////////////////////////
////////////Edit Stuff Here/////////////
////////////////////////////////////////
/*
	1. Make arsenal boxes in your mission for the various roles you want to have a special arsenal
	2. Give the arsenal boxes a variable name (like "arsenalMedic" for example)
	3. Make the boxes invisible and/or hide them someone in the mission
	4. Follow the steps below to add each box to a role
	5. Don't forget to complete setup of the visible arsenals in config.sqf! (there's instructions there)
*/

//put your basic arsenal variable name here. It'll be the default arsenal for anyone that doesnt get a custom one.
private _arsenalBox = arsenal_4;

//iterate through possible roles and open the corresponding arsenal for each
switch (true) do
{

	//now, to add a box for a role, just uncomment the line of code (delete the "//") for their role and replace "exampleBoxName" with their arsenal box variable name
		//roles are provided for all the default units in the mission template, feel free to change them if you have different role descriptions and/or have placed additional units
		//for anyone experienced with coding, yes, fall-through does work in arma so feel free to modify the switch statement to use that if you want

	//cmd
	case ("Officer" in _roleDescriptionSimple): {
		private _arsenalBox = arsenal_5;
	};
	case ("JTAC" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case (("Combat Life Saver" in _roleDescriptionSimple) || ("Medic" in _roleDescriptionSimple) || ("medic" in _roleDescriptionSimple)): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Engineer" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

	//recon
	case ("Recon Team Leader" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Recon Paramedic" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Recon Demo Specialist" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Recon Sharpshooter" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

	//air
	case ("Pilot" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Copilot" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

	//armor
	case ("Commander" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Gunner" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Driver" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

	//squad (medic is in cmd section)
	case ("Squad Leader" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case (("Radioman" in _roleDescriptionSimple) || ("RTO" in _roleDescriptionSimple)): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Machinegunner" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Team Leader" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Autorifleman" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};
	case ("Rifleman (AT)" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

	//other, feel free to add more if you have custom names
	case ("Zeus" in _roleDescriptionSimple): {
		//private _arsenalBox = exampleBoxName;
	};

};

//open the corresponding arsenal for the _unit
[_arsenalBox, _unit] call ace_arsenal_fnc_openBox;