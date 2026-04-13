function progressBar(text, duration)
    local p = promise.new()
    
    if IsResourceRunning('ox_lib') then
        local success = exports.ox_lib:progressBar({
            duration = duration,
            label = text,
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            }
        })
        p:resolve(success)
    elseif IsResourceRunning('qb-core') then
        getCore().Functions.Progressbar("bridge_action", text, duration, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            p:resolve(true)
        end, function() -- Cancel
            p:resolve(false)
        end)
    else
        Wait(duration)
        p:resolve(true)
    end
    
    return Citizen.Await(p)
end
