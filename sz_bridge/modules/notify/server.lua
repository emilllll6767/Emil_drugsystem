function notify(source, title, text, type)
    if IsResourceRunning('ox_lib') then
        TriggerClientEvent('ox_lib:notify', source, {
            title = title,
            description = text,
            type = type or 'info'
        })
    else
        TriggerClientEvent('sz_bridge:client:notify', source, title, text, type)
    end
end
