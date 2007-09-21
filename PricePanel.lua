

local function HideTooltip(self) GameTooltip:Hide() end
local function ShowTooltip(self)
	if not self.link then return end

	GameTooltip:SetOwner(frame, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, 60)
	GameTooltip:SetHyperlink(self.link)

end

local function GS(cash)
	if not cash then return end
	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


function Panda:CreateDisenchantingPricePanel()
	local items = {
		{10940, 11083, 11137, 11176, 16204, 22445}, -- Dust
		{10938, 10998, 11134, 11174, 16202, 22447}, -- Lesser Essence
		{10939, 11082, 11135, 11175, 16203, 22446}, -- Greater Essence
		{10978, 11138, 11177, 14343, 22448},        -- Small Shard
		{11084, 11139, 11178, 14344, 22449},        -- Large Shard
		{20725, 22450} -- Crystals
	}

	frame = CreateFrame("Frame", nil, UIParent)

	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,ids in ipairs(items) do
		for j,id in ipairs(ids) do
			local f = CreateFrame("Frame", nil, frame)
			if i == 1 and j == 1 then
				f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP, -HGAP)
				rowanchor = f
			elseif j == 1 then
				f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
				rowanchor = f
			else f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0) end

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

			lastframe = f
		end
	end

	return frame
end


