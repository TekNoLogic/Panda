

local lib, oldminor = LibStub:NewLibrary("tekPanel-Auction", 2)
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

	return frame
end

