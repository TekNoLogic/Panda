
------------------------------
--      Are you local?      --
------------------------------

local BC_GREEN_GEMS, BC_BLUE_GEMS, BC_EPIC_GEMS, BC_META_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.BC_EPIC_GEMS, Panda.BC_META_GEMS, Panda.CUTS
local HideTooltip, ShowTooltip, GS, G = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS, Panda.G
local frame, epicframe, metaframe


-- Query server, we need these items!
for i,t in pairs(CUTS) do GameTooltip:SetHyperlink("item:"..i); for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end


local rawframes, cutframes, knowncombines, frame = {}, {}, {}
function Panda:CreateCutGreenBluePanel()
	local function SetupFrame(f, id, secure, notext)
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		f.link, f.id, f.name = link, id, name

		f:SetHeight(32)
		f:SetWidth(32)
		if not secure then f:EnableMouse() end
		f:SetScript("OnEnter", ShowTooltip)
		f:SetScript("OnLeave", HideTooltip)

		local icon = f:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(f)
		icon:SetTexture(texture)

		if not notext then
			local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			text:SetPoint("TOP", icon, "BOTTOM")
			local price = Panda:GetAHBuyout(id)
			text:SetText(GS(price))
		end

		local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
		count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
		f.count = count

		if secure and self.canJC then
			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
		end

		return f
	end

	frame = CreateFrame("Frame", nil, UIParent)

	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(BC_GREEN_GEMS) do
		local f = CreateFrame("Frame", nil, frame)
		if i == 1 then
			f:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, -HGAP-VGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)
		rawframes[rawid] = f

		for j,id in ipairs(CUTS[rawid]) do
			local f = CreateFrame("CheckButton", nil, frame, "SecureActionButtonTemplate")
			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
			lastframe = SetupFrame(f, id, true)
			cutframes[id] = f
		end
	end

	for i,rawid in ipairs(BC_BLUE_GEMS) do
		local f = CreateFrame("Frame", nil, frame)
		if i == 1 then
			f:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", HGAP*8 + 32*8, -HGAP-VGAP)

			local f2 = CreateFrame("CheckButton", nil, frame, "SecureActionButtonTemplate")
			f2:SetPoint("TOPRIGHT", f, "TOPLEFT", -HGAP*2, 0)
			SetupFrame(f2, 35945, true, true)
			cutframes[35945] = f2
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)
		rawframes[rawid] = f

		for j,id in ipairs(CUTS[rawid]) do
			local f = CreateFrame("CheckButton", nil, frame, "SecureActionButtonTemplate")
			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
			lastframe = SetupFrame(f, id, true)
			cutframes[id] = f
		end
	end

	if self.canJC then
		local b = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
		b:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3)
		b:SetWidth(80) b:SetHeight(22)

		-- Fonts --
		b:SetDisabledFontObject(GameFontDisable)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetTextFontObject(GameFontNormal)

		-- Textures --
		b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetBlendMode("ADD")

		b:SetText("Refresh")
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run CloseTradeSkill()")
	end

	frame:Hide()
	frame:SetScript("OnShow", function()
		OpenBackpack()
		self:RegisterEvent("BAG_UPDATE", "GemCutBagUpdate")
		self:GemCutBagUpdate()
	end)
	frame:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	self.CreateCutGreenBluePanel = nil -- Don't need this function anymore!
	return frame
end


function Panda:CreateCutMetaPanel()
	local function SetupFrame(f, id, secure)
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		f.link, f.id, f.name = link, id, name

		f:SetHeight(32)
		f:SetWidth(32)
		if not secure then f:EnableMouse() end
		f:SetScript("OnEnter", ShowTooltip)
		f:SetScript("OnLeave", HideTooltip)

		local icon = f:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(f)
		icon:SetTexture(texture)

		local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		text:SetPoint("TOP", icon, "BOTTOM")
		local price = Panda:GetAHBuyout(id)
		text:SetText(G(price))

		local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
		count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
		f.count = count

		if secure and self.canJC then
			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
		end

		return f
	end

	metaframe = CreateFrame("Frame", nil, UIParent)

	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(BC_META_GEMS) do
		local f = CreateFrame("Frame", nil, metaframe)
		if i == 1 then
			f:SetPoint("TOPLEFT", metaframe, "TOPLEFT", HGAP, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)
		rawframes[rawid] = f

		for j,id in ipairs(CUTS[rawid]) do
			local f = CreateFrame("CheckButton", nil, metaframe, "SecureActionButtonTemplate")
			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
			lastframe = SetupFrame(f, id, true)
			cutframes[id] = f
		end
	end

	if self.canJC then
		local b = CreateFrame("Button", nil, metaframe, "SecureActionButtonTemplate")
		b:SetPoint("TOPRIGHT", metaframe, "BOTTOMRIGHT", 4, -3)
		b:SetWidth(80) b:SetHeight(22)

		-- Fonts --
		b:SetDisabledFontObject(GameFontDisable)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetTextFontObject(GameFontNormal)

		-- Textures --
		b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetBlendMode("ADD")

		b:SetText("Refresh")
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run CloseTradeSkill()")
	end

	metaframe:Hide()
	metaframe:SetScript("OnShow", function()
		OpenBackpack()
		self:RegisterEvent("BAG_UPDATE", "GemCutBagUpdate")
		self:GemCutBagUpdate()
	end)
	metaframe:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	self.CreateCutMetaPanel = nil -- Don't need this function anymore!
	return metaframe
end


function Panda:CreateCutPurplePanel()
	local function SetupFrame(f, id, secure)
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		f.link, f.id, f.name = link, id, name

		f:SetHeight(32)
		f:SetWidth(32)
		if not secure then f:EnableMouse() end
		f:SetScript("OnEnter", ShowTooltip)
		f:SetScript("OnLeave", HideTooltip)

		local icon = f:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints(f)
		icon:SetTexture(texture)

		local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		text:SetPoint("TOP", icon, "BOTTOM")
		local price = Panda:GetAHBuyout(id)
		text:SetText(G(price))

		local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
		count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
		f.count = count

		if secure and self.canJC then
			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
		end

		return f
	end

	epicframe = CreateFrame("Frame", nil, UIParent)

	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(BC_EPIC_GEMS) do
		local f = CreateFrame("Frame", nil, epicframe)
		if i == 1 then
			f:SetPoint("TOPLEFT", epicframe, "TOPLEFT", HGAP, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)
		rawframes[rawid] = f

		for j,id in ipairs(CUTS[rawid]) do
			local f = CreateFrame("CheckButton", nil, epicframe, "SecureActionButtonTemplate")
			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
			lastframe = SetupFrame(f, id, true)
			cutframes[id] = f
		end
	end

	if self.canJC then
		local b = CreateFrame("Button", nil, epicframe, "SecureActionButtonTemplate")
		b:SetPoint("TOPRIGHT", epicframe, "BOTTOMRIGHT", 4, -3)
		b:SetWidth(80) b:SetHeight(22)

		-- Fonts --
		b:SetDisabledFontObject(GameFontDisable)
		b:SetHighlightFontObject(GameFontHighlight)
		b:SetTextFontObject(GameFontNormal)

		-- Textures --
		b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
		b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
		b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
		b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
		b:GetHighlightTexture():SetBlendMode("ADD")

		b:SetText("Refresh")
		b:SetAttribute("type", "macro")
		b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run CloseTradeSkill()")
	end

	epicframe:Hide()
	epicframe:SetScript("OnShow", function()
		OpenBackpack()
		self:RegisterEvent("BAG_UPDATE", "GemCutBagUpdate")
		self:GemCutBagUpdate()
	end)
	epicframe:SetScript("OnHide", function() self:UnregisterEvent("BAG_UPDATE") end)

	self.CreateCutPurplePanel = nil -- Don't need this function anymore!
	return epicframe
end


function Panda:TRADE_SKILL_SHOW()
	for i=1,GetNumTradeSkills() do
		local name, rowtype = GetTradeSkillInfo(i)
		if rowtype ~= "header" then knowncombines[name] = true end
	end
	for id,f in pairs(cutframes) do f:SetAlpha((not self.canJC or knowncombines[f.name]) and 1 or 0.25) end
end


function Panda:GemCutBagUpdate()
	for id,f in pairs(cutframes) do
		local count = GetItemCount(id)
		f.count:SetText(count > 0 and count or "")
	end

	for id,f in pairs(rawframes) do
		local count = GetItemCount(id)
		f.count:SetText(count > 0 and count or "")
	end
end
