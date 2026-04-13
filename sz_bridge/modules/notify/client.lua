function notify(title, text, type)
    if IsResourceRunning('ox_lib') then
        exports.ox_lib:notify({
            title = title,
            description = text,
            type = type or 'info'
        })
    elseif IsResourceRunning('qb-core') then
        getCore().Functions.Notify(text, type)
    elseif IsResourceRunning('es_extended') then
        getCore().ShowNotification(text)
    end
end

RegisterNetEvent('sz_bridge:client:notify', function(title, text, nType)
    notify(title, text, nType)
end)
