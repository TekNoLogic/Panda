
local knowncombines, unknown, tracker = {}, {}
local nocombine = "39334 39338 39339 39340 39341 39342 39343"


function Panda:PanelFiller()
	local factory = Panda.ButtonFactory
	local scroll, func = self.scroll, self.func

	local canCraft = self.spellid and GetSpellInfo((GetSpellInfo(self.spellid)))

	local uncached = {}
	local HGAP, VGAP = 5, -18
	local numrows, rowanchor, lastrow = 0

	for ids in self.itemids:gmatch("[^\n]+") do
		numrows = numrows + 1
		local row = CreateFrame("Frame", nil, self)
		row:SetHeight(32) row:SetWidth(1)
		row:SetPoint("TOPLEFT", lastrow or self, lastrow and "BOTTOMLEFT" or "TOPLEFT", 0, lastrow and VGAP or -HGAP)
		lastrow = row

		local gap, lastframe = 0
		for id in ids:gmatch("%d+") do
			local craftable = not nocombine:match(id)
			gap = gap + (lastframe and HGAP or 0)
			id = tonumber(id)
			if id == 0 then gap = gap + 32 + (not lastframe and HGAP or 0)
			else
				lastframe = factory(self, id, craftable and canCraft, nil, "TOPLEFT", lastframe or row, lastframe and "TOPRIGHT" or "TOPLEFT", gap, 0)
				if func then func(id, lastframe) end
				if not GetItemInfo(id) then uncached[lastframe] = true end
				if craftable and canCraft and not knowncombines[lastframe.name] then
					lastframe:SetAlpha(.25)
					unknown[lastframe] = true
				end
				gap = 0
			end
		end
	end

	local LINEHEIGHT = VGAP - 32
	local MAXOFFSET = min(0, (numrows - 6)*LINEHEIGHT)
	local offset = 0

	if scroll then
		self:SetPoint("TOP")
		self:SetPoint("LEFT")
		self:SetPoint("RIGHT")
		self:SetHeight(1000)

		scroll:UpdateScrollChildRect()
		scroll:EnableMouseWheel(true)
		scroll:SetScript("OnMouseWheel", function(scroll, val)
			offset = math.max(math.min(offset - val*LINEHEIGHT, 0), MAXOFFSET)
			scroll:SetVerticalScroll(-offset)
			self:SetPoint("TOP", 0, offset)
		end)
	end

	if canCraft then Panda.RefreshButtonFactory(scroll or self, canCraft, "TOPRIGHT", scroll or self, "BOTTOMRIGHT", 4, -3) end
	if next(uncached) then
		local b = LibStub("tekKonfig-Button").new(scroll or self, "TOPRIGHT", scroll or self, "BOTTOMRIGHT", -155, -3)
		b:SetText("Cache")
		b.tiptext = "Click to query server for missing item data.  This could potentially disconnect you from the server, use with care."
		b:SetScript("OnClick", function(self)
			GameTooltip:Hide()
			for button in pairs(uncached) do GameTooltip:SetHyperlink("item:"..button.id) end

			local elapsed = 0
			self:SetScript("OnUpdate", function(self, elap)
				elapsed = elapsed + elap
				if elapsed < 2 then return end

				for button in pairs(uncached) do
					local name, link, _, _, _, _, _, _, _, texture = GetItemInfo(button.id)
					if not name then elapsed = 0; return end

					button.icon:SetTexture(texture)
					button.link, button.name = link, name or ""
				end
				self:SetScript("OnUpdate", nil)
				self:Hide()
			end)
		end)
	end

	if canCraft and not tracker and next(unknown) then
		self:SetScript("OnEvent", function()
			for i=1,GetNumTradeSkills() do
				local name, rowtype = GetTradeSkillInfo(i)
				if rowtype ~= "header" then knowncombines[name] = true end
			end
			for f in pairs(unknown) do f:SetAlpha(knowncombines[f.name] and 1 or 0.25) end
		end)
		self:RegisterEvent("TRADE_SKILL_SHOW")
		tracker = true
	end

	self:SetScript("OnShow", OpenBackpack)
	OpenBackpack()
end

function Panda.PanelFactory(name, spellid, itemids, func)
	local scroll = CreateFrame("ScrollFrame", nil, UIParent)
	local frame = CreateFrame("Frame", nil, UIParent)
	scroll:SetScrollChild(frame)
	scroll:Hide()
	Panda.panel:RegisterFrame(name, scroll)
	frame.scroll, frame.spellid, frame.itemids, frame.func = scroll, spellid, itemids, func

	frame:SetScript("OnShow", Panda.PanelFiller)
end


