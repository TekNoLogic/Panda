

local function GS(cash)
	if not cash then return end
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

		if not name or (itemType ~= "Armor" and itemType ~= "Weapon") or qual <= 1 then
			t[link] = false
			return
		end

		local id1, _, _, weight1, id2, _, _, weight2, id3, _, _, weight3 = Panda:GetPossibleDisenchants(link)
		local bo1, bo2, bo3 = Panda:GetAHBuyout(id1), Panda:GetAHBuyout(id2), Panda:GetAHBuyout(id3)
		local val = (id1 and weight1*bo1 or 0) + (id2 and weight2*bo2 or 0) + (id3 and weight3*bo3 or 0)

		val = GS(val)
		t[link] = val
		return val
	end,
})


local orig1 = GameTooltip:GetScript("OnTooltipSetItem")
GameTooltip:SetScript("OnTooltipSetItem", function(frame, ...)
	assert(frame, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = frame:GetItem()
	local val = values[link]
	if val and val ~= 0 then
		frame:AddDoubleLine("Estimated DE Value:", val)
	end
	if orig1 then return orig1(frame, ...) end
end)


