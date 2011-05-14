

local tip = DEATinyGratuity
DEATinyGratuity = nil


local ICONSIZE = 32
local NUM_LINES = math.floor(305/ICONSIZE)
local OFFSET = math.floor((305 - NUM_LINES*ICONSIZE)/(NUM_LINES+1))
local BUTTON_WIDTH = math.floor((630 - OFFSET*2-15)/2)
local ENCHANTING = GetSpellInfo(7411)

local showBOP, nocompare, buttons = false
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
	["69210"] = true, -- Renowned Guild Tabard, is DEable, but no one in their right mind would want to
}

local GS, L = Panda.GS, Panda.locale
local function IsBound(bag, slot)
	tip:SetBagItem(bag, slot)
	for i=1,30 do
		if tip.L[i] == L.Soulbound then return true end
	end
end


function Panda:DEable(link)
	local id = type(link) == "number" and link or select(3, link:find("item:(%d+):"))
	if id and notDEable[id] then return end

	local _, _, qual, itemLevel, _, itemType = GetItemInfo(link)
	if (itemType == ARMOR or itemType == L.Weapon) and qual > 1 and qual < 5 then return true end
end


-- Tells us if we can DE a give item based on ilvl and quality
local function HasEnoughSkill(ilvl, quality)
	local prof1, prof2 = GetProfessions()
	local name, _, myskill = GetProfessionInfo(prof1)
	if name ~= ENCHANTING then name, _, myskill = GetProfessionInfo(prof2) end
	if name ~= ENCHANTING then return false end

	if ilvl <= 20 then return true end
	if ilvl <= 60 then return myskill >= (math.floor(ilvl/5) - 3) * 25 end
	if ilvl <= 89 or quality <= 3 and ilvl <= 99 then return myskill >= 225 end

	if quality == 2 then -- uncommon
		if ilvl <= 120 then return myskill >= 275 end
		if ilvl <= 150 then return myskill >= 325 end
		if ilvl <= 182 then return myskill >= 350 end
		if ilvl <= 333 then return myskill >= 425 end
	end

	if quality == 3 then -- rare
		if ilvl <= 120 then return myskill >= 275 end
		if ilvl <= 200 then return myskill >= 325 end
		if ilvl <= 346 then return myskill >= 450 end
	end

	if quality == 4 then -- epic
		if ilvl <= 151 then return myskill >= 300 end
		if ilvl <= 277 then return myskill >= 375 end
		if ilvl <= 379 then return myskill >= 525 end
	end

	-- We must have new ilvls not defined here
	-- might as well assume the player can DE
	return true
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


local tipinframe
local function ShowItemDetails(self)
	if not (self.bag and self.slot) then return end

	nocompare = true
	tipinframe = self
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self.icon, "BOTTOMRIGHT")
	GameTooltip:SetBagItem(self.bag, self.slot)

	local link = GetContainerItemLink(self.bag, self.slot)
	if not link then return end

	local id1, _, _, _, perc1, id2, _, _, _, perc2, id3, _, _, _, perc3 = Panda:GetPossibleDisenchants(link)
	if id1 then
		for i,f in pairs(buttons) do f:SetAlpha(.1) end
		if buttons[id1] then buttons[id1]:SetAlpha(.5 + perc1/2) end
		if id2 and buttons[id2] then buttons[id2]:SetAlpha(.5 + perc2/2) end
		if id3 and buttons[id3] then buttons[id3]:SetAlpha(.5 + perc3/2) end
	end
end


local function HideItemDetails(self)
	nocompare, tipinframe = nil
	GameTooltip:Hide()
	for i,f in pairs(buttons) do f:SetAlpha(1) end
end


local function HideCompareTooltip(self)
	if nocompare then self:Hide() end
end



local frame = CreateFrame("Frame", nil, UIParent)
Panda.panel:RegisterFrame(L.Disenchanting, frame)
frame:Hide()

frame:SetScript("OnShow", function(self)
	local canDE = GetSpellInfo(GetSpellInfo(13262))

	local deframe = CreateFrame("Frame", nil, self)
	deframe:SetPoint("TOPLEFT")
	deframe:SetPoint("BOTTOMRIGHT", self, "BOTTOM", -15, 0)

	local NoItems = cfs(deframe, nil, "ARTWORK", "GameFontNormalHuge", "CENTER", deframe, "CENTER", 0, 0)
	NoItems:SetText("Nothing to disenchant!")

	self.lines = {}
	for i=1,NUM_LINES do
		local f = CreateFrame("CheckButton", "PandaDEFrame"..i, deframe, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", deframe, OFFSET, ICONSIZE-i*(ICONSIZE+OFFSET))
		f:SetPoint("RIGHT")
		f:SetHeight(ICONSIZE)
		f:SetScript("OnEnter", ShowItemDetails)
		f:SetScript("OnLeave", HideItemDetails)
		if canDE then f:SetAttribute("type", "macro") end

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetPoint("TOPLEFT")
		f.icon:SetWidth(ICONSIZE)
		f.icon:SetHeight(ICONSIZE)

		f.name = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, 0)
		f.type = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, -12)
		f.bind = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", f, "TOPRIGHT", -5, -12)

		self.lines[i] = f
	end

	local function OnEvent(self)
		local i = 1
		NoItems:Hide()

		for bag=0,4 do
			for slot=1,GetContainerNumSlots(bag) do
				local link = GetContainerItemLink(bag, slot)
				if link and Panda:DEable(link) then
					local bound = IsBound(bag, slot)
					if showBOP or not bound then
						local name, _, quality, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)

						local l = frame.lines[i]
						if canDE then l:SetAttribute("macrotext", string.format("/cast Disenchant\n/use %s %s", bag, slot)) end
						l.bag, l.slot = bag, slot
						l.icon:SetTexture(texture)
						if HasEnoughSkill(itemLevel, quality) then l.icon:SetVertexColor(1, 1, 1) else l.icon:SetVertexColor(0.9, 0, 0) end
						l.name:SetText(link)
						l.type:SetText(itemType)
						l.bind:SetText(bound and ITEM_SOULBOUND or ITEM_BIND_ON_EQUIP)
						l:Show()

						if l == tipinframe then ShowItemDetails(tipinframe) end

						i = i + 1
						if i > NUM_LINES then return end
					end
				end
			end
		end

		if i == 1 then NoItems:Show() end
		for j=i,NUM_LINES do frame.lines[j]:Hide() end
	end

	local BOP = CreateFrame("CheckButton", "DEAFrameDEShowBOP", self, "OptionsCheckButtonTemplate")
	BOP:SetWidth(22)
	BOP:SetHeight(22)
	BOP:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -4)
	BOP:SetScript("OnClick", function() showBOP = not showBOP; OnEvent(self) end)

	local BOPlabel = cfs(BOP, nil, "ARTWORK", "GameFontNormalSmall", "LEFT", BOP, "RIGHT", 5, 0)
	BOPlabel:SetText("Show soulbound items")

	self:SetScript("OnEvent", OnEvent)
	self:RegisterEvent("BAG_UPDATE")
	OnEvent(self)
	OpenBackpack()

	self:SetScript("OnShow", function(self)
		self:RegisterEvent("BAG_UPDATE")
		OnEvent(self)
		OpenBackpack()
	end)
	self:SetScript("OnHide", self.UnregisterAllEvents)

	-- Block compare tips when showing tip
	ShoppingTooltip1:SetScript("OnShow", HideCompareTooltip)
	ShoppingTooltip2:SetScript("OnShow", HideCompareTooltip)

	-- Set up price panel
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("TOPLEFT", deframe, "TOPRIGHT")
	frame:SetPoint("BOTTOMRIGHT")
	frame.spellid = 7411
	frame.func = function(id, f) f.notcrafted = not f.tiplink end
	frame.itemids = [[10940 11083 11137 11176 16204 22445 34054 52555
	                  10938 10998 11134 11174 16202 22447 34056 52718 20725:42613
	                  10939 11082 11135 11175 16203 22446 34055 52719 22448:28022
	                    0   10978 11138 11177 14343 22448 34053 52720 22449:42615
	                    0   11084 11139 11178 14344 22449 34052 52721 22450:45765
	                    0     0     0     0   20725 22450 34057 52722 34057:69412]]
	buttons = Panda.PanelFiller(frame)
end)
