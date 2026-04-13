-- Global Bridge Object Initializer
Bridge = {
    Core = {},
    Inventory = {},
    Dispatch = {},
    Target = {},
    UI = {},
    Teleport = {},
    Security = {},
    Teams = {},
    Vehicles = {},
    Keys = {},
    Fuel = {}
}

-- Helper function to check if resource is running
function IsResourceRunning(resName)
    return GetResourceState(resName) == 'started' or GetResourceState(resName) == 'starting'
end

-- Fallback mechanism wrapper
function Bridge.Fallback(moduleStr, funcStr)
    print("^3[sz_bridge-WARN]^0 Missing dependency for: " .. moduleStr .. ":" .. funcStr)
    return false
end
