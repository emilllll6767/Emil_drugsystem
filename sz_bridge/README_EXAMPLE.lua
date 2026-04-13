--[[
    Welcome to the sz_bridge documentation.
    Because this is a bridge, you DO NOT need to require 'es_extended' or 'qb-core' inside your other scripts anymore!

    Instead of: ESX = exports["es_extended"]:getSharedObject()
    Simply do nothing! Just call the bridge exports.

    Here are examples of how your other scripts (like sz_garage or sz_drugs) should call the bridge functions:
    
    ----------------------------------------------------------------------
    -- INVENTORY (Server side usage)
    ----------------------------------------------------------------------
    -- Check if player has 5x water
    local hasWater = exports.sz_bridge:hasItem(source, "water", 5)

    -- Give 10 coke leaves
    exports.sz_bridge:addItem(source, "coca_leaf", 10)

    -- Remove 1 dirty money
    exports.sz_bridge:removeItem(source, "black_money", 1)


    ----------------------------------------------------------------------
    -- UI & NOTIFICATIONS (Client side usage)
    ----------------------------------------------------------------------
    -- Notify the player
    exports.sz_bridge:notify("Success", "You successfully processed the drugs!", "success")

    -- Show a text UI prompt
    exports.sz_bridge:textUI('show', '[E] Harvest Drugs')

    -- Hide it
    exports.sz_bridge:textUI('hide')

    -- Play a progress bar (Returns true if completed, false if cancelled/died)
    local finished = exports.sz_bridge:progressBar("Harvesting Coke...", 7600)
    if finished then
        print("Progressbar successfully finished!")
    end


    ----------------------------------------------------------------------
    -- SECURITY & LOGS & DISPATCH (Server side usage)
    ----------------------------------------------------------------------
    -- Ban a modder triggered by dropping/exploiting
    exports.sz_bridge:banPlayer(source, "Tried to exploit drug script")

    -- Send a Discord log (Uses the config.lua 'drugs' webhook)
    exports.sz_bridge:sendLog('drugs', 'Illegal Activity', 'Player processed 10x coke.')

    -- Dispatch ping to cops (Client side)
    exports.sz_bridge:sendDispatch("10-14", "Suspicious Activity at the ports", GetEntityCoords(PlayerPedId()))


    ----------------------------------------------------------------------
    -- GARAGE & VEHICLES (Server / Client usage)
    ----------------------------------------------------------------------
    -- Spawn a car cleanly via server
    local vehicleEntity = exports.sz_bridge:spawnVehicle("adder", vector3(0,0,0), 90.0)

    -- Give keys to a specific plate
    exports.sz_bridge:giveKeys(source, "123ABC45")

    -- Set fuel to 100%
    exports.sz_bridge:setFuel(vehicleEntity, 100)
    
]]
