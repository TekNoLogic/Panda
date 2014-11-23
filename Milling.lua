
local panel = Panda.panel:NewPanel(true)
local NAME, _, MILLICON = GetSpellInfo(51005)
local NAME2 = GetSpellInfo(45357)
local _, _, _, _, _, HERB = GetAuctionItemSubClasses(6)
local inks = "113111 79254 79255 39469 39774 43115 43116 43117 43118 43118 43119 43120 43121 43122 43123 43124 43125 43126 43127 61978 61981"
local blacklist_herbs = {[72238] = true}
local whitelist_herbs = {[87821] = true, [89639] = true, [39969] = true}
panel:RegisterFrame(NAME, Panda.PanelFactory(45357,
[[114931 113111   0     0     0  109124 109125 109126 109127 109129 109128   0     0   0 0 6948
   79251  79253 79254 79255   0   72234  72235  72237  79010  79011  89639
   61979  61980 61978 61981   0   52983  52984  52985  52986  52987  52988
   39343  43109 43126 43127   0   36901  36903  36904  36905  36906  36907 37921 39970
   39342  43108 43124 43125   0   22785  22786  22787  22789  22790  22791 22792 22793
   39341  43107 43122 43123   0   13464  13463  13465  13466  13467
   39340  43106 43120 43121   0    4625   8831   8836   8838   8845   8839  8846
   39339  43105 43118 43119   0    3818   3821   3358   3819
   39338  43104 43116 43117   0    3369   3355   3356   3357
   39334  43103 39774 43115   0     785   2450   2452   3820   2453
   39151    0   39469   0     0    2447    765   2449
]], function(id, frame) if id == 6948 and not GetSpellInfo((GetSpellInfo(45357))) then frame:Hide() end end, function(frame)
	frame:SetAttribute("type", "macro")
	if frame.id == 6948 then
		frame.icon:SetTexture(MILLICON)
		frame.id = nil
		frame.tiptext = "Mass Mill\nThis will mill any available herb.\nTo use in a macro: '/click MassMill'"

		local function GetHerb()
			for bag=0,4 do
				for slot=1,GetContainerNumSlots(bag) do
					local id = GetContainerItemID(bag, slot)
					local _, count = GetContainerItemInfo(bag, slot)
					if id and not blacklist_herbs[id] then
						local _, _, _, _, _, _, itemtype = GetItemInfo(id)
						if (whitelist_herbs[id] or itemtype == HERB) and count >= 5 then
							return bag, slot
						end
					end
				end
			end
		end

		frame:SetScript("PreClick", function()
			if InCombatLockdown() then return end

			local bag, slot = GetHerb()
			if not (bag and slot) then return end

			frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use ".. bag.. " ".. slot)
		end)

		frame:SetScript("PostClick", function()
			-- Revert back to basic casting, in case next click is in combat
			if InCombatLockdown() then return end
			frame:SetAttribute("macrotext", "/cast "..NAME)
		end)

	elseif inks:match(frame.id) then
		frame:SetAttribute("macrotext", Panda.CraftMacro(NAME2, frame.id))
	else
		frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use item:"..frame.id)
	end
end))
