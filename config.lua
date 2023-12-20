Config = {}

Config.VehicleModel = "blista"
Config.VehicleSpawn = vector4(440.84, -981.92, 30.69, 180.0)

Config.PedModel = "s_m_m_linecook"
Config.PedLocation = vector3(440.84, -981.92, 30.69)
Config.PedHeading = 180.0

Config.Target = 'qb' -- qb / ox

Config.PickupLocations = {
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
}

Config.DropOffLocations = {
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
    vector3(440.84, -981.92, 30.69),
}

Config.PickupBlip = {
    Sprite = 1,
    Color = 1,
    Scale = 1.0,
    Display = 4,
    ShortRange = true,
    Text = "Pickup Food",
}

Config.DropOffBlip = {
    Sprite = 1,
    Color = 1,
    Scale = 1.0,
    Display = 4,
    ShortRange = true,
    Text = "Drop Off Food",
}