function teleport(entity, coords)
    if not entity then entity = PlayerPedId() end
    
    DoScreenFadeOut(500)
    Wait(500)
    
    SetEntityCoords(entity, coords.x, coords.y, coords.z, false, false, false, true)
    if coords.w then
        SetEntityHeading(entity, coords.w)
    end
    
    Wait(500)
    DoScreenFadeIn(500)
end

RegisterNetEvent('sz_bridge:client:teleport', function(coords)
    teleport(PlayerPedId(), coords)
end)
