local Prompt = nil
local promptGroup = GetRandomIntInRange(0, 0xffffff)
local menuOpen = false
lostAnimals = {}

local function prompt()
    Citizen.CreateThread(function()
        local str = CreateVarString(10, 'LITERAL_STRING', "Otevřít")
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

local function OpenShellterMenu(coords)
    menuOpen = true
    SetNuiFocus(true, true) -- Povolí myš

    local shelterData = {}
    for _, animal in pairs(lostAnimals) do
        local animalCfg = Config.Animals[animal.breed]
        if animal.age < animalCfg.dieAge then
            local price = (animalCfg.dieAge - animal.age) * 10
            table.insert(shelterData, {
                id = animal.id,
                name = animal.name or animal.breed,
                breed = animal.breed,
                age = animal.age,
                price = price,
                coords = {x = coords.x, y = coords.y, z = coords.z} -- Převod vektoru na čistá data pro JS
            })
        end
    end

    -- Pošleme data do HTML
    SendNUIMessage({
        type = "OPEN_SHELTER",
        animals = shelterData
    })
end

-- ===============================================
-- NUI CALLBACKS PRO ÚTULEK
-- ===============================================
RegisterNUICallback("closeShelter", function(data, cb)
    SetNuiFocus(false, false)
    menuOpen = false
    cb("ok")
end)

RegisterNUICallback("buyAnimal", function(data, cb)
    local price = tonumber(data.price)
    local c = data.coords
    local spawnCoords = vector3(c.x, c.y, c.z)

    if price <= LocalPlayer.state.Character.Money then
        TriggerServerEvent("aprts_ranch:Server:takeAnimal", data.id, true, spawnCoords)
        TriggerServerEvent("aprts_ranch:Server:removeMoney", price)
        notify("Zvíře bylo vykoupeno.")
    else
        notify("Nemáš dostatek peněz.")
    end

    SetNuiFocus(false, false)
    menuOpen = false
    SendNUIMessage({type = "CLOSE_SHELTER"})
    cb("ok")
end)
-- ===============================================

local function LoadModel(model)
    local modelHash = GetHashKey(model)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end
    return modelHash
end

local function spawnNPC(model, x, y, z, h)
    local modelHash = LoadModel(model)
    local npc_ped = CreatePed(modelHash, x, y, z, false, false, false, false)
    PlaceEntityOnGroundProperly(npc_ped)
    Citizen.InvokeNative(0x283978A15512B2FE, npc_ped, true)
    SetEntityHeading(npc_ped, h or 0.0)
    SetEntityCanBeDamaged(npc_ped, false)
    SetEntityInvincible(npc_ped, true)
    FreezeEntityPosition(npc_ped, true)
    SetBlockingOfNonTemporaryEvents(npc_ped, true)
    SetEntityCompletelyDisableCollision(npc_ped, false, false)
    SetModelAsNoLongerNeeded(modelHash)
    return npc_ped
end

local function handleNPC(playerPos)
    for _, shellter in ipairs(Config.Shelters) do
        local distance = #(playerPos - shellter.npcCoords)
        if distance < Config.RenderDistance then
            if not DoesEntityExist(shellter.npc) then
                shellter.npc = spawnNPC(shellter.model, shellter.npcCoords.x, shellter.npcCoords.y, shellter.npcCoords.z, shellter.heading)
            end
        else
            if DoesEntityExist(shellter.npc) then
                DeleteEntity(shellter.npc)
                shellter.npc = nil
            end
        end
    end
end

Citizen.CreateThread(function()
    prompt()
    while true do
        local pause = 1000
        if menuOpen == false then
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed, false)
            handleNPC(playerPos)

            for _, shellter in ipairs(Config.Shelters) do
                local distance = #(playerPos - shellter.npcCoords)
                if distance < 1.5 then
                    if hasJob(Config.Jobs) == true then
                        local name = CreateVarString(10, 'LITERAL_STRING', "Útulek")
                        PromptSetActiveGroupThisFrame(promptGroup, name)

                        if PromptHasHoldModeCompleted(Prompt) then
                            Citizen.Wait(1000)
                            OpenShellterMenu(shellter.coords)
                        end
                        pause = 0
                    end
                end
            end
        end
        Citizen.Wait(pause)
    end
end)

RegisterNetEvent("aprts_ranch:Client:removeLostAnimal")
AddEventHandler("aprts_ranch:Client:removeLostAnimal", function(id)
    lostAnimals[id] = nil
end)