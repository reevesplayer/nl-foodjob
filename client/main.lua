QBCore = exports['qb-core']:GetCoreObject()

local onDuty = false
local onJob = false 
local activatedJob = false
local pickUpLocations = Config.PickupLocations
local DropOffLocations = Config.DropOffLocations
local vehicleSpawnLoc = Config.VehicleSpawn
local deliveryVeh = nil

function spawnVeh(x, y, z, w)
    local vehModel = GetHashKey(Config.VehicleModel)
    RequestModel(vehModel)
    while not HasModelLoaded(vehModel) do
        Wait(0)
    end
    deliveryVeh = CreateVehicle(vehModel, x, y, z, w, true, false)
    local id = NetworkGetNetworkIdFromEntity(deilveryVeh)
	SetNetworkIdCanMigrate(id, true)
	SetNetworkIdExistsOnAllMachines(id, true)
	SetVehicleDirtLevel(deilveryVeh, 0)
	SetVehicleHasBeenOwnedByPlayer(deilveryVeh, true)
	SetEntityAsMissionEntity(deilveryVeh, true, true)
	SetVehicleEngineOn(deilveryVeh, true, true, true)
	SetVehicleColours(deilveryVeh, 131, 74)
	exports[Config.FuelSystem]:SetFuel(deilveryVeh, 100.0)
	local plate = GetVehicleNumberPlateText(deilveryVeh)
	csVehKeys(plate)
end


CreateThread(function()
    local pedModel = GetHashKey(Config.PedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(1)
    end
    local ped = CreatePed(4, pedModel, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, Config.PedHeading, false, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetEntityHeading(ped, Config.PedHeading)
    SetPedCanPlayAmbientAnims(ped, true)
	SetPedCanRagdollFromPlayerImpact(ped, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)

    if Config.Target == 'qb' then 
        exports['qb-target']:AddTargetModel(pedModel, {
            options = {
                {
                    event = "cs-foodjob:startJob",
                    icon = "fas fa-utensils",
                    label = "Start Job",
                    canInteract = function() 
                        return not activatedJob
                    end
                },
                {
                    event = "cs-foodjob:stopJob",
                    icon = "fas fa-utensils",
                    label = "Stop Job",
                    canInteract = function() 
                        return activatedJob
                    end
                },
            },
            distance = 2.5
        })
    elseif Config.Target == 'ox' then
        -- oxlogic
    end
end)

RegisterNetEvent('cs-foodjob:startJob', function()
    if not activatedJob and onJob then 
        if not DoesEntityExist(Config.VehicleModel) then
            SpawnDeliveryVehicle(vehicleSpawnLoc.x, vehicleSpawnLoc.y, vehicleSpawnLoc.z, vehicleSpawnLoc.w)
            if QBCore.Functions.GetPlayerData().money.cash >= Config.DepositPrice then 
                TriggerServerEvent('cs-foodjob:payDeposit', Config.DepositPrice, "remove")
                csNoti('Wait for an order to come in')
                onJob = true
                activatedJob = true
                Wait(Config.OrderWaitTime)
                csNoti('An order has come in. Proceed to the waypoint.')
                pickUpBlip = AddBlipForCoord(pickUpLocations[math.random(1, #pickUpLocations)])
                SetBlipSprite(pickUpBlip, Config.PickupBlip.Sprite)
                SetBlipColour(pickUpBlip, Config.PickupBlip.Color)
                SetBlipScale(pickUpBlip, Config.PickupBlip.Scale)
                SetBlipAsShortRange(pickUpBlip, Config.PickupBlip.ShortRange)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.PickupBlip.Text)
                EndTextCommandSetBlipName(pickUpBlip)
                
            else 
                csNoti('You do not have enough money to pay the deposit')
            end
        end 
    else
        csNoti('You are already making a delivery')
    end           
end)

RegisterNetEvent('cs-foodjob:stopJob', function()
    if activatedJob and onJob then 
        if DoesEntityExist(Config.VehicleModel) then 
            DeleteEntity(Config.VehicleModel)
            RemoveBlip(pickUpBlip)
            RemoveBlip(dropOffBlip)
            onJob = false
            activatedJob = false
            if IsVehicleDamaged(Config.VehicleModel) then 
                TriggerServerEvent('cs-foodjob:server:refundPartial')
                csNoti('You have stopped making deliveries. You have been refunded the deposit minus the damage fee')
            else 
                TriggerServerEvent('cs-foodjob:server:refundFull')
                csNoti('You have stopped making deliveries. You have been refunded the deposit')
            end
        else
            csNoti('You lost the vehicle. Damn you....')
            onJob = false
            activatedJob = false
        end
        csNoti('You have stopped making deliveries')
    else 
        csNoti('You need to be making a delivery to stop making deliveries...')
    end
end)

RegisterNetEvent('cs-foodjob:pickupFood', function()
    if activatedJob and onJob then 
        local distance = #(GetEntityCoords(PlayerPedId()) - pickUpLocations[math.random(1, #pickUpLocations)])
        DrawMarker(2, pickUpLocations[math.random(1, #pickUpLocations)], 0, 0, 0, 0, 0, 0, 0.3, 0.2, -0.2, 100, 100, 155, 255, true, true, 0, false, nil, nil, false)
        if distance < 2.5 then 
            RemoveBlip(pickUpBlip)
            csNoti('Picked up the food')
            TriggerServerEvent('cs-foodjob:server:pickupItem')
            Wait(1000)
            csNoti('You have picked up the food. Proceed to the drop off location')
            dropOffBlip = AddBlipForCoord(DropOffLocations[math.random(1, #DropOffLocations)])
            SetBlipSprite(dropOffBlip, Config.DropOffBlip.Sprite)
            SetBlipColour(dropOffBlip, Config.DropOffBlip.Color)
            SetBlipScale(dropOffBlip, Config.DropOffBlip.Scale)
            SetBlipAsShortRange(dropOffBlip, Config.DropOffBlip.ShortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.DropOffBlip.Text)
            EndTextCommandSetBlipName(dropOffBlip)
        end
    end
end)

RegisterNetEvent('cs-foodjob:dropOffFood', function()
    if activatedJob and onJob then 
        local distance = #(GetEntityCoords(PlayerPedId()) - DropOffLocations[math.random(1, #DropOffLocations)])
        DrawMarker(2, DropOffLocations[math.random(1, #DropOffLocations)], 0, 0, 0, 0, 0, 0, 0.3, 0.2, -0.2, 100, 100, 155, 255, true, true, 0, false, nil, nil, false)
        if distance < 2.5 then 
            RemoveBlip(dropOffBlip)
            csNoti('Dropped off the food')
            TriggerServerEvent('cs-foodjob:server:payDelivery')
            TriggerServerEvent('cs-foodjob:server:dropoffItem')
            Wait(Config.WaitTime)
            csNoti('Proceed to the next pickup location.')
            pickUpBlip = AddBlipForCoord(pickUpLocations[math.random(1, #pickUpLocations)])
            SetBlipSprite(pickUpBlip, Config.PickupBlip.Sprite)
            SetBlipColour(pickUpBlip, Config.PickupBlip.Color)
            SetBlipScale(pickUpBlip, Config.PickupBlip.Scale)
            SetBlipAsShortRange(pickUpBlip, Config.PickupBlip.ShortRange)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Config.PickupBlip.Text)
            EndTextCommandSetBlipName(pickUpBlip)
        end
    end
end)



---------------------------------
--  Handlers
---------------------------------
AddEventHandler('onClientResourceStart', function(resourceName)
    csSpawnPed()
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    csRemovePed()
end)
---------------------------------
-- End Handlers
---------------------------------