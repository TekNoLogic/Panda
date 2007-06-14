
function Panda:CreateProspectingPanel()
	local frame = CreateFrame("Frame", nil, OptionHouseOptionsFrame)
	frame:SetWidth(630)
	frame:SetHeight(305)
	frame:SetPoint("TOPLEFT", 190, -103)

	frame.NYI = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
	frame.NYI:SetPoint("CENTER")
	frame.NYI:SetText("This panel is under construction,\nplease check back later!")

	return frame
end


