
local NAME = GetSpellInfo(51005)
local NAME2 = GetSpellInfo(45357)
local inks = "39469 39774 43115 43116 43118 43118 43120 43121 43122 43123 43124 43125 43126 43127"
Panda.PanelFactory(NAME, 45357,
[[39151   0   39469   0     0    2447   765  2449   785
  39334 43103 39774 43115   0    2450  2452  3820  2453
  39338 43104 43116   0     0    3369  3355  3356  3357
  39339 43105 43118 43119   0    3818  3821  3358  3819
  39340 43106 43120 43121   0    4625  8831  8836  8838  8845  8839 8846
  39341 43107 43122 43123   0   13464 13463 13465 13466 13467
  39342 43108 43124 43125   0   22786 22785 22789 22787 22791 22793
  39343 43109 43126 43127   0   36901 36904
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	if inks:match(frame.id) then
		frame:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..NAME2.."\n/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..frame.name:gsub("\'", "\\\'").."' then DoTradeSkill(i) end end\n/run CloseTradeSkill()")
	else
		frame:SetAttribute("macrotext", "/cast "..NAME.."\n/use "..frame.name)
	end
end)

