
-------------------------------
--      Addon Namespace      --
-------------------------------

Panda = DongleStub("Dongle-1.0"):New("Panda")
if tekDebug then Panda:EnableDebug(1, tekDebug:GetFrame("Panda")) end


function Panda:Initialize()
	self.BC_GREEN_GEMS, self.BC_BLUE_GEMS, self.CUTS = nil -- Don't hold on to the constants, we might want them to GC later

	local _, title = GetAddOnInfo("Panda")
	local author, version = GetAddOnMetadata("Panda", "Author"), GetAddOnMetadata("Panda", "Version")
	local oh = LibStub("OptionHouse-1.1"):RegisterAddOn("Panda", title, author, version)
	oh:RegisterCategory("Disenchanting", self, "CreateDisenchantingPanel")
	oh:RegisterCategory("Prospecting", self, "CreateProspectingPanel")
	oh:RegisterCategory("Prices", self, "CreateDisenchantingPricePanel")
	oh:RegisterCategory("Gem Cutting", self, "CreateCutGreenBluePanel")
	oh:RegisterCategory("Gem Cutting (Meta)", self, "CreateCutMetaPanel")
	oh:RegisterCategory("Gem Cutting (Epic)", self, "CreateCutPurplePanel")

	self:RegisterEvent("LOOT_OPENED")
end


function Panda:Enable()
	local i, spellname = 1
	repeat
		spellname = GetSpellName(i, BOOKTYPE_SPELL)
		if spellname == "Disenchant" then self.canDisenchant = true end
		if spellname == "Prospecting" then self.canProspect = true end
		if spellname == "Jewelcrafting" then self.canJC = true end
		i = i + 1
	until (self.canDisenchant and self.canProspect and self.canJC) or not spellname

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("TRADE_SKILL_SHOW")
end


------------------------------
--      Util functions      --
------------------------------

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


function Panda.G(cash)
	if not cash then return end
	return "|cffffd700".. floor(cash/10000)
end


-------------------------
--      Constants      --
-------------------------

Panda.BC_GREEN_GEMS = {23077, 21929, 23112, 23079, 23117, 23107}
Panda.BC_BLUE_GEMS = {23436, 23439, 23440, 23437, 23438, 23441}
Panda.BC_EPIC_GEMS = {32227, 32231, 32229, 32249, 32228, 32230}
Panda.BC_META_GEMS = {25867, 25868}
Panda.CUTS = {
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
	[25867] = {25896, 25897, 25898, 25899, 25901, 32409, 35501},
	[25868] = {25890, 25893, 25894, 25895, 32410, 34220, 35503},
	[32227] = {32193, 32194, 32195, 32196, 32197, 32198, 32199},
	[32231] = {32217, 32218, 32219, 32220, 32221, 32222, 35760},
	[32229] = {32204, 32205, 32206, 32207, 32208, 32209, 32210, 35761},
	[32249] = {32223, 32224, 32225, 32226, 35758, 35759},
	[32228] = {32200, 32201, 32202, 32203},
	[32230] = {32211, 32212, 32213, 32214, 32215, 32216},
}
