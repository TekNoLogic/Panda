
----------------------------
--      Localization      --
----------------------------

local locale = GetLocale()
local L = setmetatable(locale == "deDE" and {
	Disenchanting = "Entzaubern",
	Scrolls = "Rollen",
	Weapon = "Waffe",
	["Elixirs (BC)"] = "Elixire (BC)",
	["Elixirs (Wrath)"] = "Elixire (WotLK)",
	["Enchant Bracer"] = "Armschiene verzaubern",
	["Enchant Cloak"] = "Umhang verzaubern",
	["Enchant Shield"] = "Schild verzaubern",
	["Enchant Weapon"] = "Waffe verzaubern",
	["Gem Cutting (BC Epic/Meta)"] = "Sockel (BC Epic/Meta)",
	["Gem Cutting (BC Unc/Rare)"] = "Sockel (BC Selten/Rar)",
	["Gem Cutting (Wrath Meta)"] = "Sockel (WotLK Meta)",
	["Gem Cutting (Wrath Rare)"] = "Sockel (WotLK Rar)",
	["Gem Cutting (Wrath Unc)"] = "Sockel (WotLK Selten)",
	["Minor Glyphs (by class)"] = "Geringe Glyphen (-> Klasse)",
	["Minor Glyphs (by ink)"] = "Geringe Glyphen (-> Tinte)",
	["Minor Inscription Research"] = "Schwache Inschriftenforschung",
	["Northrend Inscription Research"] = "Inschriftenforschung von Nordend",
	["Scroll of (.+)$"] = "Rolle der (.+)$",
} or {}, {__index=function(t,i) return i end})


-------------------------------
--      Addon Namespace      --
-------------------------------

local panel = LibStub("tekPanel-Auction").new("PandaPanel", "Panda", true)
Panda = {panel = panel, locale = L}


------------------------------
--      Util functions      --
------------------------------

function Panda:HideTooltip() GameTooltip:Hide() end
function Panda:ShowTooltip()
	if self.link then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:SetHyperlink(self.link)
	elseif IsShiftKeyDown() and self.id then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:SetHyperlink("item:"..self.id)
	elseif self.id then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:AddLine("Hold shift to force a server query for this tooltip.")
		GameTooltip:AddLine("This may cause the server to disconnect you!")
		GameTooltip:AddLine("Use with caution.")
		GameTooltip:Show()
	elseif self.tiptext then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:SetText(self.tiptext)
		GameTooltip:Show()
	end
end


function Panda.GS(cash)
	if not cash then return end
	if cash > 999999 then return "|cffffd700".. floor(cash/10000) end

	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end


function Panda.G(cash)
	if not cash then return end
	return "|cffffd700".. floor(cash/10000)
end


--------------------------
--      Main panel      --
--------------------------

local butts, lastbutt = {}

local function OnClick(self)
	for i,f in pairs(panel.panels) do f:Hide() end
	for i,b in pairs(butts) do b:SetChecked(false) end
	panel.panels[self.i]:Show()
	self:SetChecked(true)
end

for i,spellid in ipairs{7411, 25229, 45357, 2259} do
	local name, _, icon = GetSpellInfo(spellid)
	local butt = CreateFrame("CheckButton", nil, panel)
	butt:SetWidth(32) butt:SetHeight(32)
	butt:SetPoint("TOPLEFT", lastbutt or panel, lastbutt and "TOPRIGHT" or "TOPLEFT", lastbutt and 4 or 75, lastbutt and 0 or -40)
	butt:SetNormalTexture(icon)
	butt:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")

	butt.tiptext, butt.i, butt.anchor = name, i, "BOTTOMLEFT"
	if i == 1 then butt:SetChecked(true) end
	butt:SetScript("OnClick", OnClick)
	butt:SetScript("OnEnter", Panda.ShowTooltip)
	butt:SetScript("OnLeave", Panda.HideTooltip)

	butts[i], lastbutt = butt, butt
end


-----------------------------
--      Slash Handler      --
-----------------------------

SLASH_SADPANDA1 = "/panda"
function SlashCmdList.SADPANDA() ShowUIPanel(panel) end


----------------------------------------
--      Quicklaunch registration      --
----------------------------------------

local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj = ldb:GetDataObjectByName("Panda") or ldb:NewDataObject("Panda", {type = "launcher", icon = "Interface\\AddOns\\Panda\\icon"})
dataobj.OnClick = function() ShowUIPanel(panel) end
