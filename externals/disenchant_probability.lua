
local myname, ns = ...
local GetItemInfo = GetItemInfo
local WEAPON = GetItemClassInfo(LE_ITEM_CLASS_WEAPON) -- returns localized strings
local ARMOR = GetItemClassInfo(LE_ITEM_CLASS_ARMOR)

-- I am lazy, so I "borrowed" these constants from Enchantrix ^^
local VOID, NEXUS, ABYSS, MAELSTROM = 22450, 20725, 34057, 52722
local SHEAVENLY, LHEAVENLY = 52720, 52721
local LRADIANT, SBRILLIANT, LBRILLIANT, SPRISMATIC, LPRISMATIC, LDREAM = 11178, 14343, 14344, 22448, 22449, 34052
local SGLIMMERING, LGLIMMERING, SGLOWING, LGLOWING, SRADIANT, SDREAM = 10978, 11084, 11138, 11139, 11177, 34053
local LCELEST, GCELEST = 52718, 52719
local LNETHER, GNETHER, LETERNAL, GETERNAL, LPLANAR, GPLANAR, LCOSMIC, GCOSMIC = 11174, 11175, 16202, 16203, 22447, 22446, 34056, 34055
local LMAGIC, GMAGIC, LASTRAL, GASTRAL, LMYSTIC, GMYSTIC = 10938, 10939, 10998, 11082, 11134, 11135
local STRANGE, SOUL, VISION, DREAM, ILLUSION, ARCANE, INFINITE, HYPNOTIC = 10940, 11083, 11137, 11176, 16204, 22445, 34054, 52555
local SHA, ETHERAL, SETHERAL, SPIRIT, MYST = 74248, 74247, 74252, 74249, 74250
local notDEable = {
	["32540"] = true,
	["32541"] = true,
	["18665"] = true,
	["21766"] = true,
	["5004"] = true,
	["20408"] = true,
	["20406"] = true,
	["20407"] = true,
	["14812"] = true,
	["31336"] = true,
	["32660"] = true,
	["32662"] = true,
	["11288"] = true,
	["11290"] = true,
	["12772"] = true,
	["11287"] = true,
	["11289"] = true,
	["29378"] = true,
	["69210"] = true, -- Renowned Guild Tabard, is DEable, but no one in their right mind would want to
	["63352"] = true, -- Shroud of Cooperation (A), as above
	["63353"] = true, -- Shroud of Cooperation (H)
	["63206"] = true, -- Wrap of Unity (A)
	["63207"] = true, -- Wrap of Unity (H)
	["69209"] = true, -- Illustrious Guild Tabard
}


local function GetUncommonVals(ilvl)
	if     ilvl <= 15  then return  STRANGE,  "1-2x", "80%", 1.5, .80,   LMAGIC, "1-2x", "20%", 1.5, .20
	elseif ilvl <= 20  then return  STRANGE,  "2-3x", "75%", 2.5, .75,   GMAGIC, "1-2x", "20%", 1.5, .20, SGLIMMERING, "1x", "5%", 1, .05
	elseif ilvl <= 25  then return  STRANGE,  "4-6x", "75%", 5.0, .75,  LASTRAL, "1-2x", "15%", 1.5, .15, SGLIMMERING, "1x", "10%", 1, .1
	elseif ilvl <= 30  then return     SOUL,  "1-2x", "75%", 1.5, .75,  GASTRAL, "1-2x", "20%", 1.5, .20, LGLIMMERING, "1x", "5%", 1, .05
	elseif ilvl <= 35  then return     SOUL,  "2-5x", "75%", 3.5, .75,  LMYSTIC, "1-2x", "20%", 1.5, .20,    SGLOWING, "1x", "5%", 1, .05
	elseif ilvl <= 40  then return   VISION,  "1-2x", "75%", 1.5, .75,  GMYSTIC, "1-2x", "20%", 1.5, .20,    LGLOWING, "1x", "5%", 1, .05
	elseif ilvl <= 45  then return   VISION,  "2-5x", "75%", 3.5, .75,  LNETHER, "1-2x", "20%", 1.5, .20,    SRADIANT, "1x", "5%", 1, .05
	elseif ilvl <= 50  then return    DREAM,  "1-2x", "75%", 1.5, .75,  GNETHER, "1-2x", "20%", 1.5, .20,    LRADIANT, "1x", "5%", 1, .05
	elseif ilvl <= 55  then return    DREAM,  "2-5x", "75%", 3.5, .75, LETERNAL, "1-2x", "20%", 1.5, .20,  SBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 60  then return ILLUSION,  "1-2x", "75%", 1.5, .75, GETERNAL, "1-2x", "20%", 1.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 65  then return ILLUSION,  "2-5x", "75%", 3.5, .75, GETERNAL, "2-3x", "20%", 2.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 80  then return   ARCANE,  "2-3x", "75%", 2.5, .75,  LPLANAR, "1-2x", "22%", 1.5, .22,  SPRISMATIC, "1x", "3%", 1, .03
	elseif ilvl <= 99  then return   ARCANE,  "2-3x", "75%", 2.5, .75,  LPLANAR, "2-3x", "22%", 2.5, .22,  SPRISMATIC, "1x", "3%", 1, .03
	elseif ilvl <= 120 then return   ARCANE,  "2-5x", "75%", 3.5, .75,  GPLANAR, "1-2x", "22%", 1.5, .22,  LPRISMATIC, "1x", "3%", 1, .03
	elseif ilvl <= 151 then return INFINITE,  "1-2x", "75%", 1.5, .75,  LCOSMIC, "1-2x", "22%", 1.5, .22,      SDREAM, "1x", "3%", 1, .03
	elseif ilvl <= 187 then return INFINITE,  "2-5x", "75%", 3.5, .75,  GCOSMIC, "1-2x", "22%", 1.5, .22,      LDREAM, "1x", "3%", 1, .03
	elseif ilvl <= 272 then return HYPNOTIC,  "1-3x", "75%", 2.0, .75,  LCELEST, "1-3x", "25%", 2.0, .25
	elseif ilvl <= 289 then return HYPNOTIC,  "1-5x", "75%", 3.0, .75,  LCELEST, "1-5x", "25%", 3.0, .25
	elseif ilvl <= 300 then return HYPNOTIC,  "1-7x", "75%", 4.0, .75,  LCELEST, "1-7x", "25%", 4.0, .25
	elseif ilvl <= 312 then return HYPNOTIC,  "1-8x", "75%", 4.5, .75,  GCELEST, "1-2x", "25%", 1.5, .25
	elseif ilvl <= 325 then return HYPNOTIC,  "1-9x", "75%", 5.0, .75,  GCELEST, "2-3x", "25%", 2.5, .25
	elseif ilvl <= 333 then return HYPNOTIC, "1-10x", "75%", 5.5, .75,  GCELEST, "2-3x", "25%", 2.5, .25
	elseif ilvl <= 380 then return   SPIRIT,  "1-3x", "85%", 2.0, .85,     MYST,   "1x", "15%", 1.0, .15
	elseif ilvl <= 390 then return   SPIRIT,  "1-4x", "85%", 2.5, .85,     MYST,   "1x", "15%", 1.0, .15
	elseif ilvl <= 410 then return   SPIRIT,  "1-5x", "85%", 3.0, .85,     MYST, "1-2x", "15%", 1.5, .15
	else return                      SPIRIT,  "1-6x", "85%", 3.5, .85,     MYST, "1-3x", "15%", 2.0, .15 end
end


-- Find all the possible DE results for a given item
--
-- item - The item to query, accepts all values GetItemInfo accepts
--
-- Returns up to three set of DE results.  Each result set consists of 5 values
--   itemID   - the ID of the item received
--   quantity - A String describing the number you may get, like "1-3x"
--   percent  - A String detailing the probability of this result
--   num_qty  - A number representing the average qty received
--   num_perc - A number representing the probability
function ns.GetPossibleDisenchants(item)
	local _, link, qual, ilvl, _, itemtype = GetItemInfo(item)
	if not link or not ns.DEable(link) then return end

	if qual == 4 then -- Epic
		if ilvl > 75 and ilvl <= 80 and itemtype == WEAPON then return NEXUS, "1-2x", "33%/66%", 5/3
		elseif ilvl <= 45  then return   SRADIANT, "2-4x",    "100%", 3.0, 1
		elseif ilvl <= 50  then return   LRADIANT, "2-4x",    "100%", 3.0, 1
		elseif ilvl <= 55  then return SBRILLIANT, "2-4x",    "100%", 3.0, 1
		elseif ilvl <= 60  then return      NEXUS,   "1x",    "100%", 1.0, 1
		elseif ilvl <= 80  then return      NEXUS, "1-2x",    "100%", 1.5, 1
		elseif ilvl <= 100 then return       VOID, "1-2x",    "100%", 1.5, 1
		elseif ilvl <= 164 then return       VOID, "1-2x", "33%/66%", 5/3, 1
		elseif ilvl <= 200 then return      ABYSS,   "1x",    "100%", 1.0, 1
		elseif ilvl <= 284 then return      ABYSS, "1-2x",    "100%", 1.5, 1
		elseif ilvl <= 359 then return  MAELSTROM,   "1x",    "100%", 1.0, 1
		elseif ilvl <= 359 then return  MAELSTROM, "1-2x",    "100%", 1.5, 1
		elseif ilvl <= 416 then return  MAELSTROM, "1-2x",    "100%", 1.5, 1
		else return                           SHA,   "1x",    "100%", 1.0, 1 end

	elseif qual == 3 then -- Rare
		if     ilvl <=  25 then return SGLIMMERING, "1x",  "100%", 1, 1
		elseif ilvl <=  30 then return LGLIMMERING, "1x",  "100%", 1, 1
		elseif ilvl <=  35 then return    SGLOWING, "1x",  "100%", 1, 1
		elseif ilvl <=  40 then return    LGLOWING, "1x",  "100%", 1, 1
		elseif ilvl <=  45 then return    SRADIANT, "1x",  "100%", 1, 1
		elseif ilvl <=  50 then return    LRADIANT, "1x",  "100%", 1, 1
		elseif ilvl <=  55 then return  SBRILLIANT, "1x",  "100%", 1, 1
		elseif ilvl <=  65 then return  LBRILLIANT, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
		elseif ilvl <=  99 then return  SPRISMATIC, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 120 then return  LPRISMATIC, "1x", "99.5%", 1, .995,  VOID, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 165 then return      SDREAM, "1x", "99.5%", 1, .995, ABYSS, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 200 then return      LDREAM, "1x", "99.5%", 1, .995, ABYSS, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 316 then return   SHEAVENLY, "1x",  "100%", 1, 1
		elseif ilvl <= 380 then return   LHEAVENLY, "1x",  "100%", 1, 1
		elseif ilvl <= 424 then return    SETHERAL, "1x",  "100%", 1, 1
		else return                        ETHERAL, "1x",  "100%", 1, 1 end

	elseif qual == 2 then -- Uncommon
		if itemtype == ARMOR then
			return GetUncommonVals(ilvl)
		elseif itemtype == WEAPON and ilvl < 380 then
			local r1i, r1ta, r1tp, r1a, r1p, r2i, r2ta, r2tp, r2a, r2p, r3i, r3ta, r3tp, r3a, r3p = GetUncommonVals(ilvl)
			return r1i, r1ta, r2tp, r1a, r2p, r2i, r2ta, r1tp, r2a, r1p, r3i, r3ta, r3tp, r3a, r3p
		elseif itemtype == WEAPON then
			-- Panda green weapons follow different rules form the old pattern
			if     ilvl <= 380 then return SPIRIT, "1-4x", "85%", 2.5, .85, MYST,   "1x", "15%", 1.0, .15
			elseif ilvl <= 390 then return SPIRIT, "1-5x", "85%", 3.0, .85, MYST,   "1x", "15%", 1.0, .15
			elseif ilvl <= 410 then return SPIRIT, "1-6x", "85%", 3.5, .85, MYST, "1-2x", "15%", 1.5, .15
			else return                    SPIRIT, "1-7x", "85%", 4.0, .85, MYST, "1-3x", "15%", 2.0, .15 end
		end
	end
end


-- Check if an item can be disenchanted
--
-- item - The item to query, must be an item link or itemID
--
-- Returns true if the item can be DE'd
function ns.DEable(link)
	local id = type(link) == "number" and link or select(3, link:find("item:(%d+):"))
	if id and notDEable[id] then return end

	local _, _, qual, itemLevel, _, itemType = GetItemInfo(link)
	return (itemType == ARMOR or itemType == WEAPON) and qual > 1 and qual < 5
end
