-- Target isn't exported as a standalone function typically, since it's an API, but we'll include a wrapper if you need to dynamically inject target zones
Bridge.Target = {}
local targetType = Config.ForceTarget

if not targetType then
    if IsResourceRunning('ox_target') then targetType = 'ox'
    elseif IsResourceRunning('qb-target') then targetType = 'qb'
    end
end
Bridge.Target.Type = targetType

-- Generic wrapper for adding global ped/model targets
function addTargetModel(models, options)
    if Bridge.Target.Type == 'ox' then
        exports.ox_target:addModel(models, options)
    elseif Bridge.Target.Type == 'qb' then
        exports['qb-target']:AddTargetModel(models, {
            options = options,
            distance = 2.5
        })
    end
end
