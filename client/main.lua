QBCore = exports['qb-core']:GetCoreObject()

local onDuty = false


























function spawnPed()
    ReguestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do
        Wait(0)
    end

    local pedCreated = CreatePed(0, Config.PedModel, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, Config.PedHeading, false, false)
    FreezeEntityPosition(pedCreated, true)
    SetEntityInvincible(pedCreated, true)
    SetBlockingOfNonTemporaryEvents(pedCreated, true)
    exports['qb-target']:AddTargetEntity(pedCreated, {
        options = {{type = "client", event = "nl-foodjob:client:startwork", label = "Start Work", icon = 'fas fa-check', canInteract = function (entity)
            if not IsPedInAnyVehicle(PlayerPedId()) and not IsEntityDead(PlayerPedId()) then
                return true
            end 
        end}},
        distance = 2.0
    })
end


AddEventHandler('onResourceStart', function(resourceName)
    spawnPed()
end)