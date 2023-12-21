QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('cs-foodjob:server:pickupItem')
AddEventHandler('cs-foodjob:server:pickupItem', function()
    local src = source

    -- Check if the player is on the job
    if activatedJob and onJob then
        local success = false

        local item = Config.DeliveryItem
        local amount = 1
        local Player = QBCore.Functions.GetPlayer(src)

        if Player.Functions.AddItem(item, 1) then
            TriggerClientEvent('inventory:client:ItemBox', QBCore.Shared.Items[item], 'add')
            success = true

            if Config.Debug then 
                print('cs-foodjob: pickupItem success')
            end
            csNoti('You have picked up the food. Proceed to the drop-off location')
            local dropOffLocation = DropOffLocations[math.random(1, #DropOffLocations)]
            TriggerClientEvent('cs-foodjob:client:startDropOff', src, dropOffLocation)
        else
            if Config.Debug then 
                print('cs-foodjob: pickupItem failure')
            end
            csNoti('Failed to pick up the food. Please try again.')
        end

        -- Send the success status to the client
        TriggerClientEvent('cs-foodjob:pickupItemStatus', src, success)
    else
        -- Notify the player that they can't pick up the item
        TriggerClientEvent('chatMessage', src, 'SYSTEM', {255, 0, 0}, 'You are not on the job or not activated.')
    end
end)


RegisterNetEvent('cs-foodjob:server:dropoffItem')
AddEventHandler('cs-foodjob:server:dropoffItem', function()
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