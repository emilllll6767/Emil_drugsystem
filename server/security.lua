Security = {}

-- State tracking
local ActivePlayers = {}
local Cooldowns = {}

-- Utility to get 2D distance (xy ignores Z difference)
local function Vdist(v1, v2)
    return #(vec2(v1.x, v1.y) - vec2(v2.x, v2.y))
end

-- Validate and Lock Player for a task
function Security.LockPlayer(source, actionType, drugKey, zoneIndex, coords, radius)
    if ActivePlayers[source] then
        return false, "Player already active"
    end

    local plyPed = GetPlayerPed(source)
    local plyCoords = GetEntityCoords(plyPed)
    
    if Vdist(plyCoords, coords) > (radius + Config.Security.MaxDistanceTolerance) then
        return false, "Too far from start position"
    end

    -- Check cooldowns
    if Cooldowns[source] and Cooldowns[source][actionType] then
        local timeRemaining = Cooldowns[source][actionType] - os.time()
        if timeRemaining > 0 then
            return false, "Cooldown active"
        end
    end

    local duration = actionType == 'harvest' and Config.HarvestTime or Config.ProcessTime

    ActivePlayers[source] = {
        actionType = actionType,
        drugKey = drugKey,
        zoneIndex = zoneIndex,
        coords = coords,
        startTime = os.time(),
        duration = math.ceil(duration / 1000), -- Convert ms to seconds
        radius = radius
    }

    return true
end

-- Validate Completion
function Security.ValidateCompletion(source, actionType, drugKey)
    local state = ActivePlayers[source]
    if not state then
        return false, "No active job found"
    end

    if state.actionType ~= actionType or state.drugKey ~= drugKey then
        return false, "Action mismatch"
    end

    local elapsedTime = os.time() - state.startTime
    -- Add 1-2 seconds of grace time for lag
    local allowedTime = state.duration - (Config.Security.MaxPingTolerance / 1000)

    if elapsedTime < allowedTime then
        return false, "Speed hack detected / Completed too fast"
    end

    local plyPed = GetPlayerPed(source)
    local plyCoords = GetEntityCoords(plyPed)

    if Vdist(plyCoords, state.coords) > (state.radius + Config.Security.MaxDistanceTolerance) then
        return false, "Player moved away from zone"
    end

    return true
end

-- Clear Lock and Apply Cooldown
function Security.ClearLock(source, success)
    local state = ActivePlayers[source]
    if not state then return end

    if success then
        if not Cooldowns[source] then Cooldowns[source] = {} end
        
        local cdTime = state.actionType == 'harvest' and Config.Cooldowns.Harvest or Config.Cooldowns.Process
        Cooldowns[source][state.actionType] = os.time() + math.ceil(cdTime / 1000)
    end

    ActivePlayers[source] = nil
end

-- Get state for loop continuation
function Security.GetState(source)
    return ActivePlayers[source]
end

-- Handle Ban
function Security.BanAbuser(source, reason)
    if Config.Security.EnableBan then
        Bridge.BanPlayer(source, reason)
    else
        print(("[EMIL_DRUGS] Exploit Attempt by %s: %s"):format(GetPlayerName(source), reason))
    end
end

-- Export/Shared for cleanup if player drops
AddEventHandler('playerDropped', function(reason)
    local source = source
    if ActivePlayers[source] then
        ActivePlayers[source] = nil
    end
end)
