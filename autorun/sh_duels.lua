AddCSLuaFile()
properties.Add("DuelProposition", {
	---[[
	MenuLabel = "Proposer un duel",
	MenuIcon = "tkg_osaka/icon_duel.png",

	Filter = function(self, ent) --Filtrage afin de montrer l'option seulement aux joueurs
		if !(ent:IsPlayer()) then return end
		return true
	end,
	MenuOpen = function(self, option, ent, tr)
		local Menu = option:AddSubMenu()
		Menu:AddOption( "Duel équilibré", function()
				OsakaTKG.MenuEquilibre(ent)
		end):SetIcon( "icon16/user_go.png" )
		Menu:AddSpacer()
		Menu:AddOption( "Duel par défaut", function()
				net.Start("TKGOsaka_DuelRequest")
					net.WriteEntity(ent)
				net.SendToServer()
		end):SetIcon( "icon16/award_star_bronze_1.png" )
	end,---]]

})