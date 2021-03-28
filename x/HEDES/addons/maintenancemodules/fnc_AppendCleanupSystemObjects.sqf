/*
---------------------------------------------
Append Cleanup System Objects
Author: ZanchoElGrande
---------------------------------------------
*/

#include "script_component.hpp"
if (!isServer) exitWith {};

ISNILS(GVARMAIN(GLOBALCLEANUPLIST),[]);

if (typeName _this == "ARRAY") then {
	_this apply {
		switch (typeName _x) do {
			case "GROUP" : { 
					units(_x) apply { GVARMAIN(GLOBALCLEANUPLIST) pushBack _x }; 
				};
			case "OBJECT" : { 
					GVARMAIN(GLOBALCLEANUPLIST) pushBack _x; 
				};
			case "STRING" : {
				switch (true) do {
					case (!isNull(objectFromNetId _x)) : { 
							GVARMAIN(GLOBALCLEANUPLIST) pushBack (objectFromNetId _x); 
						};
					case (!isNull(groupFromNetId _x)) : { 
							units(groupFromNetId _x) apply { GVARMAIN(GLOBALCLEANUPLIST) pushBack _x }; 
						};
				}
			};
		};
	};
} else {
	GVARMAIN(GLOBALCLEANUPLIST) pushBack _this;
};