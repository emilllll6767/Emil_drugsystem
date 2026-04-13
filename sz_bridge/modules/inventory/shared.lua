Bridge.Inv = {}
local invType = Config.ForceInventory

if not invType then
    if IsResourceRunning('ox_inventory') then invType = 'ox'
    elseif IsResourceRunning('qs-inventory') then invType = 'qs'
    elseif IsResourceRunning('ps-inventory') then invType = 'ps'
    elseif IsResourceRunning('codem-inventory') then invType = 'codem'
    elseif IsResourceRunning('qb-inventory') then invType = 'qb'
    end
end

Bridge.Inv.Type = invType
