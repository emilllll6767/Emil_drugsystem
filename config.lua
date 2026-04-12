Config = {}
Config.Debug = false

Config.Security = {
    MaxPingTolerance = 1500,
    MaxDistanceTolerance = 3.0,
    EnableBan = true,
}

Config.HarvestTime = 8000 
Config.ProcessTime = 6000 

Config.Animations = {
    Harvest = {
        dict = "amb@world_human_gardener_plant@male@base",
        anim = "base",
        flags = 1,
        prop = {
            model = 'prop_cs_trowel',
            bone = 28422,
            pos = vec3(0.0, 0.0, -0.05),
            rot = vec3(0.0, 0.0, 0.0)
        }
    },
    Process = {
        dict = "amb@prop_human_parking_meter@male@base",
        anim = "base",
        flags = 49
    }
}

Config.Drugs = {
    ['coke'] = {
        label = 'Kokain',
        raw_item = 'cocaine_raw',
        processed_item = 'cocaine_bag',
        requires_bags = true,
        bag_item = 'empty_bag',
        harvest_zones = {
            { coords = vec3(1593.7292, 2198.4675, 78.8708), radius = 5.0 }
        },
        process_zones = {
            { coords = vec3(-54.0975, -2522.8176, 7.4012), radius = 5.0 }
        }
    },
    ['skunk'] = {
        label = 'Skunk',
        raw_item = 'skunk_raw',
        processed_item = 'skunk_bag',
        requires_bags = true,
        bag_item = 'empty_bag',
        harvest_zones = {
            { coords = vec3(221.8633, 2578.7646, 45.8409), radius = 5.0 }
        },
        process_zones = {
            { coords = vec3(1757.6500, -1649.9189, 112.6611), radius = 5.0 }
        }
    },
    ['meth'] = {
        label = 'Meth',
        raw_item = 'meth_raw',
        processed_item = 'meth_bag',
        requires_bags = true,
        bag_item = 'empty_bag',
        harvest_zones = {
            { coords = vec3(1952.9500, 4651.2656, 40.6836), radius = 5.0 }
        },
        process_zones = {
            { coords = vec3(-283.9211, 2535.9426, 74.6699), radius = 5.0 }
        }
    }
}

Config.RewardsAmount = { min = 6, max = 12 }

Config.Cooldowns = {
    Harvest = 0, 
    Process = 0
}
