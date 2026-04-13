function giveKeys(source, plate)
    -- This handles assigning keys for any vehicle based on plate
    if IsResourceRunning('qb-vehiclekeys') then
        TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    elseif IsResourceRunning('wasabi_carlock') then
        exports.wasabi_carlock:GiveKey(plate, source)
    elseif IsResourceRunning('jaksam_keys') then
        TriggerEvent("jaksam_keys:giveKey", source, plate)
    elseif IsResourceRunning('t1ger_keys') then
        -- T1ger Keys has a few versions. Standard export for giving keys:
        if exports['t1ger_keys']:GiveTemporaryKeys(source, plate, 'Vehicle') then return end
        -- Fallback if GiveTemporaryKeys isn't supported in their version:
        TriggerClientEvent('t1ger_keys:updateKeys', source, plate, true)
    elseif IsResourceRunning('esx_vehiclelock') then
        -- Typically handled client side or differently, but here's a standard event
        TriggerClientEvent('esx_vehiclelock:giveKey', source, plate)
    end
end
