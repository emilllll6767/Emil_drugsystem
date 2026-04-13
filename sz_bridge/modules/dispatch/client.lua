Bridge.Dispatch = {}

local dispatchType = Config.ForceDispatch
if not dispatchType then
    if IsResourceRunning('ps-dispatch') then dispatchType = 'ps'
    elseif IsResourceRunning('cd_dispatch') then dispatchType = 'cd'
    elseif IsResourceRunning('qs-dispatch') then dispatchType = 'qs'
    elseif IsResourceRunning('core_dispatch') then dispatchType = 'core'
    elseif IsResourceRunning('codem-dispatch') then dispatchType = 'codem'
    elseif IsResourceRunning('origen_police') then dispatchType = 'origen'
    elseif IsResourceRunning('linden_outlawalert') then dispatchType = 'linden'
    end
end

Bridge.Dispatch.Type = dispatchType

function sendDispatch(dType, message, coords)
    coords = coords or GetEntityCoords(PlayerPedId())
    
    if Bridge.Dispatch.Type == 'ps' then
        exports['ps-dispatch']:SuspiciousActivity() -- Example, ps uses specific exports per crime usually, but custom works:
        -- exports['ps-dispatch']:CustomAlert({ coords = coords, message = message, dispatchCode = dType })
    elseif Bridge.Dispatch.Type == 'cd' then
        local data = exports['cd_dispatch']:GetPlayerInfo()
        TriggerServerEvent('cd_dispatch:AddNotification', {
            job_table = {'police'}, 
            coords = coords,
            title = dType,
            message = message, 
            flash = 0,
            unique_id = tostring(math.random(0000000,9999999)),
            sound = 1,
            blip = {sprite = 431, color = 1, scale = 1.2, text = dType}
        })
    elseif Bridge.Dispatch.Type == 'qs' then
        exports['qs-dispatch']:getCall(dType, message, coords)
    elseif Bridge.Dispatch.Type == 'core' then
        exports['core_dispatch']:addCall(dType, message, {
            {icon = "fa-solid fa-triangle-exclamation", info = message}
        }, {coords.x, coords.y, coords.z}, 'police', 3000, 11, 5)
    end
end
