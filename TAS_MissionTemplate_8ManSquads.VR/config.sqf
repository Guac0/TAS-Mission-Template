///////////////////////////////////////////////////
///////////////Mission Maker Options///////////////
///////////////////////////////////////////////////

	/*
	Notes for options/configuration not present in this file:

		The AutoFactionArsenal script helps you make arsenals by generating an arsenal containing all items used by units for a given faction and then letting you edit what is contained in it.
			To view the autoFactionArsenal script helper description and instructions, see the file at \functions\scripts\autoFactionArsenal.sqf

		If you're adding custom hold actions to your mission, you might want to put them in functions\fn_applyHoldActions.sqf, which has support for re-applying the actions if arma eats them.

		To add a custom fortify preset, go to description.ext and follow the instructions there

		To use the automated reviewer, play the game and execute the following in the debug console:
			[] call TAS_fnc_automatedReviewer;

		Generally speaking, the default options are usually the best for the majority of missions.
	*/





//////////////////////////////////
/////Scripts/Functions Options////
//////////////////////////////////




	/* Blue Force Tracker
		Initiates Quicksilver's Blue Force Tracking on map/gps
			By default, marks all groups and players (not AI) on side, and colors people in your squad according to their team color
			Customize its settings in scripts/QS_icons if you want to
			*/
		TAS_bftEnabled 					= true; //default true


	/* 3d Group Icons
		Adds 3d icons over group leaders' heads for identification purposes, intended to be used during prep time.
			Automatically activates on mission start, zeus can enable/disable it with a zeus module
			It can also automatically disable after a certain time has passed or after players move away from the start zone
			TAS_3dGroupIcons enables/disables the whole system
			TAS_3dGroupIconsTime sets the time to wait from mission start to automatically disable the group icons.
				Set to 0 to disable.
				Do not enable both TAS_3dGroupIconsTime and TAS_3dGroupIconsRange! (enable = both are non-zero numbers)
			TAS_3dGroupIconsRange sets the range from AceHealObject to check for nearby players. If more players are beyond this range than players who are within this range, then the group icons are disabled.
				Set to 0 to disable.
				If enabled, requires AceHealObject to be present!
		*/
		TAS_3dGroupIcons 			= true; //default true
		TAS_3dGroupIconsTime		= 0;	//default 0
		TAS_3dGroupIconsRange		= 150;	//default 150


	/* Resupply Object
		Adds an "Create Resupply Box" action to a whiteboard that spawns the zeus resupply box on the parachute target object.
			Useful for allowing players to run logi without zeus intervention to create resupply box.
			Needs the "Create Resupply Box" whiteboard and "Resupply Spawn Helper" parachute jump target from mission.sqm to work
			TAS_resupplyObjectEnabled enables/disables it
		*/
		TAS_resupplyObjectEnabled 	= true; //default true


	/* Text Briefing
		Creates the standard 4 part briefing in the briefing section of the diary records.
			Functionally identical to creating a text briefing using the Eden modules or toolbars, just via an SQF file if you prefer to write it that way.
			By default it creates it for every player.
			See functions/fn_briefing.sqf to customize.
			*/
		TAS_textBriefing 			= false; //default false

	
	/* Arsenal Curate
		Removes certain problematic items from arsenal boxes that are otherwise hidden and unremoveable
			See functions/fn_arsenalCurate.sqf for full list and to add/remove your own custom items, but this is things like doomsday, hidden brightlights, LAGO superweapons, etc
				They usually get accidentally added by zeus hitting "add all compatible" to a custom arsenal, which adds invisible things too
			Arsenal boxes names must be arsenal_# from 1 to 10, template already gives you 1-3 premade and you can just copy paste those
			Only turn this to "false" if its a meme op and thus players should have extreme yield lights and doomsday and etc
		*/
		TAS_arsenalCurate 		= true; //default true

	
	/* Custom Object Mapper
		Draws black rectangles on all present custom buildings added to the mission. 
			See functions\fn_markCustomObjects for options. 
			Code from FNF.
		*/
		TAS_markCustomObjectsMap = false; //default false


	/* Buddy Blood Drawing
		Adds an action on each (alive) player's arms to draw 250mL of blood from them.
			Action only shows on the radial medical menu, not the advanced menu due to technical reasons.
			Add blood drawing to a custom unit by placing this code in their init:
				if (isServer) then { this remoteExec ["TAS_fnc_drawBlood",0,true]; };
			Customize shown text by going to function/fn_drawBlood.sqf if you want to use this for lore reasons
				If you want only your custom units to have the draw blood action, set TAS_allowBloodDrawing to 'false' and add it manually to the specified units with the above code.
		*/
		TAS_allowBloodDrawing	= true; //default true





//////////////////////////////////
/////////Inventory Options////////
//////////////////////////////////
	//just a general note, the template only contains ace arsenals for a reason. Usage of any other arsenal type may result in broken scripts/mods.



	/* TFAR Gear Assignment
		Manages TFAR radio assignment. (note: does not assign frequencies, that's handled by the tfar attributes on units in eden)
			TAS_radiosEnabled enables the whole radio giving system and will give all players the TAS_radioPersonal and all leadership players the TAS_radioBackpack in additional to the TAS_radioPersonal
			TAS_NoSquadleadLr enables giving backpack radios to RTOs (role description containing "Radioman" or "RTO") instead of Squad Leads (while still giving backpack radios to GC, vehicle crew, etc)
			TAS_radioAdditionals enables automatically setting up an additional channelon every player's short range radio (and sets main channel to left ear and additional channel to right ear)
			TAS_radioPersonal and TAS_radioBackpack are the classnames of the personal and backpack radios to give to players. Leaving TAS_radioBackpack empty will result in no radio backpacks being assigned.
			Note: leadership backpack radio assignment requires units to be set up according to standard role description naming conventions (done by default in the template)
			*/
		TAS_radiosEnabled 		= true; 				//default true
		TAS_NoSquadleadLr 		= true; 				//default true
		TAS_radioAdditionals 	= false; 				//default false
		TAS_radioPersonal 		= "TFAR_anprc152"; 		//default "TFAR_anprc152"
		TAS_radioBackpack 		= "TFAR_anprc155_coyote"; //default "TFAR_anprc155_coyote"


	/* Loadout from Config
		Assigns player loadouts via config
			It looks at the config files for the given faction and tries to match each player's Role Description with the name of a unit from that faction. If found, it gives them that unit's loadout, if not found, it gives them a Rifleman loadout from that faction
			Note that the actualy inventory items (stuff in uniform and vest and etc) of the player will be overwritten by TAS_populateInventory if that is enabled, but this will still set the clothing, weapons, etc
			To disable loadout assignment on a given unit while keeping the system enabled for other units, place the following in its init box:
				this setVariable ["TAS_disableConfigLoadoutAssignment",true];
			You can also manually set the loadout names if you don't want it to autodetermine based on the role description. To do this, put the following lines into the init box of the unit (it can have spaces, the underscores are just for easy selection and deletion):
				this setVariable ["TAS_overrideConfigLoadoutName","Display_name_of_unit_in_given_faction_whose_loadout_should_be_given_to_this_player"];

			TAS_useConfigLoadout enables/disables the whole system
			TAS_configLoadoutCustom enables/disables assigning override loadouts via the script menu in initPlayerLocal.sqf instead of via unit init boxes with the above code
			TAS_configFaction sets the target faction for loadout assignment.
				You can find the config name by placing a unit, right click, log, log faction classname to clipboard
			TAS_configUnitPrefix is the unit prefix, including space if necessary.
				Use it when your units are named like 'SF Rifleman', 'SF Team Leader' to avoid retyping, otherwise leave blank (it is NOT the mod prefix)
			TAS_defaultConfigUnit sets it so that if the player's role description doesn't match any unit in the faction, it falls back to this unit name for the loadout assignment
			TAS_configLoadoutNumber is for advanced users only. When multiple loadouts are found, use the # loadout found (zero-based)
			*/
		TAS_useConfigLoadout 	= false; 		//default false
		TAS_configLoadoutCustom	= false;		//default false
		TAS_configFaction 		= "BLU_F"; 		//default "BLU_F" (vanilla NATO)
		TAS_configUnitPrefix	= "";			//default ""
		TAS_defaultConfigUnit 	= "Rifleman"; 	//default "Rifleman"
		TAS_configLoadoutNumber = 0; 			//default 0


	/* Populate Inventory
		Automatically gives appropriate inventory items to players, loosely based on their role. Note: clears eden inventory before assigning the items (but doesn't change clothing or weapons)
			Medical: 16x basic bandages, 8x morphine, 3x TQs, 2x epi, 2x 500ml blood
				If medic, extra 40 basic bandages, 20 morphine, 15 epi, 6 TQs, 10x 500 ml blood, 6x 1000ml blood, 1x PAK
			Ammo: 4x standard primary mags, 4x special mags, 2x pistol mags (if have pistol), 2x launcher mags (if have launcher)
			Misc: 1x entrenching tool
			Grenades: 2x M67s, 2x white smoke, 1x purple smoke
			If engineer, gives 1x toolkit, 1x mine detector
			TAS_populateInventory enables/disables the whole system
			TAS_inventoryAddGps enables automatically putting a vanilla GPS item into each player's terminal slot (requires TAS_populateInventory to be set to true).
				Note that even if set to false players might have a GPS if it was a part of their EDEN inventories.
		Note: see initPlayerLocal.sqf in the custom equipment section if you want to add items for everyone or for only certain roles in addition to the items stated above
		*/
		TAS_populateInventory 	= true; //default true
		TAS_inventoryAddGps		= true;	//default true


	/* Role Based Arsenals
		Adds role-based ace arsenals. See the steps below for configuring.
			1. Make arsenal boxes in your mission for the various roles you want to have a special arsenal
			2. Give the arsenal boxes a variable name (like "arsenalMedic" for example)
			3. Make the boxes invisible and/or hide them someone in the mission
			4. Go to functions/fn_roleBasedArsenal.sqf and follow the steps there to assign each role to an arsenal box
			5. Make some box(es) and place them at the normal arsenal area and give them variable names
				these will be where players will have the action to open the arsenals. don't make these be arsenal boxes in Eden,
				the script will take care of automatically making them be the proper role-based arsenal depending on who opens them
			6. Edit TAS_visibleArsenalBoxes to contain the variable names (with quotation marks) of the boxes you've made at the player arsenal area to have the role-based arsenals
				note: these boxes should not actually have arsenals set for them
		*/
		TAS_roleBasedArsenals	= false; 						//default false
		TAS_visibleArsenalBoxes = ["arsenal_1","arsenal_2"]; 	//default ["arsenal_1","arsenal_2"]





//////////////////////////////////
/////////Respawns Options/////////
//////////////////////////////////



	/* Respawn Gear
		Determines the gear that players get upon respawning.
			Three choices:
				1. Respawning with vanilla config loadout (default in vanilla, not recommended. set both options to false to pick this option)
				2. Respawning with gear you had when you died (TAS_respawnDeathGear)
				3. Respawning with gear that you preset at the arsenal (TAS_respawnArsenalGear)
					For TAS_respawnArsenalGear, loadout is saved whenever the player exits the (ace) arsenal, and there's also an option to manually save your loadout at the AceHealObject
		*/
		TAS_respawnDeathGear 	= false; 	//default false --- DO NOT SET BOTH respawnDeathGear AND respawnArsenalGear to true!!!
		TAS_respawnArsenalGear 	= true; 	//default true


	/* Spectator Options
		Makes players respawn in ACE spectator.
			Recommended to be enabled whenever you're using anything with a timer for reinserts (respawn vehicle, wave respawns, FOB system).
				To clarify, "anything with a timer" does not include the vanilla respawn timer.
				It must be enabled for the various respawn systems included within the template to work correctly.
			Can be edited midgame via the Zeus "Manage ACE Spectator Options" module.
			TAS_respawnSpectator enables/disables respawning in spectator
			TAS_respawnSpectatorForceInterface enables/disables it so that player cannot leave spectator early.
				Disable it to allow them to close spectator and access the arsenal box or whatever while they wait.
			TAS_respawnSpectatorHideBody hides the player's body while they are in spectator.
			TAS_respawnSpectatorTime is the time (in seconds) that the respawn screen lasts before showing the player the appropriate reinsert options.
				If TAS_respawnSpectatorForceInterface is set to false, it will still continue counting when players choose to leave the interface on their own
				When it is set to 0, then spectator time is infinite. Good for one-life ops (combine it with setting "TAS_respawnSpectatorForceInterface = true" to keep dead players in spectator forever).
				Ignored if TAS_waveRespawn is enabled.
		*/
		TAS_respawnSpectator 				= false; 	//default false
		TAS_respawnSpectatorForceInterface 	= false; 	//default false
		TAS_respawnSpectatorHideBody 		= true; 	//default true
		TAS_respawnSpectatorTime 			= 30; 		//default 30


	/* Wave Respawns
		Does wave respawns, aka reinserts all dead players at once every set interval of time instead of them individually reinserting
			TAS_waveRespawn enables/disables the whole system.
			TAS_waveTime sets the time between each respawn wave.
				It can take up to 5-10 seconds for all players to respawn, and respawning is available for a 20 second window as a grace period after each respawn wave.
				It overwrites TAS_respawnSpectatorTime if TAS_waveRespawn is enabled.
		*/
		TAS_waveRespawn		= false;	//default false
		TAS_waveTime		= 300;		//default 300 (5 minutes)


	/* Respawn in Vehicle
		Adds the ability to reinsert through being teleported into the reinsert vehicle.
			Uses a GUI to allow the player which vehicle to reinsert in if multiple are available.
			After respawning, it forces the player to wait the specified duration (while either spectating/editing loadout/chilling in base) before being shown the reinsert menu
				TAS_respawnSpectator is recommended to be enabled with this system, and TAS_respawnSpectatorTime is used for the duration of the wait.
			There are 3 methods for adding a reinsert vehicle:
				1. In eden, give a vehicle any variable name and place the below code in its init box. Change "Respawn Vehicle 1" to whatever you want the vehicle to be named.
						if (isServer) then {
							[this,"Respawn Vehicle 1"] spawn TAS_fnc_assignRespawnVicInit;
						};
				2. Using the Zeus module called "Assign As Respawn Vehicle" under the "TAS Mission Template" category by placing it on a vehicle and changing the options shown on it as needed
				3. If no vehicles are configured as being reinsert vehicles within 30 seconds of mission start, then the mission template will automatically add the vehicle with
					a variable name of "logistics_vehicle" as a reinsert vehicle with the name "Default Respawn Vehicle".
			TAS_respawnInVehicle enables/disables the whole system.
		*/
		TAS_respawnInVehicle 	= false; //default false


	/* FOB System
		Manages the FOB system, which give the players the ability to establish FOBs and use them for reinserts.
			The FOB consists of an action on the vehicle in the mission named "logistics_vehicle" which leadership players (GC members, SLs) can use
				The action places a FOB around them, featuring ammo boxes, vehicle RRR crates, and some defensive structures (about 40 meters in diameter)
			TAS_respawnSpectator is recommended to be enabled with this system, and TAS_respawnSpectatorTime is used for the duration of the wait before people are shown the respawn menu.
		*/
		/*
		FOB Basic Settings
			TAS_fobEnabled enables/disables the basic FOB operation.
			TAS_fobPackup enables/disables the ability for players to repack the FOB and place it again elsewhere
			TAS_fobFullArsenals enables/disables the placing of full arsenals at the FOB. If disabled, they instead contain medical supplies and ammo for each player's weapons
			TAS_fobDistance sets the distance from the logistics_vehicle that has to be clear of enemies in order for the FOB to be successfully placed
			TAS_fobRespawn enables/disables adding a vanilla respawn position at the FOB in addition to adding it to the respawn GUI
				You might want to disable this if you want players to spawn at main and then use the respawn GUI to respawn at the FOB

			To change the FOB layout, modify buildfob/fobComposition.sqf
		*/
		TAS_fobEnabled 			= false; 	//default false
		TAS_fobPackup			= false;	//default false
		TAS_fobFullArsenals 	= false; 	//default false
		TAS_fobDistance 		= 300; 		//default 300 meters
		TAS_fobRespawn			= false;	//default false

		/*
		FOB Overrun Settings
			The overrun sequence (if enabled) activates when more enemies than friendlies (adjusted by TAS_fobOverrunFactor) are within TAS_fobDistance of the FOB.
				It gives the players TAS_fobOverrunInterval to kill enough enemies to bring them back under the threshold. If this is not done in time, then the FOB is destroyed.

			TAS_fobOverrun enables/disables the ability for the FOB to be overrun.
			TAS_fobOverrunDestroy enables/disables the destroying all FOB objects when FOB is overrun (may cause mild damage to units nearby)
				does not destroy ammoboxes but does remove arsenals
			TAS_fobOverrunFactor determines how many more enemies than friendlies have to be in TAS_fobDistance of the FOB to begin the overrun sequence.
				i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
			TAS_fobOverrunMinEnemy sets the minimum number of enemies nearby to start/continue the overrun
			TAS_fobOverrunTimer is the time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
			TAS_fobOverrunInterval determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of TAS_fobOverrunTimer.
				Values larger than 30 will result in the message fading out between updates
		*/
		TAS_fobOverrun			= false;	//default false
		TAS_fobOverrunDestroy	= true;		//default true
		TAS_fobOverrunFactor	= 2;		//default 2
		TAS_fobOverrunMinEnemy	= 8;		//default 8
		TAS_fobOverrunTimer		= 300;		//default 300 (5 min)
		TAS_fobOverrunInterval	= 30;		//default 30 (1 min)


	/* Rallypoint System
		Manages the Rallypoints system, which give the players the ability to establish Rallypoints and use them for reinserts.
			It lets all Squad leaders, GC leader, and Recon leader place Rallypoints via an ace self action, which become reinsert positions for the respawn GUI.
				It also spawns a small campsite at the rallypoint's location and makes a marker appear on map.
			TAS_respawnSpectator is recommended to be enabled with this system, and TAS_respawnSpectatorTime is used for the duration of the wait before people are shown the respawn menu.
			You can change what the rallypoint looks like by modifying buildfob/rallypointComposition.sqf or buildfob/rallypointSmallComposition.sqf
			By default, only players with "Squad Leader" and their squad name in their role description will get the rallypoint. Change this in buildfob/fn_initRallypoints.sqf
				Recon just needs "Leader" and "Recon", and GC accepts several variations on "Leader", "Officer", etc as long as "GC", "Command Element", "Ground Command" is also included.
		*/
		/*
		Rallypoint Basic Settings
			TAS_rallypointsEnabled enables/disables the entire system.
			TAS_useSmallRally enables/disables using the small rally. The small rally is slightly smaller than the regular rally and lacks the supply crate that the regular rally has
			TAS_rallyDistance sets the distance that if enemies are within then rallypoint cannot be created
			TAS_rallyOutnumber enables/disables using outnumbering instead of just any enemies being within TAS_rallyDistance. If enabled, more enemies than friendlies must be within TAS_rallyDistance to fail the rallypoint placement. If false, if any enemies are present then rallypoint creation fails.
		*/
		TAS_rallypointsEnabled	= false;	//default false
		TAS_useSmallRally 		= true; 	//default true
		TAS_rallyDistance 		= 150; 		//default 150 meters
		TAS_rallyOutnumber 		= true; 	//default true

		/*
		Rallypoint Overrun Settings
			The overrun sequence (if enabled) activates when more enemies than friendlies (adjusted by TAS_rallyOutnumberFactor) are within TAS_rallyDistance of a rally.
				It gives the players TAS_rallyOverrunTimer to kill enough enemies to bring them back under the threshold. If this is not done in time, then the rally is destroyed.

			TAS_rallypointOverrun enables/disables the overrun system for rallypoints.
			TAS_rallyOutnumberFactor determines how many more enemies than friendlies have to be in TAS_rallyDistance of the rally to begin the overrun sequence
				i.e. a value of 2 makes it so enemies must outnumber friendlies 2 to 1
			TAS_rallyOverrunMinEnemy sets the minimum number of enemies nearby to start/continue the overrun
			TAS_rallyOverrunTimer is the time it takes for overrun to complete (friendlies can kill enemies to cancel it midway)
			TAS_rallyOverrunInterval  determines how often the overrun status is checked and/or broadcast to players. Must be a divisor of TAS_rallyOverrunTimer.
				Values larger than 30 will result in the message fading out between updates
		*/
		TAS_rallypointOverrun 		= false;	//default false
		TAS_rallyOutnumberFactor 	= 2;		//default 2 
		TAS_rallyOverrunMinEnemy	= 4;		//default 4
		TAS_rallyOverrunTimer		= 90;		//default 90 (1.5 min)
		TAS_rallyOverrunInterval 	= 15;		//default 15










//////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Advanced Options/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
	/*

	Below you can find various options that are not included in the main list for one of three reasons:
		1. It is illogical to change these settings from the defaults
			For example, they manage adding various zeus modules required to manage other systems enabled in the regular template options, or are just handy in general
			Some, like TAS_aceHealObjectEnabled, are intended to be always enabled even if you don't include the relevant objects from the mission.sqm because 
				they are capable to automatically detecting when they are not required (i.e. you delete the object the resupply creator is attached to)
		2. They have either extremely advanced usage cases that only Guac uses, or are settings for developer work on the template/versioning
			For example, TAS_spawnUnitsOnHC and TAS_templateVersion respectively
		3. They are WIP or known to be broken features which default to disabled. Use at your own risk.
			These are rare and are marked as "feature temp removed", "doesn't work", or "probably works but not promises and rare usage case anyways"

		TL;DR: don't scroll down unless you know what you're doing, have been instructed to do so, or are very curious.

	*/


	/* Shortlist of options below that are enabled by default, in (roughly) the order that they appear:
			ace heal object
			ace spectate object
			disabling vanilla stamina
			clean briefing of disabled template systems
			dynamic groups
			global TFAR
			FPS display
			trim group names
			fix team color on death and respawn
			adds various zeus modules
			adds client keys for AFK, music mute, and earplugs
			discord update
			track all clients performance
			does mod log of unallowed mods
		*/





	//////////////////////////////////
	////Scripts/Functions Options/////
	//////////////////////////////////



		/* AceHealObject
			Manages actions tied to the 'AceHealObject' in the mission
				TAS_aceHealObjectEnabled adds a hold action to it that gives an Ace Heal to all players within a certain radius when activated
				TAS_aceSpectateObjectEnabled adds a hold action to it that puts the player into acespectator mode
				*/
			TAS_aceHealObjectEnabled 		= true; //default true
			TAS_aceSpectateObjectEnabled 	= true; //default true


		// boss
			//see functions/fn_handleDamage for health value config
			TAS_bossEnabled = true;
			TAS_bossImagePath = "media/logo256x256.paa";







	//////////////////////////////////
	//////////Misc Options////////////
	//////////////////////////////////



		//Disables vanilla stamina at mission start and on player respawn.
		TAS_vanillaStaminaDisabled = true; //defaults to true
		//publicVariable "TAS_vanillaStaminaDisabled";


		//probably works now but no promises
		//Modifies weapon sway (well, aim precison) coefficient and recoil coefficient. 1 is normal, 0 is nothing (but don't use 0, use 0.1)
		TAS_doAimCoefChange 	= false; 	//default false
		TAS_aimCoef 	  		= 0.5;		//default 0.5; no effect if TAS_doCoefChanges is FALSE
		TAS_recoilCoef 	  		= 0.75;		//default 0.75; no effect if TAS_doCoefChanges is FALSE
		//publicVariable "TAS_doAimCoefChange";
		//publicVariable "TAS_aimCoef";
		//publicVariable "TAS_recoilCoef";


		//automatically assign appropriate ctab items, for SL rugged tablet assignment needs preset variable names for SLs (see template)
		//if SL names are not preset, then will just give them rifleman stuff without error message. Better than nothing.
		//Required Mods: CTAB
		TAS_ctabEnabled 		= false; //default false (since ctab isnt in scifi modpack)
		//publicVariable "TAS_ctabEnabled";





	//////////////////////////////////
	////////Template Options///////////
	//////////////////////////////////



		TAS_templateVersion 	= 11.11; //if it's a major release (like 10.0), note that arma will truncate the empty decimal to just '10'
		//publicVariable "TAS_templateVersion";


		TAS_doTemplateBriefing 	= true;
		//publicVariable "TAS_doTemplateBriefing";
		TAS_templateBriefing = [
			"1. Added new medical items to medic inventory population (Splints and AED).",
			"2. Added buddy blood drawing to each player's arms (only in radial medical menu, not advanced medical menu).",
			"3. Added custom objects mapper (if enabled by Zeus).",
			"4. Other zeus-side fixes and improvements.",
			"Known issues: Respawn In Vehicle has approximately a 5% change to not work when you try to click the button. Fix is WIP.",
			"Please visit the 'Mission Template' section in the mission notes (in the top left of the map screen) to be aware of the enabled toggleable features present in this mission, and check your custom keybindings for the 'TAS Mission Template' section to access the various custom keybinds we have.",
			"You will only receive this message once every time you join a mission with a new mission template version. Enjoy the mission!"
		];
		//publicVariable "TAS_templateBriefing"; //is probably a problematically-large var to share 


		//Cleans the mission template briefing by removing diary records for options set to FALSE
		TAS_cleanBriefing 			= true; //default true. true to enable, false to disable.
		//publicVariable "TAS_cleanBriefing"; //don't touch the //publicVariable lines





	//////////////////////////////////
	////////Scripts Options///////////
	//////////////////////////////////



		//Special logic in init.sqf for spawning AI directly on HCs. Advanced usage only and requires extensive setup. Do not touch unless Guac tells you to.
		TAS_spawnUnitsOnHC 		= false; //default false
		//publicVariable "TAS_spawnUnitsOnHC";


		//turn TAS_globalTFAR on/off, if on then make sure you have a way to activate it (i recommend a trigger, see template)
		//Required Mods: TFAR
		TAS_globalTfarEnabled 		= true; //default true, no effect if you dont call it using the trigger or a script
		//publicVariable "TAS_globalTfarEnabled";


		//Enables the Dynamic Groups system.
		TAS_dynamicGroupsEnabled 	= true; //default true
		//publicVariable "TAS_dynamicGroupsEnabled";


		//Displays markers in the bottom left of the map that display the server's and HC's FPS and number of local groups/units
		//might be desirable to turn off if you don't want players to see
		TAS_fpsDisplayEnabled 	= true; //default true
		//publicVariable "TAS_fpsDisplayEnabled";


		//attempts to solve people losing their team color after death by reapplying it on respawn
		TAS_fixDeathColor		= true; //default true
		//publicVariable "TAS_fixDeathColor";


		//trims player group names to get rid of the extra spaces added by the template's need for duplicate group names
		TAS_trimGroupNames 		= true;
		//publicVariable "TAS_trimGroupNames";





	//////////////////////////////////
	///////Logistics Options//////////
	//////////////////////////////////



		//FEATURE TEMP REMOVED
		//Enables the KP crate filler script, see "KPCF_config" for options 
		//NOTE: With default settings, it will add custom behavior to ALL "Land Parachute Target" and "Seismic Map (Whiteboard)" objects in your mission. Disable this setting or change the target objects in KPCF_config if you are using those objects in your mission.
		//TAS_kpCratefiller = true;	//default true
		////publicVariable "TAS_kpCratefiller";





	//////////////////////////////////
	//////////Zeus Options////////////
	//////////////////////////////////



		//Adds two custom resupply modules to Zeus
		//Each has 6 magazines of each player's weapon and a bunch of medical
		//One spawns the crate at cursor location, other paradrops it (watch for wind!)
		//Find the modules under the "Resupply" section in Zeus
		//Required Mods: ZEN
		TAS_zeusResupply 		= true; //default true
		//publicVariable "TAS_zeusResupply";


		//Adds zeus module to play info text
		TAS_zeusInfoText 		= true; //default true
		//publicVariable "TAS_zeusInfoText";


		//Adds zeus modules for manually managing group ownership
		TAS_zeusHcTransfer 		= true; //default true
		//publicVariable "TAS_zeusHcTransfer";


		//allows zeus to trigger an automatic debug and cleanup of hold actions available in the mission
			//for example, try placing it when people complain that the heal box doesn't work anymore
		TAS_zeusActionDebug		= true; //default true
		//publicVariable "TAS_zeusActionDebug";


		//adds two modules for zeus to manage spectator settings and to apply spectator to units
		TAS_zeusSpectateManager	= true; //default true
		//publicVariable "TAS_zeusSpectateManager";


		//adds a module for zeus to delete all empty groups and mark occupied groups as eligible for deletion once they are empty
		TAS_zeusGroupDeletion 	= true; //default true
		//publicVariable "TAS_zeusGroupDeletion";


		//adds a module to zeus to run the marker follow script
		TAS_zeusFollowMarker 	= true; //default true
		//publicVariable "TAS_zeusFollowMarker";


		//add module to zeus to enable RRR zone script on placed unit
		TAS_zeusServiceVehicle 	= true; //default true





	//////////////////////////////////
	//Client Hotkeys/Actions Options//
	//////////////////////////////////



		//Script by IndigoFox that adds an ace interact to all windows which breaks them upon use.
		//Source: https://www.reddit.com/r/armadev/comments/sv72xa/let_your_players_break_windows_using_ace/?utm_source=share&utm_medium=ios_app&utm_name=iossmf
		TAS_aceWindowBreak 		= false; //default false
		//publicVariable "TAS_aceWindowBreak";


		//hotkey to turn afk script on/off
		//Required mods: CBA
		TAS_afkEnabled 			= true; //default true
		//publicVariable "TAS_afkEnabled";


		//hotkey to turn earplugs script on/off
		TAS_earplugsEnabled 	= true; //default true
		TAS_earplugVolume 		= 0.25; //volume to reduce to when earplugs are in (0 is no volume, 1 is regular). Applies to fadeSound, fadeRadio, fadeSpeech, fadeMusic, and fadeEnvironment.
		//publicVariable "TAS_earplugsEnabled";
		//publicVariable "TAS_earplugVolume";


		//adds a hotkey to mute/unmute music
		TAS_musicKeyEnabled 	= true; //default true
		//publicVariable "TAS_musicKeyEnabled";





	//////////////////////////////////
	//////////Admin Options///////////
	//////////////////////////////////
		//these options are more geared towards logging or other admin actions and should be left at their defaults unless you know what you're doing 



		//logging information for certain mods, with optional chat messages
		TAS_ModLog 				= true;	//default true
		TAS_ModLogShame 		= true; //default true
		//publicVariable "TAS_ModLog";
		//publicVariable "TAS_ModLogShame";


		//tracks various performance statistics for each client and sends the results to the server
		TAS_trackPerformance 	= true; //default true, customize specific settings in initPlayerLocal.sqf
		//publicVariable "TAS_trackPerformance";


		//adds a custom rich presence for people running the discord rich presence mod
		TAS_doDiscordUpdate		= true; //default true
		TAS_discordUpdateDelay 	= 30; 	//default 30
		//publicVariable "TAS_doDiscordUpdate";
		//publicVariable "TAS_discordUpdateDelay";





//note: player == null in preinit