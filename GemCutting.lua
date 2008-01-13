
------------------------------
--      Are you local?      --
------------------------------

local HideTooltip, ShowTooltip, GS = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS
local frame
local basegems = {
	{23077, 21929, 23112, 23079, 23117, 23107}, -- BC Greens
	{23436, 23439, 23440, 23437, 23438, 23441},  -- BC Blues
}
local cuts = {
	[23077] = {23094, 23095, 23097, 23096, 28595},
	[21929] = {23098, 23099, 23100, 23101, 31866, 31869},
	[23112] = {23113, 23114, 23115, 23116, 28290, 31860},
	[23079] = {23103, 23104, 23105, 23106},
	[23117] = {23118, 23119, 23120, 23121},
	[23107] = {23108, 23109, 23110, 23111, 31862, 31864},
	[23436] = {24027, 24028, 24029, 24030, 24031, 24032, 24036},
	[23439] = {24058, 24059, 24060, 24061, 31867, 31868},
	[23440] = {24047, 24048, 24050, 24051, 24052, 24053, 31861},
	[23437] = {24062, 24065, 24066, 24067, 33782},
	[23438] = {24033, 24035, 24037, 24039},
	[23441] = {24054, 24055, 24056, 24057, 31863, 31865},
}


-- Query server, we need these items!
for i,t in pairs(cuts) do for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end


local cutframes, knowncombines, frame = {}, {}
function Panda:CreateCutGreenBluePanel()
	local function SetupFrame(f, id, secure)
		local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
		f.link = link
		f.id = id
		f.name = name

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
	for i,rawid in ipairs(basegems[1]) do
		local f = CreateFrame("Frame", nil, frame)
		if i == 1 then
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)

		for j,id in ipairs(cuts[rawid]) do
			local f = CreateFrame("CheckButton", nil, frame, "SecureActionButtonTemplate")
			f:SetPoint("LEFT", lastframe, "RIGHT", HGAP, 0)
			lastframe = SetupFrame(f, id, true)
			cutframes[id] = f
		end
	end

	for i,rawid in ipairs(basegems[2]) do
		local f = CreateFrame("Frame", nil, frame)
		if i == 1 then
			f:SetPoint("TOPLEFT", frame, "TOPLEFT", HGAP*8 + 32*8, -HGAP)
		else
			f:SetPoint("TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		end
		rowanchor = f
		lastframe = SetupFrame(f, rawid)

		for j,id in ipairs(cuts[rawid]) do
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

	return frame
end


function Panda:TRADE_SKILL_SHOW()
	for i=1,GetNumTradeSkills() do
		local name, rowtype = GetTradeSkillInfo(i)
		if rowtype ~= "header" then knowncombines[name] = true end
	end
	for id,f in pairs(cutframes) do f:SetAlpha((not self.canJC or knowncombines[f.name]) and 1 or 0.25) end
end
