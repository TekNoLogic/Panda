
local Panda = Panda


local function GS(cash)
	if not cash then return end
	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


local GetItemInfo = GetItemInfo


local values = setmetatable({}, {
	__index = function(t, link)
		if not link then return end

		local name, _, qual, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)

		if not name or not Panda:DEable(link) then
			t[link] = false
			return
		end

		local id1, _, _, qty1, weight1, id2, _, _, qty2, weight2, id3, _, _, qty3, weight3 = Panda:GetPossibleDisenchants(link)
		local bo1, bo2, bo3 = Panda:GetAHBuyout(id1), Panda:GetAHBuyout(id2), Panda:GetAHBuyout(id3)
		local mean = GS((id1 and qty1*weight1*bo1 or 0)+ (id2 and qty2*weight2*bo2 or 0) + (id3 and qty3*weight3*bo3 or 0))
		local mode = GS(qty1*bo1)

		val = string.format("%s (%s)", mode, mean)
		t[link] = val
		return val
	end,
})


local origs = {}
local OnTooltipSetItem = function(frame, ...)
	assert(frame, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = frame:GetItem()
	local val = values[link]
	if val and val ~= 0 then
		frame:AddDoubleLine("Estimated DE Value:", val)
	end
	if origs[frame] then return origs[frame](frame, ...) end
end

for i,frame in pairs{GameTooltip, ItemRefTooltip} do
	origs[frame] = frame:GetScript("OnTooltipSetItem")
	frame:SetScript("OnTooltipSetItem", OnTooltipSetItem)
end

