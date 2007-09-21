
function Panda:ADDON_LOADED(event, addon)
	if addon ~= "btmscan" then return end

	local libName = "Panda DE"
	local lcName = libName:lower()
	local lib = { name = lcName, propername = libName }
	table.insert(BtmScan.evaluators, lcName)
	local define = BtmScan.Settings.SetDefault
	local get = BtmScan.Settings.GetSetting
	local set = BtmScan.Settings.SetSetting

	BtmScan.evaluators[lcName] = lib


	local values = setmetatable({}, {
		__index = function(t, link)
			if not link then return end

			local name, _, qual, itemLevel, _, itemType, itemSubType, _, _, texture = GetItemInfo(link)

			if not name or not Panda:DEable(link) then
				t[link] = false
				return
			end

			local id1, _, _, qty1 = Panda:GetPossibleDisenchants(link)
			local bo1 = Panda:GetAHBuyout(id1)

			val = qty1*bo1
			t[link] = val
			return val
		end,
	})


	function lib:valuate(item, tooltip)
		local price = 0

		if not get(lcName..".enable") or item.qual <= 1 then return end

		-- Valuate this item
		local market = values[item.id]
		if not market then
			item:info("Unable to get DE value")
			return
		end
		item:info("Disenchant value", market)

		-- Adjust for brokerage / deposit costs
		local adjusted = market
		local brokerage = get(lcName..'.adjust.brokerage')

		if brokerage then
			local basis = get(lcName..'.adjust.basis')
			local brokerRate, depositRate = 0.05, 0.05
			if (basis == "neutral") then
				brokerRate, depositRate = 0.15, 0.25
			end
			if (brokerage) then
				local amount = (market * brokerRate)
				adjusted = adjusted - amount
				item:info(" - Brokerage", amount)
			end
			item:info(" = Adjusted amount", adjusted)
		end

		-- Calculate the real value of this item once our profit is taken out
		local pct = get(lcName..".profit.pct")
		local min = get(lcName..".profit.min")
		local value, mkdown = BtmScan.Markdown(adjusted, pct, min)
		item:info((" - %d%% / %s markdown"):format(pct,BtmScan.GSC(min, true)), mkdown)

		-- Check for tooltip evaluation
		if tooltip then
			item.what = self.name
			item.valuation = value
			if item.bid == 0 then return end
		end

		-- If the current purchase price is more than our valuation,
		-- another module "wins" this purchase.
		if value < item.purchase then return end

		-- Check to see what the most we can pay for this item is.
		if item.canbuy and item.buy < value then price = item.buy
		elseif item.canbid and item.bid < value then price = item.bid end

		-- Check our projected profit level
		local profit = price > 0 and (value - price) or 0

		-- If what we are willing to pay for this item beats what
		-- other modules are willing to pay, and we can make more
		-- profit, then we "win".
		if price >= item.purchase and profit > item.profit then
			item.purchase = price
			item.reason = self.name
			item.what = self.name
			item.profit = profit
			item.valuation = market
		end
	end

	local ahList = {
		{'faction', "Faction AH Fees"},
		{'neutral', "Neutral AH Fees"},
	}

	define(lcName..'.enable', true)
	define(lcName..'.profit.min', 4500)
	define(lcName..'.profit.pct', 45)
	define(lcName..'.adjust.brokerage', true)
	define(lcName..'.adjust.basis', "faction")

	function lib:setup(gui)
		id = gui:AddTab(libName)
		gui:AddControl(id, "Subhead",          0,    libName.." Settings")
		gui:AddControl(id, "Checkbox",         0, 1, lcName..".enable", "Enable purchasing for "..lcName)
		gui:AddControl(id, "MoneyFramePinned", 0, 1, lcName..".profit.min", 1, 99999999, "Minimum Profit")
		gui:AddControl(id, "WideSlider",       0, 1, lcName..".profit.pct", 1, 100, 0.5, "Minimum Discount: %0.01f%%")
		gui:AddControl(id, "Subhead",          0,    "Fees adjustment")
		gui:AddControl(id, "Selectbox",        0, 1, ahList, lcName..".adjust.basis", "Auction fees basis")
		gui:AddControl(id, "Checkbox",         0, 1, lcName..".adjust.brokerage", "Subtract auction fees from projected profit")
	end

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
end
