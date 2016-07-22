/* WOLFENSWAN's SIMPLE SPAWN SYSTEM */

// Check if client is a headless client
ws_var_isHC = [] call ws_fnc_checkHC;
ws_var_useHC = false;
["ws_sss_spawnDone",false] call ws_fnc_setGVar;

// Execute the script
if ((!ws_var_useHC && isServer) || (ws_var_useHC && ws_isHC)) then {

	// Include all relevant files
	#include "ws_sss_functions.sqf"
	#include "ws_sss_processlogics.sqf"
	#include "ws_sss_spawn.sqf"
};
// Code to be executed after spawning:
waitUntil {sleep 0.1;ws_sss_spawnDone};

if (isServer) exitWith {};

// Check if F3 AI Skill Selector is active and process the new units
if({!isNil _x} count ["f_param_AISkill_BLUFOR","f_param_AISkill_INDP","f_param_AISkill_OPFOR"] > 0) then {
    [] execVM "f\setAISKill\f_setAISkill.sqf";
};