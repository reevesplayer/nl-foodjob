QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('cs-foodjob:server:pickupItem')
AddAventHandler('cs-foodjob:server:pickupItem', function()
    local item = Config.DeliveryItem 
    local amount = 1
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[item], 'add')
end)

RegisterNetEvent('cs-foodjob:server:dropoffItem')
AddAventHandler('cs-foodjob:server:dropoffItem', function()
    local item = Config.DeliveryItem 
    local amount = 1
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, 1)
    TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[item], 'remove')
end)

RegisterNetEvent('cs-foodjob:server:payDelivery')
AddEventHandler('cs-foodjob:server:payDelivery', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.DeliveryPay
    Player.Functions.AddMoney(Config.PayType, payment)
end)

RegisterNetEvent('cs-foodjob:server:refundPartial')
AddEventHandler('cs-foodjob:server:refundPartial', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.DepositPrice / 2
    Player.Functions.AddMoney(Config.PayType, payment)
end)

RegisterNetEvent('cs-foodjob:server:refundFull')
AddEventHandler('cs-foodjob:server:refundFull', function()
    local src = source 
    local Player = QBCore.Functions.GetPlayer(src)
    local payment = Config.DepositPrice
    Player.Functions.AddMoney(Config.PayType, payment)
end)