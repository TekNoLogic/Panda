

local tip = DEATinyGratuity
DEATinyGratuity = nil


local NUM_LINES = 11
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


function Panda:DisenchantBagUpdate(self)
	local i = 1

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and DEable(link) and (showBOP or not IsBound(bag, slot)) then
				local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)
				local l = frame.lines[i]
				if self.canDisenchant then l:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %s %s", bag, slot)) end
				l.icon:SetTexture(texture)
				l.name:SetText(link)
				l.type:SetText(itemType)
				l:Show()

				i = i + 1
				if i > NUM_LINES then return end
			end
		end
	end

	if i == 1 then frame.NoItems:Show() else frame.NoItems:Hide() end

	for j=i,NUM_LINES do frame.lines[j]:Hide() end
end


local ICONSIZE = 24
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
	frame.BOPlabel:SetText("Show BoP Items")
	frame.BOP:SetScript("OnClick", function() showBOP = not showBOP; self:DisenchantBagUpdate(self) end)

	frame.lines = {}
	for i=1,NUM_LINES do
		local f = CreateFrame("CheckButton", "DEADEFrame"..i, frame, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", frame, 2, ICONSIZE-i*(ICONSIZE+3)+1)
		f:SetHeight(ICONSIZE)
		f:SetWidth(300)
		if self.canDisenchant then f:SetAttribute("type", "macro") end

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetPoint("TOPLEFT")
		f.icon:SetWidth(ICONSIZE)
		f.icon:SetHeight(ICONSIZE)

		f.name = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.name:SetPoint("TOPLEFT", f.icon, "TOPRIGHT", 5, 0)

		f.type = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.type:SetPoint("BOTTOMLEFT", f.icon, "BOTTOMRIGHT", 5, 0)

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
