/* WOLFENSWAN's SIMPLE SPAWN SYSTEM */

// Use BI's Dynamic Simulation (if enabled)?
ws_var_useDynamicSim = true;

// Check if client is a headless client
_isHC = [] call ws_fnc_checkHC;
_useHC = param [0, false];
["ws_sss_spawnDone",false,true] call ws_fnc_setGVar;

if (ws_sss_spawnDone) exitWith {};

systemchat format["sss_init step 1: %1,%2",_isHC,_useHC];

// Execute the script
if ((!_useHC && isServer) || (_useHC && _isHC)) then {
	systemchat format["sss_init step 2: %1,%2",_isHC,_useHC];

	// Include all relevant files
	#include "ws_sss_functions.sqf"
	#include "ws_sss_processlogics.sqf"
	#include "ws_sss_spawn.sqf"
};
// Code to be executed after spawning:
waitUntil {sleep 0.1;ws_sss_spawnDone};
systemchat format["sss_init step 3: %1,%2",_isHC,_useHC];

if !(isServer) exitWith {};

// Check if F3 AI Skill Selector is active and process the new units
if({!isNil _x} count ["f_param_AISkill_BLUFOR","f_param_AISkill_INDP","f_param_AISkill_OPFOR"] > 0) then {
    [] execVM "f\setAISKill\f_setAISkill.sqf";
};