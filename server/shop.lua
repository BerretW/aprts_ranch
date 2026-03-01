local Core = exports.vorp_core:GetCore()

RegisterNetEvent("aprts_ranch:Server:buyShopAnimal")
-- Přidán parametr reqGender
AddEventHandler("aprts_ranch:Server:buyShopAnimal", function(shopId, breed, price, reqGender)
    local _source = source
    local User = Core.getUser(_source)
    local Character = User.getUsedCharacter
    local money = Character.money

    if money >= price then
        Character.removeCurrency(0, price) -- Strhne peníze
        
        -- Zjištění pohlaví zvířete (pokud není specifikováno, nebo je random, hodí se mincí)
        local finalGender = reqGender
        if finalGender == nil or finalGender == "random" then
            finalGender = math.random() < 0.5 and 'male' or 'female'
        end

        local meta = {} -- Výchozí meta pro zvíře
        local time = getTimeStamp()

        MySQL:execute([[
            INSERT INTO aprts_ranch_animals 
            (name, breed, gender, health, food, water, clean, sick, happynes, energy, age, pregnant, `count`, railing_id, home, born, updated, meta) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, FROM_UNIXTIME(?), FROM_UNIXTIME(?), ?)
        ]], {
            breed, breed, finalGender, 100, 100, 100, 100, 0, 100, 100, 0, 0, 0, 0, 0, time, time, json.encode(meta)
        }, function(result)
            
            local animalId = result.insertId
            local newAnimal = {
                id = animalId,
                name = breed,
                breed = breed,
                gender = finalGender, -- Přepsáno z 'gender' na 'finalGender'
                health = 100,
                food = 100,
                water = 100,
                clean = 100,
                sick = 0,
                happynes = 100,
                energy = 100,
                age = 0,
                pregnant = 0,
                count = 0,
                railing_id = 0,
                oldRailing = 0, 
                home = 0,       
                meta = meta,
                xp = 0
            }

            TriggerClientEvent("aprts_ranch:Client:walkAnimal", _source, newAnimal)
            TriggerClientEvent("notifications:notify", _source, "RANČ", "Zakoupil jsi nové zvíře!", 4000)
            
        end)
    else
        TriggerClientEvent("notifications:notify", _source, "RANČ", "Nemáš dostatek peněz!", 4000)
    end
end)

-- Tento event použije sendHome v client.lua, pokud uteče zvíře, které ještě nemělo ohradu
RegisterNetEvent("aprts_ranch:Server:lostAnimal")
AddEventHandler("aprts_ranch:Server:lostAnimal", function(animalId)
    -- Uložení do DB jako ztracené (home = 0, railing_id = 0)
    MySQL:execute("UPDATE aprts_ranch_animals SET home = 0, railing_id = 0 WHERE id = ?", {animalId})
end)