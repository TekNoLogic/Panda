
local myname, ns = ...


----------------------------
--      Localization      --
----------------------------

local locale = GetLocale()
local L = setmetatable(locale == "deDE" and {
	Scrolls = "Rollen",
	Weapon = "Waffe",

	["All Cat"] = "Alles (Cata)",
	["All Wrath"] = "Alles (WotLK)",
	["Enchant Boots"] = "Stiefel verzaubern",
	["Enchant Bracer"] = "Armschiene verzaubern",
	["Enchant Chest"] = "Brust verzaubern",
	["Enchant Cloak"] = "Umhang verzaubern",
	["Enchant Gloves"] = "Handschuhe verzaubern",
	["Enchant Shield"] = "Schild verzaubern",
	["Enchant Weapon"] = "Waffe verzaubern",
	["Scroll of (.-)"] = "Rolle der (.-)n?verzauberung",

	["Cat Uncommon"] = "Cata Selten",
	["Cat Rare"] = "Cata Rar",
	["Cat Epic"] = "Cata Episch",
	["Cat Meta & JC-only"] = "Cata Meta/Juwelier",
	["Cat Meta"] = "WotLK Meta",
	["Wrath Uncommon"] = "WotLK Selten",
	["Wrath Rare"] = "WotLK Rar",
	["Wrath Epic"] = "WotLK Episch",
	["Wrath Meta"] = "WotLK Meta",
	["BC Epic/Meta"] = "BC Epic/Meta",
	["BC Unc/Rare"] = "BC Selten/Rar",

	["Minor Glyphs (by class)"] = "Geringe Glyphen (-> Klasse)",
	["Minor Glyphs (by ink)"] = "Geringe Glyphen (-> Tinte)",
	["Minor Inscription Research"] = "Schwache Inschriftenforschung",
	["Northrend Inscription Research"] = "Inschriftenforschung von Nordend",

	["Flasks (Cat)"] = "Fläschchen (Cata)",
	["Elixirs (Cat)"] = "Elixire (Cata)",
	["Flasks"] = "Fläschchen (pre Cata)",
	["Battle Elixirs (Wrath)"] = "Kampfelixiere (WotLK)",
	["Guardian Elixirs (Wrath)"] = "Wächterelixiere (WotLK)",
	["Battle Elixirs (BC)"] = "Kampfelixiere (BC)",
	["Guardian Elixirs (BC)"] = "Wächterelixiere (BC)",
	["Transmutes (Elemental)"] = "Transmutieren (Elementar)",
	["Transmutes (Gems)"] = "Transmutieren (Edelsteine)",
	["Transmutes (Metals)"] = "Transmutieren (Metalle)",

	["Food"] = "Essen",
	["Feasts"] = "Festmahl",
	["Emo food"] = "Lebt Eure Gefühle",
} or {}, {__index=function(t,i) return i end})


-------------------------------
--      Addon Namespace      --
-------------------------------

local panel = ns.tekPanelAuction("PandaPanel", "Panda", true)
Panda = {panel = panel, locale = L}
local butts, lastbutt = {}


------------------------------
--      Util functions      --
------------------------------

function Panda:HideTooltip() GameTooltip:Hide() end
function Panda:ShowTooltip()
	if self.tiplink then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:SetHyperlink(self.tiplink)
	elseif self.id then
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", self, self.anchor or "TOPRIGHT")
		GameTooltip:SetHyperlink("item:"..self.id)
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
--      Initialize      --
--------------------------

panel:SetScript("OnEvent", function(self, event, addon)
	if addon ~= myname then return end

	PandaDBPC = PandaDBPC or {knowns = {}}

	-- Upgrade from old format
	if not PandaDBPC.knowns then PandaDBPC = {knowns = (PandaDBPC or {})} end

	ns.db = PandaDBPC

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		ns.CheckAlchy()
		ns.CheckAlchy = nil
		self:SetScript("OnEvent", nil)
	else
		self:RegisterEvent("PLAYER_LOGIN")
		self:SetScript("OnEvent", function()
			ns.CheckAlchy()
			ns.CheckAlchy = nil
			self:UnregisterEvent("PLAYER_LOGIN")
			self:SetScript("OnEvent", nil)
		end)
	end
end)
panel:RegisterEvent("ADDON_LOADED")


panel:SetScript("OnShow", function(self)
	local opentab = ns.db.lasttab or 1
	butts[opentab]:SetChecked(true)
	for i,f in pairs(panel.panels) do f:Hide() end

	if ns.db.lastsubtab then panel.panels[opentab]:ShowPanel(ns.db.lastsubtab) end

	panel.panels[opentab]:Show()

	self:SetScript("OnShow", nil)
end)


panel:SetScript("OnHide", function(self)
	ns.db.lastsubtab = nil

	for i,f in pairs(panel.panels) do if f:IsShown() then ns.db.lasttab = i end end
	for name,f in pairs(panel.panels[ns.db.lasttab].frames) do if f:IsShown() then ns.db.lastsubtab = name end end
end)


--------------------------
--      Main panel      --
--------------------------

local function OnClick(self)
	for i,f in pairs(panel.panels) do f:Hide() end
	for i,b in pairs(butts) do b:SetChecked(false) end
	panel.panels[self.i]:Show()
	self:SetChecked(true)
end

for i,spellid in ipairs{7411, 25229, 45357, 2259, 2550} do
	local name, _, icon = GetSpellInfo(spellid)
	local butt = CreateFrame("CheckButton", nil, panel)
	butt:SetWidth(32) butt:SetHeight(32)
	butt:SetPoint("TOPLEFT", lastbutt or panel, lastbutt and "BOTTOMLEFT" or "TOPRIGHT", lastbutt and 0 or 2, lastbutt and -17 or -65)
	butt:SetNormalTexture(icon)
	butt:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight")

	local tex = butt:CreateTexture(nil, "BACKGROUND")
	tex:SetWidth(64) tex:SetHeight(64)
	tex:SetPoint("TOPLEFT", -3, 11)
	tex:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab")

	butt.tiptext, butt.i, butt.anchor = name, i
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
