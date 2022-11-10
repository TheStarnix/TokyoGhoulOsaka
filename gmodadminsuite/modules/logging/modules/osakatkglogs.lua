/*local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Osaka TKG"
MODULE.Name = "Cadavres"
MODULE.Colour = Color(52, 73, 94)

MODULE:Setup(function()

	function blogs_playereatragdoll(ply1, ply2, steamidkiller)
		if steamidkiller == ply1:SteamID() then
			MODULE:Log("{1} a tué & mangé le cadavre de {2}", GAS.Logging:FormatPlayer(ply1), GAS.Logging:FormatPlayer(ply2))
		else
			MODULE:Log("{1} a mangé le cadavre de {2}", GAS.Logging:FormatPlayer(ply1), GAS.Logging:FormatPlayer(ply2))
		end
		
	end

end)

GAS.Logging:AddModule(MODULE)

//---------
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Osaka TKG"
MODULE.Name = "Rerolls"
MODULE.Colour = Color(52, 73, 94)

MODULE:Setup(function()

	function blogs_rerolls(ply, kagune)
		MODULE:Log("{1} a reroll un {2}", GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(kagune))
	end

end)

GAS.Logging:AddModule(MODULE)

//---------
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Osaka TKG"
MODULE.Name = "Modifications"
MODULE.Colour = Color(52, 73, 94)

MODULE:Setup(function()

	function blogs_admingouleRC(ply, ply2, rcbefore, rcafter)
		MODULE:Log("{1} a changé les RC de {2}. {3}RC -> {4}RC.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(rcbefore), GAS.Logging:Highlight(rcafter))
	end
	function blogs_admingouleClassification(ply, ply2, classbefore, classafter)
		MODULE:Log("{1} a changé la classification de {2}. {3} -> {4}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(classbefore), GAS.Logging:Highlight(classafter))
	end
	function blogs_admingouleRerolls(ply, ply2, rerollsbefore, rerollsafter)
		MODULE:Log("{1} a changé le nombre de rerolls de {2}. {3} -> {4}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(rerollsbefore), GAS.Logging:Highlight(rerollsafter))
	end
	function blogs_admingouleKagune(ply, ply2, kagunebefore, kaguneafter)
		MODULE:Log("{1} a changé le kagune de {2}. {3} -> {4}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(kagunebefore), GAS.Logging:Highlight(kaguneafter))
	end


end)

GAS.Logging:AddModule(MODULE)

//---------
local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Osaka TKG"
MODULE.Name = "Duels"
MODULE.Colour = Color(52, 73, 94)

MODULE:Setup(function()

	function blogs_duelrequested(ply,ply2,hp,armor)
		if hp == 0 || armor == 0 then
			MODULE:Log("{1} a demandé en duel {2}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2))
		else
			MODULE:Log("{1} a demandé en duel {2}. HP duel: {3}. Armure duel: {4}.", GAS.Logging:FormatPlayer(ply), GAS.Logging:FormatPlayer(ply2), GAS.Logging:Highlight(hp), GAS.Logging:Highlight(armor))
		end
	end


end)

GAS.Logging:AddModule(MODULE)
*/