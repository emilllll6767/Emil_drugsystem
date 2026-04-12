# Installation Guide

## Krav

Inden du installerer dette script, skal følgende ressourcer vaere installeret og korrekt konfigureret pa din server:

- ox_lib
- ox_inventory
- oxmysql
- sz_bridge (valgfri - scriptet falder tilbage til standalone hvis ikke tilstede)

---

## Trin 1 - Kopiering af ressource

Kopierer mappen til din resources-mappe, f.eks.:

```
resources/[drugs]/emil_drugs/
```

Tilfoej derefter ressourcen i din `server.cfg`:

```
ensure emil_drugs
```

---

## Trin 2 - Items i ox_inventory

Abn filen:

```
ox_inventory/data/items.lua
```

Tilfoej folgende items i filen:

```lua
-- Emil Drugs - Raw items
['cocaine_raw'] = {
    label = 'Raa Kokain',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raat kokain klar til forarbejdning.',
    image = 'cocaine_raw.png',
},
['skunk_raw'] = {
    label = 'Raa Skunk',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raa skunk klar til forarbejdning.',
    image = 'skunk_raw.png',
},
['meth_raw'] = {
    label = 'Raat Meth',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raat meth klar til forarbejdning.',
    image = 'meth_raw.png',
},

-- Emil Drugs - Processed items
['cocaine_bag'] = {
    label = 'Kokain',
    weight = 50,
    stack = true,
    close = true,
    description = 'Faerdigpakket kokain.',
    image = 'cocaine_bag.png',
},
['skunk_bag'] = {
    label = 'Skunk',
    weight = 50,
    stack = true,
    close = true,
    description = 'Faerdigpakket skunk.',
    image = 'skunk_bag.png',
},
['meth_bag'] = {
    label = 'Meth',
    weight = 50,
    stack = true,
    close = true,
    description = 'Faerdigpakket meth.',
    image = 'meth_bag.png',
},

-- Emil Drugs - Supplies
['empty_bag'] = {
    label = 'Tom Pose',
    weight = 10,
    stack = true,
    close = true,
    description = 'En tom pose til pakning af stoffer.',
    image = 'empty_bag.png',
},
```

---

## Trin 3 - Item billeder

Kopierer alle billeder fra mappen `inventory/` i denne ressource til:

```
ox_inventory/web/images/
```

Folgende billeder skal vaere tilstede:

| Filnavn            | Beskrivelse              |
|--------------------|--------------------------|
| cocaine_raw.png    | Raat kokain              |
| skunk_raw.png      | Raa skunk                |
| meth_raw.png       | Raat meth                |
| cocaine_bag.png    | Faerdigpakket kokain     |
| skunk_bag.png      | Faerdigpakket skunk      |
| meth_bag.png       | Faerdigpakket meth       |
| empty_bag.png      | Tom pose                 |

---

## Trin 4 - Konfiguration

Abn `config.lua` i ressourcen og juster folgende efter behov:

```lua
Config.HarvestTime = 8000   -- Tid i ms for at hoste (standard: 8 sekunder)
Config.ProcessTime = 6000   -- Tid i ms for at forarbejde (standard: 6 sekunder)

Config.RewardsAmount = { min = 6, max = 12 }  -- Min/max udbytte per handling

Config.Cooldowns = {
    Harvest = 0,   -- Cooldown i ms mellem hostninger (0 = ingen)
    Process = 0    -- Cooldown i ms mellem forarbejdninger (0 = ingen)
}
```

Zones for hver drug kan ogsa justeres under `Config.Drugs` i samme fil.

---

## Trin 5 - Sikkerhed

Scriptet har et indbygget anti-cheat system. Juster folgende i `config.lua`:

```lua
Config.Security = {
    MaxPingTolerance = 1500,      -- Max ping foer handling afvises
    MaxDistanceTolerance = 3.0,   -- Max afstand fra zone foer handling afvises
    EnableBan = true,             -- Aktiver automatisk ban ved snyd
}
```

---

## Genstart

Naar alt er sat op, genstart din server eller kor:

```
refresh
ensure emil_drugs
```

---

## Support

Oplever du problemer, tjek konsollen for fejlbeskeder og sikr dig at alle dependencies er korrekt installeret og startet foer `emil_drugs`.
