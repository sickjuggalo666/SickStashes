Core = nil

if Config.Framework == 'ESX' then
    Core = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QBCore' then
    Core = exports['qb-core']:GetCoreObject()
end

if Config.Framework == 'ESX' then
    Core.RegisterUsableItem('stash_key', function(playerId)
        local xPlayer = Core.GetPlayerData(playerId)
        local slot = 1
        local meta = nil
        local Search = exports.ox_inventory:Search(playerId, 'slots', 'stash_key')
        if Search then
            for _,name in pairs(Search) do
                slot = name.slot
                meta = name.metadata.plate or nil
            end
        end
        TriggerClientEvent('SickStashes:secretstash', source, xPlayer.identifier, meta, slot)
    end)
else
    Core.Functions.CreateUseableItem("stash_key", function(source, item)
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.GetItemBySlot(item.slot) ~= nil then
            TriggerClientEvent('SickStashes:secretstash', source, Player.PlayerData.citizenid, item.metadata, item.slot)
        end
    end)
end

RegisterServerEvent('SickStashes:regsecretstash', function(car, plate, ident, slot)
    if Config.Framework == 'ESX' then
        local src = source
        local player = Core.GetPlayerFromIdentifier(ident)
        local slotData = exports.ox_inventory:GetSlotWithItem(src, 'stash_key')
        for _,data in pairs(slotData) do
            if data.metadata.stashplate == plate then
                exports.ox_inventory:RemoveItem(src, 'stash_key', 1)
                local name = player.getName()
                local info = {}
                info.car = car
                info.stashplate = plate
                info.owner = name
                exports.ox_inventory:AddItem(src, 'stash_key', 1, info, slot)
                exports.ox_inventory:RegisterStash("carstash:"..plate, plate, 5, 15000, nil)
            end   
        end
    elseif Config.Framework == 'QBCore' then
        local Player = Core.Functions.GetPlayerByCitizenId(ident)
        if Player.Functions.GetItemBySlot(slot) ~= nil then
            Player.Functions.RemoveItem('stash_key', 1)
            local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
            local info = {}
            info.car = car
            info.stashplate = plate
            info.owner = name
            exports.ox_inventory:AddItem(Player.PlayerData.source, 'stash_key', 1, info, slot)
            exports.ox_inventory:RegisterStash("carstash:"..plate, plate, 5, 15000, nil)
            Wait(1000)
        else
            print('SLOT CHANGED')
        end
    end
end)

if Config.Framework == 'ESX' then
    Core.RegisterServerCallback('SickStashes:checkVehicleOwner', function(src, cb, plate, owner)
        MySQL.query('SELECT * FROM owned_vehicles WHERE plate = ? AND identifier = ?',{plate, owner}, function(result)
            if result[1] then
                cb(true)
            else
                cb(false)
            end
        end)
      end)
elseif Config.Framework == 'QBCore' then
    Core.Functions.CreateCallback("SickStashes:checkVehicleOwner", function(source, cb, plate, owner)
        MySQL.query('SELECT * FROM player_vehicles WHERE plate = ? AND citizenid = ?',{plate, owner}, function(result)
            if result[1] then
                cb(true)
            else
                cb(false)
            end
        end)
    end)
    
end

