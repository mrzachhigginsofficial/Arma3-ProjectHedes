#define GLOBALMISSIONTRACKERNAME #HEDESServer_Profile_PlayerMissionTracker

#ifndef PREFIX
    #define PREFIX x
#endif

#ifndef MODNAME
    #define MODNAME HedesModules
#endif

#define CONCAT2(VAR1,VAR2) VAR1##VAR2
#define CONCAT3(VAR1,VAR2,VAR3) VAR1##VAR2##VAR3
#define CONCAT4(VAR1,VAR2,VAR3,VAR4) VAR1##VAR2##VAR3##VAR4
#define CONCAT5(VAR1,VAR2,VAR3,VAR4,VAR5) VAR1##VAR2##VAR3##VAR4##VAR5

#define QUOTE(VAR1) #VAR1

#define FUNC(FUNC) CONCAT3(MODNAME,_fnc_,FUNC)

#define PATHTO_FUNC(FUNC) class FUNC {\
    file = QUOTE(CONCAT3(PREFIX\MODNAME\functions\fn_,FUNC,.sqf));\
    recompile = 1;\
};\

#define PATHTO_INITFUNC(FUNC) class FUNC {\
    file = QUOTE(CONCAT3(PREFIX\MODNAME\functions\fn_,FUNC,.sqf));\
    recompile = 1;\
    postinit = 1;\
};\

#define PATHTO_FUNCDIR(FUNC,DIR) class FUNC {\
    file = QUOTE(CONCAT5(PREFIX\MODNAME\functions\,DIR,\fn_,FUNC,.sqf));\
    recompile = 1;\
};\

#define PATHTO_ASSETS(ASSET) QUOTE(CONCAT2(PREFIX\MODNAME\assets\,ASSET));\