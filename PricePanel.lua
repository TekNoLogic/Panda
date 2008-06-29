
------------------------------
--      Are you local?      --
------------------------------

local HideTooltip, ShowTooltip, GS = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS
local frame
local ores = {2770, 2771, 2772, 3858, 10620, 23424, 23425}
local deitems = {
	{10940, 11083, 11137, 11176, 16204, 22445}, -- Dust
	{10938, 10998, 11134, 11174, 16202, 22447}, -- Lesser Essence
	{10939, 11082, 11135, 11175, 16203, 22446}, -- Greater Essence
	{10978, 11138, 11177, 14343, 22448},        -- Small Shard
	{11084, 11139, 11178, 14344, 22449},        -- Large Shard
	{20725, 22450} -- Crystals
}
local prositems = {
	{23424, 23425, 24243},
	Panda.BC_GREEN_GEMS,
	Panda.BC_BLUE_GEMS,
}


-- Query server, we need these items!
for i,t in pairs(deitems) do for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end
for i,t in pairs(prositems) do for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end
for _,id in pairs(ores) do GameTooltip:SetHyperlink("item:"..id) end


function Panda:CreateDisenchantingPricePanel()
	local function SetupFrame(f, id)
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		f.link = link

		f:SetHeight(32)
		f:SetWidth(32)
		f:EnableMouse()
		f:SetScript("OnEnter", ShowTooltip)
		f:SetScript("OnLeave", HideTooltip)

		local icon = f:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(f)
		icon:SetTexture(texture)

		local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		text:SetPoint("TOP", icon, "BOTTOM")
		local price = Panda:GetAHBuyout(id)
		text:SetText(GS(price))

		return f
	end

	frame = CreateFrame("Frame", nil, UIParent)

	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,ids in ipairs(deitems) do
		for j,id in ipairs(ids) do
			local f = CreateFrame("Frame", nil, frame)
			if i == 1 and j == 1 then
				f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP, -HGAP)
				rowanchor = f
			elseif j == 1 then
				f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
				rowanchor = f
			else f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0) end

			lastframe = SetupFrame(f, id)
		end
	end

	for i,ids in ipairs(prositems) do
		for j,id in ipairs(ids) do
			local f = CreateFrame("Frame", nil, frame)
			if i == 1 and j == 1 then
				f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP*7 + 32*7, -HGAP)
				rowanchor = f
			elseif j == 1 then
				f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
				rowanchor = f
			else f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0) end

			lastframe = SetupFrame(f, id)
		end
	end

	self.CreateDisenchantingPricePanel = nil -- Don't need this function anymore!
	return frame
end
