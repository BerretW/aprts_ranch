AddEventHandler("onClientResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    TriggerServerEvent("aprts_ranch_npc:Server:getData")
end)


AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    for k, npc in pairs(Config.NPC) do
        if DoesEntityExist(npc.ped) then
            print("Ukončuji resource, mažu NPC: " .. npc.ped)
            DeleteEntity(npc.ped)
        end
    end
end)

RegisterNetEvent("aprts_ranch_npc:Client:buyAnimal")
AddEventHandler("aprts_ranch_npc:Client:buyAnimal", function(animal)
    animal.obj = exports["aprts_ranch"]:newAnimal(animal.name)
    table.insert(walkedAnimals, animal)
end)