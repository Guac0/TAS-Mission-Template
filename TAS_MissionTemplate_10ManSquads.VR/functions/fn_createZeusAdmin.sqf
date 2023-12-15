//from Bassbeard's Wonder Emporium
private _moduleGroup = createGroup sideLogic; 
"ModuleCurator_F" createUnit [ 
	[0,0,0], 
	_moduleGroup, 
	"this setVariable ['owner', '76561198234172740', true]; this setVariable ['BIS_fnc_initModules_disableAutoActivation', false, true];" 
];