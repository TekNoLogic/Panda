﻿
Panda.PanelFactory("Glyphs", 45357,
[[39334 39774 43413 41096 42743 42960 41531 42410 42455 42912 40897 40922
    0     0   43418 41095 42741 42956 41537 42408 42462 42907 40913
  39338 43116 43423 41106 42734 42961 41530 42398 42461 42898 40924
    0     0   43417 41092 42735 42962 41532 42400 42458 42900 40914
    0     0   43427 41108 42737 42964 41536 42402 42465 42908 40923
  39339 43118 43422 41100 42738 42966 41540 42411 42467 42910 40919
    0     0   43424 41104 42746 42970 41547 42415 42473 42897 40909
  39340 43120 43420 41099 42747 42972 41533 42416 42466 42903 40902
    0     0   43414 41098 42744 42973 41535 42397 42470 42904 40916
  39341 43122 43416 41103 42750 42974 41541 42399 42468 42905 40901 43536 43543 43546 43541
    0     0     0   41105 42749 42963 41527 42401 42471 42911 40903 43548 43553 43825 43826
  39342 43124 43428 41094 42736 42955 41542 42406 42453 42906 40896 43551 43827 43554 43549
    0     0     0   41102 42754 42958 41518 42407 42460 42899 40920 43552
  39343 43126   0   41110 42745 42957 41517 42405 42454 42902 40908
		0     0     0   41109 42748 42965 41538 42409 42463 42915 40900
		0     0     0     0   42751 42969 41539 42412 42469 42916 40906
		0     0     0   41101 42740 42954 41524 42396 42456 42901 40899
	  0     0     0   41107 42739 42959 41526 42403 42457 42909 40915
		0     0     0   41097 42742 42967 41529 42404 42459 42913 40912
		0     0     0     0   42752 42968 41534 42414 42464 42914 40921
		0     0     0     0   42753 42971 41552 42417 42472
]],
function(id, frame)
	local _, _, _, _, _, _, subtype = GetItemInfo(id)
	local c = subtype and RAID_CLASS_COLORS[subtype:gsub(" ", ""):upper()]
	frame.border:SetVertexColor(c and c.r or 0, c and c.g or 0, c and c.b or 0)
	frame.border:SetAlpha(1)
	frame.border:Show()
end)


-- 43427 Sunder Armor
-- 43414 Cleaving
-- 43432 Whirlwind
