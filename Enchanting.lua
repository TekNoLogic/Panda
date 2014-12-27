
local L = Panda.locale


local SPELLID = 7411
local NAME = GetSpellInfo(SPELLID)
local function NoSpelltips(id, f) f.tiplink = nil end
local function MakeMacro(frame)
	local id, extra = frame.id, frame.extra

	return "/run if IsShiftKeyDown() then "..
	  "            ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) "..
	  "          end\n"..
		"/stopmacro [mod:shift]\n"..
		"/run CloseTradeSkill()\n"..
		"/cast "..NAME.."\n"..
		"/run for i=1,GetNumTradeSkills() do "..
		  "     local l = GetTradeSkillRecipeLink(i) "..
		  "     if l and l:match('enchant:"..extra.."') then "..
			"       TradeSkillFrame_SetSelection(i) "..
			"       if not IsAltKeyDown() then DoTradeSkill(i) end "..
			"     end "..
			"   end "..
			"   if not IsAltKeyDown() then CloseTradeSkill() end\n"..
		"/use item:38682"
end


Panda.panel:RegisterFrame(L["Draenor"], Panda.PanelFactory(SPELLID,
[[110617:158907:CRIT 110618:158908:HASTE 110619:158909:MAS 110620:158910:MULT 110621:158911:VERS 110638:158914:CRIT 110639:158915:HASTE 110640:158916:MAS 110641:158917:MULT 110642:158918:VERS
  110624:158892:CRIT 110625:158893:HASTE 110626:158894:MAS 110627:158895:MULT 110628:158896:VERS 110645:158899:CRIT 110646:158900:HASTE 110647:158901:MAS 110648:158902:MULT 110649:158903:VERS
  110631:158877:CRIT 110632:158878:HASTE 110633:158879:MAS 110634:158880:MULT 110635:158881:VERS 110652:158884:CRIT 110653:158885:HASTE 110654:158886:MAS 110655:158887:MULT 110656:158889:VERS
	0
	110682:159235:CRIT 112164:159671:HASTE 118015:173323:MAS 112165:159672:MULT 112115:159673:SPI  112160:159674:ARM  112093:159236:BLD
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))
