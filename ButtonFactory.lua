
local HideTooltip, ShowTooltip, GS, G = Panda.HideTooltip, Panda.ShowTooltip, Panda.GS, Panda.G
local auc = LibStub("tekAucQuery")


local server = GetRealmName().." "..UnitFactionGroup("player")
local UNK, ICONS = "Interface\\Icons\\INV_Misc_QuestionMark", {
	AGI = "Spell_Holy_BlessingOfAgility",
	AP = "Spell_Holy_FistOfJustice",
	APEN = "Ability_Rogue_Rupture",
	ARM = "INV_Misc_ArmorKit_25",
	BEAST = "Ability_Druid_FerociousBite",
	BERSERK = "Spell_Shadow_DeathPact",
	BLD = "spell_shadow_lifedrain",
	BLKR = "Ability_Warrior_DefensiveStance",
	BLKV = "INV_Shield_04",
	CRIT = "Ability_Rogue_KidneyShot",
	CRUSADER = "Spell_Holy_WeaponMastery",
	DAM = "Ability_Gouge",
	DEF = "Ability_Defend",
	DEMON = "Spell_Shadow_DemonicTactics",
	DOD = "Spell_Nature_Invisibilty",
	ELEM = "Spell_Frost_SummonWaterElemental",
	EXP = "Spell_Holy_BlessingOfStrength",
	FADE = "Spell_Magic_LesserInvisibilty",
	FIERY = "Spell_Fire_Immolation",
	FIP = "Spell_Fire_FireBolt02",
	FISH = "INV_Misc_Fish_09",
	FROST = "Spell_Frost_FrostShock",
	FRP = "Spell_Frost_FrostBolt02",
	GATHER = "Trade_Herbalism",
	GIANT = "Ability_Racial_Avatar",
	HASTE = "Ability_Hunter_RunningShot",
	HERB = "INV_Misc_Flower_02",
	HIT = "Ability_Marksmanship",
	HMP = "INV_Potion_79",
	HP = "INV_Potion_51",
	INT = "Spell_Holy_MagicalSentry",
	LIFESTEAL = "Spell_Shadow_LifeDrain",
	MAS = "Spell_Holy_ChampionsBond",
	MINE = "Trade_Mining",
	MONGOOSE = "Spell_Nature_UnrelentingStorm",
	MOUNT = "INV_Misc_Crop_02",
	MP = "INV_Potion_72",
	MPR = "Spell_Magic_ManaGain",
	MULT = "ability_monk_palmstrike",
	NAT = "Spell_Nature_AbolishMagic",
	PARRY = "Ability_Parry",
	RALL = "Spell_Frost_WizardMark",
	RAR = "Spell_Nature_StarFall",
	RES = "Spell_Holy_ChampionsGrace",
	RFI = "Spell_Fire_FireArmor",
	RFR = "Spell_Frost_FrostWard",
	RNA = "Spell_Nature_ResistNature",
	RSH = "Spell_Shadow_AntiShadow",
	SHP = "Spell_Shadow_ShadowBolt",
	SKIN = "INV_Misc_Pelt_Wolf_01",
	SOULFROST = "Spell_Holy_ConsumeMagic",
	SP = "Spell_Holy_MindVision",
	SPE = "Spell_Fire_BurningSpeed",
	SPEN = "Spell_Nature_StormReach",
	SPI = "Spell_Holy_DivineSpirit",
	STA = "Spell_Nature_UnyeildingStamina",
	STAT = "Spell_ChargePositive",
	STL = "Ability_Stealth",
	STR = "Spell_Nature_Strength",
	SUNFIRE = "Ability_Mage_FireStarter",
	THREAT = "Spell_Nature_Reincarnation",
	UNDEAD = "Spell_Shadow_DarkSummoning",
	UNHOLY = "Spell_Shadow_CurseOfMannoroth",
	VERS = "ability_monk_roll",
	WINTER = "Spell_Frost_FrostNova",
}


local function OnEvent(self)
	if not self.id then return end
	local count = GetItemCount(self.id, true)
	if self.craftqty then
		self.count:SetText("*".. self.craftqty)
	else
		self.count:SetText(count > 0 and count or "")
	end
	if self.text then
		local auc_price = auc[self.id]
		local craft_price = not self.notcrafted and GetReagentCost and GetReagentCost(self.id)
		local price = auc_price and craft_price and Panda.showprofit and (auc_price - craft_price) or auc_price
		if price and price < 100 then price = nil end
		self.text:SetText(GS(price))
	end


	if ForSaleByOwnerDB then
		local count = 0
		for char,vals in pairs(ForSaleByOwnerDB[server]) do
			count = count + (vals[self.id] or 0)
		end
		self.ahcount:SetText(count ~= 0 and count or "")
	end
end


local function OnHide(self) self:UnregisterEvent("BAG_UPDATE") end
local function OnShow(self)
	self:RegisterEvent("BAG_UPDATE")
	OnEvent(self)
end


function Panda.CraftMacro(name, id, extra)
	local linkfunc, linktoken = extra and "GetTradeSkillRecipeLink" or "GetTradeSkillItemLink", extra and "enchant:" or "item:"
	return "/run if IsShiftKeyDown() then ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) end\n"..
		"/stopmacro [mod:shift]\n"..
		"/run CloseTradeSkill()\n/cast "..name.."\n"..
		"/run for i=1,GetNumTradeSkills() do local l = "..linkfunc.."(i) if l and l:match('"..linktoken..(extra or id)..(extra and "" or ":").."') then "..
			"TradeSkillFrame_SetSelection(i); DoTradeSkill(i, IsAltKeyDown() and select(3, GetTradeSkillInfo(i)) or 1) end end\n"..
		"/run if not IsAltKeyDown() then CloseTradeSkill() end"
end


function Panda.ButtonFactory(parent, id, secure, notext, extra, ...)
	local craftqty = (extra or ""):match("^x(%d*)")
	local extraid, extraicon = (not craftqty and extra or ""):match("(%d*):?(%S*)")
	local customicon = extraicon ~= "" and extraicon

	local f = CreateFrame(secure and "CheckButton" or "Frame", id == 6948 and "MassMill" or nil, parent, secure and "SecureActionButtonTemplate")
	local texture = GetItemIcon(id)
	f.id = id
	if extraid and extraid ~= "" then f.extra, f.tiplink = extraid, "spell:"..extraid end

	f:SetHeight(32)
	f:SetWidth(32)
	if not secure then f:EnableMouse() end
	if select("#", ...) > 0 then f:SetPoint(...) end
	f:SetScript("OnEnter", ShowTooltip)
	f:SetScript("OnLeave", HideTooltip)
	f:SetScript("OnShow", OnShow)
	f:SetScript("OnHide", OnHide)
	f:SetScript("OnEvent", OnEvent)

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetAllPoints(f)
	icon:SetTexture(texture and (customicon and ("Interface\\Icons\\".. ICONS[customicon]) or texture) or UNK)
	f.icon = icon

	if not notext then
		f.text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		f.text:SetPoint("TOP", icon, "BOTTOM")
	end

	local count = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", -2, 2)
	f.count = count

	f.ahcount = f:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmall")
	f.ahcount:SetPoint("TOPRIGHT", icon, "TOPRIGHT", -2, -2)

	f.craftqty = craftqty
	if secure then
		if type(secure) == "function" then
			secure(f)
		else
			f:SetAttribute("type", "macro")
			f:SetAttribute("macrotext", Panda.CraftMacro(secure, id, f.extra))
		end
	end

	if f:IsVisible() then OnShow(f) end

	return f
end


function Panda.RefreshButtonFactory(parent, tradeskill, ...)
	local b = CreateFrame("Button", nil, parent, "SecureActionButtonTemplate")
	b:SetPoint(...)
	b:SetWidth(80) b:SetHeight(22)

	-- Fonts --
	b:SetDisabledFontObject(GameFontDisable)
	b:SetHighlightFontObject(GameFontHighlight)
	b:SetNormalFontObject(GameFontNormal)

	-- Textures --
	b:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	b:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	b:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	b:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	b:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	b:GetHighlightTexture():SetBlendMode("ADD")

	b:SetText("Refresh")
	b:SetAttribute("type", "macro")
	b:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..tradeskill.."\n/run CloseTradeSkill()")

	return b
end
