HEDES_ATTACKCOMPOSITIONS = [];

SPAWNCOMP = {
	private _objects = param[0];
	private _obj = "";
	private _objectClass = "";
	private _objectPosition = [];
	private _objectDirection = 0;
	private _spawnedobjs = [];
	{
		_objectClass = _x select 0;
		_objectPosition = _x select 1;
		_objectDirection = _x select 2;
		_obj = createVehicle [_objectClass, _objectPosition, [], 0, "CAN_COLLIDE"];
		_obj setDir _objectDirection;
		_spawnedobjs pushBack _obj;
	} forEach _objects;
	_spawnedobjs;
};

TANOACOMP_LAMI_INTERSECTION = [
	[7877.21,7728.4,-4.76837e-007],
	[
		["Land_Razorwire_F",[7858.17,7728.73,-0.026607],90.5494],
		["Land_Wreck_HMMWV_F",[7849.86,7725.74,-0.00421286],245.03],
		["Land_HBarrier_01_tower_green_F",[7858.98,7716.47,0],357.896],
		["Land_PlasticBarrier_03_F",[7851.79,7734.41,0.000104904],281.355],
		["Land_PlasticBarrier_03_F",[7850.81,7728.34,0.000122547],290.282],
		["Land_PlasticBarrier_03_F",[7851.43,7730.4,0.000452995],281.368],
		["Land_PlasticBarrier_03_F",[7851.59,7732.37,0.000731468],269.544],
		["Land_DragonsTeeth_01_4x2_old_redwhite_F",[7854.35,7729.55,0.000126362],271.256],
		["ModuleEffectsFire_F",[7851.46,7726.61,0],0],
		["ModuleEffectsSmoke_F",[7851.49,7726.59,0],0],
		["B_G_HMG_02_high_F",[7872.99,7722.04,0.0152774],182.355],
		["B_G_HMG_02_high_F",[7867.27,7726.26,0.0139894],278.3],
		["B_G_HMG_02_high_F",[7882.66,7734.53,0.0153308],359.996],
		["Land_BagFence_01_round_green_F",[7883.53,7735.04,0.000509262],229.57],
		["Land_BagFence_01_round_green_F",[7873.25,7720.92,0.000605583],0],
		["Land_BagFence_01_long_green_F",[7883.98,7732.5,-7.39098e-005],272.887],
		["Land_BagFence_01_long_green_F",[7880.99,7735.86,0.000212669],182.998],
		["Land_BagFence_01_long_green_F",[7870.66,7721.43,-8.67844e-005],11.8809],
		["Land_BagBunker_01_small_green_F",[7868,7726,0.00577736],92.2962],
		["MetalBarrel_burning_F",[7883.83,7730.35,3.09944e-005],0],
		["RoadBarrier_F",[7879.88,7713.82,-0.00394392],189.444],
		["RoadBarrier_F",[7874.56,7714.17,-0.00150633],156.832],
		["VirtualReammoBox_camonet_F",[7870.96,7723.23,0.000321388],46.0867],
		["B_MRAP_01_F",[7870.67,7741.47,0.00437403],7.50763],
		["RoadBarrier_F",[7880.06,7749.28,-0.00391817],343.13],
		["RoadBarrier_F",[7874.83,7750.22,-0.00283051],15.7536],
		["Land_DragonsTeeth_01_4x2_old_redwhite_F",[7905.04,7741.99,-3.24249e-005],90.7008]
	]
];
HEDES_ATTACKCOMPOSITIONS pushback TANOACOMP_LAMI_INTERSECTION;

TANOACOMP_IMONE_FIELD = [
	[10717.6,10515.3,0.00119019],
	[
		["Land_Bunker_01_tall_F",[10665.3,10499.5,0],335.98],
		["Land_Bunker_01_small_F",[10654.9,10502.5,0],65.7142],
		["Land_Bunker_01_blocks_3_F",[10657.7,10506.8,0.676392],155.706],
		["Land_Bunker_01_blocks_3_F",[10662.4,10508.9,0.98671],155.706],
		["Land_Bunker_01_big_F",[10669.4,10506.4,1.06392],246.043],
		["Land_Wreck_Ural_F",[10662.6,10521.3,0.0055542],56.5968],
		["Land_CratesWooden_F",[10672.4,10506.4,0.74498],154.106],
		["CraterLong_02_small_F",[10664,10519.7,-0.0552521],233.658],
		["Land_WaterTower_01_ruins_F",[10669.3,10504.3,3.97055],65.392],
		["SatelliteAntenna_01_Small_Mounted_Sand_F",[10662.6,10502.5,4.79875],336.737],
		["Land_Wreck_BRDM2_F",[10665.2,10518.7,0.00254822],63.5557]
	]
];
HEDES_ATTACKCOMPOSITIONS pushback TANOACOMP_IMONE_FIELD;