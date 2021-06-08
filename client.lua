----------------- 		BIG THNKS to gottfriedleibniz for this DataView in LUA.		-------------
----------------- https://gist.github.com/gottfriedleibniz/8ff6e4f38f97dd43354a60f8494eedff	-------------
-----------------MUST GET THE DATAVIEW IN LUA IN ORDER  TO GET THIS SCRIPT WORK-----------------

local _strblob = string.blob or function(length)
    return string.rep("\0", math.max(40 + 1, length))
end

DataView = {
    EndBig = ">",
    EndLittle = "<",
    Types = {
        Int8 = { code = "i1", size = 1 },
        Uint8 = { code = "I1", size = 1 },
        Int16 = { code = "i2", size = 2 },
        Uint16 = { code = "I2", size = 2 },
        Int32 = { code = "i4", size = 4 },
        Uint32 = { code = "I4", size = 4 },
        Int64 = { code = "i8", size = 8 },
        Uint64 = { code = "I8", size = 8 },

        LuaInt = { code = "j", size = 8 }, 
        UluaInt = { code = "J", size = 8 }, 
        LuaNum = { code = "n", size = 8}, 
        Float32 = { code = "f", size = 4 },
        Float64 = { code = "d", size = 8 }, 
        String = { code = "z", size = -1, }, 
    },

    FixedTypes = {
        String = { code = "c", size = -1, },
        Int = { code = "i", size = -1, },
        Uint = { code = "I", size = -1, },
    },
}
DataView.__index = DataView
local function _ib(o, l, t) return ((t.size < 0 and true) or (o + (t.size - 1) <= l)) end
local function _ef(big) return (big and DataView.EndBig) or DataView.EndLittle end
local SetFixed = nil
function DataView.ArrayBuffer(length)
    return setmetatable({
        offset = 1, length = length, blob = _strblob(length)
    }, DataView)
end
function DataView.Wrap(blob)
    return setmetatable({
        offset = 1, blob = blob, length = blob:len(),
    }, DataView)
end
function DataView:Buffer() return self.blob end
function DataView:ByteLength() return self.length end
function DataView:ByteOffset() return self.offset end
function DataView:SubView(offset)
    return setmetatable({
        offset = offset, blob = self.blob, length = self.length,
    }, DataView)
end
for label,datatype in pairs(DataView.Types) do
    DataView["Get" .. label] = function(self, offset, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            local v,_ = string.unpack(_ef(endian) .. datatype.code, self.blob, o)
            return v
        end
        return nil
    end

    DataView["Set" .. label] = function(self, offset, value, endian)
        local o = self.offset + offset
        if _ib(o, self.length, datatype) then
            return SetFixed(self, o, value, _ef(endian) .. datatype.code)
        end
        return self
    end
    if datatype.size >= 0 and string.packsize(datatype.code) ~= datatype.size then
        local msg = "Pack size of %s (%d) does not match cached length: (%d)"
        error(msg:format(label, string.packsize(fmt[#fmt]), datatype.size))
        return nil
    end
end
for label,datatype in pairs(DataView.FixedTypes) do
    DataView["GetFixed" .. label] = function(self, offset, typelen, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            local v,_ = string.unpack(code, self.blob, o)
            return v
        end
        return nil
    end
    DataView["SetFixed" .. label] = function(self, offset, typelen, value, endian)
        local o = self.offset + offset
        if o + (typelen - 1) <= self.length then
            local code = _ef(endian) .. "c" .. tostring(typelen)
            return SetFixed(self, o, value, code)
        end
        return self
    end
end

SetFixed = function(self, offset, value, code)
    local fmt = { }
    local values = { }
    if self.offset < offset then
        local size = offset - self.offset
        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(self.offset, size)
    end
    fmt[#fmt + 1] = code
    values[#values + 1] = value
    local ps = string.packsize(fmt[#fmt])
    if (offset + ps) <= self.length then
        local newoff = offset + ps
        local size = self.length - newoff + 1

        fmt[#fmt + 1] = "c" .. tostring(size)
        values[#values + 1] = self.blob:sub(newoff, self.length)
    end
    self.blob = string.pack(table.concat(fmt, ""), table.unpack(values))
    self.length = self.blob:len()
    return self
end

DataStream = { }
DataStream.__index = DataStream

function DataStream.New(view)
    return setmetatable({ view = view, offset = 0, }, DataStream)
end

for label,datatype in pairs(DataView.Types) do
    DataStream[label] = function(self, endian, align)
        local o = self.offset + self.view.offset
        if not _ib(o, self.view.length, datatype) then
            return nil
        end
        local v,no = string.unpack(_ef(endian) .. datatype.code, self.view:Buffer(), o)
        if align then
            self.offset = self.offset + math.max(no - o, align)
        else
            self.offset = no - self.view.offset
        end
        return v
    end
end
------------------------- END OF DATAVIEW----------------------------
-----------------------------------------------------------------------

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
                    SellWildHorseFunction()
                end
            end
    end
end)

function SellWildHorseFunction()
    if SellWildHorse ~= 0 then
        local PlayerPed = PlayerPedId()
        if GetMount(PlayerPed) == SellWildHorse then
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
                if eventAtIndex == GetHashKey("EVENT_HORSE_BROKEN") then 
                    local eventDataSize = 3 
					local eventDataStruct = DataView.ArrayBuffer(24) 
					eventDataStruct:SetInt32(0 ,0)
					eventDataStruct:SetInt32(8 ,0) 	
					eventDataStruct:SetInt32(16 ,0)	
					local is_data_exists = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA,0,i,eventDataStruct:Buffer(),eventDataSize)
					if is_data_exists then
                        if eventDataStruct:GetInt32(16) == Broken then
                            if PlayerPedId() == eventDataStruct:GetInt32(0) then
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
        exports.sell_wild_horse.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    else
        local txtr = "tick"
        exports.sell_wild_horse.LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    end
end)
