local coreType = Config.ForceCore

if not coreType then
    if IsResourceRunning('qbx_core') then coreType = 'QBX'
    elseif IsResourceRunning('qb-core') then coreType = 'QB'
    elseif IsResourceRunning('es_extended') then coreType = 'ESX'
    end
end

Bridge.Core.Type = coreType

function getCore()
    if coreType == 'QBX' then
        return exports['qbx_core']:GetCoreObject()
    elseif coreType == 'QB' then
        return exports['qb-core']:GetCoreObject()
    elseif coreType == 'ESX' then
        return exports['es_extended']:getSharedObject()
    end
    return Bridge.Fallback("Core", "getCore")
end
