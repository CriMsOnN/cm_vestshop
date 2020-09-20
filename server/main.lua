ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


TriggerEvent('esx_society:registerSociety', 'vestshop', 'Vestshop', 'society_vestshop', 'society_vestshop', 'society_vestshop', {type = 'public'})

RegisterNetEvent('cm_vestshop:removeItemAddItem')
AddEventHandler('cm_vestshop:removeItemAddItem', function(item) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem(item)

    if item == 'bulletproof' then
        if xPlayer.getInventoryItem(Config.NeededItem).count > 0 then
            if xPlayer.canCarryItem(item, 1) then
                xPlayer.addInventoryItem(item, 1)
                xPlayer.removeInventoryItem(Config.NeededItem, Config.NeededItemAmount)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="inform", text="You used x1 iron to craft the bulletproof"})
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="You dont have enough space!"})

            end
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="You dont have iron"})
        end
    end
end)

ESX.RegisterUsableItem('bulletproof', function(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local hasItem = xPlayer.getInventoryItem('bulletproof')
    if hasItem then
        xPlayer.removeInventoryItem('bulletproof', 1)
        TriggerClientEvent('cm_vestshop:useBulletproof', source)
    end
end)


RegisterNetEvent('cm_vestshop:server:getStockItem')
AddEventHandler('cm_vestshop:server:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vestshop', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then

			-- can the player carry the said amount of x item?
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="inform", text="You have withdrawn x" .. count .. " " .. inventoryItem.label})
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="Invalid quantity"})
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, {type="error", text="Invalid quantity"})
		end
	end)
end)

RegisterNetEvent('cm_vestshop:server:putStockItems')
AddEventHandler('cm_vestshop:server:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vestshop', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type="inform", text="You have deposited x" .. count .. " " .. inventoryItem.label})
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type="error", text="Invalid quantity"})
		end
	end)
end)

ESX.RegisterServerCallback('cm_vestshop:server:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_vestshop', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('cm_vestshop:server:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)