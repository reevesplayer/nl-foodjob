QBCore = exports['qb-core']:GetCoreObject()

function csNoti(msg)
    if Config.Notify == 'qb' then 
        QBCore.Functions.Notify(msg)
    elseif Config.Notify == 'ox' then -- Uncomment ox_lib in fxmanifest.lua
        libNotify({

        })
    elseif Config.Notify == 'custom' then 
        -- Your Notify Script logic here
    else 
        print('Notify not set. Set it correctly in config.lua')
    end
end

function csVehKeys(plate)
    if Config.VehicleKeys == 'qb' then 
        TriggerServerEvent('vehiclekeys:client:SetOwner', plate)
    elseif Config.VehicleKeys == 'custom' then 
        -- Your Vehicle Keys logic here
    else 
        print('Vehicle Keys not set. Set it correctly in config.lua')
    end
end