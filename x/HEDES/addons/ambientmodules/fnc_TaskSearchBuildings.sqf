#include "script_component.hpp"

_this spawn {

	params ["_group","_area"];
	if !(local _group) exitWith {};

	while {_group isNotEqualTo grpNull} do
	{
		if (_group getVariable [QGVAR(TaskReady),true]) then {

			// Lock group in place.
			_group setVariable [QGVAR(TaskReady), false];
			[_group] call CBA_fnc_clearWaypoints;

			private _wpstatementsearch = {
				private _group = group this;
				private _leader = this;
				private _nbuilding = nearestBuilding _leader;
				private _nbuildingpos = _nbuilding buildingPos -1;

				// Tag limiters on each unit.
				{
					_x setVariable [QGVAR(searchtimestart), time];
					_x setVariable [QGVAR(maxsearchtime), 60];
				} forEach (units _group);
				
				[_group,_nbuildingpos] spawn {
					params ["_group", "_nbuildingpos"];
					while {_nbuildingpos isNotEqualTo []} do {
						{
							if (_nbuildingpos isEqualTo [] || units _group isEqualTo [] || _group isEqualTo grpNull) exitWith {};

							_istimeout = if ((_x getVariable QGVAR(searchtimestart)) + (_x getVariable QGVAR(maxsearchtime)) < time) then {true} else {false};
							if (unitReady _x || _istimeout) then {
								_x setVariable [QGVAR(searchtimestart), time];
								_x setVariable [QGVAR(maxsearchtime), 60];
								_x doMove (_nbuildingpos deleteAt 0)
							};
						} forEach (units _group - [leader _group]);
						sleep 1;
					};

					// Force ready (sometimes we get stuck).
					{
						_x doFollow leader _group;
					} forEach (units _group);

					_group lockWP false;
				};
			};

			_wpstatementclear = {
				// Group is ready again.
				private _group = group this;
				_group setVariable [QGVAR(TaskReady), true];
				[_group] call CBA_fnc_clearWaypoints;
			};

			private _wppos = [_area, true, 5] call FUNCMAIN(FindRanPosInMarker);
			if (_wppos isEqualTo [0,0]) exitWith {ERROR_1("Unable to find valid location at %1", getPos leader _group)};

			private _wp2 = _group addWaypoint [_wppos, 30, 0, QGVAR(Regroup)];
			_wp2 setWaypointStatements ["true", toString _wpstatementclear];
			_wp2 setWaypointType "MOVE";

			private _wp1 = _group addWaypoint [_wppos, 30, 0, QGVAR(FindNewBuilding)];
			_wp1 setWaypointStatements ["true", toString _wpstatementsearch];
			_wp1 setWaypointType "MOVE";

			_group lockWP true;
		};

		sleep 5;
	};
};
