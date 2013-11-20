
local L = Panda.locale


local SPELLID = 7411
local NAME = GetSpellInfo(SPELLID)
local function NoSpelltips(id, f) f.tiplink = nil end
local function MakeMacro(frame)
	local id, extra = frame.id, frame.extra

	if extra then
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

	return "/run if IsShiftKeyDown() then "..
	  "            ChatEdit_InsertLink(select(2, GetItemInfo("..id.."))) "..
	  "          end\n"..
		"/stopmacro [mod:shift]\n"..
		"/run CloseTradeSkill()\n"..
		"/cast "..NAME.."\n"..
		"/run local chantname = GetItemInfo("..id.."):gsub(\""..L["Scroll of "].."\", '') "..
		"     for i=1,GetNumTradeSkills() do "..
		"       if GetTradeSkillInfo(i) == chantname then "..
		"         TradeSkillFrame_SetSelection(i) "..
		"         if not IsAltKeyDown() then DoTradeSkill(i) end "..
		"       end "..
		"     end "..
		"     if not IsAltKeyDown() then CloseTradeSkill() end\n"..
		"/use item:38682"
end


Panda.panel:RegisterFrame(L["All Panda"], Panda.PanelFactory(SPELLID,
[[74729:INT  74250x3    0      0 89737:PARRY 74250x3 74247x1 0 74717:AGI   74247x2   0     0 74708:STAT 74249x2 74250x3
    0          0        0      0   0           0       0     0 74715:HASTE 74249x2 74250x1 0 74707:SPI  74249x4
  74727:DEF  74247x3    0      0 74704:STR   74248x3   0     0 74716:HIT   74249x2 74250x1 0 74706:RES  74249x3 74250x1
  74726:STAT 74249x12 74248x10 0 74705:AGI   74248x3   0     0 74718:MAS   74249x4 74250x3 0 74709:STA  74249x4 74250x1
  74725:DAM  74250x3    0      0 74701:DOD   74249x8 74250x2
  74724:INT  74250x4  74248x10 0 74700:MAS   74249x4   0     0 74712:INT   74249x3 74250x3 0 74719:HASTE 74249x4
  74728:DOD  76138x1  74250x50 0 74703:INT   74248x3   0     0 74710:HIT   74249x7   0     0 74721:STR   74249x3 74250x1 74247x1
  74723:STAT 74249x12 74247x1  0   0           0       0     0 74711:STA   74247x2   0     0 74720:EXP   74250x2
    0          0        0      0   0           0       0     0 74713:CRIT  74250x1   0     0 74722:MAS   74250x3
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["All Cat"], Panda.PanelFactory(SPELLID,
[[52743:STA      52750:HASTE 52757:AGI  52769:HIT   52781:AGI  52771:MAS  52782:MAS     0         52754:ARM 52762:BLKR
  52763:DOD      52766:HIT   52770:SPI  52772:EXP   52752:CRIT 52778:CRIT 52746:HASTE 52785:HASTE 68784:AGI 68785:STR 68786:INT
  52758:RES      52765:SPI   52744:STAT 52779:STAT  52751:STA  52780:STA
  52745:SPEN     52767:ARM   52753:INT  52773:INT   52764:CRIT 52777:CRIT
  52749:HASTE    52756:STR   52759:EXP  52783:STR   52784:MAS
  52747:CRUSADER 52748:NAT   52755:ELEM 52760:HASTE 52761:SPI 52774:INT 52775:DOD 52776:AP 0 52768:INT 0 68134:AGI
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["All Wrath"], Panda.PanelFactory(SPELLID,
[[38976:AGI       38943:SPE  39006:SPE 44449:AP        44469:AP    38966:STA    38961:SPI  38974:HMP      38986:HIT 0 0 0 0 0 0 38954:DEF 44455:INT
  38984:44598:EXP 38987:STAT 38902:STA 44947:62256:STA 38971:AP    44815:AP     38968:INT  38997:SP       44470:60767:SP 38980:SPI
  38955:HP        39005:HP   39002:DEF 38912:MP        38962:MPR   38989:STAT   44465:STAT 38975:RES
  38959:AGI       44457:AGI  39001:ARM 44456:HASTE     39003:HASTE 38973:SPEN   39004:FADE 38993:STL      38978:DEF      0              0               0       38969:RFI   38977:RSH   38982:RAR 38956:RNA 38950:RFR
  38967:AGI       38964:AP   44458:AP  38953:HIT       38951:EXP   38990:THREAT 38979:SP        0         50816:FISH   38960:GATHER     0               0         0           0         38992:AP  44463:AP  38981:UNDEAD
  38995:AGI       44453:AP   44466:AP  38963:SPI       38991:SP    44467:SP     44493:BERSERK 38965:FIERY 43987:UNHOLY 38972:CRUSADER 46098:LIFESTEAL 44497:HIT 46026:PARRY 38988:GIANT   0       45060:SP  45056:SP
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Boots"], Panda.PanelFactory(SPELLID,
[[38786:AGI 38807:AGI 38844:AGI 38863:AGI 37603:AGI 38976:AGI 0 38943:SPE   0       44449:AP  44469:AP
  38785:STA 38810:STA 38830:STA 38862:STA 38909:STA 38966:STA 0 38944:SPE 39006:SPE
  38819:SPI 38864:SPI 38961:SPI   0       38908:HMP 38974:HMP 0 38837:SPE   0       45628:HIT 38910:HIT 38986:HIT
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Bracer"], Panda.PanelFactory(SPELLID,
[[38768:DEF 38811:DEF 38842:DEF 38899:DEF   0       38984:44598:EXP   0             38898:STAT 38987:STAT
  38771:STA 38793:STA 38812:STA 38849:STA 38855:STA 38902:STA       44947:62256:STA   0        38679:HP   0      38777:AGI 68784:AGI
  38778:STR 38797:STR 38817:STR 38846:STR 38854:STR 38897:STR       68785:STR         0        38938:AP 38971:AP 44815:AP
  38803:INT 38829:INT 38852:INT 38937:INT 38968:INT 68786:INT         0             38882:SP   38900:SP 38903:SP 38997:SP  44470:60767:SP
  38774:SPI 38783:SPI 38809:SPI 38832:SPI 38853:SPI 38980:SPI         0             38881:MPR  38901:MPR
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Chest"], Panda.PanelFactory(SPELLID,
[[38766:HP   38773:HP   38782:HP   38808:HP   38833:HP   38866:HP   38911:HP 38955:HP  39005:HP 0 38767:DEF 38798:DEF 38999:DEF 39002:DEF
  38769:MP   38776:MP   38799:MP   38818:MP   38841:MP   38867:MP   38912:MP   0         0      0 38929:MPR 38962:MPR   0       38928:SPI
	38804:STAT 38824:STAT 38847:STAT 38865:STAT 38913:STAT 38989:STAT 44465:STAT 0         0      0 38930:RES 38975:RES
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Cloak"], Panda.PanelFactory(SPELLID,
[[38789:AGI   38835:AGI   38940:AGI  38959:AGI  44457:AGI   0         0       0 0 0 0 0 0 38770:RALL 38826:RALL 38858:RALL 38915:RALL
  38775:ARM   38790:ARM   38806:ARM  38825:ARM  38859:ARM 38914:ARM 39001:ARM 0 0 0 0 0 0 38784:RFI  38815:RFI  38891:RFI  38969:RFI
    0           0           0          0          0         0         0       0 0 0 0 0 0   0        38795:RSH  38942:RSH  38977:RSH
    0           0         38939:SPEN 38894:FADE 38893:STL 39000:DEF 38895:DOD 0 0 0 0 0 0   0          0        38941:RAR  38982:RAR
  44456:HASTE 39003:HASTE 38973:SPEN 39004:FADE 38993:STL 38978:DEF   0       0 0 0 0 0 0   0          0        38892:RNA  38956:RNA
    0           0           0          0          0         0         0       0 0 0 0 0 0   0          0          0        38950:RFR
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Gloves"], Panda.PanelFactory(SPELLID,
[[38850:MOUNT 0       38802:FISH 50816:FISH 38823:SKIN 38801:HERB 38834:HERB 38800:MINE 38831:MINE 38960:GATHER
  38827:AGI 38856:AGI 38890:AGI  38967:AGI    0        38836:STR  38857:STR  38933:STR    0          38934:AP  38964:AP     44458:AP
  38932:HIT 38953:HIT    0       38931:CRIT   0        38951:EXP    0        38851:HASTE    0       38885:THREAT 38990:THREAT
  38888:FIP 38887:FRP 38886:SHP    0        38889:SP   38936:SP   38935:SP   38979:SP
  74722:MAS
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Shield"], Panda.PanelFactory(SPELLID,
[[38787:STA 38805:STA 38828:STA 38861:STA 38945:STA    0          0   38949:RES
  38791:ARM   0       38904:BLKV  0       38820:BLKR 38906:BLKR   0   38954:DEF
  38792:SPI 38816:SPI 38839:SPI 38860:SPI   0        38905:INT  44455:INT
  38843:RFR   0       38907:RALL
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))


Panda.panel:RegisterFrame(L["Enchant Weapon"], Panda.PanelFactory(SPELLID,
[[38780:DAM 38794:DAM 38821:DAM 38848:DAM 38870:DAM 38917:DAM 0   0        0      0 0   0       38772:DAM 38796:DAM 38822:DAM 38845:DAM 38869:DAM
  38880:AGI 38947:AGI 38995:AGI   0       38879:STR 38920:STR 0 44453:AP 44466:AP 0 0 38896:AGI 38922:AGI   0       38919:AP  38992:AP 44463:AP
  38883:SPI 38963:SPI   0       38884:INT 38918:INT   0       0   0        0      0 0   0       38788:SPI 38874:SPI   0       38781:INT 38875:INT
  38878:SP  38877:SP  38946:SP  38921:SP  38991:SP  44467:SP  0   0        0      0 0   0         0         0         0       45060:SP  45056:SP
  38876:WINTER  38838:FIERY 38868:FROST 38872:UNHOLY 38873:CRUSADER 38871:LIFESTEAL   0       38925:MONGOOSE 38927:LIFESTEAL 38926:MPR 38924:SOULFROST 38923:SUNFIRE
  44493:BERSERK 38965:FIERY 38998:FROST 43987:UNHOLY 38972:CRUSADER 46098:LIFESTEAL 44497:HIT 46026:PARRY      0               0       38779:BEAST     38813:BEAST 38814:ELEM 38840:DEMON 38988:GIANT 0 38981:UNDEAD
]], NoSpelltips, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame))
end))
