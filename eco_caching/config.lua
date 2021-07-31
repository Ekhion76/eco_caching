Config = {}
Config.Locale = 'hu'

-- STATES:
-- 'b' = 'box'
-- 's' = 'shiney'
-- 'd' = 'disabled'
-- 'f' = 'fortune'
-- 'l' = 'lucky' -- Negatív effektek hívása?
-- '-' = 'disabled'

-- BLIP
Config.boxBlip = {
    name = 'Geo Point',
    sprite = 587, -- default sprite -- 587
    color = 47, -- default color
    scale = 0.7
}

Config.shopBlip = {
    name = 'Geo Shop',
    sprite = 537, --541 G,
    color = 47,
    scale = 0.9
}

Config.geoBlip = {
    name = 'Túra utvonal',
    sprite = 537, --541 G,
    color = 42,
    scale = 0.9
}

-- MARKER
Config.showObject = true -- Ládák megjelenítése a lelőhelyeknél
Config.showMarker = true -- Markerek megjelenítése a lelőhelyeknél

-- SHOP
Config.shopCommand = false -- Ha kikapcsolod a parancsot, megjelennek az NPC-k
Config.geoCommand = true -- Ha kikapcsolod a parancsot, megjelennek a start/stop NPC-k

-- EVENT REWARD
Config.eventCoin = {
    20, -- Első helyezett
    10, -- Második helyezett
    5, -- Harmadik helyezett
}

Config.zone = {
    [1] = {
        label = "Útvonal 1",
        blipColor = 49, -- Red
    },
    [2] = {
        label = "Útvonal 2",
        blipColor = 42, -- Blue
    },
    [3] = {
        label = "Útvonal 3",
        blipColor = 51, -- Salmon
    },
    [4] = {
        label = "Útvonal 4",
        blipColor = 27, -- Bright Purple
    },
    [5] = {
        label = "Útvonal 5",
        blipColor = 2, -- Green
    },
    [6] = {
        label = "Útvonal 6",
        blipColor = 36, -- Beige
    },
    -- event zone
    [10] = {
        label = "Event",
        blipColor = 46,
        blipSprite = 570
    },
}

Config.point = {
    -- RED
    { 1, vector3(2434.9, 2890.88, 40.05) },
    { 1, vector3(2923.9, 4151.04, 50.3) },
    { 1, vector3(2610.66, 5318.22, 42.5) },
    { 1, vector3(1421.64, 6576.34, 14.24) },
    { 1, vector3(-615.57, 5656.88, 36.98) },
    { 1, vector3(-2297.4, 4254.19, 41.59) },
    { 1, vector3(-2746.08, 2302.01, 18.67) },
    { 1, vector3(-2181.27, -428.94, 11.71) },
    { 1, vector3(862.78, 78.77, 68.67) },
    { 1, vector3(-415.63, -546.79, 24.94) },


    -- EASTER
    { 2, vector3(2010.65, 973.51, 211.0) },
    { 2, vector3(1923.86, 795.78, 194.51) },
    { 2, vector3(1897.26, 430.65, 163.28) },
    { 2, vector3(1924.48, -64.88, 192.71) },
    { 2, vector3(2140.31, 70.58, 220.16) },
    { 2, vector3(2323.8, 1045.64, 71.17) },
    { 2, vector3(2432.57, -713.58, 61.77) },
    { 2, vector3(1724.11, -1753.61, 112.1) },
    { 2, vector3(1636.66, -2544.04, 71.53) },
    { 2, vector3(1169.63, -1767.38, 35.49) },


    -- VINEWOOD
    { 3, vector3(866.19, 418.09, 119.68) },
    { 3, vector3(376.08, 446.84, 144.05) },
    { 3, vector3(-53.03, 1069.02, 221.96) },
    { 3, vector3(-672.32, 974.24, 238.35) },
    { 3, vector3(-2006.29, 828.7, 161.34) },
    { 3, vector3(-2576.39, 1654.3, 142.2) },
    { 3, vector3(-2202.95, 1916.27, 187.42) },
    { 3, vector3(-1722.26, 2282.5, 76.94) },
    { 3, vector3(-1578.81, 2100.43, 67.42) },
    { 3, vector3(-909.48, 1703.52, 183.62) },
    { 3, vector3(289.15, 1657.29, 239.49) },
    { 3, vector3(1214.24, 1282.87, 143.44) },


    -- PALETO
    { 4, vector3(-1605.93, -648.64, 30.78) },
    { 4, vector3(-904.82, -1215.91, 4.26) },
    { 4, vector3(-1107.65, -1932.8, 12.13) },
    { 4, vector3(-268.6, -2201.75, 9.29) },
    { 4, vector3(176.98, -1819.44, 27.84) },
    { 4, vector3(807.76, -1970.78, 28.34) },
    { 4, vector3(795.86, -620.52, 28.45) },
    { 4, vector3(550.55, -228.38, 51.63) },
    { 4, vector3(-314.22, 276.06, 87.05) },
    { 4, vector3(-1228.95, 411.71, 75.04) },
    { 4, vector3(-1696.52, -23.5, 62.62) },
    { 4, vector3(-1755.62, -527.06, 37.62) },


    -- GREEN
    { 5, vector3(1640.09, 4944.53, 41.07) },
    { 5, vector3(1279.93, 4326.62, 37.98) },
    { 5, vector3(469.45, 4314.62, 58.16) },
    { 5, vector3(337.83, 4373.27, 63.03) },
    { 5, vector3(-522.66, 4517.23, 84.15) },
    { 5, vector3(-1327.95, 4698.59, 67.55) },
    { 5, vector3(-1484.18, 4953.75, 63.07) },
    { 5, vector3(-2133.03, 4501.48, 30.55) },
    { 5, vector3(-1674.06, 4465.93, 0.03) },
    { 5, vector3(-785.38, 4415.53, 16.32) },
    { 5, vector3(-235.59, 3836.41, 36.46) },
    { 5, vector3(854.71, 3495.01, 36.99) },
    { 5, vector3(2999.09, 4551.1, 49.44) },
    { 5, vector3(2236.24, 5210.56, 61.03) },



    -- PURPLE DESERT
    { 6, vector3(1254.01, 711.55, 100.36) },
    { 6, vector3(1308.5, 1441.14, 98.11) },
    { 6, vector3(968.95, 2208.2, 48.84) },
    { 6, vector3(-156.9, 1994.21, 188.31) },
    { 6, vector3(-788.52, 2257.88, 82.3) },
    { 6, vector3(-391.34, 2797.57, 44.77) },
    { 6, vector3(1017.06, 2674.14, 38.65) },
    { 6, vector3(2538.53, 2626.56, 37.07) },
    { 6, vector3(2050.06, 1421.94, 74.19) },


    -- EVENT
    { 10, vector3(-25.0, 6309.9, 30.42) },
    { 10, vector3(-741.08, 5594.97, 40.7) },
    { 10, vector3(-825.11, 5181.62, 106.82) },
    { 10, vector3(-309.0, 4943.44, 267.89) },
    { 10, vector3(-354.34, 4825.15, 143.35) },
    { 10, vector3(984.27, 4453.42, 54.05) },
    { 10, vector3(1921.61, 5131.64, 43.81) },
    { 10, vector3(3372.8, 5183.62, 0.51) },
    { 10, vector3(2976.22, 3482.08, 70.49) },
    { 10, vector3(2337.25, 2540.66, 45.72) },
    { 10, vector3(1351.72, -762.82, 66.72) },
    { 10, vector3(1335.07, -1850.21, 56.14) },
    { 10, vector3(575.95, -1941.97, 24.15) },
    { 10, vector3(97.64, -1390.34, 28.49) },
    { 10, vector3(-81.01, -884.07, 39.74) },
    { 10, vector3(-1398.37, 23.34, 52.41) },
    { 10, vector3(-3427.18, 967.58, 7.4) },
    { 10, vector3(-902.32, -2549.9, 13.6) },
    { 10, vector3(107.03, -3277.83, 5.05) },
}

-- { item = { 'item1', 'item2' }, money = { min, max }, weight = weight ratio },

Config.action = {
    x = {
        -- TÖRÖTT LÁDA
        drop = {
            { item = { 'bread', 'water' }, money = { 100, 150 }, weight = 50 }, -- common (gyakori)
            { item = {}, money = { 100, 150 }, weight = 50 } -- nothing (semmi)
        },
        point = 1, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    },
    b = {
        -- NORMÁL LÁDA
        drop = {
            { item = { 'coin_car', 'coin_property' }, money = { 500, 600 }, weight = 1 }, -- Legendary (extra ritka)
            { item = { 'coin_weapon' }, money = { 500, 600 }, weight = 2 }, -- epic (nagyon ritka)
            { item = { 'coin_shirt' }, money = { 500, 600 }, weight = 10 }, -- rare (ritka)
            { item = { 'iron', 'petrol' }, money = { 500, 600 }, weight = 40 }, -- uncommon (közepes)
            { item = { 'bread', 'water' }, money = { 500, 600 }, weight = 80 }, -- common (gyakori)
            { item = {}, money = { 500, 600 }, weight = 70 } -- nothing (semmi)
        },
        point = 2, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    },
    s = {
        -- SHINEY RAGYOGÓ LÁDA (0-3)
        drop = {
            { item = { 'coin_car', 'coin_property' }, money = { 600, 1000 }, weight = 1 }, -- Legendary (extra ritka)
            { item = { 'coin_weapon' }, money = { 600, 1000 }, weight = 4 }, -- epic (nagyon ritka)
            { item = { 'coin_shirt' }, money = { 600, 1000 }, weight = 12 }, -- rare (ritka)
            { item = { 'iron', 'petrol' }, money = { 600, 1000 }, weight = 40 }, -- uncommon (közepes)
            { item = { 'bread', 'water' }, money = { 600, 1000 }, weight = 60 } -- common (gyakori)
        },
        point = 3, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    },
    f = {
        -- FORTUNE LÁDA (0-2)
        drop = {
            { item = { 'coin_car', 'coin_property' }, money = { 1000, 1500 }, weight = 1 }, -- Legendary (extra ritka)
            { item = { 'coin_weapon' }, money = { 1000, 1500 }, weight = 2 }, -- epic (nagyon ritka)
            { item = { 'coin_shirt' }, money = { 1000, 1500 }, weight = 10 }, -- rare (ritka)
            { item = { 'iron', 'petrol' }, money = { 1000, 1500 }, weight = 40 }, -- uncommon (közepes)
            { item = { 'bread', 'water' }, money = { 1000, 1500 }, weight = 80 } -- common (gyakori)
        },
        point = 3, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    },
    l = {
        -- LUCKY LÁDA (0-2)
        drop = {
            { item = { 'coin_car', 'coin_property' }, money = { 1000, 1500 }, weight = 1 }, -- Legendary (extra ritka)
            { item = { 'coin_weapon' }, money = { 1000, 1500 }, weight = 2 }, -- epic (nagyon ritka)
            { item = { 'coin_shirt' }, money = { 1000, 1500 }, weight = 10 }, -- rare (ritka)
            { item = { 'iron', 'petrol' }, money = { 1000, 1500 }, weight = 40 }, -- uncommon (közepes)
            { item = { 'bread', 'water' }, money = { 1000, 1500 }, weight = 80 } -- common (gyakori)
        },
        point = 3, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    },
    e = {
        -- EVENT LÁDA
        drop = {
            { item = {}, money = { 5000, 10000 }, weight = 1 }
        },
        point = 5, -- geopoint
        object = 1489572967,
        offset = vector3(0.0, 0.0, 0.0)
    }
}

-- Láda találat esetén jelzés a global chat-re
Config.broadcast = {
    20, -- standard láda találatonként chat értesítést kap mindenki
    15 -- eventláda találatonként chat értesítést kap mindenki
}

Config.hitList = {
    'kis rozsda',
    'szög',
    'cetli',
    'jókívánság',
    'kolbászdarab',
    'egérfarok',
    'nyúlláb',
    'toll',
    'kagyló',
    'szárított virág',
    'csont darab',
    'hangya',
    'újságdarab',
    'szelepsapka',
    'imbuszfejű csavar',
    'banánhéj',
    'bogár',
    'giliszta',
    'drót',
    'bálamadzag',
    'hajgumi',
    'lukas garas',
    'csokipapír',
    'gally',
    'csúszósaru',
    'érvéghüvely',
    'almacsutka',
    'tojáshéj',
    'porcica',
    'szálka',
    'moha',
    'pitypang',
    'üres darázsfészek',
    'szelepgumi',
    'befőttesgumi',
    'jégkrém pálcika',
    'kavics',
    'cápafog',
    'puma karom',
    'kukorica',
    'lyukas hangszóró',
}

Config.npc = {
    { modelHash = 's_f_y_shop_low', heading = 87.45, pos = vector3(463.17, -792.74, 26.36), action = 'shop' },
    { modelHash = 's_f_y_shop_mid', heading = 264.2, pos = vector3(-3028.04, 365.12, 13.47), action = 'shop' },
    { modelHash = 's_f_y_shop_low', heading = 241.42, pos = vector3(1683.46, 6426.39, 31.19), action = 'shop' },
    { modelHash = 's_f_y_shop_mid', heading = 187.26, pos = vector3(1797.06, 4591.74, 36.73), action = 'shop' },
    { modelHash = 'a_f_y_tourist_01', heading = 30.0, pos = vector3(1507.19, 762.5, 76.42), action = 'geo' },
    { modelHash = 'a_f_y_tourist_01', heading = 90.0, pos = vector3(-1492.26, 4973.61, 62.81), action = 'geo' },
}

Config.shopItem = {
    -- crafting materials
    -- knife, bandage, drug, diamond, gold, food
    { item = 'coin_property', currency = 'coin', price = 100 },
    { item = 'coin_car', currency = 'coin', price = 60 },
    { item = 'coin_weapon', currency = 'coin', price = 20 },
    { item = 'coin_shirt', currency = 'coin', price = 10 },

    { item = 'gold', currency = 'coin', price = 100 },
    { item = 'diamond', currency = 'coin', price = 50 },
    { item = 'iron', currency = 'coin', price = 5 },

    { item = 'coin_shirt', currency = 'point', price = 200 },
    { item = 'bread', currency = 'point', price = 10 },
    { item = 'water', currency = 'point', price = 10 },
}


-- RANK CONDITIONS
Config.rank = {
    { hit = 0, opened = 0 }, -- iron
    { hit = 150, opened = 300 }, -- bronze
    { hit = 250, opened = 500 }, -- silver
    { hit = 500, opened = 1000 }, -- gold
    { hit = 800, opened = 1600 }, -- platinum
}

-- TITLE CONDITIONS
Config.title = {
    { opened = 0, rank = 1 }, -- Kezdő,
    { opened = 100, rank = 2 }, -- Barangoló,
    { opened = 300, rank = 3 }, -- Kiránduló,
    { opened = 500, rank = 3 }, -- Kutató,
    { opened = 700, rank = 3 }, -- Kalandor,
    { opened = 1000, rank = 3 }, -- Felfedező,
    { opened = 1300, rank = 4 }, -- Kincsvadász,
    { opened = 1600, rank = 4 }, -- Világjáró,
    { opened = 2000, rank = 4 }, -- Expedíció vezető,
    { opened = 2500, rank = 5 }, -- Kincstárnok,
}


Config.anim = {
    greeting = {
        { dict = 'gestures@m@standing@casual', anim = 'gesture_hello', duration = 1250 },
        { dict = 'anim@mp_player_intupperwave', anim = 'enter', duration = 1250 },
        { dict = 'friends@frm@ig_1', anim = 'greeting_idle_a', duration = 3400 },
        { dict = 'random@shop_tattoo', anim = '_greeting', duration = 7720 },
        { dict = 'random@shop_gunstore', anim = '_greeting', duration = 4800 },
    },
    bye = {
        { dict = 'gestures@f@standing@casual', anim = 'gesture_bye_soft', duration = 1450 },
        { dict = 'anim@mp_player_intincarwavebodhi@ps@', anim = 'exit', duration = 1050 },
        { dict = 'anim@mp_player_intupperwave', anim = 'exit', duration = 1500 },
        { dict = 'anim@arena@celeb@podium@no_prop@', anim = 'regal_c_1st', duration = 6100 },
        { dict = 'rcmepsilonism8', anim = 'think', duration = 3000 },
        { dict = 'random@shop_clothes@low', anim = '_reaction_a', duration = 5150 },
        { dict = 'random@shop_tattoo', anim = '_positive_goodbye', duration = 4150 },
        { dict = 'random@shop_gunstore', anim = '_positive_goodbye', duration = 4150 },
    },
    search = {
        { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', anim = 'machinic_loop_mechandplayer', duration = 4000 }, -- 22.250 ms
        { dict = 'amb@world_human_gardener_plant@male@base', anim = 'base', duration = 4000 },
        { dict = 'amb@medic@standing@tendtodead@idle_a', anim = 'idle_c', duration = 4400 },
        { dict = 'anim@mp_snowball', anim = 'pickup_snowball', duration = 2500 },
        { dict = 'missheist_agency2aig_13', anim = 'pickup_briefcase', duration = 4800 },
        { dict = 'pickup_object', anim = 'pickup_low', duration = 2000 },
        -- { dict = 'amb@world_human_bum_wash@male@high@base', anim = 'base', duration = 3700 }, -- Csak lógatja a kezét
    }
}

for _, v in pairs(Config.npc) do

    if (v.action == 'shop' and not Config.shopCommand) or (v.action == 'geo' and not Config.geoCommand) then

        v.enable = true
    end
end