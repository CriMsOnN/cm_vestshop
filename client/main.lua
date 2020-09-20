local PlayerData, CurrentActionData, blipsVestShop, currentTask = {}, {}, {}, {}
local HasAlreadyEnteredMarker, isDead, hasAlreadyJoined = false, false, false
local LastStation, LastPart, LastPartNum, LastEntity, CurrentAction, CurrentActionMsg
local isCrafting = false

ESX = nil

Citizen.CreateThread(function() 
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

cleanPed = function(ped)
	SetPedArmour(ped, 0)
	ClearPedBloodDamage(ped)
	ResetPedVisibleDamage(ped)
	ClearPedLastWeaponDamage(ped)
	ResetPedMovementClipset(ped, 0)
end

setUniform = function(job, ped)
    TriggerEvent('skinchanger:getSkin', function(skin) 
        if skin.sex == 0 then
            if Config.Uniforms[job].male then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
            else
                exports['mythic_notify']:SendAlert('error', 'No outfit available')
            end
        else
            if Config.Uniforms[job].female then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
            else
                exports['mythic_notify']:SendAlert('error', 'No outfit available')
            end
        end
    end)
end

OpenCraftMenu = function()
    local ped = PlayerPedId()
    local elements = {
        {label = 'Vest', value = 'vest'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'craft', {
        title = 'Craft Menu',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
            isCrafting = true
            exports['progressBars']:startUI(5000, 'Crafting Bullet Proof')
            TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)
            Citizen.Wait(5000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('cm_vestshop:removeItemAddItem', 'bulletproof')
            isCrafting = false
    end, function(data, menu)
        menu.close()
        CurrentAction = 'menu_craft'
        CurrentActionData = {}
    end)
end

RegisterNetEvent('cm_vestshop:useBulletproof')
AddEventHandler('cm_vestshop:useBulletproof', function() 
    local playerPed = GetPlayerPed(-1)
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(PlayerId()), "clothingshirt", "try_shirt_positive_d", 1.0, -1, -1, 50, 0, 0, 0, 0)
    exports['progressBars']:startUI(2000, "Putting on Vest")
    Citizen.Wait(2000)
    SetPedArmour(playerPed, 100)
    StopAnimTask(PlayerPedId(), 'clothingshirt', 'try_shirt_positive_d', 1.0)
    SetPedComponentVariation(GetPlayerPed(-1), 9, 27, 6, 0)
    exports['mythic_notify']:SendAlert('inform', 'Used vest')
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)
        if isCrafting then
            DisableAllControlActions(0)
        end
    end
end)


RegisterCommand('bill', function(source, args, rawCommand) 
    if PlayerData.job.name == 'vestshop' then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 3.0 then
            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_vestshop', 'Vestshop', args[1])
            exports['mythic_notify']:SendAlert('inform', 'Ticket send')
        else
            exports['mythic_notify']:SendAlert('error', 'No nearby players')

        end
    else
        exports['mythic_notify']:SendAlert('error', 'You dont have permissions for this command')
    end
end)

OpenBossActions = function()
    ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_society:openBossMenu', 'vestshop', function(data, menu)
		menu.close()

		CurrentAction     = 'menu_boss_actions'
        CurrentActionData = {}
    end, {wash = false})

end

OpenArmoryActions = function()
    local elements = {
        { label = 'Withdraw Stock', value = 'get_stock'},
        { label = 'Deposit Stock', value = 'put_stock'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = 'Vestshop Armory',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
        if data.current.value == 'get_stock' then
            OpenGetStocksMenu()
        elseif data.current.value == 'put_stock' then
            OpenPutStocksMenu()
        end
    end, function(data,menu) 
        menu.close()
        CurrentAction = 'menu_armory'
        CurrentActionData = {station = station}
    end) 
end


OpenGetStocksMenu = function()
	ESX.TriggerServerCallback('cm_vestshop:server:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Stock Menu',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Quantity'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					exports['mythic_notify']:SendAlert('Invalid quantity')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('cm_vestshop:server:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenArmoryActions()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

OpenPutStocksMenu = function()
    ESX.TriggerServerCallback('cm_vestshop:server:getPlayerInventory', function(inventory) 
        local elements = {}

        for i=1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard', 
                    value = item.name
                })
            end
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            title = 'Inventory',
            align = 'top-left',
            elements = elements
        }, function(data, menu) 
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                title = 'Quantity'
            }, function(data2, menu2) 
                local count = tonumber(data2.value)

                if not count then
                    exports['mythic_notify']:SendAlert('Invalid quantity')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('cm_vestshop:server:putStockItems', itemName, count)
                    Citizen.Wait(300)
                    OpenArmoryActions()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu) 
            menu.close()
        end)
    end)
end



OpenCloakroomMenu = function()
    local ped = PlayerPedId()
    local grade = PlayerData.job.grade

    local elements = {
        { label = 'Personal Outfit', value = 'citizen_wear'},
        { label = 'Recruit', value = 'recruit_wear'},
    }
    if grade == 1 then
        table.insert(elements, { label = 'Boss Suit', value = 'boss_wear' })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
        title = 'Locker Room',
        align = 'top-left',
        elements = elements
    }, function(data, menu) 
        cleanPed(ped)
        clothes = data.current.value

        if clothes == 'citizen_wear' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin) 
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        elseif clothes == 'recruit_wear' or clothes == 'boss_wear' then
            setUniform(clothes, ped)
        end
    end, function(data, menu) 
        menu.close()
        CurrentAction = 'menu_cloakroom'
        CurrentActionData = {}
    end)
end


Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)

        if PlayerData.job and PlayerData.job.name == 'vestshop' then
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            local isInMarker, hasExited  = false, false
            local currentStation, currentPart, currentPartNum

            for k,v in pairs(Config.VestShop) do
                for i=1, #v.Cloakrooms, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Cloakrooms[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Cloakrooms[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Cloakroom', i
                    end
                end
                for i=1, #v.Craft, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Craft[i], true)
    
                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Craft[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'Craft', i
                    end
                end
                for i=1, #v.BossActions, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.BossActions[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.BossActions[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'BossActions', i
                    end
                end
                for i=1, #v.Armories, 1 do
                    local distance = GetDistanceBetweenCoords(coords, v.Armories[i], true)

                    if distance < Config.DrawDistance then
                        DrawMarker(20, v.Armories[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.2, 0.3, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, true, false, false, false)
                    end

                    if distance < Config.MarkerSize.x then
                        isInMarker, currentStation, currentPart, currentPartNum = true, k, 'ArmoryActions', i
                    end
                end
            end
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then
				if
					(LastStation and LastPart and LastPartNum) and
					(LastStation ~= currentStation or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
				then
					TriggerEvent('cm_vestshop:hasExitedMarker', LastStation, LastPart, LastPartNum)
					hasExited = true
				end

				HasAlreadyEnteredMarker = true
				LastStation             = currentStation
				LastPart                = currentPart
				LastPartNum             = currentPartNum

				TriggerEvent('cm_vestshop:hasEnteredMarker', currentStation, currentPart, currentPartNum)
			end

			if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('cm_vestshop:hasExitedMarker', LastStation, LastPart, LastPartNum)
			end
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(0)

        if CurrentAction then
            ESX.ShowHelpNotification(CurrentActionMsg)

            if IsControlJustReleased(0, 38) and PlayerData.job and PlayerData.job.name == 'vestshop' then
                if CurrentAction == 'menu_cloakroom' then
                    OpenCloakroomMenu()
                elseif CurrentAction == 'menu_craft' then
                    OpenCraftMenu()
                elseif CurrentAction == 'menu_boss_actions' then
                    OpenBossActions()
                elseif CurrentAction == 'menu_armory' then
                    OpenArmoryActions()
                end
            end
        end
    end
end)

AddEventHandler('cm_vestshop:hasEnteredMarker', function(station, part, partNum) 
    if part == 'Cloakroom' then
        CurrentAction = 'menu_cloakroom'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Cloakroom~s~.'
        CurrentActionData = {}
    elseif part == 'Craft' then
        CurrentAction = 'menu_craft'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Craft~s~.'
        CurrentActionData = {}
    elseif part == 'BossActions' then
        CurrentAction = 'menu_boss_actions'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Computer~s~.'
        CurrentActionData = {}
    elseif part == 'ArmoryActions' then
        CurrentAction = 'menu_armory'
        CurrentActionMsg = 'Press ~g~E~w~ to access the ~g~Armory~s~.'
        CurrentActionData = {}
    end
end)

AddEventHandler('cm_vestshop:hasExitedMarker', function(station, part, partNum) 
    ESX.UI.Menu.CloseAll()
    CurrentAction = nil
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job) 
    PlayerData.job = job
    Citizen.Wait(5000)
    TriggerServerEvent('cm_vestshop:forceCreateBlips')
end)

function Travel(coords, heading)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Citizen.Wait(500)
    end

    ESX.Game.Teleport(playerPed, coords, function() 
        DoScreenFadeIn(800)

        if heading then
            SetEntityHeading(playerPed, heading)
        end
    end)
end

--Travel
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k,v in pairs(Config.VestShop.House.Travel) do
				local distance = #(playerCoords - v.From)

				if distance < Config.DrawDistance then
					DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil, nil, false)
					letSleep = false

					if distance < v.Marker.x then
						Travel(v.To.coords, v.To.heading)
					end
				end
		end
	end
end)

-- Blips
Citizen.CreateThread(function() 
    for k,v in pairs(Config.VestShop) do
        local blip = AddBlipForCoord(v.Blip.Coords)
        SetBlipSprite(blip, v.Blip.Sprite)
        SetBlipDisplay(blip, v.Blip.Display)
        SetBlipScale(blip, v.Blip.Scale)
        SetBlipColour(blip, v.Blip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Vest Shop')
        EndTextCommandSetBlipName(blip)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	isDead = true
end)

AddEventHandler('onResourceStop', function(resource) 
    if resource == GetCurrentResourceName() then
        ESX.UI.Menu.CloseAll()
    end
end)