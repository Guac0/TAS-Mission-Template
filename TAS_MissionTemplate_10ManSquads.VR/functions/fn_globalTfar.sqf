//TAS_globalTFAR scruot by Guac
//sets all players' short range radios' to alternate channel for zeus to broadcast on
//call it a second time to undo the changes
//defined as a script in initPlayerLocal.sqf
//example: remoteExecCall ["TAS_fnc_globalTfar", 2]; //Executed only on the server
//rewrite as remoteExec here?

//diary entry and fail message in initPlayerLocal

if !(isServer) exitWith { diag_log format ["Exiting TAS_fnc_globalTFAR: only server can run this function!"]; }; //only server should run this due to remoteExecs

private _headlessClients = entities "HeadlessClient_F";
private _humanPlayers = allPlayers - _headlessClients;

//setup variable if not previously made. Default to false
private _playerRadiosAreGlobal = missionNamespace getVariable ["playersRadioGlobal", false];
diag_log format ["Running TAS_globalTfar on server. Current playersRadioGlobal value: %1",_playerRadiosAreGlobal];

if (_playerRadiosAreGlobal == false) then { //if player has not had radio set to global most recently then cache current additional data and set additional to global
	
	[[],{
		private _activeSwRadio = call TFAR_fnc_ActiveSwRadio;
		private _originalAdditionalChannel = _activeSwRadio call TFAR_fnc_getAdditionalSwChannel;
		private _originalAdditionalStereo = _activeSwRadio call TFAR_fnc_getAdditionalSwStereo;
		player setVariable ["originalAdditionalChannel", _originalAdditionalChannel];
		player setVariable ["originalAdditionalStereo", _originalAdditionalStereo];
		[_activeSwRadio, 8, "87"] call TFAR_fnc_SetChannelFrequency; //these two lines determine global channel and frequency, freq is the max freq LRs can go to
		[_activeSwRadio, 7] call TFAR_fnc_setAdditionalSwChannel; //lower by 1 cause internally this fnc is zero-based
		[_activeSwRadio, 0] call TFAR_fnc_setAdditionalSwStereo;
		player setVariable ["playersRadioGlobal", true];
		
		diag_log format ["TAS_fnc_globalTFAR applied successfully."];
	}] remoteExec ["spawn",_humanPlayers];

	missionNamespace setVariable ["playersRadioGlobal", true];

} else { //if radio is already global, then undo it back to the cached settings
	
	[[],{
		private _activeSwRadio = call TFAR_fnc_ActiveSwRadio; //do this again because private var would be stuck in the then section
		[_activeSwRadio, (player getVariable "originalAdditionalChannel")] call TFAR_fnc_setAdditionalSwChannel;
		[_activeSwRadio, (player getVariable "originalAdditionalStereo")] call TFAR_fnc_setAdditionalSwStereo;
		player setVariable ["playersRadioGlobal", false];
		
		diag_log format ["TAS_fnc_globalTFAR undone successfully."];
	}] remoteExec ["spawn",_humanPlayers];

	missionNamespace setVariable ["playersRadioGlobal", false];

};



/*
if ( _playerRadiosAreGlobal == false) then { //if player has not had radio set to global most recently then cache current additional data and set additional to global
			private _activeSwRadio = call TFAR_fnc_ActiveSwRadio;
			private _originalAdditionalChannel = _activeSwRadio call TFAR_fnc_getAdditionalSwChannel;
			private _originalAdditionalStereo = _activeSwRadio call TFAR_fnc_getAdditionalSwStereo;
			player setVariable ["originalAdditionalChannel", _originalAdditionalChannel];
			player setVariable ["originalAdditionalStereo", _originalAdditionalStereo];
			[_activeSwRadio, 8, "87"] call TFAR_fnc_SetChannelFrequency; //these two lines determine global channel and frequency, freq is the max freq LRs can go to
			[_activeSwRadio, 7] call TFAR_fnc_setAdditionalSwChannel; //lower by 1 cause internally this fnc is zero-based
			[_activeSwRadio, 0] call TFAR_fnc_setAdditionalSwStereo;
			player setVariable ["playersRadioGlobal", true];
			//systemChat "TAS_fnc_globalTFAR applied successfully.";
		} else { //if radio is already global, then undo it back to the cached settings
			private _activeSwRadio = call TFAR_fnc_ActiveSwRadio; //do this again because private var would be stuck in the then section
			[_activeSwRadio, (player getVariable "originalAdditionalChannel")] call TFAR_fnc_setAdditionalSwChannel;
			[_activeSwRadio, (player getVariable "originalAdditionalStereo")] call TFAR_fnc_setAdditionalSwStereo;
			player setVariable ["playersRadioGlobal", false];
			//systemChat "TAS_fnc_globalTFAR undone successfully.";
		};
*/

/*{
    {
        // sleep until the player has a SW radio assigned
        waitUntil {(call TFAR_fnc_haveSWRadio)};

        // change active SW radio to channel 2
        [call TFAR_fnc_activeSwRadio, 2] call TFAR_fnc_setSwChannel;
        // change the frequency for channel 2 to 76.2
        [call TFAR_fnc_activeSwRadio, "76.2"] call TFAR_fnc_setSwFrequency;
        // set channel 2 as the 'additional' channel (0-index chan number here)
        [(call TFAR_fnc_activeSwRadio), 1] call TFAR_fnc_setAdditionalSwChannel;
        // set active SW radio back to channel 1
        [call TFAR_fnc_activeSwRadio, 1] call TFAR_fnc_setSwChannel;
    } remoteExec ["call", _x]; // remoteExec this on each of the players
} forEach _humanPlayers;*/