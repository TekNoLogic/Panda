
local L = Panda.locale


Panda.PanelFactory(L["Transmutes"], 2259,
[[35624 35623   0     0   0 0 22451 21884 22452 21885 0 0 7082  7078  7076  7080
  35623 35622
  35622 36860   0   41163 0 0 21884 22457   0   23571 0 0 7076 12803   0   12360
	36860 35625   0   40248 0 0 22452 21886   0   25867 0 0 7080 12808   0    7068
  35625 35627   0   41266 0 0 21885 22456   0   25868 0 0  0     0     0    3577
  35627 35624   0   41334 0 0   0     0     0     0   0 0  0     0     0    6037
]], nil, nil, function(self)
	local function DoubleArrow(...)
		local f = CreateFrame("Frame", nil, self.scroll)
		f:SetWidth(32) f:SetHeight(32)
		f:SetPoint(...)

		local bar = f:CreateTexture(nil, "BACKGROUND")
		bar:SetAllPoints()
		bar:SetTexture("Interface\\TalentFrame\\UI-TalentBranches")
		bar:SetTexCoord(2/8, 3/8, .5, 1)

		local left = f:CreateTexture(nil, "ARTWORK")
		left:SetWidth(32) left:SetHeight(32)
		left:SetPoint("CENTER", f, "LEFT")
		left:SetTexture("Interface\\TalentFrame\\UI-TalentArrows")
		left:SetTexCoord(1, .5, .5, 1)

		local right = f:CreateTexture(nil, "ARTWORK")
		right:SetWidth(32) right:SetHeight(32)
		right:SetPoint("CENTER", f, "RIGHT")
		right:SetTexture("Interface\\TalentFrame\\UI-TalentArrows")
		right:SetTexCoord(.5, 1, .5, 1)

		return f
	end

	local function CycleArrow(...)
		local f = CreateFrame("Frame", nil, self.scroll)
		f:SetWidth((32+5)*3+5) f:SetHeight(64)
		f:SetPoint(...)

		local bar1 = f:CreateTexture(nil, "BACKGROUND")
		bar1:SetWidth((32+5)*3+5) bar1:SetHeight(32)
		bar1:SetPoint("BOTTOM", -5, 0)
		bar1:SetTexture("Interface\\TalentFrame\\UI-TalentBranches")
		bar1:SetTexCoord(2/8, 3/8, .5, 1)

		local right = f:CreateTexture(nil, "ARTWORK")
		right:SetWidth(32) right:SetHeight(32)
		right:SetPoint("CENTER", bar1, "RIGHT")
		right:SetTexture("Interface\\TalentFrame\\UI-TalentArrows")
		right:SetTexCoord(.5, 1, .5, 1)

		local bar2 = f:CreateTexture(nil, "BACKGROUND")
		bar2:SetTexture("Interface\\TalentFrame\\UI-TalentBranches")
		bar2:SetTexCoord(2/8, 3/8, .5, 1)

		local corner1 = f:CreateTexture(nil, "ARTWORK")
		corner1:SetWidth(32) corner1:SetHeight(32)
		corner1:SetPoint("TOPLEFT", -5, 0)
		corner1:SetTexture("Interface\\TalentFrame\\UI-TalentBranches")
		corner1:SetTexCoord(5/8, 4/8, .5, 1)

		local corner2 = f:CreateTexture(nil, "ARTWORK")
		corner2:SetWidth(32) corner2:SetHeight(32)
		corner2:SetPoint("TOPRIGHT", 10, 0)
		corner2:SetTexture("Interface\\TalentFrame\\UI-TalentBranches")
		corner2:SetTexCoord(4/8, 5/8, .5, 1)

		bar2:SetPoint("TOPLEFT", corner1, "TOP")
		bar2:SetPoint("BOTTOMRIGHT", corner2, "BOTTOM")

		local down = f:CreateTexture(nil, "OVERLAY")
		down:SetWidth(32) down:SetHeight(32)
		down:SetPoint("CENTER", corner1, "BOTTOM", -4, 0)
		down:SetTexture("Interface\\TalentFrame\\UI-TalentArrows")
		down:SetTexCoord(0, .5, .5, 1)

		return f
	end

	DoubleArrow("BOTTOMLEFT", self, "TOPLEFT", 16, 0)
	DoubleArrow("BOTTOMLEFT", self, "TOPLEFT", (32+5)*6+16, -(32+18)*2)
	DoubleArrow("BOTTOMLEFT", self, "TOPLEFT", (32+5)*12+16, -(32+18)*2)
	CycleArrow("BOTTOMLEFT", self, "TOPLEFT", (32+5)*6+16-5, 0)
	CycleArrow("BOTTOMLEFT", self, "TOPLEFT", (32+5)*12+16-5, 0)
end)


