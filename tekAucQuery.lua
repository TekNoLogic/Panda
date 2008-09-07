
local lib = LibStub:NewLibrary("tekAucQuery", 1)
if not lib then return end

setmetatable(lib, {
	__index = function(t,i)
		if not i then return end
		return GetAuctionBuyout and GetAuctionBuyout(i)
			or AucAdvanced and AucAdvanced.API.GetMarketValue(i)
	end,
})

