local polyzones = {}

CreateThread(function()
    Wait(1000) -- Wait for everything to settle
    print("[EMIL_DRUGS] Requesting drug data from server...")
    local Marker, Omdanner = lib.callback.await('emil_drugs:server:getDrugData', false)
    
    if not Marker or not Omdanner then
        print("[EMIL_DRUGS] ^1Error: Failed to fetch drug data from server!^7")
        return
    end

    local mCount, oCount = 0, 0
    for _ in pairs(Marker) do mCount = mCount + 1 end
    for _ in pairs(Omdanner) do oCount = oCount + 1 end
    print(("[EMIL_DRUGS] Received %s markers and %s processors"):format(mCount, oCount))
    
    -- Pass data back to main.lua
    exports['Emil_drugs']:SetDrugData(Marker, Omdanner)
    
    for k, v in pairs(Marker) do
        print("[EMIL_DRUGS] Creating farming zone:", k)
        polyzones[k] = lib.zones.poly({
            name = k,
            points = v.points,
            debugColour = vec4(51, 54, 92, 50.0),
            thickness = 10,
            debug = Config.Debug,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    exports['Emil_drugs']:ToggleFarm(k)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] Start Farm', { alignIcon = 'center', icon = 'fa-solid fa-trowel' })
            end,
            onExit = function()
                TriggerEvent('emil_drugs:client:stopLoop')
                lib.hideTextUI()
            end
        })
    end

    for k, v in pairs(Omdanner) do
        print("[EMIL_DRUGS] Creating processing zone:", k)
        polyzones[k] = lib.zones.poly({
            name = k,
            points = v.points,
            debugColour = vec4(51, 54, 92, 50.0),
            thickness = 10,
            debug = Config.Debug,
            inside = function()
                if IsControlJustReleased(0, 38) then
                    exports['Emil_drugs']:ToggleOmdan(k)
                end
            end,
            onEnter = function()
                lib.showTextUI('[E] Start Omdan', { alignIcon = 'center', icon = 'fa-brands fa-envira' })
            end,
            onExit = function()
                TriggerEvent('emil_drugs:client:stopLoop')
                lib.hideTextUI()
            end
        })
    end
    print("[EMIL_DRUGS] Zones initialized successfully.")
end)
