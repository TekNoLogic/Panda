

local tip = DEATinyGratuity
DEATinyGratuity = nil


local ICONSIZE, NUM_LINES = 36, 7
local OFFSET = math.floor((305 - NUM_LINES*ICONSIZE)/(NUM_LINES+1))

local showBOP, frame = false


local function IsBound(bag, slot)
	tip:SetBagItem(bag, slot)
	for i=1,30 do
		if tip.L[i] == "Soulbound" then return true end
	end
end


local function DEable(link)
	local _, _, qual, itemLevel, _, itemType = GetItemInfo(link)
	if (itemType == "Armor" or itemType == "Weapon") and qual > 1 then return true end
end


local function GS(cash)
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


local function GSC(cash)
	local g, s, c = floor(cash/10000), floor((cash/100)%100), cash%100
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d.|cffeda55f%02d", g, s, c)
	elseif s > 0 then return string.format("|cffc7c7cf%d.|cffeda55f%02d", s, c)
	else return string.format("|cffc7c7cf%d", c) end
end


function Panda:DisenchantBagUpdate()
	local i = 1
	frame.NoItems:Hide()

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local bound = IsBound(bag, slot)
			if link and DEable(link) and (showBOP or not bound) then
				local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)
				local id1, qty1, prob1, weight1, id2, qty2, prob2, weight2, id3, qty3, prob3, weight3 = self:GetPossibleDisenchants(link)
				local bo1, bo2, bo3 = self:GetAHBuyout(id1), self:GetAHBuyout(id2), self:GetAHBuyout(id3)
				local _, link1 = GetItemInfo(id1)
				local _, link2 = GetItemInfo(id2)
				local _, link3 = GetItemInfo(id3)
				local val = (id1 and weight1*bo1 or 0) + (id2 and weight2*bo2 or 0) + (id3 and weight3*bo3 or 0)

				local l = frame.lines[i]
				if self.canDisenchant then l:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %s %s", bag, slot)) end
				l.icon:SetTexture(texture)
				l.name:SetText(link)
				l.type:SetText(itemType)
				l.bind:SetText(bound and "Soulbound" or "Bind on Equip")
				l.value:SetText(GS(val))
				l.item1:SetText(link1); l.prob1:SetText(prob1); l.total1:SetText(GS(bo1)); l.qty1:SetText(qty1)
				l.item2:SetText(link2); l.prob2:SetText(prob2); l.total2:SetText(GS(bo2)); l.qty2:SetText(qty2)
				l.item3:SetText(link3); l.prob3:SetText(prob3); l.total3:SetText(GS(bo3)); l.qty3:SetText(qty3)
				l:Show()

				i = i + 1
				if i > NUM_LINES then return end
			end
		end
	end

	if i == 1 then frame.NoItems:Show() end

	for j=i,NUM_LINES do frame.lines[j]:Hide() end
end


function Panda:CreateDisenchantingPanel()
	frame = CreateFrame("Frame", nil, OptionHouseOptionsFrame)
	frame:SetWidth(630)
	frame:SetHeight(305)
	frame:SetPoint("TOPLEFT", 190, -103)

	frame.NoItems = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	frame.NoItems:SetPoint("CENTER")
	frame.NoItems:SetText("Nothing to disenchant!")
	frame.NoItems:Hide()

	frame.BOP = CreateFrame("CheckButton", "DEAFrameDEShowBOP", frame, "OptionsCheckButtonTemplate")
	frame.BOP:SetWidth(22)
	frame.BOP:SetHeight(22)
	frame.BOP:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -4)
	frame.BOPlabel = frame.BOP:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	frame.BOPlabel:SetPoint("LEFT", frame.BOP, "RIGHT", 5, 0)
	frame.BOPlabel:SetText("Show soulbound items")
	frame.BOP:SetScript("OnClick", function() showBOP = not showBOP; self:DisenchantBagUpdate(self) end)

	frame.lines = {}
	for i=1,NUM_LINES do
		local f = CreateFrame("CheckButton", "DEADEFrame"..i, frame, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", frame, OFFSET, ICONSIZE-i*(ICONSIZE+OFFSET))
		f:SetHeight(ICONSIZE)
		f:SetWidth(250)
		if self.canDisenchant then f:SetAttribute("type", "macro") end

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetPoint("TOPLEFT")
		f.icon:SetWidth(ICONSIZE)
		f.icon:SetHeight(ICONSIZE)

		f.name = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.name:SetPoint("TOPLEFT", f.icon, "TOPRIGHT", 5, 0)

		f.type = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.type:SetPoint("LEFT", f.icon, "RIGHT", 5, 0)

		f.bind = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.bind:SetPoint("RIGHT", f, "RIGHT", -5, 0)
		f.bind:SetText("Bind on Equip")

		f.valuelabel = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.valuelabel:SetPoint("BOTTOMLEFT", f.icon, "BOTTOMRIGHT", 5, 0)
		f.valuelabel:SetText("Estimated DE value:")

		f.value = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.value:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -5, 0)
		f.value:SetText("999.99")

		local dx = 630-OFFSET*2
		f.total1 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.total1:SetPoint("TOPRIGHT", f, "TOPLEFT", dx, 0)
--~ 		f.total1:SetJustifyH("RIGHT")

		f.total2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.total2:SetPoint("RIGHT", f, "LEFT", dx, 0)
--~ 		f.total2:SetJustifyH("RIGHT")

		f.total3 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.total3:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", dx, 0)
--~ 		f.total3:SetJustifyH("RIGHT")

		f.item1 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.item1:SetPoint("TOPRIGHT", f, "TOPLEFT", dx-150, 0)

		f.item2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.item2:SetPoint("RIGHT", f, "LEFT", dx-150, 0)

		f.item3 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.item3:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", dx-150, 0)

		f.prob1 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.prob1:SetPoint("TOPRIGHT", f, "TOPLEFT", dx-80, 0)

		f.prob2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.prob2:SetPoint("RIGHT", f, "LEFT", dx-80, 0)

		f.prob3 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.prob3:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", dx-80, 0)

		f.qty1 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.qty1:SetPoint("TOPRIGHT", f, "TOPLEFT", dx-40, 0)

		f.qty2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.qty2:SetPoint("RIGHT", f, "LEFT", dx-40, 0)

		f.qty3 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.qty3:SetPoint("BOTTOMRIGHT", f, "BOTTOMLEFT", dx-40, 0)

		frame.lines[i] = f
	end

	self:RegisterEvent("BAG_UPDATE", "DisenchantBagUpdate")
	self:DisenchantBagUpdate(self)

	frame:SetScript("OnShow", function()
		self:RegisterEvent("BAG_UPDATE", "DisenchantBagUpdate")
		self:DisenchantBagUpdate(self)
	end)
	frame:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	return frame
end



