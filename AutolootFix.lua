
local crushings = {
	-- Prospecting results
	[24188] = true, [24234] = true, [24235] = true, [24190] = true, [24242] = true, [24186] = true, [24243] = true, -- Powders
	[23117] = true, [23077] = true, [23079] = true, [21929] = true, [23112] = true, [23107] = true, -- BC Green minerals
	[23436] = true, [23437] = true, [23438] = true, [23439] = true, [23440] = true, [23441] = true, -- BC Blue minerals
	[7909] = true,  [12800] = true, [12361] = true, [3864] = true,  [12364] = true, [1529] = true, [1210] = true,
	[7910] = true,  [818] = true,   [1206] = true,  [12799] = true, [1705] = true,  [774] = true, -- Pre-BC minerals

	-- DE Results
	[10940] = true, [11083] = true, [11137] = true, [11176] = true, [16204] = true, [22445] = true, [10938] = true, [10939] = true, [10998] = true, [11082] = true,
	[11134] = true, [11135] = true, [11174] = true, [11175] = true, [16202] = true, [16203] = true, [22447] = true, [22446] = true, [10978] = true, [11084] = true,
	[11138] = true, [11139] = true, [11177] = true, [11178] = true, [14343] = true, [14344] = true, [22448] = true, [22449] = true, [20725] = true, [22450] = true,
}


local function IsPandaItem(slot)
	if LootSlotIsCoin(slot) then return end
	local link = GetLootSlotLink(slot)
	if not link then return end
	local _, _, itemID = string.find(link, "item:(%d+)")
	itemID = tonumber(itemID)
	return itemID and crushings[itemID]
end


local LootOpenedTime = 0
function Panda:LOOT_OPENED()
	if (GetTime() - LootOpenedTime) < 1 then return end
	LootOpenedTime = GetTime()

	for slot=1,GetNumLootItems() do if not IsPandaItem(slot) then return end end
	CloseLoot()
end

