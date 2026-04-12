lib.callback.register('emil_drugs:server:hasRecipe', function(source, itemKey)
    local drugKey = itemKey:match("^(.-)_") or itemKey
    local drugConfig = Config.Drugs[drugKey]
    if not drugConfig then return false, "Drug config missing" end

    local rawAmount = Bridge.Inventory.GetItemCount(source, drugConfig.raw_item)
    if rawAmount <= 0 then
        return false, drugConfig.raw_item
    end

    if drugConfig.requires_bags then
        local ratio = drugConfig.bag_ratio or 2
        local currentBags = Bridge.Inventory.GetItemCount(source, drugConfig.bag_item)
        if rawAmount < ratio then
            return false, drugConfig.raw_item
        end
        if currentBags < 1 then
            return false, drugConfig.bag_item
        end
    end

    return true
end)

AddEventHandler('emil_drugs:server:handleProcessReward', function(source, drugKey)
    local drugConfig = Config.Drugs[drugKey]
    if not drugConfig then return end

    local rawAmount = Bridge.Inventory.GetItemCount(source, drugConfig.raw_item)
    if rawAmount <= 0 then
        Bridge.Notify(source, ('Du mangler %s!'):format(drugConfig.label), 'error')
        TriggerClientEvent('emil_drugs:client:stopLoop', source)
        return
    end

    local rawToProcess = rawAmount > 5 and 5 or rawAmount
    local itemsToAdd = rawToProcess
    
    if drugConfig.requires_bags then
        local ratio = drugConfig.bag_ratio or 2
        itemsToAdd = math.floor(rawToProcess / ratio)
        if itemsToAdd <= 0 then
            Bridge.Notify(source, ('Ikke nok %s til at omdanne!'):format(drugConfig.label), 'error')
            TriggerClientEvent('emil_drugs:client:stopLoop', source)
            return
        end
        rawToProcess = itemsToAdd * ratio
        
        local currentBags = Bridge.Inventory.GetItemCount(source, drugConfig.bag_item)
        if currentBags < itemsToAdd then
            Bridge.Notify(source, 'Mangler poser!', 'error')
            TriggerClientEvent('emil_drugs:client:stopLoop', source)
            return
        end
        Bridge.Inventory.RemoveItem(source, drugConfig.bag_item, itemsToAdd)
    end

    if Bridge.Inventory.CanCarryItem(source, drugConfig.processed_item, itemsToAdd) then
        Bridge.Inventory.RemoveItem(source, drugConfig.raw_item, rawToProcess)
        local success = Bridge.Inventory.AddItem(source, drugConfig.processed_item, itemsToAdd)
        if success then
            Bridge.Notify(source, ("Du omdannede %s x%s"):format(drugConfig.label, itemsToAdd), "success")
        else
            Bridge.Notify(source, "Fejl ved omdannelse", "error")
        end
    else
        Bridge.Notify(source, 'Ingen plads i tasken!', 'error')
        TriggerClientEvent('emil_drugs:client:stopLoop', source)
    end
end)
