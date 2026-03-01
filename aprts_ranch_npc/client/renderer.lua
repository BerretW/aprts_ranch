Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for _, npc in pairs(Config.NPC) do
            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - npc.coords)
            if distance < Config.RenderDistance then
                if not DoesEntityExist(npc.ped) then
                    npc.ped = spawnNPC(npc.model, npc.coords.x, npc.coords.y, npc.coords.z, npc.heading)
                end
            else
                if DoesEntityExist(npc.ped) then
                    DeleteEntity(npc.ped)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local pause = 1000

        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)

        for _, animal in pairs(walkedAnimals) do
            animal.coords = GetEntityCoords(animal.obj)

            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, animal.coords.x, animal.coords.y,
                animal.coords.z)
            if distance > Config.maxDistance or IsPedDeadOrDying(animal.obj, true) then
                if DoesEntityExist(animal.obj) then
                    debugPrint("Deleting animal: " .. animal.obj)
                    notify("Zvíře které vedeš se ztratilo")
                    DeleteEntity(animal.obj)
                    exports["aprts_ranch"]:removeHerdAnimal(animal.obj)
                    table.remove(walkedAnimals, _)
                end
            end
        end
        local count = table.count(walkedAnimals)
       -- print(count)
        if count > 0 then
            DrawTxt("Vedu : " .. count .. "/" .. Config.maxWalkedAnimals, 0.5, 0.01, 0.5, 0.5, true, 255, 255, 255,
                255, true)
            pause = fpsTimer()
        end
        Citizen.Wait(pause)
    end
end)
