function createMenus(npc)
    debugPrint("Creating menus for: " .. npc.name)
    local shopID = 'shop_' .. npc.id
    WarMenu.CreateMenu(shopID, npc.name, "Interakce")
    WarMenu.SetSubTitle(shopID, 'Nákup a Prodej')

    WarMenu.CreateSubMenu(shopID .. '_Buy', shopID, "Koupit")
    WarMenu.CreateSubMenu(shopID .. '_Sell', shopID, "Prodat")

    -- for _, animal in pairs(npc.animals) do 
    --     WarMenu.CreateSubMenu(animal.. "_buy", shopID .. '_Buy', animal)
    --     WarMenu.CreateSubMenu(animal.. "_sell", shopID .. '_Sell', animal)
    -- end

    Citizen.CreateThread(function()
        while true do
            local pause = 1000
            if WarMenu.IsMenuOpened(shopID) then
                pause = fpsTimer()
                if WarMenu.MenuButton('Koupit', shopID .. '_Buy') then
                elseif WarMenu.MenuButton('Prodat', shopID .. '_Sell') then
                end
                WarMenu.Display()
            elseif HandleBuySellMenus(shopID .. '_Buy', shopID .. '_Sell', npc.animals) then
                pause = fpsTimer()
                -- This function will handle displaying and interactions in the buy and sell menus
            end
            Citizen.Wait(pause)
        end
    end)
end

function HandleBuySellMenus(buyMenuId, sellMenuId, data)
    local playerPed = PlayerPedId()
    local handled = false
    if WarMenu.IsMenuOpened(buyMenuId) then
        -- debugPrint(json.encode(data))
        for categoryId, category in pairs(data) do
            -- debugPrint(json.encode(category))
            if category.job == "" or string.lower(category.job) == string.lower(LocalPlayer.state.Character.Job) then
                if WarMenu.Button(category.name, tostring(category.price)) then
                    debugPrint("Buying: " .. category.name)
                    -- exports["aprts_ranch"]:newAnimal(category.name)
                    TriggerServerEvent("aprts_ranch_npc:Server:buyAnimal", category)
                    WarMenu.CloseMenu()
                    FreezeEntityPosition(playerPed, false)
                end
            end
        end
        WarMenu.Display()
        handled = true
    elseif WarMenu.IsMenuOpened(sellMenuId) then
        for categoryId, category in pairs(data) do
            debugPrint("asd"..json.encode(category))
            -- if WarMenu.Button(category.name, tostring(category.price)) then
                

            --     -- debugPrint("Buying: " .. category.name)
            --     -- -- exports["aprts_ranch"]:newAnimal(category.name)
            --     -- TriggerServerEvent("aprts_ranch_npc:Server:buyAnimal", category)
            --     WarMenu.CloseMenu()
            --     FreezeEntityPosition(playerPed, false)

            -- end
        end
        WarMenu.Display()
        handled = true
    end
    return handled
end

Citizen.CreateThread(function()
    for _, npc in pairs(Config.NPC) do
        createMenus(npc)
    end
end)

