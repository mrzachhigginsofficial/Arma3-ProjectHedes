/*
---------------------------------------------
Init Unit Cleanup Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

private _timeout = _logic getVariable ["LifeSpanValue",240];
private _interval = _logic getVariable ["SimulationInterval",240];

missionNamespace setVariable [QGVARMAIN(MAINTENANCE_INTERVAL),_timeout];
missionNamespace setVariable [QGVARMAIN(MAINTENANCE_TIMEOUT),_interval];