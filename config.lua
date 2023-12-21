Config = {}

Config.Debug = true

Config.VehicleModel = 'blista'
Config.VehicleSpawn = vector4(-1165.72, -888.22, 14.12, 120.58)
Config.FuelSystem = 'cdn-fuel'
Config.VehicleKeys = 'qb' -- qb / custom

Config.DepositPrice = 500

Config.OrderWaitTime = 8000 -- ms

Config.PedModel = "s_m_m_linecook"
Config.PedLocation = vector3(-1176.33, -890.07, 13.83)
Config.PedHeading = 307.71

Config.Target = 'qb' -- qb / ox
Config.Notify = 'qb' -- qb / ox / custom

Config.DeliveryPay = 100
Config.PayType = 'cash' -- cash / bank
Config.DeliveryItem = 'blankusb'



Config.PickupLocations = {
    vector3(-1180.75, -885.86, 13.89),
    vector3(81.28, 273.96, 110.21),
    vector3(51.01, -135.41, 55.20),
    vector3(-519.74, -677.45, 33.67),
    vector3(-137.95, -256.67, 43.59),
}

Config.DropOffLocations = {
    vector3(-328.25, 370.40, 110.02),
    vector3(119.30, 564.83, 183.96),
    vector3(-20.69, -1858.66, 25.41),
    vector3(1052.23, -470.68, 63.90),
    vector3(-1128.17, -1081.25, 4.22),
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