function getPlayer(source)
    local core = getCore()
    if not core then return nil end
    
    if Bridge.Core.Type == 'ESX' then
        return core.GetPlayerFromId(source)
    elseif Bridge.Core.Type == 'QB' or Bridge.Core.Type == 'QBX' then
        return core.Functions.GetPlayer(source)
    end
    return nil
end

function getIdentifier(source, idType)
    idType = idType or 'license'
    
    if Bridge.Core.Type == 'QB' or Bridge.Core.Type == 'QBX' then
        local p = getPlayer(source)
        if p then return p.PlayerData.citizenid end
    elseif Bridge.Core.Type == 'ESX' then
        local p = getPlayer(source)
        if p then return p.identifier end
    end
    
    -- Fallback to standard FiveM identifiers if framework player isn't found
    for _, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len(idType .. ":")) == idType .. ":" then
            return v
        end
    end
    return nil
end
