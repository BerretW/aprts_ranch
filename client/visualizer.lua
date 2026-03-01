local function getFPS()
    return 1.0 / GetFrameTime()
end

function fpsTimer()
    return 0
end

-- ==========================================
-- DYNAMICKÝ NUI SYSTÉM ("STACKING")
-- ==========================================
local nuiStates = {}

function setDisplayData(category, data, showImage, imagePath)
    nuiStates[category] = {
        data = data,
        showImage = showImage,
        imagePath = imagePath,
        lastUpdate = GetGameTimer() -- Záznam času, kdy se hodnota naposledy aktualizovala
    }
end

Citizen.CreateThread(function()
    local lastJson = ""
    while true do
        Citizen.Wait(200) 
        local currentTime = GetGameTimer()
        local activeStates = {}

        -- Kontrola platnosti dat (pokud hráč odejde, hodnota se přestane updatovat a vyprší)
        for cat, state in pairs(nuiStates) do
            if currentTime - state.lastUpdate < 400 then 
                activeStates[cat] = {
                    data = state.data,
                    showImage = state.showImage,
                    imagePath = state.imagePath
                }
            else
                nuiStates[cat] = nil -- Data jsou příliš stará, mažeme slot
            end
        end

        local currentJson = json.encode(activeStates)
        if currentJson ~= lastJson then
            SendNUIMessage({
                type = "UPDATE_OVERLAYS",
                states = activeStates
            })
            lastJson = currentJson
        end
    end
end)
-- ==========================================

local function prepareData(animal)
    local tool = exports["aprts_tools"]:GetEquipedTool()
    local animalConfig = Config.Animals[animal.breed]
    local data = {}

    if runningAnimation ~= nil then
        if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
    else
        if tool == Config.BrushItem then
            if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
            data[2] = {text = "Čistota: " .. animal.clean .. "%", color = "#ffffff"}
            data[3] = {text = "Stiskni[" .. Config.KeyLabel .. "] pro vyčištění", color = "#ffddff"}
        elseif medicine ~= nil then
            if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
            data[2] = {text = "Zdraví: " .. animal.health .. "%", color = "#fc0a03"}
            data[3] = {text = "Pohlaví: " .. animal.gender, color = "#00aaff"}
            data[4] = {text = "Věk: " .. animal.age .. " let / Dospělost: " .. (animal.adult and "ano" or "ne"), color = "#ffffff"}
            if hasJob(Config.DoctorJobs) == true then
                data[5] = {text = "Nemoc: " .. animal.sick .. "%", color = "#ffffff"}
            elseif animal.sick > 1 then
                data[5] = {text = "Nemocné", color = "#fc0a03"}
            end
            if animal.gender == "female" then
                data[6] = {text = (animal.pregnant == 0 and "Není březí" or "Březí"), color = "#ffffff"}
            end
            data[7] = {text = "Stiskni [" .. Config.KeyLabel .. "] pro léčbu", color = "#ffddff"}
        elseif tool == nil then
            if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
            data[2] = {text = "Zdraví: " .. animal.health .. "%", color = "#fc0a03"}
            data[3] = {text = "Pohlaví: " .. animal.gender, color = "#00aaff"}
            data[4] = {text = "Věk: " .. animal.age .. " let / Dospělost: " .. (animal.adult and "ano" or "ne"), color = "#ffffff"}
            data[5] = {text = "Hlad: " .. animal.food .. "/" .. animalConfig.foodMax .. " Žízeň: " .. animal.water .. "/" .. animalConfig.waterMax, color = "#00aaff"}
            data[6] = {text = "Štěstí: " .. animal.happynes .. "% / Energie: " .. animal.energy .. "%", color = "#ffffff"}
            data[7] = {text = "Čistota: " .. animal.clean .. "% / Kvalita: " .. animal.xp, color = "#ffffff"}
            if animal.sick > 1 then data[8] = {text = "Nemocné", color = "#fc0a03"} end
            if animal.gender == "female" then
                data[9] = {text = (animal.pregnant == 0 and "Není březí" or "Březí"), color = "#ffffff"}
            end
            data[10] = {text = Config.FeedKeyLabel .. " = nakrmit, " .. Config.WaterKeyLabel .. " = napojit", color = "#ffddff"}
        elseif tool == Config.leashItem and table.count(walkingAnimals) < Config.maxWalkedAnimals then
            if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
            data[2] = {text = "Zdraví: " .. animal.health .. "%", color = "#fc0a03"}
            data[3] = {text = "Energie: " .. animal.energy .. "%", color = "#ffffff"}
            data[4] = {text = "Věk: " .. animal.age .. " let / Dospělost: " .. (animal.adult and "ano" or "ne"), color = "#ffffff"}
            data[5] = {text = "Hlad: " .. animal.food .. "/" .. animalConfig.foodMax .. " Žízeň: " .. animal.water .. "/" .. animalConfig.waterMax, color = "#00aaff"}
            data[6] = {text = "Stiskni [" .. Config.KeyLabel .. "] Venčit", color = "#ffddff"}
        else
            for k, product in pairs(animalConfig.product) do
                if product.gather == 2 and tool == product.tool and (animal.gender == product.gender or product.gender == nil) then
                    if animal.name then data[1] = {text = "Jméno: " .. animal.name, color = "#ffffff"} end
                    data[2] = {text = "Zdraví: " .. animal.health .. "%", color = "#fc0a03"}
                    data[3] = {text = "Produkt: " .. animal.count .. "ks", color = "#ffffff"}
                    data[4] = {text = "Stiskni [" .. Config.KeyLabel .. "] pro sběr " .. product.name, color = "#ffddff"}
                    break
                end
            end
        end
    end
    return data
end

-- ==========================================
-- HOVNA A PRODUKTY V KOŠÍKU
-- ==========================================
Citizen.CreateThread(function()
    while true do
        local pause = 1000
        local tool = SafeExport("aprts_tools", "GetEquipedToolClass", nil)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        if tool == Config.ShovelClass and not runningAnimation then
            for _, poop in pairs(poops) do
                local poopPos = poop.coords
                local distance = #(playerPos - vector3(poopPos.x, poopPos.y, poopPos.z))
                if distance <= 1.5 then
                    setDisplayData("poop", {{text = "[" .. Config.KeyLabel .. "] Sebrat hovno", color = "#fc0a03"}}, true, "poop")
                    pause = fpsTimer()
                    if IsControlJustPressed(0, Config.Key) then
                        TriggerServerEvent("aprts_ranch:Server:pickupPoop", poop.id)
                    end
                    break
                end
            end
        elseif tool == Config.productPickupToolClass and not runningAnimation then
            if closestRailing then
                for v, product in pairs(closestRailing.products) do
                    if product.amount > 0 then
                        local productPos = product.coords
                        local distance = #(playerPos - vector3(productPos.x, productPos.y, productPos.z))
                        if distance <= 1.5 then
                            local data = {
                                {text = product.amount .. "x " .. product.name, color = "#fc0a03"}, 
                                {text = "[" .. Config.KeyLabel .. "] Sebrat", color = "#fc0a03"}
                            }
                            setDisplayData("product", data, true, "basket")
                            pause = fpsTimer()
                            if IsControlJustPressed(0, Config.Key) then
                                TriggerServerEvent("aprts_ranch:Server:pickupProduct", closestRailing.id, product.name)
                            end
                            break
                        end
                    end
                end
            end
        end
        Citizen.Wait(pause)
    end
end)

-- ==========================================
-- ZVÍŘATA (Interakce)
-- ==========================================
Citizen.CreateThread(function()
    while true do
        local pause = 1000
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local tool = SafeExport("aprts_tools", "GetEquipedTool", nil)
        
        if land and land.access and land.access >= 1 then
            for _, animal in pairs(animals) do
                if DoesEntityExist(animal.obj) and animal.health > 0 then
                    local animalPos = GetEntityCoords(animal.obj)
                    local distance = #(playerPos - animalPos)
                    local animalConfig = Config.Animals[animal.breed]
                    
                    if distance <= 1.5 then
                        -- Zapíše se do nezávislé kategorie "animal"
                        setDisplayData("animal", prepareData(animal), true, animal.breed)
                        FreezeEntityPosition(animal.obj, true)
                        closestAnimal = animal
                        pause = 0
                        
                        if runningAnimation == nil then
                            if tool == Config.BrushItem then
                                if IsControlJustPressed(0, Config.Key) then
                                    TriggerServerEvent("aprts_ranch:Server:cleanAnimal", animal.id)
                                    Wait(Config.Animation.clean.time)
                                end
                            elseif medicine ~= nil then
                                if IsControlJustPressed(0, Config.Key) then
                                    if hasJob(medicine.job) == true then
                                        TriggerServerEvent("aprts_ranch:Server:healAnimal", animal.id, medicine)
                                        Wait(Config.Animation.cure.time)
                                        exports["aprts_tools"]:UnequipTool()
                                        medicine = nil
                                    end
                                end
                            elseif tool == nil then
                                if IsControlJustPressed(0, Config.FeedKey) then
                                    TriggerServerEvent("aprts_ranch:Server:feedAnimal", animal.id)
                                    Wait(Config.Animation.feed.time)
                                end
                                if IsControlJustPressed(0, Config.WaterKey) then
                                    TriggerServerEvent("aprts_ranch:Server:waterAnimal", animal.id, 50.0)
                                    Wait(Config.Animation.water.time)
                                end
                            elseif tool == Config.leashItem and table.count(walkingAnimals) < Config.maxWalkedAnimals then
                                if IsControlJustPressed(0, Config.Key) then
                                    lastRailingID = animal.railing_id
                                    TriggerServerEvent("aprts_ranch:Server:takeAnimal", animal.id)
                                end
                            else
                                for k, product in pairs(animalConfig.product) do
                                    if product.gather == 2 and tool == product.tool and (animal.gender == product.gender or product.gender == nil) then
                                        if IsControlJustPressed(0, Config.Key) then
                                            TriggerServerEvent("aprts_ranch:Server:gatherAnimalProduct", animal.id, product)
                                            Wait(product.anim.time)
                                        end
                                        break
                                    end
                                end
                            end
                            break
                        end
                    else
                        if closestAnimal == animal then closestAnimal = nil end
                    end

                    if IsEntityFrozen(animal.obj) then FreezeEntityPosition(animal.obj, false) end
                end
            end
        end
        Citizen.Wait(pause)
    end
end)

-- ==========================================
-- PORCOVÁNÍ A OŽIVOVÁNÍ ZVÍŘAT
-- ==========================================
Citizen.CreateThread(function()
    while not LocalPlayer.state do Wait(100) end
    while not LocalPlayer.state.Character do Wait(100) end
    repeat Wait(100) until LocalPlayer.state.IsInSession
    
    while true do
        local pause = 1000
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local tool = SafeExport("aprts_tools", "GetEquipedTool", nil)
        
        if land and land.access and land.access >= 1 then
            if tool == Config.CleaverItem then
                for _, animal in pairs(animals) do
                    if DoesEntityExist(animal.obj) and animal.health == 0 then
                        local animalPos = GetEntityCoords(animal.obj)
                        if #(playerPos - animalPos) <= 1.5 then
                            setDisplayData("corpse", {
                                {text = "Zdechlina", color = "#fc0a03"},
                                {text = "Dospělost: " .. (animal.adult and "ano" or "ne"), color = "#fc0a03"},
                                {text = "Stiskni [" .. Config.KeyLabel .. "] pro naporcování", color = "#fc0a03"}
                            }, true, "meat")
                            pause = 0
                            if IsControlJustPressed(0, Config.Key) then
                                TriggerServerEvent("aprts_ranch:Server:slaughterAnimal", animal.id)
                            end
                            break
                        end
                    end
                end
            end
        end

        if tool == Config.medicineItemTool and hasJob(Config.DoctorJobs) == true then
            for _, animal in pairs(animals) do
                if DoesEntityExist(animal.obj) and IsEntityDead(animal.obj) then
                    local animalPos = GetEntityCoords(animal.obj)
                    if #(playerPos - animalPos) <= 1.5 then
                        setDisplayData("revive", {
                            {text = "Zraněné zvíře " .. animal.id, color = "#fc0a03"},
                            {text = "Stiskni [" .. Config.KeyLabel .. "] pro pokus o oživení", color = "#fc0a03"}
                        }, true, "medicine")
                        pause = 0
                        if IsControlJustPressed(0, Config.Key) then
                            TriggerServerEvent("aprts_ranch:Server:reviveAnimal", animal.id)
                        end
                    end
                end
            end
        end
        Citizen.Wait(pause)
    end
end)

-- ==========================================
-- KRMÍTKA
-- ==========================================
Citizen.CreateThread(function()
    while true do
        local pause = 1000
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local tool = SafeExport("aprts_tools", "GetEquipedTool", nil)

        if land and land.access and land.access >= 1 then
            for _, railing in pairs(railings) do
                local railingPos = vector3(railing.coords.x, railing.coords.y, railing.coords.z)
                local distance = #(playerPos - railingPos)
                local configFeeding = Config.feeding[railing.prop]
                
                if distance <= railing.size then
                    local data = {
                        {text = "[" .. railing.id .. "] Zvířat: " .. getCountAnimlsonRailing(railing) .. "/" .. railing.size, color = "#00aaff"},
                        {text = "Jídla: " .. railing.food .. "/" .. configFeeding.food, color = "#00aaff"},
                        {text = "Vody: " .. railing.water .. "/" .. configFeeding.water, color = "#ffffff"}
                    }
                    
                    if distance <= 1.5 then
                        if tool == Config.fullWaterItem then
                            data[4] = {text = "Stiskni[" .. Config.KeyLabel .. "] doplnění vody", color = "#00aaff"}
                            if IsControlJustPressed(0, Config.Key) then
                                exports["aprts_tools"]:UnequipTool()
                                TriggerServerEvent("aprts_ranch:Server:addWater", railing.id, 100)
                            end
                        elseif tool == Config.fullFoodItem then
                            data[4] = {text = "Stiskni [" .. Config.KeyLabel .. "] doplnění jídla", color = "#00aaff"}
                            if IsControlJustPressed(0, Config.Key) then
                                exports["aprts_tools"]:UnequipTool()
                                TriggerServerEvent("aprts_ranch:Server:addFood", railing.id, 100)
                            end
                        elseif tool == nil and table.count(herdAnimals) < 1 and land.access > 0 and table.count(walkingAnimals) > 0 then
                            data[4] = {text = "[" .. Config.KeyLabel2 .. "] Uvázat Zvířata", color = "#20aaff"}
                            if IsControlJustPressed(0, Config.Key2) then
                                for _, animal in pairs(walkingAnimals) do
                                    if DoesEntityExist(animal.obj) and #(GetEntityCoords(animal.obj) - playerPos) <= 30 then
                                        TriggerServerEvent("aprts_ranch:Server:putAnimal", railing.id, animal)
                                        lastRailingID = railing.id
                                    end
                                end
                            end
                        end
                    end
                    
                    pause = fpsTimer()
                    -- Zapíše se do nezávislé kategorie "railing"
                    setDisplayData("railing", data, true, "railing")
                    closestRailing = railing
                    break
                else
                    if closestRailing == railing then closestRailing = nil end
                end
            end
        end
        Citizen.Wait(pause)
    end
end)