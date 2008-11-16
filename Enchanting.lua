
local SPELLID = 7411
local AVELLUM1, AVELLUM2, AVELLUM3 = 38682, 37602, 43145
local WVELLUM1, WVELLUM2, WVELLUM3 = 29249, 39350, 43146
local NAME = GetSpellInfo(SPELLID)
local function MakeMacro(id, name, isweapon)
	local chantname = name:match("Scroll of (.+)$")
	return "/run if IsShiftKeyDown() then ChatEdit_InsertLink('"..select(2, GetItemInfo(id)).."') end\n"..
		"/stopmacro [mod:shift]\n/run CloseTradeSkill()\n/cast "..NAME.."\n"..
		"/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..chantname.."' then TradeSkillFrame_SetSelection(i); DoTradeSkill(i) end end CloseTradeSkill()\n"..
		"/use item:"..(isweapon and WVELLUM2 or AVELLUM2)
end


Panda.PanelFactory("Enchant Bracer", SPELLID,
[[38768 38811 38842 38899   0   38984   0   38898 38987
  38771 38793 38812 38849 38855 38902
  38778 38797 38817 38846 38854 38897   0   38938 38971 44815
	38803 38829 38852 38937 38968   0     0   38903 38997 38900
  38774 38783 38809 38832 38853 38980   0   38882 38900 38996
  38777   0   38881 38901   0   38679
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory("Enchant Cloak", SPELLID,
[[38789 38835 38940 38959 44457   0     0     0     0     0     0     0     0   38770 38826 38858 38915
  38775 38790 38806 38825 38859 38914 39001   0     0     0     0     0     0   38784 38815 38891 38969
    0     0     0     0     0     0     0     0     0     0     0     0     0     0   38795 38942 38977
    0     0   38939 38894 38893 39000 38895   0     0     0     0     0     0     0     0   38941 38982
  44456 39003 38973 39004 38993 38978   0     0     0     0     0     0     0     0     0   38892 38956
    0     0     0     0     0     0     0     0     0     0     0     0     0     0     0     0   38950
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory("Enchant Shield", SPELLID,
[[38787 38805 38828 38861 38945 38983   0   38949
  38791   0   38904   0   38820 38906   0   38954
  38792 38816 38839 38860   0   38905 44455
  38843   0   38907
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name))
end)


Panda.PanelFactory("Enchant Weapon", SPELLID,
[[38779 38813   0   38814   0   38840
  38780 38794 38821 38848 38870 38917 38957   0     0     0     0     0   38772 38796 38822 38845 38869
  38880 38947 38947 38995   0   38879 38920   0     0     0     0     0     0   38896 38922   0   38919
	38883 38963   0   38918 38884 38958   0     0     0     0     0     0   38788 38874   0   38781 38875
  38878 38946 38994   0   38877 38921 38991 44467
  38876 38838 38868 38872 38873 38871   0   38925 38927 38926 38924 38923   0   44453 44493 44497 38998
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	frame:SetAttribute("macrotext", MakeMacro(frame.id, frame.name, true))
end)
