
local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
local auc = LibStub("tekAucQuery")


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


function Sadpanda.ButtonFactory(parent, inherit, id, secure, notext, ...)
	local f = CreateFrame(secure and "CheckButton" or "Frame", nil, parent, inherit)
	local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(id)
	f.link, f.id, f.name = link, id, name

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
	icon:SetTexture(texture)

	if not notext then
		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		f.text:SetPoint("TOP", icon, "BOTTOM")
	end

	local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
	f.count = count

--~ 		if secure and self.canJC then
--~ 			f:SetAlpha(knowncombines[f.name] and 1 or 0.25)
--~ 			f:SetAttribute("type", "macro")
--~ 			f:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast Jewelcrafting\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..name.."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
--~ 		end

	return f
end
