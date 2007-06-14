

Panda = DongleStub("Dongle-1.0"):New("Panda")

function Panda:Initialize()
	local _, title = GetAddOnInfo("Panda")
	local author, version = GetAddOnMetadata("Panda", "Author"), GetAddOnMetadata("Panda", "Version")
	local oh = OptionHouse:RegisterAddOn("Panda", title, author, version)
	oh:RegisterCategory("Disenchanting", self, "CreateDisenchantingPanel")
	oh:RegisterCategory("Prospecting", self, "CreateProspectingPanel")

	self:RegisterEvent("LOOT_OPENED")
end

