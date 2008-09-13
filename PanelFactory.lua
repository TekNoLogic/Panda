
local knowncombines, unknown, tracker = {}, {}

function Sadpanda.PanelFactory(name, spellid, itemids, func)
	local factory = Sadpanda.ButtonFactory

	local scroll = CreateFrame("ScrollFrame", nil, UIParent)
	local frame = CreateFrame("Frame", nil, UIParent)
	scroll:SetScrollChild(frame)
	scroll:Hide()
	Sadpanda.panel:RegisterFrame(name, scroll)

	frame:SetScript("OnShow", function(self)
		local canCraft = spellid and GetSpellInfo((GetSpellInfo(spellid)))

		local uncached = {}
		local HGAP, VGAP = 5, -18
		local numrows, rowanchor, lastrow = 0

		for ids in itemids:gmatch("[^\n]+") do
			numrows = numrows + 1
			local row = CreateFrame("Frame", nil, self)
			row:SetHeight(32) row:SetWidth(1)
			row:SetPoint("TOPLEFT", lastrow or self, lastrow and "BOTTOMLEFT" or "TOPLEFT", 0, lastrow and VGAP or -HGAP)
			lastrow = row

			local gap, lastframe = 0
			for id in ids:gmatch("%d+") do
				gap = gap + (lastframe and HGAP or 0)
				id = tonumber(id)
				if id == 0 then gap = gap + 32 + (not lastframe and HGAP or 0)
				else
					lastframe = factory(self, id, canCraft, nil, "TOPLEFT", lastframe or row, lastframe and "TOPRIGHT" or "TOPLEFT", gap, 0)
					if func then func(id, lastframe) end
					if not GetItemInfo(id) then uncached[lastframe] = true end
					if canCraft and not knowncombines[lastframe.name] then
						lastframe:SetAlpha(.25)
						unknown[lastframe] = true
					end
					gap = 0
				end
			end
		end

		frame:SetPoint("TOP")
		frame:SetPoint("LEFT")
		frame:SetPoint("RIGHT")
		frame:SetHeight(1000)

		local LINEHEIGHT = VGAP - 32
		local MAXOFFSET = min(0, (numrows - 6)*LINEHEIGHT)
		local offset = 0
		scroll:UpdateScrollChildRect()
		scroll:EnableMouseWheel(true)
		scroll:SetScript("OnMouseWheel", function(self, val)
			offset = math.max(math.min(offset - val*LINEHEIGHT, 0), MAXOFFSET)
			scroll:SetVerticalScroll(-offset)
			frame:SetPoint("TOP", 0, offset)
		end)

		if canCraft then Sadpanda.RefreshButtonFactory(scroll, canCraft, "TOPRIGHT", scroll, "BOTTOMRIGHT", 4, -3) end
		if next(uncached) then
			local b = LibStub("tekKonfig-Button").new(scroll, "TOPRIGHT", scroll, "BOTTOMRIGHT", -155, -3)
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
	end)
end


