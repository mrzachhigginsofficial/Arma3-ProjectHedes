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
	private _sideconfigs = [];

	// Add East
	private _eastSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_EastSpawn" });
	if(count(_eastSpawns) > 0) then 
	{
		_sideconfigs pushback [EAST,_this getVariable ["EastVehicle",""],call compile (_this getVariable ["EastUnitPool",""]),getPos (selectRandom _eastSpawns),_this getVariable ["EastSpawnerType","HeliLand"],_this getVariable ["EastMaxUnits",80],[],[]];
	};

	// Add West
	private _westSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_WestSpawn" });
	if(count(_westSpawns) > 0) then 
	{
		_sideconfigs pushback [WEST,_this getVariable ["WestVehicle",""],call compile (_this getVariable ["WestUnitPool",""]),getPos (selectRandom _westSpawns),_this getVariable ["WestSpawnerType","HeliLand"],_this getVariable ["WestMaxUnits",80],[],[]]
	};

	// Add Independent
	private _guerSpawns = (synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_GuerSpawn" });
	if (count(_guerSpawns) > 0) then 
	{
		_sideconfigs pushback [INDEPENDENT,_this getVariable ["GUERVehicle",""],call compile (_this getVariable ["GUERUnitPool",[]]),getPos (selectRandom _guerSpawns),_this getVariable ["GUERSpawnerType","HeliLand"],_this getVariable ["GUERMaxUnits",80],[],[]];
	}; 

	// Configure trigger area for all combat zone's and lz's.
	private _newtrigger = objNull;
	private _createtriggerfnc = {
		_newtrigger = createtrigger ["emptydetector", position _this];
		_newtrigger settriggerarea (_this getvariable ["objectArea",[50,50,0,false]]);
		_newtrigger setPos (getPos _this);
		_newtrigger enableSimulationGlobal false;
		_this setVariable ["trigger",_newtrigger];
		_newtrigger
	};
	private _points = synchronizedObjects _this select { typeOf _x == "HEDES_CombatZoneModules_Point" } apply {[_x, objNull]};
	{
		_point = _x;
		_point set [1,(_point # 0) call _createtriggerfnc]; // Attach Trigger To CombatZone
		if (count(synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_EastLZ" }) > 0) then 
			{synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_EastLZ" } apply {_x call _createtriggerfnc}}; // Attach Trigger To LZ
		if (count(synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_WestLZ" }) > 0) then 
			{synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_WestLZ" } apply {_x call _createtriggerfnc}}; // Attach Trigger To LZ
		if (count(synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_GuerLZ" }) > 0) then 
			{synchronizedObjects (_point # 0) select { typeOf _x == "HEDES_CombatZoneModules_GuerLZ" } apply {_x call _createtriggerfnc}}; // Attach Trigger To LZ
		
	} foreach _points;


	//  Main Loop
	while {_this isNotEqualTo objNull} do 
	{
		if (simulationEnabled _this) then
		{
			// Find new combat zone area.
			_combatzone = selectRandom (_points select {simulationEnabled (_x select 0)});
			_pointmodule = _combatzone # 0;
			_pointranpos = (_combatzone # 1) call BIS_fnc_randomPosTrigger;
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
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_EastLZ"})};
						case WEST: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_WestLZ"})};
						case INDEPENDENT: {
							selectRandom(synchronizedObjects _pointmodule select {typeOf _x == "HEDES_CombatZoneModules_GuerLZ"})};
					};
									
					if !(isNil "HEDES_DEBUG") then 
					{
						_debug_objs pushBack ("VR_3DSelector_01_default_F" createVehicle _combatlzpos);
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

								if (_combatlzpos isNotEqualTo [0,0]) then
								{
									// Spawn Vehicle With Crew and Fireteams
									_groups = [_side, _cfgvehicle, _unitpool, _spawnpos] call FUNCMAIN(SpawnVehicleAndCrew);
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
									(_groups + [_combatlzpos, _spawnpos, true]) spawn FUNCMAIN(FlightPlanner);
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
									_newgroup createUnit [selectRandom _unitpool, _spawnpos, [], 0, "FORM"];
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