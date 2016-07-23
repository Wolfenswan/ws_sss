/* WOLFENSWAN's SIMPLE SPAWN SYSTEM */

// Loop through all controller logics and create groups for each type
{
	private _logic = _x;

	if (count (_logic getVariable ["spawns",[]]) > 0) then {

	/*
	[_logic,"typename",{
		params ["_grp","_trg","_classes"];
		private _pos = //Code to find position
		private _newgrp = //Code to create group
		// Further code to execute on new group
		_newgrp //Return newly created group
	}] _fnc_createGroupType;
	*/

	// Hold
	[_logic,"hold",{
		params ["_grp","_trg","_classes"];
		private _pos = [_trg] call ws_fnc_getPosInArea;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["HOLD"]] spawn ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	// Hold (PoI)
	[_logic,"hold-poi",{
		params ["_grp","_trg","_classes"];
		private _poi = [_trg,_type] call _fnc_getGoodSpawn;
		if (isNull _poi) exitWith {
			["ws_sss DBG: ",[_trg, _type]," does not have any valid POIs left but is trying to spawn groups on them!"] call ws_fnc_debugtext;
		};
		private _pos = [_poi,50,0,360] call ws_fnc_getPos;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["HOLD",50]] spawn ws_fnc_addWaypoint;
		_poi getVariable ["groupspresent",[]] pushback (_newgrp);
		_newgrp
	}] call _fnc_createGroupType;

	// Patrol
	[_logic,"patrol",{
		params ["_grp","_trg","_classes"];
		private _pos = [_trg] call ws_fnc_getPosInArea;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["patrol",250]] spawn ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	// Patrol (PoI)
	[_logic,"patrol-poi",{
		params ["_grp","_trg","_classes"];
		private _pois =  (_trg getVariable ["spawns",[]]);// select {(_type in (_x getVariable ["types",[]])) || (count (_x getVariable ["types",[]]) == 0)};
		private _poi = selectRandom _pois;
		if (isNil "_poi") exitWith {
			["ws_sss DBG: ",[_trg, _type]," does not have any valid POIs left but is trying to spawn groups on them!"] call ws_fnc_debugtext;
		};
		private _pos = getPos _poi;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;

		// TODO Randomize patrol points
		// TODO Only pick pois with proper type
		// Shuffle array
		_pois = _pois - [_poi];
		_pois = [_pois] call ws_fnc_shuffleArray;

		{
			[_newgrp,getPos _x,["move"]] call ws_fnc_addWaypoint;
		} forEach _pois;
		reverse _pois;
		{
			[_newgrp,getPos _x,["move"]] call ws_fnc_addWaypoint;
		} forEach _pois;

		[_newgrp,_pos,["cycle"]] spawn ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	// Garrison
	[_logic,"garrison",{
		params ["_grp","_trg","_classes"];
		private _pos = nearestBuilding ([_trg] call ws_fnc_getPosInArea);
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["garrison",round(10*(count units _newgrp))]] spawn ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	// Garrison (POI)
	[_logic,"garrison-poi",{
		params ["_grp","_trg","_classes"];
		private _poi = [_trg,_type] call _fnc_getGoodSpawn;
		if (isNull _poi) exitWith {
			["ws_sss DBG: ",[_trg, _type]," does not have any valid POIs left but is trying to spawn groups on them!"] call ws_fnc_debugtext;
		};
		private _pos = nearestBuilding _poi;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["garrison",50 + (count units _newgrp * 10)]] spawn ws_fnc_addWaypoint;
		_poi getVariable ["groupspresent",[]] pushback (_newgrp);
		_newgrp
	}] call _fnc_createGroupType;

	// Ambush
	[_logic,"ambush",{
		params ["_grp","_trg","_classes"];
		private _pos = [_trg] call ws_fnc_getPosInArea;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["ambush"]] spawn ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	// Ambush (POI)
	[_logic,"ambush-poi",{
		params ["_grp","_trg","_classes"];
		private _poi = [_trg,_type] call _fnc_getGoodSpawn;
		if (isNull _poi) exitWith {
			["ws_sss DBG: ",[_trg, _type]," does not have any valid POIs left but is trying to spawn groups on them!"] call ws_fnc_debugtext;
		};
		private _pos = [_poi,50,0,360] call ws_fnc_getPos;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["ambush"]] spawn ws_fnc_addWaypoint;
		_poi getVariable ["groupspresent",[]] pushback (_newgrp);
		_newgrp
	}] call _fnc_createGroupType;

	// Ambush (Road)
	[_logic,"ambush-road",{
		params ["_grp","_trg","_classes"];
		private _pos = [_trg] call ws_fnc_getPosInArea;
		private _newgrp = ([_pos,side leader _grp,count units _grp,[_classes,[]]] call ws_fnc_createGroup) select 0;
		[_newgrp,_pos,["ambush",10,50,true]] call ws_fnc_addWaypoint;
		_newgrp
	}] call _fnc_createGroupType;

	};

} forEach _logics;

// Clean-Up
{
private _grps = _x getVariable ["groups",[]];
	{
		private _grp = _x;
		{deleteVehicle _x} forEach units _grp;
		deleteGroup _grp;
	} forEach _grps;
} forEach _logics;

["ws_sss_spawnDone",true,true,true] call ws_fnc_setGVar;