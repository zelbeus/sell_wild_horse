RegisterServerEvent("ricx_wildhorse:sold")
AddEventHandler("ricx_wildhorse:sold", function(am)
	local _source = source
	print("Money got: "..am)
	print("ADD YOUR OWN LOGIC FOR MONEY")
	--[[ --RedEMRP money add--
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		user.addMoney(am)
	end)
	]]
end)
