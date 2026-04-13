function hasItem(source, item, amount)
    amount = amount or 1
    if Bridge.Inv.Type == 'ox' then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count >= amount
    elseif Bridge.Inv.Type == 'qb' or Bridge.Inv.Type == 'ps' then
        local p = getPlayer(source)
        if not p then return false end
        return p.Functions.GetItemByName(item) and p.Functions.GetItemByName(item).amount >= amount
    elseif Bridge.Inv.Type == 'qs' then
        return exports['qs-inventory']:GetItemTotalAmount(source, item) >= amount
    elseif Bridge.Inv.Type == 'codem' then
        return exports['codem-inventory']:HasItem(source, item, amount)
    elseif Bridge.Core.Type == 'ESX' then -- fallback to pure esx
        local p = getPlayer(source)
        if not p then return false end
        return p.getInventoryItem(item) and p.getInventoryItem(item).count >= amount
    end
    return false
end

function addItem(source, item, amount)
    amount = amount or 1
    if Bridge.Inv.Type == 'ox' then
        return exports.ox_inventory:AddItem(source, item, amount)
    elseif Bridge.Inv.Type == 'qb' or Bridge.Inv.Type == 'ps' then
        local p = getPlayer(source)
        if not p then return false end
        p.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, getCore().Shared.Items[item], "add", amount)
        return true
    elseif Bridge.Inv.Type == 'qs' then
        return exports['qs-inventory']:AddItem(source, item, amount)
    elseif Bridge.Inv.Type == 'codem' then
        return exports['codem-inventory']:AddItem(source, item, amount)
    elseif Bridge.Core.Type == 'ESX' then
        local p = getPlayer(source)
        if p then p.addInventoryItem(item, amount) return true end
    end
    return false
end

function removeItem(source, item, amount)
    amount = amount or 1
    if Bridge.Inv.Type == 'ox' then
        return exports.ox_inventory:RemoveItem(source, item, amount)
    elseif Bridge.Inv.Type == 'qb' or Bridge.Inv.Type == 'ps' then
        local p = getPlayer(source)
        if not p then return false end
        p.Functions.RemoveItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', source, getCore().Shared.Items[item], "remove", amount)
        return true
    elseif Bridge.Inv.Type == 'qs' then
        return exports['qs-inventory']:RemoveItem(source, item, amount)
    elseif Bridge.Inv.Type == 'codem' then
        return exports['codem-inventory']:RemoveItem(source, item, amount)
    elseif Bridge.Core.Type == 'ESX' then
        local p = getPlayer(source)
        if p then p.removeInventoryItem(item, amount) return true end
    end
    return false
end
