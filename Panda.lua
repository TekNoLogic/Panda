
local OptionHouse = LibStub("OptionHouse-1.1")


Panda = DongleStub("Dongle-1.0"):New("Panda")
if tekDebug then Panda:EnableDebug(1, tekDebug:GetFrame("Panda")) end


function Panda:Initialize()
	local _, title = GetAddOnInfo("Panda")
	local author, version = GetAddOnMetadata("Panda", "Author"), GetAddOnMetadata("Panda", "Version")
	local oh = OptionHouse:RegisterAddOn("Panda", title, author, version)
	oh:RegisterCategory("Disenchanting", self, "CreateDisenchantingPanel")
	oh:RegisterCategory("Prospecting", self, "CreateProspectingPanel")
	oh:RegisterCategory("Prices", self, "CreateDisenchantingPricePanel")

	self:RegisterEvent("LOOT_OPENED")
end


function Panda:Enable()
	local i, spellname = 1
	repeat
		spellname = GetSpellName(i, BOOKTYPE_SPELL)
		if spellname == "Disenchant" then self.canDisenchant = true end
		if spellname == "Prospecting" then self.canProspect = true end
		i = i + 1
	until (self.canDisenchant and self.canProspect) or not spellname

	self:RegisterEvent("ADDON_LOADED")
end


function Panda:HideTooltip() GameTooltip:Hide() end
function Panda:ShowTooltip()
	if not self.link then return end

	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
	GameTooltip:SetHyperlink(self.link)
end


function Panda.GS(cash)
	if not cash then return end
	cash = cash/100
	local s = floor(cash%100)
	local g = floor(cash/100)
	if g > 0 then return string.format("|cffffd700%d.|cffc7c7cf%02d", g, s)
	else return string.format("|cffc7c7cf%d", s) end
end
