----------------- 		BIG THNKS to gottfriedleibniz for this DataView in LUA.		-------------
----------------- https://gist.github.com/gottfriedleibniz/8ff6e4f38f97dd43354a60f8494eedff	-------------
-----------------MUST GET THE DATAVIEW IN LUA IN ORDER  TO GET THIS SCRIPT WORK-----------------

local SellWildHorse = 0
local Broken = 2

local MapBlips = {
    { name = 'Sell Wild Horse', sprite = -1103135225, x=-860.012, y=-1381.414, z=42.57}, --
    { name = 'Sell Wild Horse', sprite = -1103135225, x=-5522.55, y=-3029.57, z=-3.215}, --
    { name = 'Sell Wild Horse', sprite = -1103135225, x=-384.74,y= 783.82, z= 114.86}, --
    { name = 'Sell Wild Horse', sprite = -1103135225, x=972.66, y=-1842.48, z=45.60}, --
}

Citizen.CreateThread(function()
    for i, v in pairs(MapBlips) do
        if v.name ~= nil then
            local blip = N_0x554d9d53f696d002(1664425300, v.x, v.y, v.z)
            SetBlipSprite(blip, v.sprite, 1)
            SetBlipScale(blip, 0.2)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, v.name)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(20)
        local coords = GetEntityCoords(PlayerPedId())
        if (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, -860.012, -1381.414, 42.57, true) < 2.0) or
            (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, -5522.550, -3029.578, -3.215, true) < 2.0) or
            (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, -384.741, 783.828, 114.86, true) < 2.0) or
            (GetDistanceBetweenCoords(coords.x, coords.y, coords.z, 972.665, -1842.48, 45.60, true) < 2.0) then
                if Citizen.InvokeNative(0x580417101DDB492F, 0, 0xD8F73058) then
                    SellWildHorse()
                end
            end
    end
end)

function SellWildHorse()
    if SellWildHorse ~= 0 then
        local PlayerPed = PlayerPedId()
        if GetMount(PlayerPed == SellWildHorse then
            Citizen.InvokeNative(0x48E92D3DDE23C23A,PlayerPed,1,0,0,0,0)
            Citizen.Wait(2200)
            DeleteEntity(SellWildHorse)
            SellWildHorse= 0
            local r = math.random(Config.SellHorse.MinPrice,Config.SellHorse.MaxPrice)
            TriggerServerEvent("ricx_wildhorse:sold",r)
	    TriggerEvent("Notification:left", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.Sold..""..r, 'menu_textures', 'menu_icon_alert',  Config.SellHorse.Messages.Duration)		
          else
               TriggerEvent("Notification:left", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.NotBroken, 'menu_textures', 'menu_icon_alert',  Config.SellHorse.Messages.Duration)
           end
    else
        TriggerEvent("Notification:left", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.GetHorse, 'menu_textures', 'menu_icon_alert',  Config.SellHorse.Messages.Duration)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1) 
		local size = GetNumberOfEvents(0) 
		if size > 0 then 
			for i = 0, size - 1 do
				local eventAtIndex = GetEventAtIndex(0, i)
                if eventAtIndex == 218595333 then 
                    local eventDataSize = 3 
					local eventDataStruct = DataView.ArrayBuffer(24) 
					eventDataStruct:SetInt32(0 ,0)
					eventDataStruct:SetInt32(8 ,0) 	
					eventDataStruct:SetInt32(16 ,0)	
					local is_data_exists = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA,0,i,eventDataStruct:Buffer(),eventDataSize)
					if is_data_exists then
                        if eventDataStruct:GetInt32(16) == Broken then
                            if PlayerPedId() == eventDataStruct:SetInt32(0 ,0) then
                                SellWildHorse = eventDataStruct:GetInt32(8)
                            end
                        end
                    end
				end
			end
		end
	end
end)
--Notification
RegisterNetEvent('Notification:left')
AddEventHandler('Notification:left', function(t1, t2, dict, txtr, timer)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true) 
        while not HasStreamedTextureDictLoaded(dict) do
            Wait(5)
        end
    end
    if txtr ~= nil then
        exports.ricx_wild_horse.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    else
        local txtr = "tick"
        exports.ricx_wild_horse.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    end
end)
