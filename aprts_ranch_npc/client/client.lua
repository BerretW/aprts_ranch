-- NPCs = {}
local shopPrompt = nil
local promptGroup = GetRandomIntInRange(0, 0xffffff)
walkedAnimals = {}
blips = {}


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

function notify(text)
    TriggerEvent('notifications:notify', "Ranč", text, 3000)
end

function getFPS()
	local frameTime = GetFrameTime()
    local frame = 1.0 / frameTime
	return frame
end

function fpsTimer()
    local minFPS = 15
    local maxFPS = 165
    local minSpeed = 0
    local maxSpeed = 15
    local coefficient = 1 - (getFPS() - minFPS) / (maxFPS - minFPS)
    return minSpeed + coefficient * (maxSpeed - minSpeed)
end


function DrawTxt(str, x, y, w, h, enableShadow, col1, col2, col3, a, centre)
    local str = CreateVarString(10, "LITERAL_STRING", str)
    SetTextScale(w, h)
    SetTextColor(math.floor(col1), math.floor(col2), math.floor(col3), math.floor(a))
    SetTextCentre(centre)
    if enableShadow then
        SetTextDropshadow(1, 0, 0, 0, 255)
    end
    Citizen.InvokeNative(0xADA9255D, 22)
    DisplayText(str, x, y)
end


local function LoadModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
    end
end

function spawnNPC(model, x, y, z, h)
    debugPrint("Spawning NPC: " .. model)   
    if h == nil then
        h = 0.0
    end
    LoadModel(model)
    local npc_ped = CreatePed(model, x, y, z - 1.0, h, false, false, false, false)
    PlaceEntityOnGroundProperly(npc_ped)
    Citizen.InvokeNative(0x283978A15512B2FE, npc_ped, true)
    SetEntityCanBeDamaged(npc_ped, false)
    SetEntityInvincible(npc_ped, true)
    FreezeEntityPosition(npc_ped, true)
    SetBlockingOfNonTemporaryEvents(npc_ped, true)
    SetModelAsNoLongerNeeded(model)
    return npc_ped
end

function CreateBlip(name, coords,sprite)
    print("Creating Blip for NPC: " .. name)
    local blip = BlipAddForCoords(1664425300, coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite, 1)
    SetBlipScale(blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, name)
    return blip
end


local function prompt() 
    Citizen.CreateThread(function()
        local str ="Obchod"
        local wait = 0
        shopPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(shopPrompt, 0x760A9C6F)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(shopPrompt, str)
        PromptSetEnabled(shopPrompt, true)
        PromptSetVisible(shopPrompt, true)
        PromptSetHoldMode(shopPrompt, true)
        PromptSetGroup(shopPrompt, promptGroup)
        PromptRegisterEnd(shopPrompt) 
    end)
end

Citizen.CreateThread(function()
	prompt()
    for k, npc in pairs(Config.NPC) do
        table.insert(blips, CreateBlip(npc.name, npc.coords, -1406874050))
    end
    while true do
		Citizen.Wait(3)
		local sleep = true
		for k, npc in pairs(Config.NPC) do
            
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)
			local betweencoords = Vdist(coords.x, coords.y, coords.z, npc.coords.x, npc.coords.y, npc.coords.z)
			if betweencoords < 2.0 then
				sleep = false
				local animals = CreateVarString(10, 'LITERAL_STRING',"Zvířata")
            	PromptSetActiveGroupThisFrame(promptGroup, animals) 
            	if PromptHasHoldModeCompleted(shopPrompt) then
                    debugPrint("Opening menu for: " .. npc.name)
                    WarMenu.OpenMenu('shop_' .. npc.id)
                    -- FreezeEntityPosition(playerPed, true)
                    Citizen.Wait(1000)
				end
            
            elseif WarMenu.IsMenuOpened('shop_' .. npc.id) then
                debugPrint("No NPC in range")
                WarMenu.CloseMenu()
			end
		end
		if sleep then
			Citizen.Wait(1000)
		end
	end
end)


