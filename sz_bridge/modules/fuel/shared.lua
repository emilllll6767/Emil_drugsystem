function setFuel(vehicle, amount)
    if IsDuplicityVersion() then
        -- Server Side
        if IsResourceRunning('ox_fuel') then
            Entity(vehicle).state.fuel = amount
        elseif IsResourceRunning('LegacyFuel') then
            -- Legacy fuel is easiest set client side. We trigger it:
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            TriggerClientEvent('sz_bridge:client:setFuel', -1, netId, amount)
        end
    else
        -- Client Side
        if IsResourceRunning('LegacyFuel') then
            exports['LegacyFuel']:SetFuel(vehicle, amount)
        elseif IsResourceRunning('ox_fuel') then
            SetVehicleFuelLevel(vehicle, amount)
        end
    end
end

if not IsDuplicityVersion() then
    RegisterNetEvent('sz_bridge:client:setFuel', function(netId, amount)
        if NetworkDoesNetworkIdExist(netId) then
            local veh = NetworkGetEntityFromNetworkId(netId)
            setFuel(veh, amount)
        end
    end)
end
