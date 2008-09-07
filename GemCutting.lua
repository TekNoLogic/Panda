
------------------------------
--      Are you local?      --
------------------------------

--~ local BC_GREEN_GEMS, BC_BLUE_GEMS, BC_EPIC_GEMS, BC_META_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.BC_EPIC_GEMS, Panda.BC_META_GEMS, Panda.CUTS
local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
local factory = Sadpanda.ButtonFactory
local frame, epicframe, metaframe


local BC_GREEN_GEMS = {24478, 23077, 21929, 23112, 23079, 23117, 23107}
local BC_BLUE_GEMS = {24479, 23436, 23439, 23440, 23437, 23438, 23441}
local BC_EPIC_GEMS = {32227, 32231, 32229, 32249, 32228, 32230}
local BC_META_GEMS = {25867, 25868}
local CUTS = {
	[23077] = {23094, 23095, 23097, 23096, 28595},
	[21929] = {23098, 23099, 23100, 23101, 31866, 31869},
	[23112] = {23113, 23114, 23115, 23116, 28290, 31860},
	[23079] = {23103, 23104, 23105, 23106},
	[23117] = {23118, 23119, 23120, 23121},
	[23107] = {23108, 23109, 23110, 23111, 31862, 31864},
	[23436] = {24027, 24028, 24029, 24030, 24031, 24032, 24036},
	[23439] = {24058, 24059, 24060, 24061, 31867, 31868, 35316},
	[23440] = {24047, 24048, 24050, 24051, 24052, 24053, 31861, 35315},
	[23437] = {24062, 24065, 24066, 24067, 33782, 35318},
	[23438] = {24033, 24035, 24037, 24039},
	[23441] = {24054, 24055, 24056, 24057, 31863, 31865, 35707},
	[24478] = {32833},
	[24479] = {32836},
	[25867] = {25896, 25897, 25898, 25899, 25901, 32409, 35501},
	[25868] = {25890, 25893, 25894, 25895, 32410, 34220, 35503},
	[32227] = {32193, 32194, 32195, 32196, 32197, 32198, 32199},
	[32231] = {32217, 32218, 32219, 32220, 32221, 32222, 35760},
	[32229] = {32204, 32205, 32206, 32207, 32208, 32209, 32210, 35761},
	[32249] = {32223, 32224, 32225, 32226, 35758, 35759},
	[32228] = {32200, 32201, 32202, 32203},
	[32230] = {32211, 32212, 32213, 32214, 32215, 32216},
}


-- Query server, we need these items!
for i,t in pairs(CUTS) do GameTooltip:SetHyperlink("item:"..i); for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end


local knowncombines = {}


local frame = CreateFrame("Frame", nil, UIParent)
frame:Hide()
Sadpanda.panel:RegisterFrame("Gem Cutting", frame)

frame:SetScript("OnShow", function(frame)
	local canJC = GetSpellInfo((GetSpellInfo(25229)))
	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(BC_GREEN_GEMS) do
		local f = i == 1 and factory(frame, nil, rawid, nil, nil, "BOTTOMLEFT", frame, "TOPLEFT", 0, -HGAP-VGAP) or factory(frame, nil, rawid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		lastframe, rowanchor = f, f
		for j,id in ipairs(CUTS[rawid]) do lastframe = factory(frame, id, canJC, nil, "LEFT", lastframe, "RIGHT", HGAP, 0) end
	end

	for i,rawid in ipairs(BC_BLUE_GEMS) do
		local f = i == 1 and factory(frame, nil, rawid, nil, nil, "BOTTOMLEFT", frame, "TOPLEFT", HGAP*8 + 32*8, -HGAP-VGAP) or factory(frame, nil, rawid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		if i == 1 then factory(frame, 35945, canJC, true, "TOPRIGHT", f, "TOPLEFT", -HGAP*2, 0) end
		lastframe, rowanchor = f, f
		for j,id in ipairs(CUTS[rawid]) do lastframe = factory(frame, id, canJC, nil, "LEFT", lastframe, "RIGHT", HGAP, 0) end
	end

	if canJC then Sadpanda.RefreshButtonFactory(frame, canJC, "TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3) end

	frame:SetScript("OnShow", OpenBackpack)
	OpenBackpack()
end)


--~ function Panda:CreateCutMetaPanel()
--~ 	local function SetupFrame(f, id, secure)
--~ 		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
--~ 		f.link, f.id, f.name = link, id, name

--~ 		f:SetHeight(32)
--~ 		f:SetWidth(32)
--~ 		if not secure then f:EnableMouse() end
--~ 		f:SetScript("OnEnter", ShowTooltip)
--~ 		f:SetScript("OnLeave", HideTooltip)

--~ 		local icon = f:CreateTexture(nil, "ARTWORK")
--~ 		icon:SetAllPoints(f)
--~ 		icon:SetTexture(texture)

--~ 		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
--~ 		f.text:SetPoint("TOP", icon, "BOTTOM")

--~ 		local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
--~ 		count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
--~ 		f.count = count

--~ 		if secure and self.canJC then
--~ 			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
--~ 			f:SetAttribute("type", "macro")
--~ 			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
--~ 		end

--~ 		return f
--~ 	end

--~ 	metaframe = CreateFrame("Frame", nil, UIParent)

--~ 	local HGAP, VGAP = 5, -18
--~ 	local rowanchor, lastframe
--~ 	for i,rawid in ipairs(BC_META_GEMS) do
--~ 		local f = CreateFrame("Frame", nil, metaframe)
--~ 		if i == 1 then
--~ 			f:SetPoint("TOPLEFT", metaframe, "TOPLEFT", HGAP, -HGAP)
--~ 		else
--~ 			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
--~ 		end
--~ 		rowanchor = f
--~ 		lastframe = SetupFrame(f, rawid)
--~ 		rawframes[rawid] = f

--~ 		for j,id in ipairs(CUTS[rawid]) do
--~ 			local f = CreateFrame("CheckButton", nil, metaframe, "SecureActionButtonTemplate")
--~ 			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
--~ 			lastframe = SetupFrame(f, id, true)
--~ 			cutframes[id] = f
--~ 		end
--~ 	end

--~ 	if self.canJC then
--~ 		local b = CreateFrame("Button", nil, metaframe, "SecureActionButtonTemplate")
--~ 		b:SetPoint("TOPRIGHT", metaframe, "BOTTOMRIGHT", 4, -3)
--~ 		b:SetWidth(80) b:SetHeight(22)

--~ 		-- Fonts --
--~ 		b:SetDisabledFontObject(GameFontDisable)
--~ 		b:SetHighlightFontObject(GameFontHighlight)
--~ 		b:SetTextFontObject(GameFontNormal)

--~ 		-- Textures --
--~ 		b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
--~ 		b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
--~ 		b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
--~ 		b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
--~ 		b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetHighlightTexture():SetBlendMode("ADD")

--~ 		b:SetText("Refresh")
--~ 		b:SetAttribute("type", "macro")
--~ 		b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run CloseTradeSkill()")
--~ 	end

--~ 	metaframe:Hide()
--~ 	metaframe:SetScript("OnShow", function()
--~ 		OpenBackpack()
--~ 		self:RegisterEvent("BAG_UPDATE", "GemCutBagUpdate")
--~ 		self:GemCutBagUpdate()
--~ 	end)
--~ 	metaframe:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

--~ 	self.CreateCutMetaPanel = nil -- Don't need this function anymore!
--~ 	return metaframe
--~ end


--~ function Panda:CreateCutPurplePanel()
--~ 	local function SetupFrame(f, id, secure)
--~ 		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
--~ 		f.link, f.id, f.name = link, id, name

--~ 		f:SetHeight(32)
--~ 		f:SetWidth(32)
--~ 		if not secure then f:EnableMouse() end
--~ 		f:SetScript("OnEnter", ShowTooltip)
--~ 		f:SetScript("OnLeave", HideTooltip)

--~ 		local icon = f:CreateTexture(nil, "ARTWORK")
--~ 		icon:SetAllPoints(f)
--~ 		icon:SetTexture(texture)

--~ 		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
--~ 		f.text:SetPoint("TOP", icon, "BOTTOM")

--~ 		local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
--~ 		count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
--~ 		f.count = count

--~ 		if secure and self.canJC then
--~ 			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
--~ 			f:SetAttribute("type", "macro")
--~ 			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
--~ 		end

--~ 		return f
--~ 	end

--~ 	epicframe = CreateFrame("Frame", nil, UIParent)

--~ 	local HGAP, VGAP = 5, -18
--~ 	local rowanchor, lastframe
--~ 	for i,rawid in ipairs(BC_EPIC_GEMS) do
--~ 		local f = CreateFrame("Frame", nil, epicframe)
--~ 		if i == 1 then
--~ 			f:SetPoint("TOPLEFT", epicframe, "TOPLEFT", HGAP, -HGAP)
--~ 		else
--~ 			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
--~ 		end
--~ 		rowanchor = f
--~ 		lastframe = SetupFrame(f, rawid)
--~ 		rawframes[rawid] = f

--~ 		for j,id in ipairs(CUTS[rawid]) do
--~ 			local f = CreateFrame("CheckButton", nil, epicframe, "SecureActionButtonTemplate")
--~ 			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
--~ 			lastframe = SetupFrame(f, id, true)
--~ 			cutframes[id] = f
--~ 		end
--~ 	end

--~ 	if self.canJC then
--~ 		local b = CreateFrame("Button", nil, epicframe, "SecureActionButtonTemplate")
--~ 		b:SetPoint("TOPRIGHT", epicframe, "BOTTOMRIGHT", 4, -3)
--~ 		b:SetWidth(80) b:SetHeight(22)

--~ 		-- Fonts --
--~ 		b:SetDisabledFontObject(GameFontDisable)
--~ 		b:SetHighlightFontObject(GameFontHighlight)
--~ 		b:SetTextFontObject(GameFontNormal)

--~ 		-- Textures --
--~ 		b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
--~ 		b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
--~ 		b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
--~ 		b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
--~ 		b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--~ 		b:GetHighlightTexture():SetBlendMode("ADD")

--~ 		b:SetText("Refresh")
--~ 		b:SetAttribute("type", "macro")
--~ 		b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run CloseTradeSkill()")
--~ 	end

--~ 	epicframe:Hide()
--~ 	epicframe:SetScript("OnShow", function()
--~ 		OpenBackpack()
--~ 		self:RegisterEvent("BAG_UPDATE", "GemCutBagUpdate")
--~ 		self:GemCutBagUpdate()
--~ 	end)
--~ 	epicframe:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

--~ 	self.CreateCutPurplePanel = nil -- Don't need this function anymore!
--~ 	return epicframe
--~ end


--~ function Panda:TRADE_SKILL_SHOW()
--~ 	for i=1,GetNumTradeSkills() do
--~ 		local name, rowtype = GetTradeSkillInfo(i)
--~ 		if rowtype ~= "header" then knowncombines[name] = true end
--~ 	end
--~ 	for id,f in pairs(cutframes) do f:SetAlpha((not self.canJC or knowncombines[f.name]) and 1 or 0.25) end
--~ end


