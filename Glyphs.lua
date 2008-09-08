
------------------------------
--      Are you local?      --
------------------------------

local HideTooltip, ShowTooltip, GS, G = Sadpanda.HideTooltip, Sadpanda.ShowTooltip, Sadpanda.GS, Sadpanda.G
local factory = Sadpanda.ButtonFactory
local frame, epicframe, metaframe


local INKS = {39774, 43116, 43118, 43120, 43122, 43124, 43126, 43126, 43126}
local GLYPHS = {
	{41096, 41095, 42743, 42741, 42960, 42956, 41531, 41537, 42410, 42408, 42455, 42462, 42912, 42907, 40897, 40922, 40913},
	{41106, 41092, 42734, 42735, 42961, 42962, 41530, 41532, 42398, 42400, 42461, 42458, 42898, 42900, 40924, 40914},
	{41108, 41100, 42737, 42738, 42964, 42966, 41536, 41540, 42402, 42411, 42465, 42467, 42908, 42910, 40923, 40919},
	{41104, 41099, 42746, 42747, 42970, 42972, 41547, 41533, 42415, 42416, 42473, 42466, 42897, 42903, 40909, 40902},
	{41098, 41103, 42744, 42750, 42973, 42974, 41535, 41541, 42397, 42399, 42470, 42468, 42904, 42905, 40916, 40901},
	{41105, 41094, 42749, 42736, 42963, 42955, 41527, 41542, 42401, 42406, 42471, 42453, 42911, 40903, 40896, 40906},
	{41102, 41110, 42754, 42745, 42958, 42957, 41518, 41517, 42407, 42405, 42460, 42454, 42899, 42902, 40920, 40908},
	{41109, 41101, 42748, 42751, 42965, 42969, 41538, 41539, 42409, 42412, 42463, 42469, 42915, 42916, 40906},
	{41107, 42740, 42739, 42742, 42954, 42959, 41524, 41526, 41529, 42396, 42456, 42457, 42459, 42901, 40899},
}


-- Query server, we need these items!
for i,t in pairs(GLYPHS) do GameTooltip:SetHyperlink("item:"..INKS[i]); for _,id in pairs(t) do GameTooltip:SetHyperlink("item:"..id) end end


local scroll = CreateFrame("ScrollFrame", nil, UIParent)
local frame = CreateFrame("Frame", nil, UIParent)
scroll:SetScrollChild(frame)
scroll:Hide()
Sadpanda.panel:RegisterFrame("Glyphs", scroll)

frame:SetScript("OnShow", function(frame)
	local HGAP, VGAP = 5, -18
	local LINEHEIGHT = VGAP - 32
	local MAXOFFSET = LINEHEIGHT*3

	frame:SetPoint("TOP")
	frame:SetPoint("LEFT")
	frame:SetPoint("RIGHT")
	frame:SetHeight(1000)

	local offset = 0
	scroll:UpdateScrollChildRect()
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, val)
		offset = math.max(math.min(offset - val*LINEHEIGHT, 0), MAXOFFSET)
		scroll:SetVerticalScroll(-offset)
		frame:SetPoint("TOP", 0, offset)
	end)

	local canScribe = GetSpellInfo((GetSpellInfo(45357)))
	local rowanchor, lastframe
	for i,inkid in ipairs(INKS) do
		local f = i == 1 and factory(frame, inkid, nil, nil, "TOPLEFT", frame, "TOPLEFT", 0, -HGAP) or factory(frame, inkid, nil, nil, "TOPLEFT", rowanchor, "BOTTOMLEFT", 0, VGAP)
		lastframe, rowanchor = f, f
		for j,id in ipairs(GLYPHS[i]) do
			lastframe = factory(frame, id, canScribe, nil, "LEFT", lastframe, "RIGHT", HGAP, 0)
			local _, _, _, _, _, _, subtype = GetItemInfo(id)
			local c = subtype and RAID_CLASS_COLORS[subtype:upper()]
			lastframe.border:SetVertexColor(c and c.r or 0, c and c.g or 0, c and c.b or 0)
			lastframe.border:SetAlpha(.8)
			lastframe.border:Show()
		end
	end

	if canScribe then Sadpanda.RefreshButtonFactory(frame, canScribe, "TOPRIGHT", frame, "BOTTOMRIGHT", 4, -3) end

	frame:SetScale(.95)

	frame:SetScript("OnShow", OpenBackpack)
	OpenBackpack()
end)
