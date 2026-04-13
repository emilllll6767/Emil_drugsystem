-- Client side overrides for getPlayer since source isn't used
function getPlayer()
    local core = getCore()
    if not core then return nil end
    
    if Bridge.Core.Type == 'ESX' then
        return core.GetPlayerData()
    elseif Bridge.Core.Type == 'QB' or Bridge.Core.Type == 'QBX' then
        return core.Functions.GetPlayerData()
    end
    return nil
end

function getIdentifier()
    local p = getPlayer()
    if not p then return nil end

    if Bridge.Core.Type == 'ESX' then
        return p.identifier
    elseif Bridge.Core.Type == 'QB' or Bridge.Core.Type == 'QBX' then
        return p.citizenid
    end
    return nil
end
