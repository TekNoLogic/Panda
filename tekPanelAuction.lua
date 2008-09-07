

local lib, oldminor = LibStub:NewLibrary("tekPanel-Auction", 3)
if not lib then return end
oldminor = oldminor or 0


local function createtex(parent, layer, w, h, ...)
	local tex = parent:CreateTexture(nil, layer)
	tex:SetWidth(w) tex:SetHeight(h)
	tex:SetPoint(...)
	return tex
end


function lib.new(name, titletext, splitstyle)
	local frame = CreateFrame("Frame", name, UIParent)
	frame:CreateTitleRegion()
	frame:SetFrameStrata("DIALOG")
	frame:SetWidth(832) frame:SetHeight(447)
	frame:SetPoint("TOPLEFT", 0, -104)
	frame:EnableMouse() -- To avoid click-thru

	frame:Hide()

	frame:SetAttribute("UIPanelLayout-defined", true)
	frame:SetAttribute("UIPanelLayout-enabled", true)
	frame:SetAttribute("UIPanelLayout-area", "doublewide")
	frame:SetAttribute("UIPanelLayout-whileDead", true)
	table.insert(UISpecialFrames, name)

	local title = frame:GetTitleRegion()
	title:SetWidth(757) title:SetHeight(20)
	title:SetPoint("TOPLEFT", 75, -15)

	local portrait = createtex(frame, "OVERLAY", 57, 57, "TOPLEFT", 9, -7)
	SetPortraitTexture(portrait, "player")
	frame:SetScript("OnEvent", function(self, event, unit) if unit == "player" then SetPortraitTexture(portrait, "player") end end)
	frame:RegisterEvent("UNIT_PORTRAIT_UPDATE")

	local title = frame:CreateFontString(nil, "OVERLAY")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("TOP", 0, -18)
	title:SetText(titletext)

	local topleft = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", 0, 0)
	local top = createtex(frame, "ARTWORK", 320, 256, "TOPLEFT", 256, 0)
	local topright = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", top, "TOPRIGHT")
	local bottomleft = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", 0, -256)
	local bottom = createtex(frame, "ARTWORK", 320, 256, "TOPLEFT", 256, -256)
	local bottomright = createtex(frame, "ARTWORK", 256, 256, "TOPLEFT", bottom, "TOPRIGHT")

	if splitstyle then
		topleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopLeft")
		top:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Top")
		topright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-TopRight")
		bottomleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotLeft")
		bottom:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-Bot")
		bottomright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Browse-BotRight")
	else
		topleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft")
		top:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Top")
		topright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopRight")
		bottomleft:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft")
		bottom:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-Bot")
		bottomright:SetTexture("Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight")
	end

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 3, -8)
	close:SetScript("OnClick", function() HideUIPanel(frame) end)

	if splitstyle then
		local frames, names, refresh = {}, {}

		function frame:RegisterFrame(name, newframe)
			frames[name] = newframe
			table.insert(names, name)
			if refresh then refresh() end
		end


		frame:SetScript("OnShow", function(self)
			local panel, buttons, offset = self, {}, 0

			local function OnClick(self)
				if not self.scrollframe then return end

				local frame = self.scrollframe
				if frame:IsVisible() then
					frame:Hide()
					self:UnlockHighlight()
				else
					for _,f in pairs(frames) do f:Hide() end
					for _,f in pairs(buttons) do f:UnlockHighlight() end

					frame:SetParent(panel)
					frame:ClearAllPoints()
					frame:SetPoint("TOPLEFT", 190, -103)
					frame:SetWidth(630) frame:SetHeight(305)
					frame:SetFrameStrata("DIALOG")
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

			refresh()
			self:SetScript("OnShow", nil)
		end)
	end

	return frame
end

