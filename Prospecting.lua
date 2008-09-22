
local frame = CreateFrame("Frame", nil, UIParent)
Panda.panel:RegisterFrame("Prospecting", frame)
frame:Hide()

frame:SetScript("OnShow", function(self)
	local canProspect = GetSpellInfo(GetSpellInfo(31252))

	local ORES = {2770, 2771, 2772, 3858, 10620, 23424, 23425, 36909, 36912}
	local ICONSIZE, NUM_LINES = 32, #ORES
	local OFFSET = math.floor((305 - NUM_LINES*ICONSIZE)/(NUM_LINES+1))
	local BUTTON_WIDTH = math.floor((630 - OFFSET*2-15)/2)

	local function OnEvent(self)
		self.count:SetText(((GetItemCount(self.id) or 0)/5).." prospects")
	end

	local function OnShow(self)
		self:RegisterEvent("BAG_UPDATE")
		OnEvent(self)
	end

	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		GameTooltip:SetHyperlink("item:"..self.id)
	end

	local function OnLeave(self) GameTooltip:Hide() end

	for i,id in ipairs(ORES) do
		local f = CreateFrame("CheckButton", "PandaProspectingFrame"..i, self, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", self, OFFSET, ICONSIZE-i*(ICONSIZE+OFFSET))
		f:SetHeight(ICONSIZE)
		f:SetWidth(BUTTON_WIDTH)
		f.id = id

		local itemname, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(id)

		local icon = f:CreateTexture(nil, "ARTWORK")
		icon:SetPoint("TOPLEFT")
		icon:SetWidth(ICONSIZE)
		icon:SetHeight(ICONSIZE)
		icon:SetTexture(texture)

		local name = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 5, 0)
		name:SetText(itemname)

		f.count = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		f.count:SetPoint("TOPLEFT", icon, "TOPRIGHT", 5, -12)

		if canProspect and itemname then
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/cast Prospecting\n/use ".. itemname)
		end

		f:SetScript("OnEnter", OnEnter)
		f:SetScript("OnLeave", OnLeave)
		f:SetScript("OnEvent", OnEvent)
		f:SetScript("OnShow", OnShow)
		f:SetScript("OnHide", f.UnregisterAllEvents)

		OnShow(f)
	end

	self:SetScript("OnShow", OpenBackpack)
	OpenBackpack()

	-- Set up price panel
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("TOPLEFT", self, "TOP", 20, 0)
	frame:SetPoint("BOTTOMRIGHT")
	frame.itemids = [[818   774  1210  1206  1705 3864  1529  7909
	                 7910 12799 12800 12364 12361
									23077 21929 23112 23079 23117 23107
	                23436 23439 23440 23437 23438 23441
	                36917 36929 36920 36932 36923 36926
	                36918 36930 36921 36933 36924 36927]]
	buttons = Panda.PanelFiller(frame)
end)
