
--[[
tekPanelAuction v11

Creates a frame using the Auction House textures.  Also generates a panel
inside this frame.  Additional panels can be created.  Panels can be
completely blank, like the Bids tab or split with a side frame like the
Browse tab.  When using the split panel, sub-panels can be registered that
will create a menu item on the left that opens the subpanel in the space on
the right.  Switching between main panels is not automatically provided,
you must create tabs or some other interface to do this.

Make sure you use ShowUIPanel(...) to show your frame, this ensure it is
positioned by the game's engine, and closes with the ESC key.

name       - A string defining the name to assign the frame in the global.
             namespace, use nil for no name. Passed to CreateFrame.
titletext  - A string containing the text to display in the frame's titlebar.
             Nil can be passed if no title is desired, but one is recommended
splitstyle - A boolean to trigger using split style in the default panel.

Examples
  ns.tekPanelAuction("rawr", "Imma bear", true)
  -- Creates a frame nameed rawr, with title "Imma bear", and a split panel.

  ns.tekPanelAuction()
  -- Create an anonymous frame, with no title and a blank panel.

Returns the frame and the automatically generated panel.


Additional panels can be generated with the NewPanel method on the frame.
The panel is inserted into the frame's panel list, but you must provide
means of toggling its visibility.

splitstyle - A boolean to trigger using split style.

Example

  local f = ns.tekPanelAuction(nil, "")
  local panel = f:NewPanel(true)

Returns the newly generated panel.


When using the split style, you can register new subpanels by calling the
panel's RegisterFrame method.  You do not need to parent or anchor the frame
passed in, it will be automatically positioned in the right side of the
panel when it is displayed.

name  - A string containing the name to display in the list on the left.
frame - The frame to display for the subpanel.

Example

  local subpanel = CreateFrame("Frame", nil, UIParent)
  local f = ns.tekPanelAuction(nil, "")
  local panel = f:NewPanel(true)
  panel:RegisterFrame("Help", subpanel)

Returns nothing.
]]

local myname, ns = ...


local function createtex(parent, layer, w, h, ...)
	local tex = parent:CreateTexture(nil, layer)
	tex:SetWidth(w) tex:SetHeight(h)
	tex:SetPoint(...)
	return tex
end

local function newpanel(base, splitstyle)
	local frame = CreateFrame("Frame", nil, base)
	frame:SetAllPoints()
	frame:Hide()

	table.insert(base.panels, frame)
	frame.base = base

	if splitstyle then
		local subpanel = CreateFrame("Frame", nil, frame)
		subpanel:SetPoint("TOPLEFT", 190, -103)
		subpanel:SetPoint("BOTTOMRIGHT", -12, 39)

		local frames, buttons, names, refresh = {}, {}, {}
		frame.frames = frames

		function frame:RegisterFrame(name, newframe)
			newframe:Hide()
			frames[name] = newframe
			table.insert(names, name)
			if refresh then refresh() end
		end


		function frame:ShowPanel(name)
			local frame = frames[name]
			if not frame then return end

			for _,f in pairs(frames) do f:Hide() end
			frame:SetParent(subpanel)
			frame:SetAllPoints(subpanel)
			frame:Show()
			if refresh then refresh() end
		end


		frame:SetScript("OnShow", function(self)
			local panel, offset = self, 0

			local function OnClick(self)
				if not self.scrollframe then return end

				local frame = self.scrollframe
				if frame:IsVisible() then
					frame:Hide()
					self:UnlockHighlight()
				else
					for _,f in pairs(frames) do f:Hide() end
					for _,f in pairs(buttons) do f:UnlockHighlight() end

					frame:SetParent(subpanel)
					frame:SetAllPoints(subpanel)
					frame:Show()

					self:LockHighlight()
				end
			end

			local function OnMouseWheel(self, v)
				if v > 0 then -- up
					offset = math.max(offset - 1, 0)
					refresh()
				else -- down
					offset = math.max(math.min(offset + 1, #names - 15), 0)
					refresh()
				end
			end

			function refresh()
				for i=1,15 do
					local frame, name = buttons[i], names[i+offset]
					if name then
						frame:SetText("  "..name)
						frame.scrollframe = frames[name]
						if frames[name]:IsVisible() then frame:LockHighlight() else frame:UnlockHighlight() end
						frame:Show()
					else
						frame:Hide()
					end
				end
			end

			for i=1,15 do
				local button = CreateFrame("Button", nil, panel)
				button:SetWidth(158) button:SetHeight(20)
				if i == 1 then button:SetPoint("TOPLEFT", self, 23, -105) else button:SetPoint("TOP", buttons[i-1], "BOTTOM", 0, 0) end

				button:SetHighlightFontObject(GameFontHighlightSmallLeft)
				button:SetNormalFontObject(GameFontNormalSmallLeft)

				button:SetNormalTexture("Interface\\AuctionFrame\\UI-AuctionFrame-FilterBG")
				button:GetNormalTexture():SetTexCoord(0, 0.53125, 0, 0.625)

				button:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
				button:GetHighlightTexture():SetBlendMode("ADD")

				button:EnableMouseWheel()
				button:SetScript("OnMouseWheel", OnMouseWheel)
				button:SetScript("OnClick", OnClick)

				buttons[i] = button
			end

			local function setbackdrop(self)
				self.base.topleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft")
				self.base.top:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top")
				self.base.topright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight")
				self.base.bottomleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft")
				self.base.bottom:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot")
				self.base.bottomright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
			end

			refresh()
			setbackdrop(self)
			self:SetScript("OnShow", setbackdrop)
		end)
	else
		frame:SetScript("OnShow", function(self)
			-- AuctionFrameTopLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft");
			-- AuctionFrameTop:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Top");
			-- AuctionFrameTopRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopRight");
			-- AuctionFrameBotLeft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft");
			-- AuctionFrameBot:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot");
			-- AuctionFrameBotRight:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight");

			self.base.topleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft")
			self.base.top:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Top")
			self.base.topright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopRight")
			self.base.bottomleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft")
			self.base.bottom:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot")
			self.base.bottomright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
		end)
	end

	return frame
end


function ns.tekPanelAuction(name, titletext, splitstyle)
	local frame = CreateFrame("Frame", name, UIParent)
	-- frame:CreateTitleRegion()
	frame:SetToplevel(true)
	frame:SetFrameLevel(100) -- Force frame to a high level so it shows on top the first time it's displayed
	frame:SetWidth(832) frame:SetHeight(447)
	frame:SetPoint("TOPLEFT", 0, -104)
	frame:EnableMouse() -- To avoid click-thru
	-- frame:SetMovable(false)

	frame:Hide()

	frame:SetAttribute("UIPanelLayout-defined", true)
	frame:SetAttribute("UIPanelLayout-enabled", true)
	frame:SetAttribute("UIPanelLayout-area", "doublewide")
	frame:SetAttribute("UIPanelLayout-whileDead", true)
	table.insert(UISpecialFrames, name)

	-- local title = frame:GetTitleRegion()
	-- title:SetWidth(757) title:SetHeight(20)
	-- title:SetPoint("TOPLEFT", 75, -15)

	local portrait = createtex(frame, "OVERLAY", 57, 57, "TOPLEFT", 9, -7)
	SetPortraitTexture(portrait, "player")
	frame:SetScript("OnEvent", function(self, event, unit) if unit == "player" then SetPortraitTexture(portrait, "player") end end)
	frame:RegisterEvent("UNIT_PORTRAIT_UPDATE")

	local title = frame:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("TOP", 0, -18)
	title:SetText(titletext)

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 3, -8)
	close:SetScript("OnClick", function() HideUIPanel(frame) end)

	frame.topleft = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", 0, 0)
	frame.top = createtex(frame, "ARTWORK", 320, 256, "TOPLEFT", 256, 0)
	frame.topright = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", frame.top, "TOPRIGHT")
	frame.bottomleft = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", 0, -256)
	frame.bottom = createtex(frame, "ARTWORK", 320, 256, "TOPLEFT", 256, -256)
	frame.bottomright = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", frame.bottom, "TOPRIGHT")

	frame.panels = {}
	frame.NewPanel = newpanel

	local panel = frame:NewPanel(splitstyle)
	if splitstyle then
		function frame:RegisterFrame(...)
			panel:RegisterFrame(...)
		end
	end

	local voyeur = CreateFrame("Frame", nil, frame)
	voyeur:SetScript("OnShow", function()
		local vis
		for i,panel in pairs(frame.panels) do vis = vis or panel:IsShown() end
		if not vis then frame.panels[1]:Show() end
	end)

	return frame, panel
end


