private _cmnder 			= param[0,"Major Meathead"];
private _text 				= param[1,"Mission is a go, I repeat, mission is a go. Command out."];
private _ambientsound		= param[2,"RadioAmbient5"];
private _object 			= param[3, player]; 

[_cmnder, _text] spawn BIS_fnc_showSubtitle;
playMusic _ambientsound;

titlecut ["","BLACK IN",2];

// Setup
private _camera = "camera" camCreate (_object modelToWorld [random 360,random 360,200]); 
[_camera,true] call BIS_fnc_camera_setCinemaBordersEnabled; 
_camera camPrepareTarget _object;  
_camera cameraEffect ["internal", "back"];  
_camera camCommitPrepared 0;  
waitUntil { camCommitted _camera };  

// Transition
_camera camPrepareRelPos [random 50,random 50,8];  
_camera camCommitPrepared 5;  
waitUntil { camCommitted _camera }; 

// Disposal
_camera cameraEffect ["terminate", "back"];  
titlecut [" ","BLACK IN",2]; 
camDestroy _camera; 