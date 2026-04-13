function sendLog(webhookKey, title, message)
    if not Config.Logging.Enabled then return end
    
    local webhookUrl = Config.Logging.Webhooks[webhookKey] or Config.Logging.Webhooks['default']
    
    if webhookUrl and webhookUrl ~= "" then
        local embed = {
            {
                ["color"] = 16711680, -- Red color
                ["title"] = "**" .. title .. "**",
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "sz_bridge Logging System | " .. os.date('%Y-%m-%d %H:%M:%S'),
                },
            }
        }

        PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({username = "Server Logs", embeds = embed}), { ['Content-Type'] = 'application/json' })
    end
end
