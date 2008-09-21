
local ICONSIZE = 38
local NUM_LINES = 7
local OFFSET = math.floor((305 - NUM_LINES*ICONSIZE)/(NUM_LINES+1))
local BUTTON_WIDTH = math.floor((630 - OFFSET*2-15)/2)


local function cfs(frame, a1, a2, a3, ...)
	local fs = frame:CreateFontString(a1, a2, a3)
	fs:SetPoint(...)
	return fs
end


local frame
function Panda:CreateProspectingPanel()
	frame = CreateFrame("Frame", nil, UIParent)
--~ 	frame:SetWidth(630)
--~ 	frame:SetHeight(305)
--~ 	frame:SetPoint("TOPLEFT", 190, -103)

--~ 	frame.BOP = CreateFrame("CheckButton", "DEAFrameDEShowBOP", frame, "OptionsCheckButtonTemplate")
--~ 	frame.BOP:SetWidth(22)
--~ 	frame.BOP:SetHeight(22)
--~ 	frame.BOP:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -4)
--~ 	frame.BOPlabel = cfs(frame.BOP, nil, "ARTWORK", "GameFontNormalSmall", "LEFT", frame.BOP, "RIGHT", 5, 0)
--~ 	frame.BOPlabel:SetText("Show soulbound items")
--~ 	frame.BOP:SetScript("OnClick", function() showBOP = not showBOP; self:DisenchantBagUpdate(self) end)

--~ 	frame.itemdetails = CreateFrame("Frame", nil, frame)
--~ 	frame.itemdetails:SetWidth(630)
--~ 	frame.itemdetails:SetHeight(48)
--~ 	frame.itemdetails:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -3, 8)
--~ 	frame.total1 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 36)
--~ 	frame.total2 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 24)
--~ 	frame.total3 = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 12)
--~ 	frame.item1  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 36)
--~ 	frame.item2  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 24)
--~ 	frame.item3  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -150, 12)
--~ 	frame.prob1  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 36)
--~ 	frame.prob2  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 24)
--~ 	frame.prob3  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -80, 12)
--~ 	frame.qty1   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 36)
--~ 	frame.qty2   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 24)
--~ 	frame.qty3   = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -40, 12)
--~ 	frame.estde  = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", 0, 0)
--~ 	frame.elabel = cfs(frame.itemdetails, nil, "ARTWORK", "GameFontNormalSmall",    "BOTTOMRIGHT", frame.itemdetails, "BOTTOMRIGHT", -60, 0)
--~ 	frame.elabel:SetText("Estimated DE Value: ")
--~ 	frame.itemdetails:Hide()

	frame.lines = {}
	for i,id in ipairs{2770, 2771, 2772, 3858, 10620, 23424, 23425} do
		local f = CreateFrame("CheckButton", "DEAProspectingFrame"..i, frame, "SecureActionButtonTemplate")
		f:SetPoint("TOPLEFT", frame, OFFSET, ICONSIZE-i*(ICONSIZE+OFFSET))
		f:SetHeight(ICONSIZE)
		f:SetWidth(BUTTON_WIDTH)
		f:SetScript("OnEnter", ShowItemDetails)
		f:SetScript("OnLeave", HideItemDetails)

		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetPoint("TOPLEFT")
		f.icon:SetWidth(ICONSIZE)
		f.icon:SetHeight(ICONSIZE)

		f.name = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, 0)
		f.count = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPLEFT", f.icon, "TOPRIGHT", 5, -12)
--~ 		f.bind = cfs(f, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", f, "TOPRIGHT", -5, -12)

		local name, _, _, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(id)
		f.name:SetText(name)
		f.icon:SetTexture(texture)
		if self.canProspect and name then
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/cast Prospecting\n/use ".. name)
		end

		f.id = id
		frame.lines[i] = f
	end

	local XOFFSET = -75
--~ 	frame.powders = {}
--~ 	for i, id in ipairs{24188, 24234, 24235, 24190, 24242, 24186, 24243} do
--~ 		if i == 1 then frame.powders[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", XOFFSET, 0)
--~ 		else frame.powders[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", frame.powders[i-1], "BOTTOMRIGHT") end

--~ 		local name, link = GetItemInfo(id)
--~ 		frame.powders[i]:SetText(link)
--~ 	end

	frame.greens = {}
	for i, id in ipairs{
		7909, 12800, 12361, 3864,  12364, 1529, 1210, 7910, 818, 1206, 12799, 1705, 774, --Pre-BC Greens
		23117, 23077, 23079, 21929, 23112, 23107, -- BC Greens
		23436, 23437, 23438, 23439, 23440, 23441  -- BC Blues
	} do
		if i == 1 then frame.greens[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT")
		else frame.greens[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "TOPRIGHT", frame.greens[i-1], "BOTTOMRIGHT") end

		local name, link = GetItemInfo(id)
		frame.greens[i]:SetText(link)
	end

--~ 	frame.greensBC = {}
--~ 	for i, id in ipairs{} do
--~ 		if i == 1 then frame.greensBC[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", XOFFSET, 0)
--~ 		else frame.greensBC[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.greensBC[i-1], "TOPRIGHT") end

--~ 		local name, link = GetItemInfo(id)
--~ 		frame.greensBC[i]:SetText(link)
--~ 	end

--~ 	frame.blues = {}
--~ 	for i,id in ipairs{} do
--~ 		if i == 1 then frame.blues[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT")
--~ 		else frame.blues[i] = cfs(frame, nil, "ARTWORK", "GameFontHighlightSmall", "BOTTOMRIGHT", frame.blues[i-1], "TOPRIGHT") end

--~ 		local name, link = GetItemInfo(id)
--~ 		frame.blues[i]:SetText(link)
--~ 	end

	self:RegisterEvent("BAG_UPDATE", "ProspectingBagUpdate")
	self:ProspectingBagUpdate()

	frame:SetScript("OnShow", function()
		self:RegisterEvent("BAG_UPDATE", "ProspectingBagUpdate")
		self:ProspectingBagUpdate()
		OpenBackpack()
	end)
	frame:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	return frame
end


function Panda:ProspectingBagUpdate()
	if not frame then return end

	for i,f in pairs(frame.lines) do
		f.count:SetText(((GetItemCount(f.id) or 0)/5).." prospects")
	end
end
