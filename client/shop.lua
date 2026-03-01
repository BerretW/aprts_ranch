local Prompt = nil
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local menuOpen = false

local function prompt()
    Citizen.CreateThread(function()
        local str = CreateVarString(10, 'LITERAL_STRING', "Obchod se zvířaty")
        Prompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(Prompt, 0x760A9C6F)
        PromptSetText(Prompt, str)
        PromptSetEnabled(Prompt, true)
        PromptSetVisible(Prompt, true)
        PromptSetHoldMode(Prompt, true)
        PromptSetGroup(Prompt, promptGroup)
        PromptRegisterEnd(Prompt)
    end)
end

-- Tvorba Blipů
Citizen.CreateThread(function()
    for _, shop in pairs(Config.Shops) do
        if shop.blip then
            local blip = BlipAddForCoords(1664425300, shop.coords.x, shop.coords.y, shop.coords.z)
            SetBlipSprite(blip, 423351566, 1) -- Použije ranch blip
            SetBlipScale(blip, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, shop.name)
        end
    end
end)

local function OpenShopMenu(shopId)
    local pJob = LocalPlayer.state.Character.Job
    local shop = Config.Shops[shopId]
    
    local availableAnimals = {}
    for breed, data in pairs(shop.animals) do
        -- Zkontroluje, zda má hráč povolené plemeno kupovat
        if data.job == "" or data.job == pJob then
            table.insert(availableAnimals, {
                breed = breed,
                name = data.name,
                price = data.price
            })
        end
    end

    menuOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = "OPEN_SHOP",
        shopId = shopId,
        shopName = shop.name,
        animals = availableAnimals
    })
end

-- NUI Callbacks
RegisterNUICallback("closeShop", function(data, cb)
    SetNuiFocus(false, false)
    menuOpen = false
    cb("ok")
end)

RegisterNUICallback("buyShopAnimal", function(data, cb)
    SetNuiFocus(false, false)
    menuOpen = false

    local count = table.count(walkingAnimals)
    if count >= Config.maxWalkedAnimals then
        notify("Už nemůžeš vést další zvířata!")
        cb("ok")
        return
    end

    -- Přidán 4. parametr: data.gender
    TriggerServerEvent("aprts_ranch:Server:buyShopAnimal", data.shopId, data.breed, data.price, data.gender)
    cb("ok")
end)

local function LoadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Citizen.Wait(10) end
    return modelHash
end

local function spawnNPC(model, x, y, z, h)
    local modelHash = LoadModel(model)
    local npc = CreatePed(modelHash, x, y, z, false, false, false, false)
    PlaceEntityOnGroundProperly(npc)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetEntityHeading(npc, h or 0.0)
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetModelAsNoLongerNeeded(modelHash)
    return npc
end

Citizen.CreateThread(function()
    prompt()
    while true do
        local pause = 1000
        if not menuOpen then
            local playerPos = GetEntityCoords(PlayerPedId(), false)
            
            for id, shop in pairs(Config.Shops) do
                local dist = #(playerPos - shop.coords)
                
                if dist < Config.RenderDistance then
                    if not DoesEntityExist(shop.npcObj) then
                        shop.npcObj = spawnNPC(shop.model, shop.coords.x, shop.coords.y, shop.coords.z, shop.heading)
                    end
                else
                    if DoesEntityExist(shop.npcObj) then
                        DeleteEntity(shop.npcObj)
                        shop.npcObj = nil
                    end
                end

                if dist < 1.5 then
                    PromptSetActiveGroupThisFrame(promptGroup, CreateVarString(10, 'LITERAL_STRING', "Obchod"))
                    if PromptHasHoldModeCompleted(Prompt) then
                        Citizen.Wait(500)
                        OpenShopMenu(id)
                    end
                    pause = 0
                end
            end
        end
        Citizen.Wait(pause)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    for _, shop in pairs(Config.Shops) do
        if DoesEntityExist(shop.npcObj) then
            DeleteEntity(shop.npcObj)
        end
    end
end)