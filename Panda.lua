
local OptionHouse = DongleStub("OptionHouse-1.0")


Panda = DongleStub("Dongle-1.0"):New("Panda")


function Panda:Initialize()
	local _, title = GetAddOnInfo("Panda")
	local author, version = GetAddOnMetadata("Panda", "Author"), GetAddOnMetadata("Panda", "Version")
	local oh = OptionHouse:RegisterAddOn("Panda", title, author, version)
	oh:RegisterCategory("Disenchanting", self, "CreateDisenchantingPanel")
	oh:RegisterCategory("Prospecting", self, "CreateProspectingPanel")

	self:RegisterEvent("LOOT_OPENED")
end


function Panda:Enable()
	local i, spellname = 1
	repeat
		spellname = GetSpellName(i, BOOKTYPE_SPELL)
		if spellname == "Disenchant" then self.canDisenchant = true end
		if spellname == "Prospect" then self.canProspect = true end
		i = i + 1
	until (self.canDisenchant and self.canProspect) or not spellname
end
