
------------------------------
--      Are you local?      --
------------------------------

--~ local BC_GREEN_GEMS, BC_BLUE_GEMS, BC_EPIC_GEMS, BC_META_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.BC_EPIC_GEMS, Panda.BC_META_GEMS, Panda.CUTS
local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
local factory = Sadpanda.ButtonFactory
local frame, epicframe, metaframe


--~ local WRATH_GREEN_GEMS = {36917}
local WRATH_BLUE_GEMS  = {36918, 36930, 36921, 36933, 36924, 36927}
local CUTS = {
--~ 	[36917] = {53831, 53832, 53834, 53835, 53843, 53844, 53845, 54017},
	[36918] = {39996, 39997, 39998, 39999, 40000, 40001, 40002, 40003},
	[36930] = {40037, 40038, 40039, 40040, 40041, 40043, 40044, 40045, 40046, 40047, 40048, 40049, 40050, 40051, 40052, 40053, 40054, 40055, 40056, 40057, 40058, 40059},
	[36921] = {40012, 40016, 40017, 40014, 40013, 40015},
	[36933] = {40085, 40086, 40088, 40089, 40090, 40091, 40092, 40094, 40095, 40096, 40098, 40099, 40100, 40101, 40102, 40103, 40104, 40105, 40106},
	[36924] = {40008, 40009, 40010, 40011},
	[36927] = {40022, 40023, 40024, 40025, 40026, 40027, 40028, 40029, 40030, 40031, 40032, 40033, 40034},
}


local knowncombines = {}


--------------------------
--      Green cuts      --
--------------------------

--~ local frame = CreateFrame("Frame", nil, UIParent)
--~ frame:Hide()
--~ Sadpanda.panel:RegisterFrame("Gem Cutting (Wrath Green)", frame)

--~ frame:SetScript("OnShow", function(frame)
--~ 	local canJC = GetSpellInfo((GetSpellInfo(25229)))
--~ 	local HGAP, VGAP = 5, -18
--~ 	local rowanchor, lastframe
--~ 	for i,rawid in ipairs(WRATH_GREEN_GEMS) do
--~ 		local f = i == 1 and factory(frame, rawid, nil, nil, "TOPLEFT", frame, "TOPLEFT", 0, -HGAP) or factory(frame, rawid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
--~ 		lastframe, rowanchor = f, f
--~ 		for j,id in ipairs(CUTS[rawid]) do lastframe = factory(frame, id, canJC, nil, "LEFT", lastframe, "RIGHT", HGAP, 0) end
--~ 	end

--~ 	if canJC then Sadpanda.RefreshButtonFactory(frame, canJC, "TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3) end

--~ 	frame:SetScript("OnShow", OpenBackpack)
--~ 	OpenBackpack()
--~ end)


-------------------------
--      Blue cuts      --
-------------------------

local frame = CreateFrame("Frame", nil, UIParent)
frame:Hide()
Sadpanda.panel:RegisterFrame("Gem Cutting (Wrath Blue)", frame)

frame:SetScript("OnShow", function(frame)
	local canJC = GetSpellInfo((GetSpellInfo(25229)))
	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(WRATH_BLUE_GEMS) do
		local f = i == 1 and factory(frame, rawid, nil, nil, "TOPLEFT", frame, "TOPLEFT", 0, -HGAP) or factory(frame, rawid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		lastframe, rowanchor = f, f
		for j,id in ipairs(CUTS[rawid]) do lastframe = factory(frame, id, canJC, nil, "LEFT", lastframe, "RIGHT", HGAP, 0) end
	end

	if canJC then Sadpanda.RefreshButtonFactory(frame, canJC, "TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3) end

	frame:SetScript("OnShow", OpenBackpack)
	OpenBackpack()
end)

