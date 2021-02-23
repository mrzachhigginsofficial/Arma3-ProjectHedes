/*
Gets position of location from name and location type.
Both are required because all locations are analyzed on the map and then sorted.
*/

private _locname = param[0, 'Ile Sainte-Marie'];
private _loctype = param[1, 'namelocal'];
private _reference = param[2, [worldSize/2, worldSize/2, 0]];
position ((nearestLocations [_reference, [_loctype], worldSize /2]) select {
    text _x == _locname
} select 0);