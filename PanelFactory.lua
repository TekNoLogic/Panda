﻿
local myname, ns = ...

local idmemo = LibStub("tekIDmemo")

local unknown, knowncombines, tracker = {}
local known = setmetatable({}, {__index = function(t,i)
	local spellid = tonumber(i.extra)
	local name = i.id and GetItemInfo(i.id)
	if not spellid and (knowncombines[i.id] or name and knowncombines[name]) or spellid and knowncombines[spellid + 0.1] then
		t[i] = true
		return true
	end
end})
-- leave the space at the beginning of nocombine
local nocombine = [[ 39334 39338 39339 39340 39341 39342 39343
39151  2447   765  2449   785
43103  2450  2452  3820  2453
43104  3369  3355  3356  3357
43105  3818  3821  3358  3819
43106  4625  8831  8836  8838  8845  8839 8846
43107 13464 13463 13465 13466 13467 13468
43108 22785 22786 22787 22789 22790 22791 22792 22793 22794
43109 36901 36903 36904 36905 36906 36907 37921
 8925  3371
22578 22574
24478 24479
 2770  2771  2772  3858 10620
  818   774  1210  1206  1529  1705  3864  7909  7910 12799 12361 12800 12364
23424 23077 21929 23112 23079 23117 23107
23425 23436 23439 23440 23437 23438 23441
32227 32231 32229 32249 32228 32230
36909 36917 36929 36920 36932 36923 36926
36912 36918 36930 36921 36933 36924 36927
39970 37704 36908 37701
6948
43007 41807 43011 43012 43010 34736 43009 41809 41806 41810 41802 41813 36782 41808 43013 41801 41800 41803 22577 12808 30817 43501
36910
53038 52177 52181 52179 52182 52178 52180
52183
52185 52188 52196
61979 61980 52983 52984 52985 52986 52987 52988
52325 52326 52327 52328 52329
]]

function ns.CheckAlchy()
	if not GetSpellInfo((GetSpellInfo(2259))) then
		-- We're not an alchemist, add in the transmute stones
		nocombine = nocombine.. [[
25867 25868
36919 36931 36922 36934 36925 36928
41266 51334
52190 52193 52195 52192 52191 52194
52303
]]
	end
end


local function noop() end

local function AddToData(name)
	if GetLocale() == "deDE" then -- inconsistent naming up to Cataclysm enchants
		local target, enchant = string.split("-", name)
		target, enchant = string.trim(target), string.trim(enchant)
		if target == "Handschuhe" then
			knowncombines["Rolle der Handschuhverzauberung - "..enchant] = true
		elseif target == "Waffe" or target == "Armschiene" or target == "Zweihandwaffe" then
			knowncombines["Rolle der "..target.."nverzauberung - "..enchant] = true
		else
			knowncombines["Rolle der "..target.."verzauberung - "..enchant] = true
		end
	else
		knowncombines["Scroll of "..name] = true
	end
	knowncombines[name] = true
end

function Panda:PanelFiller()
	knowncombines = ns.db.knowns
	local buttons = {}
	local factory = Panda.ButtonFactory
	local scroll, func, securefunc = self.scroll, self.func, self.securefunc

	local canCraft = self.spellid and GetSpellInfo((GetSpellInfo(self.spellid)))
	local craftDetail = canCraft and (securefunc or canCraft)

	local HGAP, VGAP = 5, -18
	local numrows, rowanchor, lastrow = 0

	for ids in self.itemids:gmatch("[^\n]+") do
		numrows = numrows + 1
		local row = CreateFrame("Frame", nil, self)
		row:SetHeight(32) row:SetWidth(1)
		row:SetPoint("TOPLEFT", lastrow or self, lastrow and "BOTTOMLEFT" or "TOPLEFT", 0, lastrow and VGAP or -HGAP)
		lastrow = row

		local gap, lastframe = 0
		for id,extra in ids:gmatch("(%d+):?(%S*)") do
			local craftable = not nocombine:match("%D"..id.."%D")
			gap = gap + (lastframe and HGAP or 0)
			id = tonumber(id)
			if id == 0 then gap = gap + 32 + (not lastframe and HGAP or 0)
			else
				lastframe = factory(self, id, (type(craftDetail) == "function" or craftable) and craftDetail, nil, extra, "TOPLEFT", lastframe or row, lastframe and "TOPRIGHT" or "TOPLEFT", gap, 0)
				lastframe.notcrafted = not craftable
				buttons[id] = lastframe
				if func then func(id, lastframe) end
				if not lastframe.notcrafted and canCraft and not known[lastframe] then
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

		scroll:EnableMouseWheel(true)

		if MAXOFFSET ~= 0 then
			local scrollbar = LibStub("tekKonfig-Scroll").new(scroll, 2, LINEHIEGHT)
			scrollbar:SetMinMaxValues(0, -MAXOFFSET)
			scrollbar:SetValue(0)

			scroll:UpdateScrollChildRect()
			scroll:SetScript("OnMouseWheel", function(scroll, val) scrollbar:SetValue(scrollbar:GetValue() + val*LINEHEIGHT) end)

			local orig = scrollbar:GetScript("OnValueChanged")
			scrollbar:SetScript("OnValueChanged", function(scrollbar, val, ...)
				scroll:SetVerticalScroll(val)
				self:SetPoint("TOP", 0, -val)
				return orig(scrollbar, val, ...)
			end)
		else
			scroll:SetScript("OnMouseWheel", noop)
		end
	end

	if canCraft then Panda.RefreshButtonFactory(scroll or self, canCraft, "TOPRIGHT", scroll or self, "BOTTOMRIGHT", 4, -3) end

	if canCraft and not tracker and next(unknown) then
		self:SetScript("OnEvent", function()
			if IsTradeSkillLinked() or IsTradeSkillGuild() then return end
			for i=1,GetNumTradeSkills() do
				local name, rowtype, _, _, skilltype = GetTradeSkillInfo(i)
				local spelllink = GetTradeSkillRecipeLink(i)
				local link = GetTradeSkillItemLink(i)
				if rowtype ~= "header" and link then
					local spellid = spelllink:match("enchant:(%d+)")
					knowncombines[tonumber(spellid) + 0.1] = true
					if skilltype == ENSCRIBE then AddToData(name)
					elseif idmemo[link] then knowncombines[idmemo[link]] = true end
				end
			end
			for f in pairs(unknown) do f:SetAlpha(known[f] and 1 or 0.25) end
		end)
		self:RegisterEvent("TRADE_SKILL_SHOW")
		tracker = true
	end

	if self.firstshowfunc then
		self:firstshowfunc()
		self.firstshowfunc = nil
	end

	self:SetScript("OnShow", function() OpenBackpack() end)
	OpenBackpack()

	return buttons
end

function Panda.PanelFactory(spellid, itemids, func, securefunc, firstshowfunc)
	local scroll = CreateFrame("ScrollFrame", nil, UIParent)
	local frame = CreateFrame("Frame", nil, UIParent)
	scroll:SetScrollChild(frame)
	scroll:Hide()
	frame.scroll, frame.spellid, frame.itemids, frame.func, frame.securefunc, frame.firstshowfunc = scroll, spellid, itemids, func, securefunc, firstshowfunc

	frame:SetScript("OnShow", Panda.PanelFiller)

	return scroll
end


