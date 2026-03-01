Config = {}
Config.Debug = false
Config.BlipSprite = 1
Config.RenderDistance = 100.0 -- Distance to render the NPC
Config.maxWalkedAnimals = 5
Config.maxDistance = 50.0
--
Config.NPC = {
    [1] = {
        id = 1,
        model = "a_m_m_rancher_01",
        coords = vector3(-2027.762329, -3020.870361, -10.007650),
        name = "Prodej zvířat NewAustin",
        heading = 0.0,
        blip = true,
        animals = {
            Goat = {
                name = "Goat",
                price = 400,
                job = ""
            },
            Cow = {
                name = "Cow",
                price = 1000,
                job = "rancher"
            },
            Chicken1 = {
                name = "Chicken1",
                price = 200,
                job = ""
            },
            sheep = {
                name = "sheep",
                price = 400,
                job = "rancher"
            },
            pig = {
                name = "pig",
                price = 500,
                job = "rancher"
            }

        }
    },
    [2] = {
        id = 2,
        model = "a_m_m_rancher_01",
        coords = vector3(3024.648193, 1444.212036, 46.983086),
        name = "Prodej zvířat",
        heading = 0.0,
        blip = true,
        animals = {
            Goat = {
                name = "Goat",
                price = 400,
                job = ""
            },
            Cow = {
                name = "Cow",
                price = 1000,
                job = "rancher"
            },
            Chicken1 = {
                name = "Chicken1",
                price = 200,
                job = ""
            },
            sheep = {
                name = "sheep",
                price = 400,
                job = "rancher"
            },
            pig = {
                name = "pig",
                price = 500,
                job = "rancher"
            }

        }
    }
    ,
    [3] = {
        id = 3,
        model = "a_m_m_rancher_01",
        coords = vector3(909.666870, -1788.167480, 43.062794),
        name = "Prodej zvířat Rhodes",
        heading = -90.0,
        blip = true,
        animals = {
            Goat = {
                name = "Goat",
                price = 400,
                job = ""
            },
            Cow = {
                name = "Cow",
                price = 1000,
                job = "rancher"
            },
            Chicken1 = {
                name = "Chicken1",
                price = 200,
                job = ""
            },
            sheep = {
                name = "sheep",
                price = 400,
                job = "rancher"
            },
            pig = {
                name = "pig",
                price = 500,
                job = "rancher"
            }

        }
    } ,
    -- [4] = {
    --     id = 4,
    --     model = "a_m_m_rancher_01",
    --     coords = vector3(1402.024780, 296.036652, 88.497635),
    --     name = "Prodej zvířat Emerald",
    --     heading = -90.0,
    --     blip = true,
    --     animals = {
    --         Goat = {
    --             name = "Goat",
    --             price = 400,
    --             job = ""
    --         },
    --         Cow = {
    --             name = "Cow",
    --             price = 1000,
    --             job = "rancher"
    --         },
    --         Chicken1 = {
    --             name = "Chicken1",
    --             price = 200,
    --             job = ""
    --         },
    --         sheep = {
    --             name = "sheep",
    --             price = 400,
    --             job = "rancher"
    --         },
    --         pig = {
    --             name = "pig",
    --             price = 500,
    --             job = "rancher"
    --         }

    --     }
    -- }
}
