function spawnVehicle(model, coords, heading)
    local p = promise.new()
    
    if IsResourceRunning('es_extended') then
        -- ESX specific spawning if using their internal systems
        getCore().OneSync.SpawnVehicle(model, coords, heading, {}, function(networkId)
            local vehicle = NetworkGetEntityFromNetworkId(networkId)
            p:resolve(vehicle)
        end)
    else
        -- Native Onesync safe spawn (works on QB / modern ESX)
        local hash = type(model) == "string" and GetHashKey(model) or model
        local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, true)
        
        while not DoesEntityExist(vehicle) do Wait(0) end
        p:resolve(vehicle)
    end
    
    return Citizen.Await(p)
end
