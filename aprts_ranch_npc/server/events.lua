local VORPcore = exports.vorp_core:GetCore()

local function notify(source, text)
    TriggerClientEvent('notifications:notify', source, "Zvířata", text, 3000)
end

RegisterServerEvent("aprts_ranch_npc:Server:buyAnimal")
AddEventHandler("aprts_ranch_npc:Server:buyAnimal", function(animal)
    local _source = source
    local firstname = Player(_source).state.Character.FirstName
    local lastname = Player(_source).state.Character.LastName

    local playerName = firstname .. " " .. lastname

    local user = VORPcore.getUser(_source) --[[@as User]]
    if not user then
        return
    end -- is player in session?
    local character = user.getUsedCharacter --[[@as Character]]
    local money = character.money

    if money >= animal.price then
        character.removeCurrency(0, animal.price)
        -- exports.vorp_inventory:addItem(source, item_code, item_count)
        notify(_source, "Koupil jsi " .. animal.name .. " za " .. animal.price .. "$")
        TriggerClientEvent("aprts_ranch_npc:Client:buyAnimal", _source, animal)

        -- exports.vorp_inventory:addItemsToCustomInventory(Config.Prefix .. store_id, item, 1)
        local text = Player(_source).state.Character.CharId .. "/" .. playerName .. ": " .. "Koupil " .. animal.name ..
                         " za " .. animal.price .. "$"
        lib.logger(_source, 'AnimalStoreBuy', text, "animal:" .. animal.name, "price:" .. animal.price)

    else
        notify(_source, "Nemáš dost peněz!")
    end

end)
