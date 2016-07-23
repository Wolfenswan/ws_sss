/* WOLFENSWAN's SIMPLE SPAWN SYSTEM */

// Function to check if a trigger or poi has reached it's group limit
// Returns TRUE if group limit has been reached
_fnc_checkGroupLimit = {
	params["_o"];

	private _groups = _o getVariable ["groupspresent",[]];
	private _maxGroups = _o getVariable ["maxGroups",-1];

	if (_maxGroups != -1 && {_maxGroups == (count _groups)}) then {
		true
	} else {
		false
	};
};

// Returns a Trigger or POI which has not yet reached it's group limit
_fnc_getGoodSpawn = {
	params ["_parent",["_type",""]];

	// First reduce array to spawn who are not at group limit
	private _spawns = ((_parent getVariable ["spawns",[]]) select {!(_x call _fnc_checkGroupLimit)});
	// Second reduce array to spawns who accept either all types or the specific type
	_spawns = _spawns select {(_type in (_x getVariable ["types",[]])) || (count (_x getVariable ["types",[]]) == 0)};

	if (count _spawns == 0) exitWith {objNull}; // Exit if no valid pois exist

	selectRandom _spawns // Randomly select a poi and return it
};

// Function to create n groups of a specific type
_fnc_createGroupType = {
	params["_logic","_type","_code"];

	for "_i" from 1 to (_logic getVariable [_type,0]) do {

		private _trg = _logic call _fnc_getGoodSpawn;

		if (isNull _trg) exitWith {
			["ws_sss DBG: ",[_logic]," is still trying to spawn but has exhausted all triggers!"] call ws_fnc_debugtext;
		};

		// Find a group that corresponds to the selected type
		private _grp = selectRandom ((_logic getVariable ["groups",[]]) select {_x getVariable [_type,false]});

		if (isNil "_grp") exitWith {
			["ws_sss DBG: ",[_logic]," is trying to a group but has no valid blueprints for it!"] call ws_fnc_debugtext;
		};

		// Create a copy of the picked group at the selected location and call the type-specific code on it
		private _newgrp = [_grp,_trg,(_grp getVariable ["classes",[]])] call _code;
		if !(isNil "_newgrp") then {
			[_newgrp,behaviour leader _grp,formation leader _grp,combatMode leader _grp,speedMode leader _grp] spawn ws_fnc_setAIMode;

			// Check if the original group was in a vehicle, if so, add the vehicle
			// TODO Restore mount order of blueprint group rather than blindly mounting new units
			if ({!(vehicle _x isKindOf "Man")} count units _grp > 0) then {
				_veh = (TypeOF (vehicle leader _grp)) createVehicle (getPos leader _newGrp);
				[[_veh],["_newGrp"],true,true] call ws_fnc_loadVehicle;
			};

			_trg getVariable ["groupspresent",[]] pushback (_newgrp);
			_logic getVariable ["groupspresent",[]] pushback (_newgrp);
		} else {
			["ws_sss DBG: ",[_logic,_type,_i]," could not create group!"] call ws_fnc_debugtext;
		};
	};
};