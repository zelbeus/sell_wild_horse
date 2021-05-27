----------------- 		BIG THNKS to gottfriedleibniz for this DataView in LUA.		-------------
----------------- https://gist.github.com/gottfriedleibniz/8ff6e4f38f97dd43354a60f8494eedff	-------------
-----------------MUST GET THE DATAVIEW IN LUA IN ORDER  TO GET THIS SCRIPT WORK-----------------

local SellWildHorse = 0
local Broken = 2

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
            print("Sold - Price: "..r)
            --TriggerEvent("redem_roleplay:NotifyLeft", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.Sold..""..r, 'menu_textures', 'menu_icon_alert', Config.SellHorse.Messages.Duration)
            else
                print("Horse is not the borken one")
                --TriggerEvent("redem_roleplay:NotifyLeft", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.NotBroken, 'menu_textures', 'menu_icon_alert', Config.SellHorse.Messages.Duration)
            end
        end
    else
        print("Get a wild horse")
        --TriggerEvent("redem_roleplay:NotifyLeft", Config.SellHorse.Messages.Title, Config.SellHorse.Messages.GetHorse, 'menu_textures', 'menu_icon_alert', Config.SellHorse.Messages.Duration)
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
