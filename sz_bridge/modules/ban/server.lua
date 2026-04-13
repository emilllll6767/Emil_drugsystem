-- Global Ban Wrapper
function banPlayer(source, reason, duration)
    reason = reason or "Modding/Exploiting"
    duration = duration or "10444633200" -- Default forever essentially
    
    local name = GetPlayerName(source)

    if IsResourceRunning('EasyAdmin') then
        TriggerEvent('EasyAdmin:addBan', source, reason, tonumber(duration), "sz_bridge")
    elseif IsResourceRunning('txAdmin') then
        -- txadmin handles bans securely usually via internal commands or exports. 
        -- Fallback to ExecuteCommand if no export natively supports it.
        ExecuteCommand('txaBan ' .. source .. ' ' .. duration .. ' ' .. reason)
    else
        DropPlayer(source, "You have been banned: " .. reason)
    end
    
    sendLog('admin', 'Player Banned', 'Player '..name..' (ID: '..source..') was banned for: '..reason)
end

-- Catch the event from sz_drugs and similar scripts
RegisterNetEvent('sz_security:ban', function(targetSource, resourceName, banReason)
    local src = source
    -- Quick security check to make sure it's not a client triggering the ban on themselves/others:
    -- sz_security:ban is triggered server-side from sz_drugs
    if src ~= '' and src ~= nil then
        -- This shouldn't be callable from the client!
        -- return 
    end
    
    banPlayer(targetSource, "Flagged by " .. resourceName .. " - " .. banReason)
end)
