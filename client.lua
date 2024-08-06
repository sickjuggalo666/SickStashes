local QBCore = exports['qb-core']:GetCoreObject()


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
            dict = 'fixing_a_ped',
            clip = 'mini@repair'
        },
    }) then 
        QBCore.Functions.TriggerCallback('SickStashes:checkVehicleOwner', function(tmkc)
            if tmkc then
                if info.ss == nil then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", plate.."SS", {
                        maxweight = 40000,
                        slots = 10,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", plate.."SS")
                    TriggerServerEvent('regsecretstash', car, plate, ident, slot)
                elseif info.ss == plate then
                    TriggerServerEvent("inventory:server:OpenInventory", "stash", plate.."SS", {
                        maxweight = 40000,
                        slots = 10,
                    })
                    TriggerEvent("inventory:client:SetCurrentStash", plate.."SS")
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
        end, plate, ident)
    else 
        lib.notify({
            description = 'Canceled..',
            type = 'error',
            position = 'top'
        })
    end
end)
