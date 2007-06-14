-- Size: 630 305
-- Offset: 190 -103


--~ local DongleFrames = DongleStub("DongleFrames-1.0")
local tiptexts, canDE, canPros
local tip = DEATinyGratuity
DEATinyGratuity = nil

--~ local function HideTooltip()
--~ 	GameTooltip:Hide()
--~ end


--~ local function ShowTooltip(self)
--~  	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
--~ 	GameTooltip:SetText(tiptexts[self])
--~ end


--~ tiptexts = setmetatable({}, {
--~ 	__newindex = function(t,i,v)
--~ 		i:SetScript("OnEnter", ShowTooltip)
--~ 		i:SetScript("OnLeave", HideTooltip)
--~ 		rawset(t,i,v)
--~ 	end,
--~ })


--~ local function AddLabel(frame, text, a1, aframe, a2, dx, dy)
--~ 	if not a1 then a1, aframe, a2, dx, dy = "LEFT", frame, "RIGHT", 5, 0 end
--~ 	local textframe = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
--~ 	textframe:SetPoint(a1, aframe, a2, dx, dy)
--~ 	textframe:SetText(text)
--~ 	return textframe
--~ end

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
function CreatePanel1()
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


function CreatePanel2()
	local frame = CreateFrame("Frame", "DEAFrameProspecting", OptionHouseOptionsFrame)
	frame:SetWidth(630)
	frame:SetHeight(305)
	frame:SetPoint("TOPLEFT", 190, -103)

	frame.NYI = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	frame.NYI:SetPoint("CENTER")
	frame.NYI:SetText("This panel is under construction,\nplease check back later!")

--~ 	frame.lines = {}
--~ 	for i=1,NUM_LINES do
--~ 		local f = CreateFrame("CheckButton", "DEADEFrame"..i, frame, "SecureActionButtonTemplate")
--~ 		f:SetPoint("TOPLEFT", frame, 2, ICONSIZE-i*(ICONSIZE+3)+1)
--~ 		f:SetHeight(ICONSIZE)
--~ 		f:SetWidth(300)
--~ 		f:SetAttribute("type", "macro")

--~ 		f.icon = f:CreateTexture(nil, "ARTWORK")
--~ 		f.icon:SetPoint("TOPLEFT")
--~ 		f.icon:SetWidth(ICONSIZE)
--~ 		f.icon:SetHeight(ICONSIZE)

--~ 		f.name = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--~ 		f.name:SetPoint("TOPLEFT", f.icon, "TOPRIGHT", 5, 0)

--~ 		f.type = f:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--~ 		f.type:SetPoint("BOTTOMLEFT", f.icon, "BOTTOMRIGHT", 5, 0)

--~ 		frame.lines[i] = f
--~ 	end

--~ 	BAG_UPDATE(frame)
--~ 	frame:RegisterEvent("BAG_UPDATE")

--~ 	frame:SetScript("OnEvent", BAG_UPDATE)
--~ 	frame:SetScript("OnShow", function(self) self:RegisterEvent("BAG_UPDATE"); BAG_UPDATE(self) end)
--~ 	frame:SetScript("OnHide", function(self) self:UnregisterEvent("BAG_UPDATE") end)

	return frame
end


local _, title = GetAddOnInfo("Panda")
local author, version = GetAddOnMetadata("Panda", "Author"), GetAddOnMetadata("Panda", "Version")
local oh = OptionHouse:RegisterAddOn("Panda", title, author, version)
oh:RegisterCategory("Disenchanting", CreatePanel1)
oh:RegisterCategory("Prospecting", CreatePanel2)


-----------------------------
--      Auto-loot Fix      --
-----------------------------

local crushings = setmetatable({
	-- Prospecting results
	[24188] = true, [24234] = true, [24235] = true, [24190] = true, [24242] = true, [24186] = true, [24243] = true, -- Powders
	[23117] = true, [23077] = true, [23079] = true, [21929] = true, [23112] = true, [23107] = true, -- BC Green minerals
	[23436] = true, [23437] = true, [23438] = true, [23439] = true, [23440] = true, [23441] = true, -- BC Blue minerals
	[7909] = true,  [12800] = true, [12361] = true, [3864] = true,  [12364] = true, [1529] = true, [1210] = true,
	[7910] = true,  [818] = true,   [1206] = true,  [12799] = true, [1705] = true,  [774] = true, -- Pre-BC minerals
	-- DE Results
	[10940] = true, [11083] = true, [11137] = true, [11176] = true, [16204] = true, [22445] = true, [10938] = true, [10939] = true, [10998] = true, [11082] = true,
	[11134] = true, [11135] = true, [11174] = true, [11175] = true, [16202] = true, [16203] = true, [22447] = true, [22446] = true, [10978] = true, [11084] = true,
	[11138] = true, [11139] = true, [11177] = true, [11178] = true, [14343] = true, [14344] = true, [22448] = true, [22449] = true, [20725] = true, [22450] = true,},
	{ __call = function (t, slot)
		if LootSlotIsCoin(slot) then return end
		local link = GetLootSlotLink(slot)
		if not link then return end
		local _, _, itemID = string.find(link, "item:(%d+)")
		itemID = tonumber(itemID)
		return itemID and t[itemID]
	end})

local LootOpenedTime = 0
local f = CreateFrame("Frame")
f:RegisterEvent("LOOT_OPENED")
f:SetScript("OnEvent", function()
	if (GetTime() - LootOpenedTime) < 1 then return end
	LootOpenedTime = GetTime()

	for slot=1,GetNumLootItems() do if not crushings(slot) then return end end
	CloseLoot()
end)