Bridge = {}

local isServer = IsDuplicityVersion()

-- Attempt to load sz_bridge
local hasSZBridge = GetResourceState('sz_bridge') == 'started' or GetResourceState('sz_bridge') == 'starting'

if hasSZBridge then
    -- Hypothetical sz_bridge implementation
    -- You can adjust these to match the exact sz_bridge exports/events you have
    if isServer then
        Bridge.GetPlayer = function(source)
            return exports.sz_bridge:GetPlayer(source)
        end
        Bridge.Notify = function(source, msg, type)
            exports.sz_bridge:Notify(source, msg, type)
        end
        Bridge.BanPlayer = function(source, reason)
            -- Use sz_bridge ban if it exists, else standard DropPlayer
            if exports.sz_bridge.BanPlayer then
                exports.sz_bridge:BanPlayer(source, reason)
            else
                print(("[EMIL_DRUGS ANTI-CHEAT] Banned %s (ID %s) Reason: %s"):format(GetPlayerName(source), source, reason))
                DropPlayer(source, reason)
            end
        end
    else
        Bridge.Notify = function(msg, type)
            lib.notify({ description = msg, type = type or 'inform' })
        end
    end
else
    -- Standalone / Fallback implementation
    if isServer then
        Bridge.GetPlayer = function(source)
            return {
                source = source,
                identifier = GetPlayerIdentifiers(source)[1]
            }
        end
        Bridge.Notify = function(source, msg, type)
            TriggerClientEvent('ox_lib:notify', source, { description = msg, type = type or 'inform' })
        end
        Bridge.BanPlayer = function(source, reason)
            print(("[EMIL_DRUGS ANTI-CHEAT] Banned %s (ID %s) Reason: %s"):format(GetPlayerName(source), source, reason))
            DropPlayer(source, reason)
        end
    else
        Bridge.Notify = function(msg, type)
            lib.notify({ description = msg, type = type or 'inform' })
        end
    end
end

-- ox_inventory Bridge functions (Server authoritative only for item management)
if isServer then
    Bridge.Inventory = {
        AddItem = function(source, item, count)
            return exports.ox_inventory:AddItem(source, item, count)
        end,
        RemoveItem = function(source, item, count)
            return exports.ox_inventory:RemoveItem(source, item, count)
        end,
        GetItemCount = function(source, item)
            local itemData = exports.ox_inventory:GetItem(source, item)
            return itemData and itemData.count or 0
        end,
        CanCarryItem = function(source, item, count)
            return exports.ox_inventory:CanCarryItem(source, item, count)
        end
    }
end
