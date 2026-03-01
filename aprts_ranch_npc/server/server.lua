function notify(source, text)
    TriggerClientEvent('notifications:notify', source, "Zvířata", text, 3000)
end


function table.count(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

function debugPrint(msg)
    if Config.Debug == true then
        print(msg)
    end
end