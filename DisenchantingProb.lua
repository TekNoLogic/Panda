

-- I am lazy, so I "borrowed" these constants from Enchantrix ^^
local VOID, NEXUS = 22450, 20725
local LRADIANT, SBRILLIANT, LBRILLIANT, SPRISMATIC, LPRISMATIC = 11178, 14343, 14344, 22448, 22449
local SGLIMMERING, LGLIMMERING, SGLOWING, LGLOWING, SRADIANT = 10978, 11084, 11138, 11139, 11177
local LNETHER, GNETHER, LETERNAL, GETERNAL, LPLANAR, GPLANAR = 11174, 11175, 16202, 16203, 22447, 22446
local LMAGIC, GMAGIC, LASTRAL, GASTRAL, LMYSTIC, GMYSTIC = 10938, 10939, 10998, 11082, 11134, 11135
local STRANGE, SOUL, VISION, DREAM, ILLUSION, ARCANE = 10940, 11083, 11137, 11176, 16204, 22445


-- Average AH Buyouts, mined from wowhead.com
local buyouts = {
	[VOID] = 500000, [NEXUS] = 72000,
	[LBRILLIANT] = 100000, [LGLIMMERING] = 10000, [LGLOWING] = 15000, [LPRISMATIC] = 150000, [LRADIANT] = 78000,
	[SBRILLIANT] = 15000, [SGLIMMERING] = 2500, [SGLOWING] = 5000, [SPRISMATIC] = 50000, [SRADIANT] = 60000,
	[GASTRAL] = 10000, [GETERNAL] = 100000, [GMAGIC] = 5000, [GMYSTIC] = 10000, [GNETHER] = 50000, [GPLANAR] = 50000,
	[LASTRAL] = 3300, [LETERNAL] = 35000, [LMAGIC] = 2000, [LMYSTIC] = 5000, [LNETHER] = 20000, [LPLANAR] = 20000,
	[ARCANE] = 20000, [DREAM] = 7500, [ILLUSION] = 20000, [SOUL] = 2000, [STRANGE] = 1000, [VISION] = 5000,
}


-- Only 4 items are disenchantable, rare, ilvl 66-70, and from TBC
local BCblues = {[23835] = true, [23836] = true, [25653] = true, [32863] = true}


local function GetUncommonVals(ilvl)
	if ilvl <= 15 then return      STRANGE, "1-2x", "80%", 1.5, .80,   LMAGIC, "1-2x", "20%", 1.5, .20
	elseif ilvl <= 20 then return  STRANGE, "2-3x", "75%", 2.5, .75,   GMAGIC, "1-2x", "20%", 1.5, .20, SGLIMMERING, "1x", "5%", 1, .05
	elseif ilvl <= 25 then return  STRANGE, "4-6x", "75%", 5.0, .75,  LASTRAL, "1-2x", "15%", 1.5, .15, SGLIMMERING, "1x", "10%", 1, .1
	elseif ilvl <= 30 then return     SOUL, "1-2x", "75%", 1.5, .75,  GASTRAL, "1-2x", "20%", 1.5, .20, LGLIMMERING, "1x", "5%", 1, .05
	elseif ilvl <= 35 then return     SOUL, "2-5x", "75%", 3.5, .75,  LMYSTIC, "1-2x", "20%", 1.5, .20,    SGLOWING, "1x", "5%", 1, .05
	elseif ilvl <= 40 then return   VISION, "1-2x", "75%", 1.5, .75,  GMYSTIC, "1-2x", "20%", 1.5, .20,    LGLOWING, "1x", "5%", 1, .05
	elseif ilvl <= 45 then return   VISION, "2-5x", "75%", 3.5, .75,  LNETHER, "1-2x", "20%", 1.5, .20,    SRADIANT, "1x", "5%", 1, .05
	elseif ilvl <= 50 then return    DREAM, "1-2x", "75%", 1.5, .75,  GNETHER, "1-2x", "20%", 1.5, .20,    LRADIANT, "1x", "5%", 1, .05
	elseif ilvl <= 55 then return    DREAM, "2-5x", "75%", 3.5, .75, LETERNAL, "1-2x", "20%", 1.5, .20,  SBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 60 then return ILLUSION, "1-2x", "75%", 1.5, .75, GETERNAL, "1-2x", "20%", 1.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 65 then return ILLUSION, "2-5x", "75%", 3.5, .75, GETERNAL, "2-3x", "20%", 2.5, .20,  LBRILLIANT, "1x", "5%", 1, .05
	elseif ilvl <= 80 then return   ARCANE, "2-3x", "75%", 2.5, .75,  LPLANAR, "1-2x", "20%", 1.5, .20,  SPRISMATIC, "1x", "5%", 1, .05
	elseif ilvl <= 99 then return   ARCANE, "2-3x", "75%", 2.5, .75,  LPLANAR, "2-3x", "20%", 2.5, .20,  SPRISMATIC, "1x", "5%", 1, .05
	else return                     ARCANE, "2-5x", "75%", 3.5, .75,  GPLANAR, "1-2x", "20%", 1.5, .20,  LPRISMATIC, "1x", "5%", 1, .05 end
end


function Panda:GetPossibleDisenchants(item)
	local _, link, qual, ilvl, _, itemtype = GetItemInfo(item)
	if not link or qual < 2 or (itemtype ~= "Weapon" and itemtype ~= "Armor") then return end

	if qual == 4 then -- Epic
		if ilvl > 75 and ilvl <= 80 and itemtype == "Weapon" then return NEXUS, "1-2x", "33%/66%", 5/3
		elseif ilvl <= 45  then return SRADIANT, "2-4x", "100%", 3, 1
		elseif ilvl <= 50  then return LRADIANT, "2-4x", "100%", 3, 1
		elseif ilvl <= 55  then return SBRILLIANT, "2-4x", "100%", 3, 1
		elseif ilvl <= 60  then return NEXUS, "1x", "100%", 1, 1
		elseif ilvl <= 80  then return NEXUS, "1-2x", "100%", 1.5, 1
		elseif ilvl <= 100 then return VOID, "1-2x", "100%", 1.5, 1
		else return VOID, "1-2x", "33%/66%", 5/3, 1 end

	elseif qual == 3 then -- Rare
		local _, _, itemid = string.find(link, "item:(%d+):")
		itemid = tonumber(itemid)

		if BCblues[itemid] then return SPRISMATIC, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 25 then return SGLIMMERING, "1x", "100%", 1, 1
		elseif ilvl <= 30 then return LGLIMMERING, "1x", "100%", 1, 1
		elseif ilvl <= 35 then return    SGLOWING, "1x", "100%", 1, 1
		elseif ilvl <= 40 then return    LGLOWING, "1x", "100%", 1, 1
		elseif ilvl <= 45 then return    SRADIANT, "1x", "100%", 1, 1
		elseif ilvl <= 50 then return    LRADIANT, "1x", "100%", 1, 1
		elseif ilvl <= 55 then return  SBRILLIANT, "1x", "100%", 1, 1
		elseif ilvl <= 65 then return  LBRILLIANT, "1x", "100%", 1, 1
		elseif ilvl <= 70 then return  LBRILLIANT, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
		elseif ilvl <= 99 then return  SPRISMATIC, "1x", "99.5%", 1, .995, NEXUS, "1x", "0.5%", 1, 0.005
		else return                    LPRISMATIC, "1x", "99.5%", 1, .995, VOID, "1x", "0.5%", 1, 0.005 end

	elseif qual == 2 then -- Uncommon
		if itemtype == "Armor" then
			return GetUncommonVals(ilvl)
		elseif itemtype == "Weapon" then
			local r1i, r1ta, r1tp, r1a, r1p, r2i, r2ta, r2tp, r2a, r2p, r3i, r3ta, r3tp, r3a, r3p = GetUncommonVals(ilvl)
			return r1i, r1ta, r2tp, r1a, r2p, r2i, r2ta, r1tp, r2a, r1p, r3i, r3ta, r3tp, r3a, r3p
		end
	end
end


function Panda:GetAHBuyout(item)
	if not item then return end
	local aadvprice = AucAdvanced and AucAdvanced.API.GetMarketValue(item)
	return aadvprice or buyouts[item]
end

