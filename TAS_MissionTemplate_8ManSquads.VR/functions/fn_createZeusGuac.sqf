//from Bassbeard's Wonder Emporium, modified
private _moduleGroup = createGroup sideLogic; 
"ModuleCurator_F" createUnit [ 
	[0,0,0], 
	_moduleGroup, 
	"this setVariable ['owner', '#adminLogged', true]; this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];" 
];