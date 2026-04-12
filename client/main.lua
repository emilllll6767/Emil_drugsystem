local isLooping = false
local Marker = {}
local Omdanner = {}

local function StopLoop(PlayerPed)
    isLooping = false
    ClearPedTasks(PlayerPed)
    SetEntityCollision(PlayerPed, true, true)
    FreezeEntityPosition(PlayerPed, false)
    if lib.progressActive() then lib.cancelProgress() end
end

local function ToggleFarm(item)
    local PlayerPed = cache.ped
    if isLooping then
        TriggerServerEvent('emil_drugs:server:logStartStop', 'stop', 'farm', item)
        StopLoop(PlayerPed)
        lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
    else
        TriggerServerEvent('emil_drugs:server:logStartStop', 'start', 'farm', item)
        isLooping = true
        TaskStartScenarioInPlace(PlayerPed, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
        FreezeEntityPosition(PlayerPed, true)
        SetEntityCollision(PlayerPed, false, false)
        lib.showTextUI('[E] Stop Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
        CreateThread(function()
            while isLooping do
                Wait(0)
                if lib.progressBar({
                    duration = Marker[item].farmTime,
                    label = Marker[item].label,
                    useWhileDead = false,
                    disable = {
                        car = true,
                    }
                }) then
                    local newPlayerped = cache.ped
                    if PlayerPed ~= newPlayerped then
                        StopLoop(PlayerPed)
                        lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
                        return
                    elseif not IsPedUsingScenario(newPlayerped, 'WORLD_HUMAN_GARDENER_PLANT') then
                        TaskStartScenarioInPlace(PlayerPed, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
                    end
                    lib.callback.await('emil_drugs:server:giveItem', false, item, Marker[item].amount)
                else
                    isLooping = false
                end
            end
            SetEntityCollision(PlayerPed, true, true)
            FreezeEntityPosition(PlayerPed, false)
        end)
    end
end

local function ToggleOmdan(item)
    local hasRecipe, missingItem = lib.callback.await('emil_drugs:server:hasRecipe', false, item)
    if not hasRecipe then lib.notify({ title = ('Du mangler %s for at omdanne'):format(missingItem or 'ting'), type = 'error' }) return end
    
    local dict = 'amb@prop_human_parking_meter@male@base'
    local PlayerPed = cache.ped
    
    if isLooping then
        TriggerServerEvent('emil_drugs:server:logStartStop', 'stop', 'omdan', item)
        StopLoop(PlayerPed)
        lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
    else
        TriggerServerEvent('emil_drugs:server:logStartStop', 'start', 'omdan', item)
        isLooping = true
        FreezeEntityPosition(PlayerPed, true)
        SetEntityCollision(PlayerPed, false, false)
        lib.playAnim(PlayerPed, dict, 'base', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
        lib.showTextUI('[E] Stop Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
        
        CreateThread(function()
            while isLooping do
                Wait(0)
                hasRecipe, missingItem = lib.callback.await('emil_drugs:server:hasRecipe', false, item)
                if not hasRecipe then
                    StopLoop(PlayerPed)
                    lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
                    lib.notify({ title = ('Du mangler %s for at omdanne'):format(missingItem or 'ting'), type = 'error' })
                    return
                end
                
                if lib.progressBar({
                    duration = Omdanner[item].omdanTime,
                    label = Omdanner[item].label,
                    useWhileDead = false,
                    disable = {
                        car = true,
                    }
                }) then
                    local newPlayerped = cache.ped
                    if PlayerPed ~= newPlayerped then
                        StopLoop(PlayerPed)
                        lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
                        return
                    elseif not IsEntityPlayingAnim(PlayerPed, dict, 'base', 3) then
                        lib.playAnim(PlayerPed, dict, 'base', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                    end
                    lib.callback.await('emil_drugs:server:giveItem', false, item, Omdanner[item].amount, true)
                else
                    isLooping = false
                end
            end
            SetEntityCollision(PlayerPed, true, true)
            FreezeEntityPosition(PlayerPed, false)
        end)
    end
end

-- Export functions to be used in zones.lua
exports('ToggleFarm', ToggleFarm)
exports('ToggleOmdan', ToggleOmdan)
exports('SetDrugData', function(m, o)
    Marker = m
    Omdanner = o
end)

RegisterNetEvent('emil_drugs:client:stopLoop', function()
    StopLoop(cache.ped)
end)
