
------------------------------
--      Are you local?      --
------------------------------

local BC_GREEN_GEMS, BC_BLUE_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.CUTS
local HideTooltip, ShowTooltip, GS = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS
local frame


-- Query server, we need these items!
for i,t in pairs(CUTS) do for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end


local cutframes, knowncombines, frame = {}, {}
function Panda:CreateCutGreenBluePanel()
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
		text:SetText(GS(price))

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
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)

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
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP*8 + 32*8, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)

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

	frame:SetScript("OnShow", function() OpenBackpack() end)

	self.CreateCutGreenBluePanel = nil -- Don't need this function anymore!
	return frame
end


function Panda:TRADE_SKILL_SHOW()
	for i=1,GetNumTradeSkills() do
		local name, rowtype = GetTradeSkillInfo(i)
		if rowtype ~= "header" then knowncombines[name] = true end
	end
	for id,f in pairs(cutframes) do f:SetAlpha((not self.canJC or knowncombines[f.name]) and 1 or 0.25) end
end
