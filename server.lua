local VorpCore
if Config.Framework == "vorp" then 
	TriggerEvent("getCore",function(core)
	    VorpCore = core
	end)
end

VorpInv = exports.vorp_inventory:vorp_inventoryApi()	
end

RegisterServerEvent("ricx_wildhorse:sold")
AddEventHandler("ricx_wildhorse:sold", function()
	local _source = source
	local am = math.random(Config.SellHorse.MinPrice,Config.SellHorse.MaxPrice)
	if Config.Framework == "redemrp" then 
		TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		    user.addMoney(am)
		end)	
	elseif Config.Framework == "vorp" then 
		local Character = VorpCore.getUser(_source).getUsedCharacter
		Character.addCurrency(0 , am)
	elseif Config.Framework == "qbr" then 
		local User = exports['qbr-core']:GetPlayer(_source)
		User.Functions.AddMoney("cash", am, "desc")
	end
	TriggerClientEvent("Notification:left", _source, Config.SellHorse.Messages.Title, Config.SellHorse.Messages.Sold..""..am, 'menu_textures', 'menu_icon_alert', Config.SellHorse.Messages.Duration)
end)
