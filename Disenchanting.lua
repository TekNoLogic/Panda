

local canDE, canPros
local tip = DEATinyGratuity
DEATinyGratuity = nil


local NUM_LINES = 11
local showBOP = false

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

local function SetLine(frame, bag, slot, link)
	local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)
	frame:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %s %s", bag, slot))
	frame.icon:SetTexture(texture)
	frame.name:SetText(link)
	frame.type:SetText(itemType)
	frame:Show()
end

local function BAG_UPDATE(self)
	local i = 1

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			if link and DEable(link) and (showBOP or not IsBound(bag, slot)) then
				SetLine(self.lines[i], bag, slot, link)
				i = i + 1
				if i > NUM_LINES then return end
			end
		end
	end

	if i == 1 then self.NoItems:Show() else self.NoItems:Hide() end

	for j=i,NUM_LINES do
		self.lines[j]:Hide()
	end
end


local ICONSIZE = 24
function Panda:CreateDisenchantingPanel()
	local frame = CreateFrame("Frame", "DEAFrameDE", OptionHouseOptionsFrame)
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
	frame.BOP:SetScript("OnClick", function() showBOP = not showBOP; BAG_UPDATE(frame) end)

	frame.lines = {}
	for i=1,NUM_LINES do
		local f = CreateFrame("CheckButton", "DEADEFrame"..i, frame, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", frame, 2, ICONSIZE-i*(ICONSIZE+3)+1)
		f:SetHeight(ICONSIZE)
		f:SetWidth(300)
		f:SetAttribute("type", "macro")

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

	BAG_UPDATE(frame)
	frame:RegisterEvent("BAG_UPDATE")

	frame:SetScript("OnEvent", BAG_UPDATE)
	frame:SetScript("OnShow", function(self) self:RegisterEvent("BAG_UPDATE"); BAG_UPDATE(self) end)
	frame:SetScript("OnHide", function(self) self:UnregisterEvent("BAG_UPDATE") end)

	return frame
end
