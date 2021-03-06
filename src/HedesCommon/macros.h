#ifndef PREFIX
    #define PREFIX x
#endif

#ifndef MODNAME
    #define MODNAME HEDES
#endif

#ifndef ADDON
    #define ADDON HEDESCommon
#endif


/*
--------------------------------------------------------------------
Global and Profile Mission Variables
--------------------------------------------------------------------
*/
#define GLOBALMISSIONTRACKERNAME #HEDESServer_Mission_PlayerMissionTracker

/*
--------------------------------------------------------------------
Common Macros
--------------------------------------------------------------------
*/
#define CONCAT2(VAR1,VAR2) VAR1##VAR2
#define CONCAT3(VAR1,VAR2,VAR3) VAR1##VAR2##VAR3
#define CONCAT4(VAR1,VAR2,VAR3,VAR4) VAR1##VAR2##VAR3##VAR4
#define CONCAT5(VAR1,VAR2,VAR3,VAR4,VAR5) VAR1##VAR2##VAR3##VAR4##VAR5
#define CONCAT6(VAR1,VAR2,VAR3,VAR4,VAR5,VAR6) VAR1##VAR2##VAR3##VAR4##VAR5##VAR6
#define QUOTE(VAR1) #VAR1

/*
--------------------------------------------------------------------
Path Helpers
--------------------------------------------------------------------
*/
#define PATHTO_ASSETS(ASSET) QUOTE(CONCAT2(PREFIX\MODNAME\assets\,ASSET));\

/*
--------------------------------------------------------------------
Function Helpers
--------------------------------------------------------------------
*/
#define FUNC(FUNC) CONCAT3(MODNAME,_fnc_,FUNC)

#define PATHTO_FUNC(VAR1) class VAR1 {\
    file = QUOTE(CONCAT4(CONCAT3(PREFIX,\,ADDON),\functions\fn_,VAR1,.sqf));\
    recompile = 1;\
};\

#define PATHTO_INITFUNC(VAR1) class VAR1 {\
    file = QUOTE(CONCAT4(CONCAT3(PREFIX,\,ADDON),\functions\fn_,VAR1,.sqf));\
    recompile = 1; postinit = 1;\
};\

#define PATHTO_FUNCDIR(VAR1,DIR) class VAR1 {\
    file = QUOTE(CONCAT6(CONCAT3(PREFIX,\,ADDON),\functions\,DIR,\fn_,VAR1,.sqf));\
    recompile = 1;\
};\

#define ALLOWREMOTE_FUNC(VAR1,TARGETS,JIP) class FUNC(VAR1) {\
    CONCAT2(allowedTargets=,TARGETS); CONCAT2(jip=,JIP); };\

#define ALLOWREMOTE_FUNCWPRE(VAR1,TARGETS,JIP) class VAR1 {\
    CONCAT2(allowedTargets=,TARGETS); CONCAT2(jip=,JIP); };\
