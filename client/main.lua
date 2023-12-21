QBCore = exports['qb-core']:GetCoreObject()

local onDuty = false
local onJob = false 
local activatedJob = false
local pickUpLocations = Config.PickupLocations
local DropOffLocations = Config.DropOffLocations
local vehicleSpawnLoc = Config.VehicleSpawn
local deliveryVeh = nil

function spawnVeh(x, y, z, w)
    if Config.Debug then 
        print('cs-foodjob: Spawning vehicle')
    end
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
    if Config.Debug then 
        print('cs-foodjob: Vehicle Fueling')
    end
	exports[Config.FuelSystem]:SetFuel(deilveryVeh, 100.0)
	local plate = GetVehicleNumberPlateText(deilveryVeh)
	csVehKeys(plate)
    if Config.Debug then 
        print('cs-foodjob: Keys Given')
    end
end

function spawnPickUpPed(x, y, z, heading)
    local pickuppedModel = GetHashKey(Config.PickupPedModel)
    RequestModel(pickuppedModel)
    while not HasModelLoaded(pickuppedModel) do
        Wait(1)
    end
    local pickupped = CreatePed(4, pickuppedModel, x, y, z, heading, false, false)
    SetBlockingOfNonTemporaryEvents(pickupped, true)
    SetPedDiesWhenInjured(pickupped, false)
    SetEntityHeading(pickupped, heading)
    SetPedCanPlayAmbientAnims(pickupped, true)
	SetPedCanRagdollFromPlayerImpact(pickupped, false)
	SetEntityInvincible(pickupped, true)
	FreezeEntityPosition(pickupped, true)
    if Config.Debug then 
        print('cs-foodjob: PickUpPed Created')
    end

    if Config.Target == 'qb' then 
        exports['qb-target']:AddTargetModelpickup(pedModel, {
            options = {
                {
                    event = "cs-foodjob:server:pickupItem",
                    icon = "fas fa-box",
                    label = "Pickup Package",
                    canInteract = function() 
                        return activatedJob and onJob
                    end
                },
            },
            distance = 2.5
        })
    elseif Config.Target == 'ox' then
        -- oxlogic
    end
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
    if Config.Debug then 
        print('cs-foodjob: Ped Created')
    end

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
    if Config.Debug then 
        print('cs-foodjob: startJob found')
    end

    -- Make sure to initialize these variables if they are not defined globally
    if not activatedJob then 
        activatedJob = false
    end

    if not onJob then 
        onJob = false
    end

    if not activatedJob and not onJob then 
        if Config.Debug then 
            print('cs-foodjob: passed activatedJob and onJob check')
        end

        if not DoesEntityExist(Config.VehicleModel) then
            local randomIndex = math.random(1, #Config.PickupLocations)
            local randomLocation = Config.PickupLocations[randomIndex]
            spawnVeh(vehicleSpawnLoc.x, vehicleSpawnLoc.y, vehicleSpawnLoc.z, vehicleSpawnLoc.w)
            if Config.Debug then 
                print('cs-foodjob: spawned vehicle')
            end
            if QBCore.Functions.GetPlayerData().money.cash >= Config.DepositPrice then 
                TriggerServerEvent('cs-foodjob:payDeposit', Config.DepositPrice, "remove")
                if Config.Debug then 
                    print('cs-foodjob: paid deposit')
                end
                csNoti('Wait for an order to come in')
                onJob = true
                activatedJob = true
                if Config.Debug then 
                    print('cs-foodjob: waiting for order')
                end
                Wait(Config.OrderWaitTime)
                if Config.Debug then 
                    print('cs-foodjob: Waittime ended')
                end
                csNoti('An order has come in. Proceed to the waypoint.')
                pickUpBlip = AddBlipForCoord(randomLocation)
                SetBlipSprite(pickUpBlip, Config.PickupBlip.Sprite)
                SetBlipColour(pickUpBlip, Config.PickupBlip.Color)
                SetBlipScale(pickUpBlip, Config.PickupBlip.Scale)
                SetBlipAsShortRange(pickUpBlip, Config.PickupBlip.ShortRange)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.PickupBlip.Text)
                EndTextCommandSetBlipName(pickUpBlip)
                spawnPickUpPed(randomLocation.x, randomLocation.y, randomLocation.z, Config.PedHeading)
                if Config.Debug then 
                    print('cs-foodjob: pick up blip and ped created at the same location')
                end
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

RegisterNetEvent('cs-foodjob:pickupFood')
AddEventHandler('cs-foodjob:pickupFood', function()
    if Config.Debug then 
        print('cs-foodjob: pickupFood event found')
    end

    -- Your existing code for checking job status and triggering drop-off event
    if activatedJob and onJob then 
        if Config.Debug then 
            print('cs-foodjob: pickupFood found')
        end

        -- Trigger the server event and handle the response
        TriggerServerEvent('cs-foodjob:server:pickupItem', function(success)
            if success then
                if Config.Debug then 
                    print('cs-foodjob: pickupItem success')
                end
                csNoti('You have picked up the food. Proceed to the drop-off location')
                dropOffBlip = AddBlipForCoord(DropOffLocations[math.random(1, #DropOffLocations)])
                SetBlipSprite(dropOffBlip, Config.DropOffBlip.Sprite)
                SetBlipColour(dropOffBlip, Config.DropOffBlip.Color)
                SetBlipScale(dropOffBlip, Config.DropOffBlip.Scale)
                SetBlipAsShortRange(dropOffBlip, Config.DropOffBlip.ShortRange)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.DropOffBlip.Text)
                EndTextCommandSetBlipName(dropOffBlip)
            else
                if Config.Debug then 
                    print('cs-foodjob: pickupItem failure')
                end
                csNoti('Failed to pick up the food. Please try again.')
            end
        end)
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