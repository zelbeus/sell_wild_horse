RegisterServerEvent("ricx_wildhorse:sold")
AddEventHandler("ricx_wildhorse:sold", function()
	local _source = source
	local am = math.random(Config.SellHorse.MinPrice,Config.SellHorse.MaxPrice)
	if Config.Framework == "redemrp" then 
			
	elseif Config.Framework == "vorp" then 
			
	elseif Config.Framework == "qbr" then 
		local User = exports['qbr-core']:GetPlayer(_source)
		User.Functions.AddMoney("cash", 100, "desc")
	end
end)
