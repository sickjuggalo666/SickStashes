Core = nil

if Config.Framework == 'ESX' then
    Core = exports.ex_extended:getSharedObject()
elseif Config.Framework == 'QBCore' then
    Core = exports['qb-core']:GetCoreObject()
end

exports.ox_inventory:displayMetadata({
    stashplate = 'Plate',
    car = 'Car'
})

RegisterNetEvent('SickStashes:secretstash', function(ident, info, slot)
    local me = PlayerPedId()
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(me))
    local car = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(me)))
    if not IsPedSittingInAnyVehicle(me) then
        lib.notify({
            description = 'You can\'t use Stash Key Outside',
            type = 'error'
        })
        return
    end
    if lib.progressBar({
        duration = 2000,
        label = 'Inserting Secret Stash Key',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped'
        },
    }) then 
        if Config.Framework == 'ESX' then
            Core.TriggerServerCallback('SickStashes:checkVehicleOwner', function(owned)
                if owned then
                    if info.ss == nil then
                        TriggerServerEvent('SickStashes:regsecretstash', car, plate, ident, slot)
                    elseif info.ss == plate then
                        TriggerServerEvent('SickStashes:regsecretstash', car, plate, ident, slot)
                        Wait(1000)
                        exports.ox_inventory:openInventory('stash', 'carstash:'..info.ss)
                    else
                        lib.notify({
                            description = 'Key Mismatch',
                            type = 'error'
                        })
                    end
                else
                    lib.notify({
                        description = 'You dont\'t own this Vehicle',
                        type = 'error',
                        position = 'top'
                    })
                end
            end, plate, ident )
        elseif Config.Framework == 'QBCore' then
            Core.Functions.TriggerCallback('SickStashes:checkVehicleOwner', function(owned)
                if owned then
                    if Config.Inventory == 'ox' then
                        if info.ss == nil then
                            TriggerServerEvent('SickStashes:regsecretstash', car, plate, ident, slot)
                        elseif info.ss == plate then
                            TriggerServerEvent('ox:loadStashes')
                            Wait(1000)
                            exports.ox_inventory:openInventory('stash', 'carstash:'..info.ss)
                        else
                            lib.notify({
                                description = 'Key Mismatch',
                                type = 'error'
                            })
                        end
                    elseif Config.Inventory == 'qb' then
                        local id = 'Secret_Stash_car:'..plate
                        local trapHouse = {}
                        trapHouse.label = 'Secret Car Stash'
                        trapHouse.items = id.inventory or {}
                        trapHouse.slots = 10
                        TriggerServerEvent('inventory:server:OpenInventory', 'stash', trapHouse.label, trapHouse)
                        TriggerEvent('inventory:client:SetCurrentStash', trapHouse.label)
                    end
                else
                    lib.notify({
                        description = 'You dont\'t own this Vehicle',
                        type = 'error',
                        position = 'top'
                    })
                end
            end, plate, ident)
        end
    else 
        lib.notify({
            description = 'Canceled..',
            type = 'error',
            position = 'top'
        })
    end
end)
