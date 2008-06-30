
local Panda = Panda
local GS = Panda.GS
local BC_GREEN_GEMS, BC_BLUE_GEMS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS


local function gemavg(gems)
	local sum, skipped = 0, 0

	for i=2,7 do
		local price = Panda:GetAHBuyout(gems[i])
		if price and price > 0 then sum = sum + price else skipped = skipped + 1 end
	end

	return skipped < 6 and sum/(6 - skipped) or 0
end


local origs = {}
local OnTooltipSetItem = function(frame, ...)
	assert(frame, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = frame:GetItem()
	local id = tonumber((link:match("item:(%d+):")))

	local val = 0
	if     id == 23424 then val = (1500 + gemavg(BC_GREEN_GEMS) * 1.027 + gemavg(BC_BLUE_GEMS) * 0.060) * 4
	elseif id == 23425 then val = (2250 + gemavg(BC_GREEN_GEMS) * 1.100 + gemavg(BC_BLUE_GEMS) * 0.195) * 4 end

	if val and val ~= 0 then frame:AddDoubleLine("Average crush value:", GS(val)) end
	if origs[frame] then return origs[frame](frame, ...) end
end


for i,frame in pairs{GameTooltip, ItemRefTooltip} do
	origs[frame] = frame:GetScript("OnTooltipSetItem")
	frame:SetScript("OnTooltipSetItem", OnTooltipSetItem)
end
