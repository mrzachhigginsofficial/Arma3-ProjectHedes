/*
---------------------------------------------
Initializes Combat Zone Manager Module
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

private _logic = param [0, objNull];

_logic spawn {

	// Initialize Variables
	private _combatzone = objNull;
	private _pointmodule = objNull;
	private _pointranpos = [0,0];
	private _config = objNull;
	private _groups = [];
	private _combatlz = objNull;
	private _combatlztrgs = [];
	private _combatlzpos = [0,0];
	private _debug_objs = [];
	private _interval = _this getVariable ["SimulationInterval",120];
	private _disabledmg = _this getVariable ["DisableDamage",true];
	private _playobjective = _this getVariable ["UnitsAlwaysPlayObjective", true];
	private _maxtimeout = 600;

	// Build Side Configuration Settings
	private _sideconfigs = _this call FUNCMAIN(InitCombatZoneManagerConfig);
	private _points = _this call FUNCMAIN(InitCombatZonePoints);

	sleep 1;

	//  Main Loop
	while {_this isNotEqualTo objNull} do 
	{
		if (simulationEnabled _this) then
		{
			// Find new combat zone area.
			_point = selectRandom (_points select {simulationEnabled _x});
			_pointranpos = (_point getVariable "trigger") call BIS_fnc_randomPosTrigger;
			_pointranpos = [_pointranpos, 0, 10] call BIS_fnc_findSafePos;

			// If the conbat zone position is valid, continue.
			if (_pointranpos isNotEqualTo [0,0]) then 
			{
				// Iterate through each side config.
				{		
					_x params ["_side","_cfgvehicle","_unitpool","_spawnpos","_spawntype","_maxunits","_activeunits","_activehelis"];
					_config = _x;

					// Delete lost heli's.
					{
						{_x setDamage 1} foreach (crew _x);
						_x setDamage 1;
					} foreach (_activehelis select {(_x getVariable "starttime") + _maxtimeout < time});
						
					// Filter out dead/null values.
					_config set [6,(_activeunits - [objNull]) select {alive _x}];	
					_config set [7,_activehelis - [objNull] select {alive _x}];

					// Update all unit orders.
					if _playobjective then 
					{
						_grouptoreset = (_activeunits select {isTouchingGround _x} apply {group _x}); 
						_grouptoreset = _grouptoreset arrayIntersect _grouptoreset;
						{[_x, _pointranpos] call BIS_fnc_taskAttack; } foreach _grouptoreset;
					};

					// Get LZ Module Properties
					_combatlz = switch (_side) do 
					{
						case EAST: {
							selectRandom(synchronizedObjects _point select {typeOf _x == "HEDES_CombatZoneModules_EastLZ"})};
						case WEST: {
							selectRandom(synchronizedObjects _point select {typeOf _x == "HEDES_CombatZoneModules_WestLZ"})};
						case INDEPENDENT: {
							selectRandom(synchronizedObjects _point select {typeOf _x == "HEDES_CombatZoneModules_GuerLZ"})};
					};

					// Spawn new units if side not full
					if(count _activeunits < _maxunits) then
					{
						// Spawn Units Based On Spawner Type
						switch _spawntype do 
						{
							case "HeliLand": {

								_combatlztrg = _combatlz getVariable "trigger";
								_combatlzpos = _combatlztrg call BIS_fnc_randomPosTrigger;
								_combatlzpos = [_combatlzpos, 0, 10] call BIS_fnc_findSafePos;	

								if !(isNil "HEDES_DEBUG") then 
								{
									_debug_objs pushBack ("VR_3DSelector_01_default_F" createVehicle _combatlzpos);
								};

								if (_combatlzpos isNotEqualTo [0,0]) then
								{
									// Spawn Vehicle With Crew and Fireteams
									_groups = [_side, _cfgvehicle, _unitpool, selectRandom _spawnpos] call FUNCMAIN(SpawnVehicleAndCrew);
									_groups apply {_x allowFleeing 0};

									// Keep group count under max units
									while {count(units (_groups # 1)) > _maxunits} do 
									{
										deleteVehicle (selectRandom units (_groups # 1));
									};

									// Disable AI
									{
										_unit = _x;
										{_unit disableAI _x} foreach ["SUPPRESSION","RADIOPROTOCOL","MINEDETECTION"];
									} foreach (units (_groups # 0));

									// Disable damage on heli and crew if configured
									if _disabledmg then 
									{
										units(_groups # 0) apply {_x allowDamage false};
										vehicle (leader (_groups # 0)) allowDamage false;
									};
									
									// Setup unit and vehicle orders					
									(_groups + [_combatlzpos, selectRandom _spawnpos, true]) spawn FUNCMAIN(FlightPlanner);
									[_groups # 1, _pointranpos] call BIS_fnc_taskAttack; 

									// Add timeout tag to heli and push to end of tracking array
									private _vehicle = vehicle (leader (_groups # 0));
									_vehicle setVariable ["starttime",time];
									_activehelis pushBack _vehicle;
									_config set [7,_activehelis];

									// Add units to cleanup array
									[_groups # 1, FUNCMAIN(IsPlayersNearGroup), true] spawn FUNCMAIN(DynamicSimulation);
									(vehicle (leader (_groups # 0))) call FUNCMAIN(AppendCleanupSystemObjects);
									_groups call FUNCMAIN(AppendCleanupSystemObjects);

									// Add new units to active unit array.
									_groups apply {_activeunits append (units _x)};	
									_config set [6,_activeunits];
								};
							};	

							case "InfantryFoot": {
								// Spawn random infantry group.
								_newgroup = createGroup [_side, true];
								while{count(units _newgroup) < 5} do 
								{
									_newgroup createUnit [selectRandom _unitpool, selectRandom _spawnpos, [], 0, "FORM"];
								};

								// Disable AI
								{
									_unit = _x;
									{_unit disableAI _x} foreach ["SUPPRESSION","RADIOPROTOCOL","MINEDETECTION"];
								} foreach (units _newgroup);

								// Assign Orders
								[_newgroup, _pointranpos] call BIS_fnc_taskAttack; 

								// Add units to cleanup array
								[_newgroup, FUNCMAIN(IsPlayersNearGroup), true] spawn FUNCMAIN(DynamicSimulation);
								_newgroup call FUNCMAIN(AppendCleanupSystemObjects);

								// Add to trackers.
								_activeunits append (units _newgroup);	
								_config set [6,_activeunits];
							};					
						};						
					};		
				} foreach _sideconfigs;
			};			
			
			_debug_objs apply {deleteVehicle _x};
		};

		sleep _interval;
	};
};