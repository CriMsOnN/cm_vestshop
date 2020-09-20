Config = {}
Config.DrawDistance = 100.0
Config.MarkerType = 20
Config.MarkerSize = { x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor = { r = 255, g = 0, b = 0}

Config.EnablePlayerManagement = true
Config.EnableArmoryManagement = true

Config.EnableJobBlip = true

Config.NeededItem = 'iron'
Config.NeededItemAmount = 1


Config.VestShop = {
    House = {
        Blip = {
            Coords = vector3(-1379.58, -499.63, 32.22),
            Sprite = 175,
            Display = 4,
            Scale = 1.2,
            Colour = 2
        },

        FrontDoor = {
            vector3(-1379.58, -499.63, 32.22)
        },

        Cloakrooms = {
            vector3(-1380.84, -466.65, 72.04)
        },
        
        Craft = {
            vector3(-1380.43, -469.35, 72.04)
        },

        BossActions = {
            vector3(-1373.02, -464.2, 72.04)
        },
        Armories = {
            vector3(-1375.32, -486, 72.04)
        },
        Travel = {
            {
                From = vector3(-1379.58, -499.63, 33),
                To = {coords = vector3(-1393.29, -479.62, 72.04), heading = 270.82},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            },
            {
                From = vector3(-1399.24, -480.23, 72.04),
                To = {coords = vector3(-1370.84, -503.57, 33.16), heading = 130.2},
                Marker = {type = 20, x = 0.3, y = 0.2, z = 0.3, r = 255, g = 0, b = 0, a = 100, rotate = true}
            }
        }
    }
}

Config.Uniforms = {
    recruit_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 65,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        }
    },
    guard_wear = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1'] = 50,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 11,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 25,   ['shoes_2'] = 0,
			['helmet_1'] = 65,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 36,  ['tshirt_2'] = 1,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = 45,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        }
    },
    boss_wear = {
        male = {
            ['tshirt_1'] = 7,  ['tshirt_2'] = 2,
			['torso_1'] = 11,   ['torso_2'] = 0,
			['decals_1'] = 8,   ['decals_2'] = 3,
			['arms'] = 11,
			['pants_1'] = 25,   ['pants_2'] = 0,
			['shoes_1'] = 21,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        },
        female = {
            ['tshirt_1'] = 35,  ['tshirt_2'] = 0,
			['torso_1'] = 48,   ['torso_2'] = 0,
			['decals_1'] = 7,   ['decals_2'] = 3,
			['arms'] = 44,
			['pants_1'] = 34,   ['pants_2'] = 0,
			['shoes_1'] = 27,   ['shoes_2'] = 0,
			['helmet_1'] = -1,  ['helmet_2'] = 0,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = 2,     ['ears_2'] = 0
        }
    }
}