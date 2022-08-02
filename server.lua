RegisterServerEvent("ricx_wildhorse:sold")
AddEventHandler("ricx_wildhorse:sold", function(am)
	local _source = source
	print("Money got: "..am)
	print("ADD YOUR OWN LOGIC FOR MONEY")
end)
