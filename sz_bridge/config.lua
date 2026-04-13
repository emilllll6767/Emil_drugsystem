Config = {}

-- Auto-Detection overrides. Set to false to auto-detect.
-- Useful if you have multiple frameworks installed (e.g. testing) and need to force one.
Config.ForceCore = false -- "ESX", "QB", "QBX", false
Config.ForceInventory = false -- "ox", "qb", "ps", "qs", "codem", false
Config.ForceTarget = false -- "ox", "qb", false
Config.ForceDispatch = false -- "cd", "ps", "qs", "linden", "codem", "origen", "core", false

-- Logging Module Configuration
Config.Logging = {
    Enabled = true,
    Webhooks = {
        ['drugs'] = "", -- Put your drug logs discord webhook here
        ['admin'] = "", 
        ['default'] = ""
    }
}
