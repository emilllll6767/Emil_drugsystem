function getTeam(source)
    local p = getPlayer(source)
    if not p then return nil, nil end
    
    if Bridge.Core.Type == 'ESX' then
        return p.job.name, p.job.grade
    elseif Bridge.Core.Type == 'QB' or Bridge.Core.Type == 'QBX' then
        return p.PlayerData.job.name, p.PlayerData.job.grade.level
    end
    return nil, nil
end
