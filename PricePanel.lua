

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

	local deitems, prositems = {
		{10940, 11083, 11137, 11176, 16204, 22445}, -- Dust
		{10938, 10998, 11134, 11174, 16202, 22447}, -- Lesser Essence
		{10939, 11082, 11135, 11175, 16203, 22446}, -- Greater Essence
		{10978, 11138, 11177, 14343, 22448},        -- Small Shard
		{11084, 11139, 11178, 14344, 22449},        -- Large Shard
		{20725, 22450} -- Crystals
	}, {
		{23424, 23425, 24243},
		{23117, 23077, 23079, 21929, 23112, 23107}, -- BC Greens
		{23436, 23437, 23438, 23439, 23440, 23441}  -- BC Blues
	}

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

	local text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	text2:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", HGAP*7 + 32*7, 8)
	local text1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	text1:SetPoint("BOTTOMLEFT", text2, "TOPLEFT", 0, 8)

	local FIGREENRATE, FIBLUERATE, ADAMGREENRATE, ADAMBLUERATE = 1.027, 0.06, 1.1, .195
	local greensum, bluesum = 0, 0
	for _,id in pairs(prositems[2]) do greensum = greensum + Panda:GetAHBuyout(id)/6 end
	for _,id in pairs(prositems[3]) do bluesum = bluesum + Panda:GetAHBuyout(id)/6 end
	local fi = (1500 + greensum * FIGREENRATE + bluesum * FIBLUERATE) / Panda:GetAHBuyout(23424) / 5
	local fi2 = (1500 + 2500 * FIGREENRATE + bluesum * FIBLUERATE) / Panda:GetAHBuyout(23424) / 5
	local adam = (Panda:GetAHBuyout(24243) + greensum * ADAMGREENRATE + bluesum * ADAMBLUERATE) / Panda:GetAHBuyout(23425) / 5
	local adam2 = (Panda:GetAHBuyout(24243) + 2500 * ADAMGREENRATE + bluesum * ADAMBLUERATE) / Panda:GetAHBuyout(23425) / 5
	text1:SetText(string.format("Fel Iron crush value: %.1f%% (%.1f%%)", fi*100, fi2*100))
	text2:SetText(string.format("Adamantite crush value: %.1f%% (%.1f%%)", adam*100, adam2*100))

	return frame
end


