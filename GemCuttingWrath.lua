
------------------------------
--      Are you local?      --
------------------------------

--~ local BC_GREEN_GEMS, BC_BLUE_GEMS, BC_EPIC_GEMS, BC_META_GEMS, CUTS = Panda.BC_GREEN_GEMS, Panda.BC_BLUE_GEMS, Panda.BC_EPIC_GEMS, Panda.BC_META_GEMS, Panda.CUTS
local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
local factory = Sadpanda.ButtonFactory
local frame, epicframe, metaframe


local WRATH_GREEN_GEMS = {36917, 36929, 36920, 36932, 36923, 36926}
local WRATH_BLUE_GEMS  = {36918, 36930, 36921, 36933, 36924, 36927}
local CUTS = {
	-- Greens
	[36917] = {39900, 39905, 39906, 39907, 39908, 39909, 39910, 39911},
	[36929] = {39946, 39947, 39948, 39949, 39950, 39951, 39952, 39953, 39954, 39955, 39956, 39957, 39958, 39959, 39960, 39961, 39962, 39963, 39964, 39965, 39966, 39967},
	[36920] = {39912, 39914, 39915, 39916, 39917, 39918},
	[36932] = {39982, 39968, 39974, 39975, 39976, 39977, 39978, 39979, 39980, 39981, 39983, 39984, 39985, 39986, 39988, 39989, 39990, 39991, 39992},
	[36923] = {39919, 39920, 39927, 39932},
	[36926] = {39933, 39934, 39935, 39936, 39937, 39938, 39939, 39940, 39941, 39942, 39943, 39944, 39945},
	-- Blues
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

local frame = CreateFrame("Frame", nil, UIParent)
frame:Hide()
Sadpanda.panel:RegisterFrame("Gem Cutting (Wrath Green)", frame)

frame:SetScript("OnShow", function(frame)
	local canJC = GetSpellInfo((GetSpellInfo(25229)))
	local HGAP, VGAP = 5, -18
	local rowanchor, lastframe
	for i,rawid in ipairs(WRATH_GREEN_GEMS) do
		local f = i == 1 and factory(frame, rawid, nil, nil, "TOPLEFT", frame, "TOPLEFT", 0, -HGAP) or factory(frame, rawid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		lastframe, rowanchor = f, f
		for j,id in ipairs(CUTS[rawid]) do lastframe = factory(frame, id, canJC, nil, "LEFT", lastframe, "RIGHT", HGAP, 0) end
	end

	if canJC then Sadpanda.RefreshButtonFactory(frame, canJC, "TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3) end

	frame:SetScript("OnShow", OpenBackpack)
	OpenBackpack()
end)


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

