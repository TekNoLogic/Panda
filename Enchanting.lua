
local L = Panda.locale


local SPELLID = 7411
local AVELLUM1, AVELLUM2, AVELLUM3 = 38682, 37602, 43145
local WVELLUM1, WVELLUM2, WVELLUM3 = 29249, 39350, 43146
local NAME = GetSpellInfo(SPELLID)
local function MakeMacro(id, name, isweapon)
	local chantname = name:match(L["Scroll of (.+)$"])
	return "/run if IsShiftKeyDown() then ChatEdit_InsertLink('"..select(2, GetItemInfo(id)).."') end\n"..
		"/stopmacro [mod:shift]\n/run CloseTradeSkill()\n/cast "..NAME.."\n"..
		"/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..chantname.."' then TradeSkillFrame_SetSelection(i); DoTradeSkill(i) end end CloseTradeSkill()\n"..
		"/use item:"..(isweapon and WVELLUM2 or AVELLUM2)
end


Panda.PanelFactory(L["Enchant Bracer"], SPELLID,
[[38768:DEF 38811:DEF 38842:DEF 38899:DEF   0       38984:EXP 0 38898:STAT 38987:STAT
  38771:STA 38793:STA 38812:STA 38849:STA 38855:STA 38902:STA 0 38679:HP
  38778:STR 38797:STR 38817:STR 38846:STR 38854:STR 38897:STR 0 38938:AP 38971:AP 44815:AP 0 38777:AGI
  38803:INT 38829:INT 38852:INT 38937:INT 38968:INT   0       0 38903:SP 38997:SP 38900:SP 0 38881:MPR 38901:MPR
  38774:SPI 38783:SPI 38809:SPI 38832:SPI 38853:SPI 38980:SPI 0 38882:SP 38900:SP 38996:SP
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory(L["Enchant Cloak"], SPELLID,
[[38789:AGI 38835:AGI 38940:AGI 38959:AGI 44457:AGI   0         0       0 0 0 0 0 0 38770:RALL 38826:RALL 38858:RALL 38915:RALL
  38775:ARM 38790:ARM 38806:ARM 38825:ARM 38859:ARM 38914:ARM 39001:ARM 0 0 0 0 0 0 38784:RFI  38815:RFI  38891:RFI  38969:RFI
    0         0         0         0         0         0         0       0 0 0 0 0 0   0        38795:RSH  38942:RSH  38977:RSH
    0         0       38939     38894     38893     39000:DEF 38895     0 0 0 0 0 0   0          0        38941:RAR  38982:RAR
  44456     39003     38973     39004     38993     38978:DEF   0       0 0 0 0 0 0   0          0        38892:RNA  38956:RNA
    0         0         0         0         0         0         0       0 0 0 0 0 0   0          0          0        38950:RFR
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory(L["Enchant Shield"], SPELLID,
[[38787:STA 38805:STA 38828:STA 38861:STA 38945:STA  38983:STA    0   38949:RES
  38791:ARM   0       38904:BLKV  0       38820:BLKR 38906:BLKR   0   38954:DEF
  38792:SPI 38816:SPI 38839:SPI 38860:SPI   0        38905:INT  44455:INT
  38843:RFR   0       38907:RALL
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory(L["Enchant Weapon"], SPELLID,
[[38780:DAM 38794:DAM 38821:DAM 38848:DAM 38870:DAM 38917:DAM 38957:DAM   0        0     0     0     0   38772:DAM 38796:DAM 38822:DAM 38845:DAM 38869:DAM
  38880:AGI 38947:AGI 38995:AGI   0       38879:STR 38920:STR   0       44453:AP   0     0     0     0     0       38896:AGI 38922:AGI   0       38919:AP
  38883:SPI 38963:SPI   0       38918:INT 38884:INT 38958:INT   0         0        0     0     0     0   38788:SPI 38874:SPI   0       38781:INT 38875:INT
  38878:SP  38946:SP  38994:SP    0       38877:SP  38921:SP  38991:SP  44467:SP
  38876:WINTER 38838:FIERY 38868:FROST 38872:UNHOLY 38873:CRUSADER 38871:LIFESTEAL 0 38925:MONGOOSE 38927:LIFESTEAL 38926:MPR 38924:SP 38923:SP 0 44493:BERSERK 44497:HIT 38998:FROST
  38779:BEAST 38813:BEAST   0   38814:ELEM   0   38840:DEMON
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name, true))
end)
