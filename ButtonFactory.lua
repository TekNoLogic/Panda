
local HideTooltip, ShowTooltip, GS, G = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS, Panda.G
local auc = LibStub("tekAucQuery")


local UNK = "Interface\\Icons\\INV_Misc_QuestionMark"


local function OnEvent(self)
	local count = GetItemCount(self.id)
	self.count:SetText(count > 0 and count or "")
	if self.text then
		local price = auc[self.id]
		self.text:SetText(price)
		self.text:SetText(GS(price))
	end
end


local function OnHide(self) self:UnregisterEvent("BAG_UPDATE") end
local function OnShow(self)
	self:RegisterEvent("BAG_UPDATE")
	OnEvent(self)
end


function Panda.ButtonFactory(parent, id, secure, notext, ...)
	local f = CreateFrame(secure and "CheckButton" or "Frame", nil, parent, secure and "SecureActionButtonTemplate")
	local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
	f.link, f.id, f.name = link, id, name or ""

	f:SetHeight(32)
	f:SetWidth(32)
	if not secure then f:EnableMouse() end
	if select("#", ...) > 0 then f:SetPoint(...) end
	f:SetScript("OnEnter", ShowTooltip)
	f:SetScript("OnLeave", HideTooltip)
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnEvent", OnEvent)

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexture(texture or UNK)
	f.icon = icon

	if not notext then
		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		f.text:SetPoint("TOP", icon, "BOTTOM")
	end

	local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
	f.count = count

	-- Thanks to oglow for this method
	local border = f:CreateTexture(nil, "OVERLAY")
	border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	border:SetBlendMode("ADD")
	border:SetAlpha(.5)
	border:Hide()

	border:SetPoint('CENTER', f, 'CENTER', 0, 1)
	border:SetWidth(f:GetWidth() * 2 - 5)
	border:SetHeight(f:GetHeight() * 2 - 5)
	f.border = border

	if secure and name then
		if type(secure) == "function" then
			secure(f)
		else
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..secure.."\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name:gsub("\'", "\\\'").."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
		end
	end

	if f:IsVisible() then OnShow(f) end

	return f
end


function Panda.RefreshButtonFactory(parent, tradeskill, ...)
	local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	b:SetPoint(...)
	b:SetWidth(80) b:SetHeight(22)

	-- Fonts --
	b:SetDisabledFontObject(GameFontDisable)
	b:SetHighlightFontObject(GameFontHighlight)
	b:SetNormalFontObject(GameFontNormal)

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
	b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..tradeskill.."\n/run CloseTradeSkill()")

	return b
end
