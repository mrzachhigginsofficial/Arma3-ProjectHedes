{
    _x spawn {
        while{
            count(_x nearEntities ["Man", 1000] select {
                _x in allplayers
            })>0;
        } do {
            sleep 10
        };
        try{
            deletevehicle _x;
        }
        catch{
            echo format["Cleanup object failed: %1... %2", netId _x, _exception]
        }
    }
} forEach _this