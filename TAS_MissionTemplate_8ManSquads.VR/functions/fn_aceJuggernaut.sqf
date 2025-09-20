/*
	Original Author: Bassbeard [Bassbeard's Wonder Emporium, https://docs.google.com/document/d/1sRuHz3H7lfLn9LZcuwL286LxCamu5XlTjhkIJH0wvYY/edit#heading=h.spr0qi8668em]
	Additional Work: Guac

	Requirements: ACE Medical
	
	Description:
	Makes provided unit be invincible until they have suffered damage X times.
	By default, unit immediately dies once they have suffered damage X times,
		but optionally system can merely disable invincibility after taking
		damage X times instead of outright killing the unit.
		Note: disabling instadeath is recommended if using juggernaut for players.
	Includes visual feedback (in fancy hint form) upon startup and upon taking
		damage if the juggernaut is the local player.
	Execute locally on the machine owner of the juggernaut unit.

	Return: true

	Examples: (RemoteExec is preferred if you can't guarantee the locality of the affected unit)
	[_unit,10] call TAS_fnc_aceJuggernautAI;
	[_unit,10] remoteExec ["TAS_fnc_aceJuggernautAI",_unit];
	[_unit,10,false] call TAS_fnc_aceJuggernautAI;
	[_unit,10,false] remoteExec ["TAS_fnc_aceJuggernautAI",_unit];
*/

params ["_unit","_hitsBeforeDepletion",["_instaKillOnDepletion",true],["_playMusic",false],["_changeLoadout",true],["_wbkDisableHitReactions",false]];

if (_unit getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",0] > 0) exitWith {
	[format ["fn_aceJuggernaut: unit %1 already has a juggernaut script applied, ignoring new juggernaut script addition!",_unit]] call TAS_fnc_error;
};

private _isPlayer = false;
if (_unit == player) then {
	_isPlayer = true;
};

_unit call ACE_medical_treatment_fnc_fullHealLocal;
_unit allowDamage false;
_unit addEventHandler ["HandleDamage",{0}];
_unit removeAllEventHandlers "HitPart";
_unit setVariable ["TAS_fnc_juggernautHitsBeforeDepletion",_hitsBeforeDepletion]; 
_unit setVariable ["TAS_fnc_juggernautInstaKillOnDepletion",_instaKillOnDepletion];

if !(_wbkDisableHitReactions) then {
	_unit setVariable ["WBK_DAH_DisableAnim_Hit",1,true]; //not sure if it needs to be global
};

// loadout
if (_changeLoadout) then {
	//Kord, RHS, LOP
	//_unit setUnitLoadout [["KLT_Kord_6T19","","","",["50Rnd_KORD_127x108_mag_Tracer",50],[],""],[],["rhsusf_weap_MP7A2_folded","","ACE_DBAL_A3_Green","",["rhsusf_mag_40Rnd_46x30_FMJ",40],[],""],["LOP_U_IRA_Fatigue_GRK_BLK",[["rhsusf_mag_40Rnd_46x30_FMJ",7,40],["rhs_mag_m67",6,1]]],["TAC_Punisher_Vest_BK",[["rhs_mag_m67",1,1],["50Rnd_KORD_127x108_mag_Tracer",1,50]]],["O_mas_chi_Kitbag_b2",[["rhs_mag_m67",2,1],["50Rnd_KORD_127x108_mag_Tracer",3,50]]],"TAC_K6C","BalaclavaBallisticRed_Black_EPSM",[],["ItemMap","","","ItemCompass","ItemWatch","BMS_Nomex_1"]];
	//vanilla, with helmet and nades from RHS and vest from JCA
	_unit setUnitLoadout [["MMG_02_black_F","","ACE_DBAL_A3_Red","optic_ACO_grn_smg",["130Rnd_338_Mag",130],[],"bipod_03_F_blk"],[],["Knife_kukri","","","",[],[],""],["U_O_R_Gorka_01_black_F",[["ACE_elasticBandage",5],["ACE_packingBandage",5],["ACE_epinephrine",2],["kat_chestSeal",2],["ACE_morphine",2],["ACE_splint",2],["ACE_tourniquet",4],["kat_phenylephrineAuto",2],["ACE_Chemlight_HiRed",5,1],["Chemlight_red",4,1]]],["JCA_V_CarrierRigKBT_01_heavy_black_F",[["ACE_CTS9",4,1],["rhs_mag_an_m14_th3",3,1],["rhs_grenade_m15_mag",1,1],["SmokeShellRed",4,1],["HandGrenade",4,1]]],["B_ViperHarness_blk_F",[["130Rnd_338_Mag",5,130]]],"rhsusf_hgu56p_visor_mask_black_skull","G_Bandanna_Syndikat1",["","","","",[],[],""],["ItemMap","ItemGPS","TFAR_anprc152","ItemCompass","ItemWatch",""]];
};

if (_isPlayer) then {
	private _msg = format ["<br/><t color='#cc6600' size='3' align='center'>Welcome to the Juggernaut Assault Suit</t><br/><br/><t color='#ff0000' size='2' align='center'>The Juggernaut Suit will allow you to take %1 hits without any adverse affects.</t><br/><br/>",_hitsBeforeDepletion]; 
	if (_instaKillOnDepletion) then {
		_msg = _msg + (format ["<t color='#ff5050' size='2' align='center'>Once your suit is depleted, you will instantly die from the strain of being hit so many times!</t><br/><br/>"]);
	} else {
		_msg = _msg + (format ["<t color='#ff5050' size='2' align='center'>Once your suit is depleted, you will no longer retain any benefits from it.</t><br/><br/>"]);
	};
	_msg = parseText (_msg);
	hint _msg;
};

_unit addEventHandler ["Killed", { //sometimes didnt remove for players. could wrap in isPlayer.
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	_target allowDamage true;
	_target removeAllEventHandlers "HandleDamage";
	_target setVariable ["TAS_isPlayerJuggernaut",false];
}];

_unit addEventHandler ["HitPart", {
	(_this select 0) params ["_target", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect"]; 
	
	private _isPlayer = false;
	if (_target == player) then {
		_isPlayer = true;
	};
	_hitsLeft = _target getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",10];
	_hitsLeft = _hitsLeft - 1;
	_target setVariable ["TAS_fnc_juggernautHitsBeforeDepletion",_hitsLeft];
	
	//hint format ["%1 has been hit %2 times",name _target,_hits];
	if (_hitsLeft < 1) then { 
		if (_target getVariable ["TAS_fnc_juggernautInstaKillOnDepletion",false]) then {
			_target allowDamage true;
			_target removeAllEventHandlers "HandleDamage";
			_target setVariable ["TAS_isPlayerJuggernaut",false];

			_target setdamage 1;
		} else {
		
			_target allowDamage true;
			_target removeAllEventHandlers "HandleDamage";
			_target setVariable ["TAS_isPlayerJuggernaut",false];

			if (_isPlayer) then {
				[_target] remoteExec ["TAS_fnc_playerJuggernautStopEffects",_target];
			};
		};
	} else {
		_target call ACE_medical_treatment_fnc_fullHealLocal;

		if (_isPlayer) then {
			private _msg = format ["<br/><t color='#ff5050' size='2' align='center'>You've been hit!</t><br/><br/><t color='#cc6600' size='2' align='center'>Hits remaining: %1</t><br/><br/>",_target getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",10]]; 
			_msg = parseText (_msg);
			hintSilent _msg;
		};
	};

}];

/*private _audioObject = createVehicle ["RoadCone_F",getPosASL _unit,[],0,"CAN_COLLIDE"];
_audioObject hideObjectGlobal true;
_audioObject allowDamage false;
_audioObject attachTo [_unit,[0,0,1.5]];
[_audioObject,_unit] spawn {
	params ["_audioObject","_unit"];
	private _trackNumber = 1;
	while {_unit getVariable ["TAS_isPlayerJuggernaut",false]} do {
		playSound3D [getMissionPath (format ["media\JuggernautSound%1.ogg",_trackNumber]), _audioObject, true];
		_trackNumber = _trackNumber + 1;
		if (_trackNumber > 4) then {_trackNumber = 1;};
		sleep 89;
	};
};*/
if (_playMusic) then {
	[_unit] spawn {
		params ["_unit"];
		private _trackNumber = 1;
		while {_unit getVariable ["TAS_fnc_juggernautHitsBeforeDepletion",0] > 0} do {
			private _track = format ["JuggernautSound%1",_trackNumber];
			//private _soundObject = _unit say3d (format ["JuggernautSound%1",_trackNumber]);
			//_unit setVariable ["TAS_juggernautSoundObject",_soundObject];
			[_unit,_track] remoteExec ["say3D"];
			_trackNumber = _trackNumber + 1;
			if (_trackNumber > 4) then {_trackNumber = 1;};
			sleep 89;
		};
	};
};

true