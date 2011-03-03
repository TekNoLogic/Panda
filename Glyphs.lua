
local L = Panda.locale
local panel = Panda.panel.panels[3]


local name = GetSpellInfo(45357)

local check = CreateFrame("CheckButton", "PandaGlyphProfit", panel, "OptionsCheckButtonTemplate")
check:SetWidth(22)
check:SetHeight(22)
check:SetPoint("TOPLEFT", Panda.panel, "BOTTOMLEFT", 185, 35)
check:SetScript("OnClick", function() Panda.showprofit = not Panda.showprofit; panel:Hide(); panel:Show() end)

local checklabel = check:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
checklabel:SetPoint("LEFT", check, "RIGHT", 5, 0)
checklabel:SetText("Show profit")

CreateFrame("Frame", nil, panel):SetScript("OnShow", function() if GetReagentCost then check:Show() else check:Hide() end end)


panel:RegisterFrame(PRIME_GLYPHS, Panda.PanelFactory(45357,
[[39343 43126 43425 41110 42745 42965 41539 42409 42454 42909 40900 43534   0     0     0   44680
    0     0   43421 45744 42751 42969 41524 42407 42456 42915 40906 43542
    0     0   43415 43869 42742 42954 41529 42403 42459 42915 40915 43547
    0     0     0     0   42753 42967 41526 42414 42464 42914 40912 43550
    0     0     0     0   44684   0     0     0   42472 45732 45603
    0     0     0     0   42739   0     0     0   50077   0   45604
    0     0     0     0   63539   0     0     0     0     0     0
  39342 43124 45790 45742 45736 45764 45772 45756 45780 45731 45601 45806
    0     0   43432 45743 45738 45762 45771 45755 45779 45625 67484 43551
    0     0     0   41105 42749 45761 41527 45753 45781 42911   0   43827
    0     0     0     0   44955   0   41542 42406 42453   0     0   43549
  39341 43122 43416 41103   0   45768 45775   0   42468   0   40901 45804
    0     0     0     0     0     0   41541   0     0     0     0   43543 43546
  39340 43120   0   45746   0   42972   0     0     0     0   40902
    0     0     0   41098   0   42973   0     0     0     0   40916
  39339 43118 43422   0     0     0   41540 42411   0   42897 40919
    0     0   43424   0     0     0     0   42415   0
	39338 43116 43423 41106 42735 42961 41532 42400 42465 42898 40923
    0     0     0   41092   0     0   41536   0     0     0   67487
  39334 39774   0     0   42743 42956 41531 42408 42455 42912 40913
    0     0     0     0     0     0     0     0     0     0   40922
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	if frame.id == 44680 then
		frame:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..name.."\n"..
			"/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..L["Northrend Inscription Research"].."' then DoTradeSkill(i) end end CloseTradeSkill()")
	else
		frame:SetAttribute("macrotext", Panda.CraftMacro(name, frame.id))
	end
end))


panel:RegisterFrame(MAJOR_GLYPHS, Panda.PanelFactory(45357,
[[61979 61978 63481
  39343 43126 43419 41102 42752 42958 41517 42412 42460 42902 40920 43552
    0     0   43431 41109 42748 42957 41538 42405 42463 42901 40908 43537
    0     0   43430 41097 42754 42959 41518 42396 42457 42899 40899 43533
    0     0     0   41101 44920 42968 45777 42404 45782 42913 40921
    0     0     0   41107   0   42971 41534 42417 45783 42917 44928
    0     0     0   43867   0   45766 41552 45757
    0     0     0   43868   0   45767
    0     0     0   45745
    0     0     0   66918
  39342 43124 45795 45741 45737 45769 45770 45758 42471 42906 45602 45800 68793
    0     0   45792   0   50045 63420   0   42401   0     0   40896 45799 43825
    0     0     0     0   42736 42955   0     0     0     0   40903 43554 43553
    0     0     0     0     0   42963   0     0     0     0     0   43826 43548
  39341 43122 67482   0     0   42974 45776 45760   0   42905 45622 43541 43536
    0     0     0     0     0     0     0   42399
  39340 43120 43414 41099 45740   0   41535 42397 42470 42904 45623   0
    0     0     0     0   42744   0   41533 42416 42466 42903   0     0
  39339 43118 67483 41104 42746 42970 41547   0   42473 45733 40909   0
    0     0     0     0   42738 64493   0     0   42467 42910 67486   0
    0     0     0     0     0   42966
  39338 43116 45797 45747 42737 42964 43725 42402 45789 45734 40924
    0     0   43427 41108   0   42962 41530 42398 42458 42908 40914
    0     0   43417   0     0     0     0     0     0   42900 67485
  39334 39774 43418 41095 42741 42960 45778 42410 45785 45735 43332
    0     0   43413 41096   0     0   41537   0   42462 42907 40897
    0     0     0   41094   0     0     0     0     0     0   48720
    0     0     0   43367
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	if frame.id == 44680 then
		frame:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..name.."\n"..
			"/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..L["Northrend Inscription Research"].."' then DoTradeSkill(i) end end CloseTradeSkill()")
	else
		frame:SetAttribute("macrotext", Panda.CraftMacro(name, frame.id))
	end
end))


panel:RegisterFrame(L["Minor Glyphs (by ink)"], Panda.PanelFactory(45357,
[[39334 39774 43395 43396 43366 43390 43339 43364 43379 43342 43338   0     0     0     0     0   44680
    0     0   43399 43397 43335 43340 43359 43361 43343 43371 43350 43356
  39338 43116 43398 43377 43365 43344 43389 42461 43316 43373 43376 43380 43368 43386 43391 43360 43331
  39339 43118 43369 43388 43385 43381 43372 43370 43392 43393 43351 43334 43674 68039 63416 41100
  39340 43120 43378 43355 45793   0     0     0   43400 43671 43539 43672 43673 43535 43544 43124 39342
    0     0     0     0     0     0     0     0   45739 44922 44923 49084 43412 43374 43394 43126 39343
]], nil, function(frame)
	frame:SetAttribute("type", "macro")
	if frame.id == 44680 then
		frame:SetAttribute("macrotext", "/run CloseTradeSkill()\n/cast "..name.."\n"..
			"/run for i=1,GetNumTradeSkills() do if GetTradeSkillInfo(i) == '"..L["Minor Inscription Research"].."' then DoTradeSkill(i) end end CloseTradeSkill()")
	else
		frame:SetAttribute("macrotext", Panda.CraftMacro(name, frame.id))
	end
end))


panel:RegisterFrame(L["Minor Glyphs (by class)"], Panda.PanelFactory(45357,
[[43395 45793 43365 43339 63416 43379 44923 43342 43390 42461 43355 43335 68039 43671
  43399 45794 43366 43359 45739 43343 43344 43371 43389 43392 43350 44922 43334 43539
  43396 43412 43340 43364 43360 43377 43386 43373 43391 43394 43338 43316 43674 43672
  43397 49084 43369 43361   0   43380 43381 43370 43393   0   43356 43331   0   43673
  43398 43400 43368   0     0   43376 43385 43372   0     0   43351   0     0   43535
    0     0   41100   0     0   43378 43388 43374   0     0     0     0     0   43544
]]))


panel:RegisterFrame(L["Scrolls"], Panda.PanelFactory(45357,
[[61979 61978 63303 63305 63306 63307 63304 63308 63388 62237 60838
  39343 43126 43463 37091 37093 37097 43465 44315
	  0     0   43464 37092 37094 37098 43466
  39342 43124 33457 33458 33461 33460 33462
  39341 43122 27498 27499 27502 27501 27503
  39340 43120 10309 10308 10307 10306 10310 43850
  39339 43118  4425  4419  4422  4424  4426 44314
  39338 43116
  39334 39774  1477  2290  1711  1712  2289 64670
  39151 39469   0     0     0     0     0   37118 38682
  39151 37101  3012   955  1180  1181   954
]]))
