#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: CBA_fnc_searchNearby
Description:
    A function for a group to search a nearby building.
Parameters:
    - Group (Group or Object)
Example:
    (begin example)
    [group player] call CBA_fnc_searchNearby
    (end)
Returns:
    Nil
Author:
    Rommel, SilentSpike
---------------------------------------------------------------------------- */

params ["_group", ["_searchTimeoutCoef", -1], ["_searchMaxTimeout", -1]];

_group = _group call CBA_fnc_getGroup;
if !(local _group) exitWith {}; // Don't create waypoints on each machine

private _building = nearestBuilding (leader _group);
if ((leader _group) distanceSqr _building > 250e3) exitwith {};

[_group, _building, _searchTimeoutCoef, _searchMaxTimeout] spawn {
    params ["_group", "_building", "_searchTimeoutCoef", "_searchMaxTimeout"];
    private _leader = leader _group;

    // Get building positions 
    private _positions = _building buildingPos -1;

    // Setup unit timeout limiters
    _timeout = if (_searchTimeoutCoef > 0 && _searchMaxTimeout > 0) then {
        (count _positions * _searchTimeoutCoef) min _searchMaxTimeout
    } else {
        -1
    };
    _timeoutTag = QGVAR(searchTimeout);
    _timeStartTag = QGVAR(searchTimeStart);
    {
        _x setVariable [_timeoutTag, _timeout];
        _x setVariable [_timeStartTag, time];
    } forEach units _group;

    // Add a waypoint to regroup after the search
    _group lockWP true;
    private _cond = {
        (
            {
                unitReady _x || 
                !(alive _x) || 
                if(_x getVariable QGVAR(searchTimeout) > 0) then {
                    (_x getVariable QGVAR(searchTimeout)) + (_x getVariable QGVAR(searchTimeStart)) < time
                } else {
                    false
                }
            } count thisList
        ) isEqualTo count thisList
    };
    private _comp = format [
        "((units group this) - [this]) doFollow this;
        this setFormation '%1'; 
        this setBehaviour '%2'; 
        deleteWaypoint [group this, currentWaypoint (group this)];", 
        formation _group, behaviour _leader];
    private _wp = _group addWaypoint [getPosASL _leader, 30, currentWaypoint _group];
    _wp setWaypointStatements [toString _cond, _comp];
    _wp setWaypointName QGVAR(TaskRegroup);

    // Prepare group to search
    _group setBehaviour "Combat";
    _group setFormDir ([_leader, _building] call BIS_fnc_dirTo);

    // Search while there are still available positions
    while {_positions isNotEqualTo []} do {

        private _units = (units _group);

        // Abort search if the group has no units left
        if (_units isEqualTo []) exitWith {};

        // Send all available units to the next available position
        {
            if (_positions isEqualTo []) exitWith {};

            _unitTimeout = if (_timeout > 0) then {
                (_x getVariable _timeoutTag) + (_x getVariable _timeStartTag) < time
            } else {
                false
            };

            if (unitReady _x || _unitTimeout) then {
                if _unitTimeout then {ERROR_1("Potential pathing issue during search at position: %1", getPos _x)};

                private _pos = _positions deleteAt 0;
                _x setVariable [_timeStartTag,time];
                _x commandMove _pos;
            };
        } forEach _units;

        sleep 2;
    };

    ((units _group) - [_leader]) doFollow _leader;

    _group lockWP false;
};