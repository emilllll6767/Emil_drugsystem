local function GetSquarePoints(center, radius)
    radius = radius or 5.0
    return {
        vec3(center.x - radius, center.y - radius, center.z),
        vec3(center.x + radius, center.y - radius, center.z),
        vec3(center.x + radius, center.y + radius, center.z),
        vec3(center.x - radius, center.y + radius, center.z),
    }
end

lib.callback.register('emil_drugs:server:getDrugData', function(source)
    local Marker = {}
    local Omdanner = {}
    
    for k, v in pairs(Config.Drugs) do
        -- Farming (Harvest)
        for i, zone in ipairs(v.harvest_zones) do
            local key = k .. "_harvest_" .. i
            Marker[key] = {
                label = ('Høster %s'):format(v.label),
                farmTime = Config.HarvestTime,
                amount = math.random(Config.RewardsAmount.min, Config.RewardsAmount.max),
                points = zone.points or GetSquarePoints(zone.coords, zone.radius),
                drugKey = k,
                zoneIndex = i
            }
        end
        
        -- Processing (Omdan)
        for i, zone in ipairs(v.process_zones) do
            local key = k .. "_process_" .. i
            Omdanner[key] = {
                label = ('Omdanner %s'):format(v.label),
                omdanTime = Config.ProcessTime,
                amount = 1,
                points = zone.points or GetSquarePoints(zone.coords, zone.radius),
                drugKey = k,
                zoneIndex = i,
                requires = k
            }
        end
    end
    
    return Marker, Omdanner
end)

RegisterNetEvent('emil_drugs:server:logStartStop', function(action, type, itemKey)
    local source = source
    local drugKey = itemKey:match("^(.-)_") or itemKey
    print(("[EMIL_DRUGS] Player %s %s %s %s"):format(GetPlayerName(source), action, type, drugKey))
    
    if action == 'start' then
        -- Initialize Security Lock
        local typeMap = { farm = 'harvest', omdan = 'process' }
        local realType = typeMap[type]
        
        -- We need the specific zone data to lock
        local drugKey, actionName, zoneIdx = itemKey:match("^(.-)_(.-)_(%d+)$")
        if drugKey and zoneIdx then
            zoneIdx = tonumber(zoneIdx)
            local drugConfig = Config.Drugs[drugKey]
            local zones = realType == 'harvest' and drugConfig.harvest_zones or drugConfig.process_zones
            local zone = zones[zoneIdx]
            
            Security.LockPlayer(source, realType, drugKey, zoneIdx, zone.coords, zone.radius)
        end
    else
        Security.ClearLock(source, false)
    end
end)

lib.callback.register('emil_drugs:server:giveItem', function(source, itemKey, amount, isProcess)
    local actionType = isProcess and 'process' or 'harvest'
    local drugKey = itemKey:match("^(.-)_") or itemKey
    
    print(("[EMIL_DRUGS] Player %s attempting to receive %s (%s)"):format(GetPlayerName(source), actionType, drugKey))
    
    local isValid, err = Security.ValidateCompletion(source, actionType, drugKey)
    if not isValid then
        print(("[EMIL_DRUGS] ^1Validation failed for %s: %s^7"):format(GetPlayerName(source), err))
        Bridge.Notify(source, "Security: " .. (err or "Ugyldig handling"), "error")
        Security.ClearLock(source, false)
        return false
    end

    local drugConfig = Config.Drugs[drugKey]
    if not drugConfig then 
        print(("[EMIL_DRUGS] ^1Error: drugConfig for %s is nil!^7"):format(drugKey))
        return false 
    end

    if isProcess then
        print(("[EMIL_DRUGS] Triggering process reward for %s"):format(drugKey))
        TriggerEvent('emil_drugs:server:handleProcessReward', source, drugKey)
    else
        -- Harvest Reward
        local finalAmount = math.random(Config.RewardsAmount.min, Config.RewardsAmount.max) or 1
        local itemToGive = drugConfig.raw_item
        
        print(("[EMIL_DRUGS] Giving %s x%s to %s"):format(itemToGive, finalAmount, GetPlayerName(source)))
        
        if Bridge.Inventory.CanCarryItem(source, itemToGive, finalAmount) then
            local success = Bridge.Inventory.AddItem(source, itemToGive, finalAmount)
            if success then
                Bridge.Notify(source, ("Du høstede %s x%s"):format(drugConfig.label, finalAmount), "success")
            else
                print("[EMIL_DRUGS] ^1Failed to add item to inventory!^7")
                Bridge.Notify(source, "Fejl ved modtagelse af genstand", "error")
            end
        else
            Bridge.Notify(source, 'Ingen plads i tasken!', 'error')
            TriggerClientEvent('emil_drugs:client:stopLoop', source)
            return false
        end
    end

    -- Update security start time for the next cycle in the loop
    local state = Security.GetState(source)
    if state then state.startTime = os.time() end
    
    return true
end)
