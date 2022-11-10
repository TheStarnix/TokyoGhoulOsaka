--- Module qui permet de give des RC à un joueur par la console. Fonctionne uniquement avec le code de Remigius.
-- @author Starnix
-- @copyright TKG Osaka, 2021-2050, tous droits réservés.
-- @module sv_questcommand

util.AddNetworkString("Bonjour")

concommand.Add("tkgosaka_questgiveRC", function( ply, cmd, args )
	if !(IsValid(ply)) then
		if #args == 0 or #args > 2 then
			print("Erreur: vous devez faire tkgosaka_questgiveRC <steamID64 du joueur> <RC>")
		else
			if sql.QueryRow("SELECT * from TKGRCKagune WHERE SteamID64 = '".. args[1] .. "'") == nil then
				print("Erreur: steamid64 spécifié introuvable.")
			else
				local rcNumber = sql.QueryValue("SELECT RC from TKGRCKagune WHERE SteamID64 = '".. args[1] .. "'")
				rcNumber = rcNumber+args[2]
				sql.QueryRow("UPDATE TKGRCKagune SET RC = '"..rcNumber.."' WHERE SteamID64 = '"..args[1].."';")
				print(args[2].." RC ajoutés au joueur possédant le SteamID64 "..args[1])
			end
		end

	else
		ply:PrintMessage(HUD_PRINTTALK, "Seul la console peut give des RC !")
	end
end)

concommand.Add("osaka_test", function( ply, cmd, args )
	ply:SetName("TPLM")
	ply:setDarkRPVar("rpname", "TPLM")
	net.Start("Bonjour")
		net.WriteString("Théo")
	net.Broadcast()
end)

