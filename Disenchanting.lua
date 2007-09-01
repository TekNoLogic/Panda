

local tip = DEATinyGratuity
DEATinyGratuity = nil


local ICONSIZE = 32
local NUM_LINES = math.floor(305/ICONSIZE)
local OFFSET = math.floor((305 - NUM_LINES*ICONSIZE)/(NUM_LINES+1))
local BUTTON_WIDTH = math.floor((630 - OFFSET*2-15)/2)
NUM_LINES = NUM_LINES*2

local showBOP, nocompare, frame = false
local notDEable = {
	["32540"] = true,
	["32541"] = true,
	["18665"] = true,
	["21766"] = true,
	["5004"] = true,
	["20408"] = true,
	["20406"] = true,
	["20407"] = true,
	["14812"] = true,
	["31336"] = true,
	["32660"] = true,
	["32662"] = true,
	["11288"] = true,
	["11290"] = true,
	["12772"] = true,
	["11287"] = true,
	["11289"] = true,
	["29378"] = true,
}


local function IsBound(bag, slot)
	tip:SetBagItem(bag, slot)
	for i=1,30 do
		if tip.L[i] == "Soulbound" then return true end
	end
end


function Panda:DEable(link)
	local _, _, id = link:find("item:(%d+):")
	if id and notDEable[id] then return end

	local _, _, qual, itemLevel, _, itemType = GetItemInfo(link)
	if (itemType == "Armor" or itemType == "Weapon") and qual > 1 then return true end
end


local function GS(cash)
	if not cash then return end
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


local function GSC(cash)
	if not cash then return end
	local g, s, c = floor(cash/10000), floor((cash/100)%100), cash%100
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d.|cffeda55f%02d", g, s, c)
	elseif s > 0 then return string.format("|cffc7c7cf%d.|cffeda55f%02d", s, c)
	else return string.format("|cffc7c7cf%d", c) end
end


local function cfs(frame, a1, a2, a3, ...)
	local fs = frame:CreateFontString(a1, a2, a3)
	fs:SetPoint(...)
	return fs
end


local gii = GetItemInfo
local function GetItemInfo(i)
	if i then return gii(i) end
end


local function ShowItemDetails(self)
	if not (self.bag and self.slot) then return end

	nocompare = true
	GameTooltip:SetOwner(frame, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, 60)
	GameTooltip:SetBagItem(self.bag, self.slot)

	local link = GetContainerItemLink(self.bag, self.slot)
	if not link then return end

	local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)
	local id1, qty1, prob1, weight1, id2, qty2, prob2, weight2, id3, qty3, prob3, weight3 = Panda:GetPossibleDisenchants(link)
	local bo1, bo2, bo3 = Panda:GetAHBuyout(id1), Panda:GetAHBuyout(id2), Panda:GetAHBuyout(id3)
	local _, link1 = GetItemInfo(id1)
	local _, link2 = GetItemInfo(id2)
	local _, link3 = GetItemInfo(id3)
	local val = (id1 and weight1*bo1 or 0) + (id2 and weight2*bo2 or 0) + (id3 and weight3*bo3 or 0)

	frame.item1:SetText(link3); frame.prob1:SetText(prob3); frame.total1:SetText(GS(bo3)); frame.qty1:SetText(qty3)
	frame.item2:SetText(link2); frame.prob2:SetText(prob2); frame.total2:SetText(GS(bo2)); frame.qty2:SetText(qty2)
	frame.item3:SetText(link1); frame.prob3:SetText(prob1); frame.total3:SetText(GS(bo1)); frame.qty3:SetText(qty1)
	frame.estde:SetText(GS(val))

	frame.itemdetails:Show()
end


local function HideItemDetails(self)
	nocompare = nil
	GameTooltip:Hide()
	frame.itemdetails:Hide()
end


local function HideCompareTooltip(self)
	if nocompare then self:Hide() end
end


function Panda:DisenchantBagUpdate()
	local i = 1
	frame.NoItems:Hide()

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local bound = IsBound(bag, slot)
			if link and self:DEable(link) and (showBOP or not bound) then
				local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)

				local l = frame.lines[i]
				if self.canDisenchant then l:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %s %s", bag, slot)) end
				l.bag, l.slot = bag, slot
				l.icon:SetTexture(texture)
				l.name:SetText(link)
				l.type:SetText(itemType)
				l.bind:SetText(bound and "Soulbound" or "Bind on Equip")
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
	frame = CreateFrame("Frame", nil, UIParent)
--~ 	frame:SetWidth(630)
--~ 	frame:SetHeight(305)
--~ 	frame:SetPoint("TOPLEFT", 190, -103)

	frame.NoItems = cfs(frame, nil, "ARTWORK", "GameFontNormalHuge", "CENTER")
	frame.NoItems:SetText("Nothing to disenchant!")

	frame.BOP = CreateFrame("CheckButton", "DEAFrameDEShowBOP", frame, "OptionsCheckButtonTemplate")
	frame.BOP:SetWidth(22)
	frame.BOP:SetHeight(22)
	frame.BOP:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -4)
	frame.BOPlabel = cfs(frame.BOP, nil, "ARTWORK", "GameFontNormalSmall", "LEFT", frame.BOP, "RIGHT", 5, 0)
	frame.BOPlabel:SetText("Show soulbound items")
	frame.BOP:SetScript("OnClick", function() showBOP = not showBOP; self:DisenchantBagUpdate(self) end)

	frame.itemdetails = CreateFrame("Frame", nil, frame)
	frame.itemdetails:SetWidth(630)
	frame.itemdetails:SetHeight(48)
	frame.itemdetails:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -3, 8)
	frame.total1 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 36)
	frame.total2 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 24)
	frame.total3 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 12)
	frame.item1  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 36)
	frame.item2  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 24)
	frame.item3  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 12)
	frame.prob1  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 36)
	frame.prob2  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 24)
	frame.prob3  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 12)
	frame.qty1   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 36)
	frame.qty2   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 24)
	frame.qty3   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 12)
	frame.estde  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 0)
	frame.elabel = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontNormalSmall",    "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -60, 0)
	frame.elabel:SetText("Estimated DE Value: ")
	frame.itemdetails:Hide()

	frame.lines = {}
	for i=1,NUM_LINES do
		local f = CreateFrame("CheckButton", "DEADEFrame"..i, frame, "SecureActionButtonTemplate")
		if i <= (NUM_LINES/2) then f:SetPoint("TOPLEFT", frame, OFFSET, ICONSIZE-i*(ICONSIZE+OFFSET))
		else f:SetPoint("TOPRIGHT", frame, -OFFSET, ICONSIZE-(i-NUM_LINES/2)*(ICONSIZE+OFFSET)) end
		f:SetHeight(ICONSIZE)
		f:SetWidth(BUTTON_WIDTH)
		f:SetScript("OnEnter", ShowItemDetails)
		f:SetScript("OnLeave", HideItemDetails)
		if self.canDisenchant then f:SetAttribute("type", "macro") end

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetPoint("TOPLEFT")
		f.icon:SetWidth(ICONSIZE)
		f.icon:SetHeight(ICONSIZE)

		f.name = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, 0)
		f.type = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, -12)
		f.bind = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", f, "TOPRIGHT", -5, -12)

		frame.lines[i] = f
	end

	self:RegisterEvent("BAG_UPDATE", "DisenchantBagUpdate")
	self:DisenchantBagUpdate(self)

	frame:SetScript("OnShow", function()
		self:RegisterEvent("BAG_UPDATE", "DisenchantBagUpdate")
		self:DisenchantBagUpdate(self)
	end)
	frame:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	-- Block compare tips when showing tip
	ShoppingTooltip1:SetScript("OnShow", HideCompareTooltip)
	ShoppingTooltip2:SetScript("OnShow", HideCompareTooltip)

	return frame
end



