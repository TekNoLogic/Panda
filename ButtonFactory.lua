
local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
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


function Sadpanda.ButtonFactory(parent, id, secure, notext, ...)
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

	if secure then
--~ 			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
		f:SetAttribute("type", "macro")
		f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..secure.."\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
	end

	return f
end


function Sadpanda.RefreshButtonFactory(parent, tradeskill, ...)
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


function Sadpanda.CacheButtonFactory(parent, buttons, ...)
	if next(buttons) then
		local b = LibStub("tekKonfig-Button").new(parent, "TOPRIGHT", parent, "BOTTOMRIGHT", -155, -3)
		b:SetText("Cache")
		b.tiptext = "Click to quesry server for missing item data.  This could potentially disconnect you from the server, use with care."
		b:SetScript("OnClick", function(self)
			GameTooltip:Hide()
			for button in pairs(buttons) do GameTooltip:SetHyperlink("item:"..button.id) end

			local elapsed = 0
			self:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed < 2 then return end

				for button in pairs(buttons) do
					local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(button.id)
					if not name then elapsed = 0; return end

					button.icon:SetTexture(texture)
					button.link, button.name = link, name or ""
				end
				self:SetScript("OnUpdate", nil)
				self:Hide()
			end)
		end)
	end
end
