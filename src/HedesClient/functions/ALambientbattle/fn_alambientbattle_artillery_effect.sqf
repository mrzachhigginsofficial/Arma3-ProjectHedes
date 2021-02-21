// by ALIAS

if (!hasInterface) exitWith {};

_art_object_name = _this select 0;
_range_art		 = _this select 1;

_art_object  = "land_helipadempty_f" createVehiclelocal getpos _art_object_name;
_li_art = "#lightpoint" createVehicleLocal getpos _art_object;

while {(al_art) and (!isNull _art_object_name)} do 
{
	_range_art= 500;
	_rel_Pos= [getPos _art_object_name,random _range_art, random 360] call BIS_fnc_relPos;;
	_art_object setPos _rel_Pos;
	
	if ((player distance _art_object_name)>500) then 
	{
		_big = random 10;
		if (_big>9) then {_range_art= 3000;	enableCamShake true; addCamShake [0.1, 10, 35];	sleep 0.5+random 1;	enableCamShake false;};
		
		if (!al_art_sunet_play) then {_art_object_name say3d ["expozie",2000]; al_art_sunet_play = true; publicVariable "al_art_sunet_play"};

		_fum = "#particlesource" createVehicleLocal getpos _art_object;
		_fum setParticleCircle [0, [0, 0, 0]];
		_fum setParticleRandom [0, [0, 0, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 0];
		_fum setParticleParams [["\A3\data_f\cl_basic", 1, 0, 1], "", "Billboard", 1, 7, [0, 0, 0], [0, 0, 1], 30, 0.01, 0.007, 0, [10,30,40], [[1, 1, 1, 1], [0, 0, 0, 0.5], [.5, .5, .5, 0]], [0.08], 1, 0, "", "", _art_object];
		_fum setDropInterval 0.05;

		_intens_li = 500+random 500;
		_li_art setpos getpos _art_object;
		_li_art setLightAttenuation [_range_art,50+random 100,50,0,random 5,_range_art];  
		_li_art setLightIntensity _intens_li;
		_li_art setLightDayLight true;	
		_li_art setLightUseFlare true;
		_li_art setLightFlareSize 30;
		_li_art setLightFlareMaxDistance 2000;	
		_li_art setLightAmbient[1, 0.5, 0];
		_li_art setLightColor[1, 0.5, 0];

		while {_intens_li>0} do {
		_li_art setLightIntensity _intens_li;
		_intens_li = _intens_li-10;
		sleep 0.001;
		};
		deleteVehicle _fum;
		//deleteVehicle _li_art;
		_li_art setLightIntensity 0;
	};	
	sleep 0.5+random 3;
};